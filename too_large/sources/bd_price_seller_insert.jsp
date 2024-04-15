<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	HashMap text = MessageUtil.getMessageMap( info, "MESSAGE", "BUTTON", "SBD_004" );
	
	String screen_id = "SBD_004";
	String grid_obj  = "GridObj";
	
	Config conf = new Configuration();
	boolean isSelectScreen = false;
 
    String BID_NO        = request.getParameter("BID_NO");      
    String BID_COUNT     = request.getParameter("BID_COUNT");   
    String VOTE_COUNT    = request.getParameter("VOTE_COUNT");   

    if(BID_NO == null) BID_NO ="";
    if(BID_COUNT == null) BID_COUNT ="";
    if(VOTE_COUNT == null) VOTE_COUNT ="";

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간 

    String CONT_TYPE1         = "";
    String CONT_TYPE2         = "";
    String ANN_NO             = "";
    String ANN_ITEM           = "";
    String CHANGE_USER_NAME_LOC= "";
    String CONT_TYPE1_TEXT_D  = "";
    String CONT_TYPE2_TEXT_D  = "";
    String CONT_TYPE1_TEXT  = "";

    String USER_NAME		    = "";
    String USER_POSITION	    = "";
    String USER_PHONE		    = "";
    String USER_MOBILE		    = "";
    String USER_EMAIL		    = "";
    String PURCHASE_BLOCK_FLAG	= "";
    String VENDOR_NAME		    = "";
    String IRS_NO   		    = "";

    String ESTM_KIND 		    = "";
    String ESTM_KIND_NM		    = "";

    String CRYP_CERT            = "";
    String TECH_DQ				= "";
    
    String ATTACH_NO          = "";
    String ATTACH_CNT          = "";

    String loading_flag       = "Y";
    String BASIC_AMT			= "";
    String COST_STATUS			= "";
    String X_ESTM_CHECK		= "false";
    String BID_INPUT_TYPE       = "";
 
	Map< String, String >   mapData = new HashMap< String, String >();
	mapData.put( "BID_NO", BID_NO );
	mapData.put( "BID_COUNT", BID_COUNT );
	mapData.put( "VOTE_COUNT", VOTE_COUNT );
	
	Object[]    obj = { mapData };
	SepoaOut    so  = ServiceConnector.doService( info, "SBD_003", "CONNECTION", "getBDHeader", obj );
	SepoaFormater wf = new SepoaFormater( so.result[0] );

        CONT_TYPE1                   = wf.getValue("CONT_TYPE1"            ,0);
        CONT_TYPE2                   = wf.getValue("CONT_TYPE2"            ,0);
        ANN_NO                       = wf.getValue("ANN_NO"                ,0);
        ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);
        CHANGE_USER_NAME_LOC         = wf.getValue("CHANGE_USER_NAME_LOC"  ,0);
        CONT_TYPE1_TEXT_D            = wf.getValue("CONT_TYPE1_TEXT_D"     ,0);
        CONT_TYPE2_TEXT_D            = wf.getValue("CONT_TYPE2_TEXT_D"     ,0);
        CRYP_CERT                    = wf.getValue("CRYP_CERT"             ,0); //입찰진행자(개찰관) 암호화 인증서
        BASIC_AMT                    = wf.getValue("BASIC_AMT"             ,0); //입찰예정금액
        CONT_TYPE1_TEXT              = wf.getValue("CONT_TYPE1_TEXT"       ,0);
        COST_STATUS              	= wf.getValue("COST_STATUS"       ,0);
        X_ESTM_CHECK              	= wf.getValue("X_ESTM_CHECK"       ,0);
        BID_INPUT_TYPE          	= wf.getValue("BID_INPUT_TYPE"       ,0);

        if(!VOTE_COUNT.equals("1")) { // 재입찰한 경우에는, 해당 업체가 전 차수에 투찰한 업체만 제출 하게끔 한다.
            wf = new SepoaFormater(so.result[1]);

            loading_flag             = wf.getValue("CNT"     ,0);
        }
        so  = ServiceConnector.doService( info, "SBD_004", "CONNECTION", "getBDHD_VnInfo", obj );
    	SepoaFormater wf2 = new SepoaFormater( so.result[0] );

        VENDOR_NAME         = wf2.getValue("VENDOR_NAME"        ,0);
        USER_NAME           = wf2.getValue("USER_NAME"          ,0);
        IRS_NO              = wf2.getValue("IRS_NO"             ,0);
        USER_POSITION       = wf2.getValue("USER_POSITION"      ,0);
        USER_PHONE          = wf2.getValue("USER_PHONE"         ,0);
        USER_MOBILE         = wf2.getValue("USER_MOBILE"		,0);
        USER_EMAIL          = wf2.getValue("USER_EMAIL"			,0);
        PURCHASE_BLOCK_FLAG	= wf2.getValue("PURCHASE_BLOCK_FLAG",0);

        ESTM_KIND           = wf2.getValue("ESTM_KIND"			,0);
        ESTM_KIND_NM        = wf2.getValue("ESTM_KIND_NM"		,0);
        
        
        System.out.println(X_ESTM_CHECK);
        
        String disp_current_date = current_date.substring(0, 4) + "년 " + current_date.substring(4, 6) + "월 " + current_date.substring(6, 8) + "일";
        TECH_DQ 					 = "".equals(TECH_DQ) ? "0" : TECH_DQ;
        
        
       // String BID_INPUT_TYPE = "T";
        
        String gridDisplayMode = "";
        String readonly = "readonly";
        String disabled = "disabled";
        
        if( "T".equals(BID_INPUT_TYPE)){
        	
        	gridDisplayMode = "display:none";
        	readonly    = "";
        	disabled    = "";
        	
        }
%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="../../css/body.css" type="text/css">

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
 
<Script language="javascript">
<!--

    var BID_NO      = "<%=BID_NO%>";
    var BID_COUNT   = "<%=BID_COUNT%>";
    var VOTE_COUNT  = "<%=VOTE_COUNT%>";

    var mode;
    var button_flag = false;

    var date_flag;
    var Current_Row;

    var current_date = "<%=current_date%>";
    var current_time = "<%=current_time%>";
     
 
    function setOnFocus(obj) {
        var target = eval("document.forms[0]." + obj.name);
        target.value = del_comma(target.value);
    }

    function setOnBlur(obj) {
        var target = eval("document.forms[0]." + obj.name);

        if(IsNumber(del_comma(target.value)) == false) {
            alert("숫자를 입력하세요.");
            target.value = "";
            target.focus();
            return;
        }

        if(obj.name == "BID_AMT_CONF") {
            if(LRTrim(document.forms[0].BID_AMT.value) == "") {
                alert("입찰금액을 먼저 입력하세요.");
                target.value = "";
                document.forms[0].BID_AMT.focus();
                return;
            }

            if(document.forms[0].BID_AMT_CONF.value == "") {
                return;
            }

            if(IsNumber(del_comma(document.forms[0].BID_AMT.value)) == false) {
                alert("입찰금액을 먼저 입력하세요.");
                target.value = "";
                document.forms[0].BID_AMT.focus();
                return;
            } else {
                if(parseFloat(del_comma(document.forms[0].BID_AMT.value)) == parseFloat(del_comma(target.value))) {
                    changeMoney(target.value, 7);
                } else {
                    alert("입찰금액과 동일 금액이 아닙니다. \n다시 입력하세요.");
                    document.forms[0].BID_AMT_H.value = "";
                    target.value = "";
                    target.focus();
                    return;
                }
            }
        }

        target.value = add_comma(target.value,0);
    }
 
//-->
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
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_price_seller_insert";

function init() {
    if("<%=loading_flag%>" == "N") {
//         alert("이전에 입찰서를 제출하지 않은 업체는 가격입찰을 진행 하실수 없습니다.");
//         history.back(-1);
    }

	setGridDraw(); 
    doQuery();
}

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
        GridObj.setColumnHidden(GridObj.getColIndexById("AMT"), true);
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
 
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
/* function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
		var header_name = GridObj.getColumnId(cellInd);
		 
    	if(header_name == "BID_PRICE")   { 

			var rowQty = 0;
    		var rowAmt = 0;
    		var totAmt = 0;
    		
    		for(var i  = 0 ; i < GridObj.GetRowCount() ; i++){
    			if(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue() != ""){
    				rowQty = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("QTY")).getValue());
    				rowAmt = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue());
	    			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("AMT")).setValue(rowQty * rowAmt);
    			}else{
    				rowAmt = 0;
    			}
    			totAmt += rowQty * rowAmt;
    		}
    		$("#BID_AMT").val(add_comma(totAmt,0));
    		changeMoney(totAmt + "", 7);
    	}
        return true;
    }
    
    return false;
}
 */
function doOnCellChange(stage,rowId,cellInd)
{
	var item_no;
	
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
		var header_name = GridObj.getColumnId(cellInd);
		 
    	if(header_name == "BID_PRICE")   { 

			var rowQty = 0;
    		var rowAmt = 0;
    		var totAmt = 0;
    		
    		item_no = GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO")).getValue();
    		
    		<%-- 용도품이 아닐경우 --%>
    		if(item_no.length != 10 || item_no.substring(0,2) != "30"){
    			if(changeMoney(GridObj.cells(rowId, cellInd).getValue() + "", 7) == false){
        			GridObj.cells(rowId, cellInd).setValue("");
        			
        			for(var i  = 0 ; i < GridObj.GetRowCount() ; i++){
            			if(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue() != ""){
            				rowQty = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("QTY")).getValue());
            				rowAmt = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue());
        	    			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("AMT")).setValue(rowQty * rowAmt);
            			}else{
            				rowAmt = 0;
            			}
            			totAmt += rowQty * rowAmt;
            		}
            		$("#BID_AMT").val(add_comma(totAmt,0));
        			return true;
        		}
    		}else{
    			if(changeMoney30(GridObj.cells(rowId, cellInd).getValue() + "", 7) == false){
        			GridObj.cells(rowId, cellInd).setValue("");
        			
        			for(var i  = 0 ; i < GridObj.GetRowCount() ; i++){
            			if(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue() != ""){
            				rowQty = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("QTY")).getValue());
            				rowAmt = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue());
        	    			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("AMT")).setValue(rowQty * rowAmt);
            			}else{
            				rowAmt = 0;
            			}
            			totAmt += rowQty * rowAmt;
            		}
            		$("#BID_AMT").val(add_comma(totAmt,0));
        			return true;
        		}    			
    		}
    		
    		for(var i  = 0 ; i < GridObj.GetRowCount() ; i++){
	    		if(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue() != ""){
	    			rowQty = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("QTY")).getValue());
	    			rowAmt = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue());
		    		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("AMT")).setValue(rowQty * rowAmt);
	    		}else{
	    			rowAmt = 0;
	    		}
	    		totAmt += rowQty * rowAmt;
	    	}
    		
	    	<%-- 용도품일 경우 --%>
    		if(item_no.length == 10 && item_no.substring(0,2) == "30"){
        		if(changeMoney(totAmt + "", 7) == false){
        			GridObj.cells(rowId, cellInd).setValue("");
        			totAmt = 0;
        			for(var i  = 0 ; i < GridObj.GetRowCount() ; i++){
            			if(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue() != ""){
            				rowQty = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("QTY")).getValue());
            				rowAmt = Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("BID_PRICE")).getValue());
        	    			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("AMT")).setValue(rowQty * rowAmt);
            			}else{
            				rowAmt = 0;
            			}
            			totAmt += rowQty * rowAmt;
            		}
            		$("#BID_AMT").val(add_comma(totAmt,0));
        			return true;
        		}    			
    		}

    		changeMoney(totAmt + "", 7);
    	    $("#BID_AMT").val(add_comma(totAmt,0));
    		
	    	
    	}
        return true;
    }
    
    return false;
}

	function calculate_bid_amt( rowId) {
		// 소숫점 두자리까지 계산
		var BID_AMT = 0;
		var pr_qty    = getCalculEval(GridObj.cells(rowId, GridObj.getColIndexById("QTY")).getValue()); 
		var bid_price    = getCalculEval(GridObj.cells(rowId, GridObj.getColIndexById("BID_PRICE")).getValue()); 
	  
		if (pr_qty == 0) {
			BID_AMT = setAmt(bid_price);
		} else {
			BID_AMT = setAmt(pr_qty * bid_price); // 소숫점이하 절삭
			//BID_AMT = RoundEx(pr_qty * bid_price, 3);
		}
	 
     GridObj.cells(rowId, GridObj.getColIndexById( "AMT" )  ).setValue( BID_AMT    );  // 금액 
 
	 calculate_bid_tot_amt();
	}
	/*금액 소수점 무조건 버림*/
	function setAmt(value) {
		rlt = 0;
		if(value == "" || value == 0) return 0;

		rlt = Math.floor(new Number(value) * 1) / 1;

		return rlt;
	}
	function calculate_bid_tot_amt() {
		var f = document.forms[0];
		var bid_tot_amt = 0;
	
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		for(var i = 0; i < grid_array.length; i++){
	  		var bid_amt = getCalculEval(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("AMT")).getValue());
			
	  		bid_tot_amt = bid_tot_amt + bid_amt;
		}
		
		f.BID_AMT.value = add_comma(bid_tot_amt, 0);
		changeMoney(bid_tot_amt+"", 7);
		//changeMoney(RoundEx(bid_tot_amt,3)+"", 7);
	}

	function changeMoney(mon, sw)
	{
		var index=0;
		var i=0;
		var result="";
		var newResult="";
		var money = del_comma(mon);
		
		//alert(money);
		if(money == 0){
			alert("값을 입력하세요");
			return false;
		}
		if(isNaN(Number(del_comma(mon)))){
			//alert("숫자로 입력하세요");
			if (sw != 0) {
				alert("숫자로 입력하세요");
				//document.forms[0].BID_AMT_CONF.value ="";
                document.forms[0].BID_AMT_H.value ="";
			}
			return false;
		}
		if(money.length>13){
			alert("가용한 금액의 크기를 넘었습니다.");
			if (sw != 0) {
				//document.forms[0].BID_AMT_CONF.value ="";
                document.forms[0].BID_AMT_H.value ="";
			}
			return false;
		}
		if(money.indexOf(".")>=0){
			alert("정수로 입력하십시오");
			return false;
		}
		if(money.indexOf("-")>=0){
			alert("양수로 입력하십시오");
			return false;
		}
		su = new Array("0","1","2","3","4","5","6","7","8","9");
		km = new Array("영","일","이","삼","사","오","육","칠","팔","구");
		danwi = new Array("","십","백","천","만","십","백","천","억","십","백","천","조");
		for(j=1;j<=money.length;j++){
			for(index=0;index<10;index++){
				money = money.replace(su[index],km[index]);
			}
		}
		for(index = money.length;index>0;index=index-1){
			result = money.substring(index-1,index);

			if(result=="영"){
				if(i<4 || i>8){
					result = "";
				}
				else if(i>=4 && i<8 && newResult.indexOf("만")<0){
					result = "만";
				}
				else if(i>=8 && i<12 && newResult.indexOf("억")<0){
					result = "억";
				}
				}else{
				result = result + danwi[i];
				//alert(danwi[i]);
			}
			i++;
			newResult = result + newResult;
			//alert(newResult);
		}
		for(j=1;j<newResult.length;j++){
			newResult = newResult.replace("영","");
		}
		if((newResult.indexOf("만")-newResult.indexOf("억"))==1)
			newResult = newResult.replace("만","");
		if((newResult.indexOf("억")-newResult.indexOf("조"))==1)
			newResult = newResult.replace("억","");

			if (sw == 7) {
				document.forms[0].BID_AMT_H.value = newResult + " 원";
				//document.forms[0].BID_AMT_H.size = newResult.length*2;
				//document.forms[0].BID_AMT_CONF.value = commaDel(document.forms[0].BID_AMT_CONF.value);

			} else if (sw == 0) {
    			return newResult;
            }
	}
	
	function changeMoney2(mon, sw)
	{
		var index=0;
		var i=0;
		var result="";
		var newResult="";
		var money = del_comma(mon.value);

		if(money == 0){
			alert("값을 입력하세요");
			mon.value = "";
			return false;
		}
		if(isNaN(Number(del_comma(mon.value)))){
			//alert("숫자로 입력하세요");
			if (sw != 0) {
				alert("숫자로 입력하세요");
				mon.value = "";
				//document.forms[0].BID_AMT_CONF.value ="";
                document.forms[0].BID_AMT_H.value ="";
			}
			return false;
		}
		if(money.length>13){
			alert("가용한 금액의 크기를 넘었습니다.");
			if (sw != 0) {
				mon.value = "";
				//document.forms[0].BID_AMT_CONF.value ="";
                document.forms[0].BID_AMT_H.value ="";
			}
			return false;
		}
		if(money.indexOf(".")>=0){
			alert("정수로 입력하십시오");
			mon.value = "";
			return false;
		}
		if(money.indexOf("-")>=0){
			alert("양수로 입력하십시오");
			mon.value = "";
			return false;
		}
		su = new Array("0","1","2","3","4","5","6","7","8","9");
		km = new Array("영","일","이","삼","사","오","육","칠","팔","구");
		danwi = new Array("","십","백","천","만","십","백","천","억","십","백","천","조");
		for(j=1;j<=money.length;j++){
			for(index=0;index<10;index++){
				money = money.replace(su[index],km[index]);
			}
		}
		for(index = money.length;index>0;index=index-1){
			result = money.substring(index-1,index);

			if(result=="영"){
				if(i<4 || i>8){
					result = "";
				}
				else if(i>=4 && i<8 && newResult.indexOf("만")<0){
					result = "만";
				}
				else if(i>=8 && i<12 && newResult.indexOf("억")<0){
					result = "억";
				}
				}else{
				result = result + danwi[i];
				//alert(danwi[i]);
			}
			i++;
			newResult = result + newResult;
			//alert(newResult);
		}
		for(j=1;j<newResult.length;j++){
			newResult = newResult.replace("영","");
		}
		if((newResult.indexOf("만")-newResult.indexOf("억"))==1)
			newResult = newResult.replace("만","");
		if((newResult.indexOf("억")-newResult.indexOf("조"))==1)
			newResult = newResult.replace("억","");

			if (sw == 7) {
				document.forms[0].BID_AMT_H.value = newResult + " 원";
				//document.forms[0].BID_AMT_H.size = newResult.length*2;
				//document.forms[0].BID_AMT_CONF.value = commaDel(document.forms[0].BID_AMT_CONF.value);

			} else if (sw == 0) {
    			return newResult;
            }
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
        //doQuery();
        location.href="bd_price_list_seller.jsp";
    } else {
        alert(messsage);
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

function doQuery() {
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getBdItemDetail";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);

	for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
		GridObj.enableSmartRendering(true);
    	GridObj.selectRowById(GridObj.getRowId(i), false, true);
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");	
    	
	}		
    return true;
}

// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("<%=text.get("MESSAGE.1004")%>");
	return false;
}
function doBid() {
	
	GridObj.editStop();

	if(!checkRows()) return;

	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	var rowcount = grid_array.length;
  
	
	//총액입력대상은 그리드 로우 1개,  수량 1 로만 가능하다.
	
	var rowcount =  GridObj.GetRowCount() ;
		
	if( "<%=BID_INPUT_TYPE%>"== "T" && ( rowcount > 1 ||  rowcount == 0 )  ){
    	   
		alert("품목수 오류입니다. 시스템닫당자에게 문의하세요.");
		return;
	}
	
	if( "<%=BID_INPUT_TYPE%>"== "T" && rowcount == 1){
		
		for(var i = 0; i < grid_array.length; i++)
		{
			var item_qty = GridObj.cells(grid_array[i], GridObj.getColIndexById("QTY")).getValue();
			
			
			if( item_qty != 1 ){
				
				alert("수량 오류입니다. 시스템담당자에게 문의하세요.");
				return;
			}
			GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_PRICE")).setValue(del_comma(document.forms[0].BID_AMT.value));
			GridObj.cells(grid_array[i], GridObj.getColIndexById("AMT")).setValue(del_comma(document.forms[0].BID_AMT.value));
				
		}
	
	}
		     
	if(button_flag == true) {
           alert("작업이 진행중입니다.");
           return;
       }
	
	if("<%=COST_STATUS%>" != "EC"){
			alert("내정가격이 확정되지 않아 입찰을 진행하실 수 없습니다.");
			return;
		}

        if(document.forms[0].ESTM_KIND.value == "M") {
            if (document.forms[0].VOTE_CNT.value =="" || document.forms[0].VOTE_CNT.value == "0") {
				alert("복수예가는 예비가격을 투표하여야 합니다.");
				//button_flag = false;
				return;
			}
        }
        
        if(LRTrim(document.forms[0].BID_AMT.value) == "") {
            alert("투찰 단가를 입력하지 않았습니다.");
            
            if( "<%=BID_INPUT_TYPE%>"== "T" ){
            //button_flag = false;
            	document.forms[0].BID_AMT.focus();
        	}
            return;
        }
		
		if(IsTrimStr(document.forms[0].USER_NAME.value) == ""){
			alert("투찰담당자 이름을 입력하세요.");
			document.forms[0].USER_NAME.focus();
            //button_flag = false;
            return;
		}

		if(IsTrimStr(document.forms[0].USER_MOBILE.value) == ""){
			alert("투찰담당자 핸드폰을 입력하세요.");
			document.forms[0].USER_MOBILE.focus();
            //button_flag = false;
            return;
		}

		if(IsTrimStr(document.forms[0].USER_EMAIL.value) == ""){
			alert("투찰담당자 EMAIL을 입력하세요.");
			document.forms[0].USER_EMAIL.focus();
            //button_flag = false;
            return;
		}

		re=/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i;
	    if(!re.test(document.forms[0].USER_EMAIL.value)) {
			alert("투찰담당자 EMAIL 이 잘못되었습니다.");
			//button_flag = false;
			document.forms[0].USER_EMAIL.focus();
            return;
	    }
		
	    /*if(LRTrim(document.forms[0].BID_AMT_CONF.value) == "") {
            alert("확인금액을 입력 안하셨습니다.");
            button_flag = false;
            document.forms[0].BID_AMT_CONF.focus();
            return;
        }
        if(document.forms[0].BID_AMT_CONF.value != document.forms[0].BID_AMT.value) {
            alert("입찰금액과 확인금액이 일치하지 않습니다.");
            button_flag = false;
            document.forms[0].BID_AMT_CONF.value = "";
            return;
        }*/

// 		if(parseFloat(LRTrim(document.forms[0].attach_cnt.value))<=0||LRTrim(document.forms[0].attach_cnt.value)=="")
// 		{
//    			alert("제출해야할 문서가 첨부되지 않았습니다.");
//    			return;
// 		}
        
	    if( "<%=BID_INPUT_TYPE%>"== "I" && rowcount > 0){
	    	
			for(var i = 0; i < grid_array.length; i++)
			{
				var item_bid_price = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_PRICE")).getValue();
				
				
				if( item_bid_price == "" ){
					
					alert("단가를 입력하세요.");
					return;
				}				
			}
			
	    }
	    
	    if($("#chkOK").prop("checked") == false){
        	alert("Clean계약 이행 확약서에 동의하여야 합니다.");
        	return;
        }
       
        var f = document.forms[0];
        var basic_amt = Number('<%=BASIC_AMT%>');
	var AMT_VALUE = document.forms[0].BID_AMT.value;
	var AMT_VALUE_H = document.forms[0].BID_AMT_H.value;
	
	
	if(basic_amt < Number(del_comma(AMT_VALUE))){
		if(!confirm("투찰금액이 예정가격보다 높습니다.\n진행하시겠습니까?"))return;
	}

	if((basic_amt * 0.3) > Number(del_comma(AMT_VALUE))){
		if(!confirm("예정가격대비 30%이내 입찰금액입니다.\n입찰금액을 확인하시기 바랍니다.\n진행하시겠습니까?"))return;
	}
	

     var Message = "부가세 포함금액 "+AMT_VALUE+" 원 ("+AMT_VALUE_H+")으로 \n\n제출 하시겠습니까?";//AMT_VALUE는 입찰금액, AMT_VALUE_H는 입찰금액과 비교하는 금액
        if(confirm(Message) != 1){
            button_flag = false;
            return;
        }else{

           button_flag = true;

       }
        
        
     
    //SignData();
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=setBDAPinsert";
 
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    myDataProcessor = new dataProcessor( G_SERVLETURL, params );
    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
}

// 첨부파일
function setAttach(attach_key, arrAttrach,rowId, attach_count) {
    if(document.forms[0].isGridAttach.value == "true"){
        setAttach_Grid(attach_key, arrAttrach, attach_count);
        return;
    }
    var attachfilename  = arrAttrach + "";
    var result          ="";
    
    var attach_info     = attachfilename.split(",");

    for (var i =0;  i <  attach_count; i ++)
    {
        var doc_no          = attach_info[0+(i*7)];
        var doc_seq         = attach_info[1+(i*7)];
        var type            = attach_info[2+(i*7)];
        var des_file_name   = attach_info[3+(i*7)];
        var src_file_name   = attach_info[4+(i*7)];
        var file_size       = attach_info[5+(i*7)];
        var add_user_id     = attach_info[6+(i*7)];

        if (i == attach_count-1)
            result = result + src_file_name;
        else
            result = result + src_file_name + ",";
    }
    var attach_seq = document.form.attach_seq.value;
    if(attach_seq == 1){
        document.forms[0].attach_no.value       = attach_key;
        document.forms[0].attach_cnt.value      = attach_count;
        document.forms[0].only_attach.value     = "attach_no";
        setAttach1();
    }else if(attach_seq == 2){
        document.forms[0].attach_no2.value      = attach_key;
        document.forms[0].attach_cnt2.value     = attach_count;
        document.forms[0].only_attach.value     = "attach_no2";
        setAttach1();
    }
}

function setAttach1() {
    var nickName        = "SIF_001";
    var conType         = "TRANSACTION";
    var methodName      = "getFileNames";
    var SepoaOut        = doServiceAjax( nickName, conType, methodName );
    
    if( SepoaOut.status == "1" ) { // 성공
        //alert("성공적으로 처리 하였습니다.");
        var test = (SepoaOut.result[0]).split("<%=conf.getString( "sepoa.separator.line" )%>");
        var test1 = test[1].split("<%=conf.getString( "sepoa.separator.field" )%>");
        
        setAttach2(test1[0]);
        
    } else { // 실패
<%--             alert("<%=message.get("MESSAGE.1002")%>"); --%>
    }
}

function setAttach2(result){
    var text  = result.split("||");
    var text1 = "";

    for( var i = 0; i < text.length ; i++ ){
        
        text1  += text[i] + "<br/>";
    }
    document.getElementById("attach_no_text").innerHTML  = text1;
    document.getElementById("attach_no_text").style.height  = text.length*13;
}

function changeMoney30(mon, sw)
{
	var index=0;
	var i=0;
	var result="";
	var newResult="";
	var money = del_comma(mon);
	
	if(money == 0){
		alert("값을 입력하세요");
		return false;
	}
	if(isNaN(Number(del_comma(mon)))){
		//alert("숫자로 입력하세요");
		if (sw != 0) {
			alert("숫자로 입력하세요");
			//document.forms[0].BID_AMT_CONF.value ="";
            document.forms[0].BID_AMT_H.value ="";
		}
		return false;
	}
	if(money.length>13){
		alert("가용한 금액의 크기를 넘었습니다.");
		if (sw != 0) {
			//document.forms[0].BID_AMT_CONF.value ="";
            document.forms[0].BID_AMT_H.value ="";
		}
		return false;
	}
	/*
	if(money.indexOf(".")>=0){
		alert("정수로 입력하십시오");
		return false;
	}
	*/
	if(money.indexOf(".")>=0){
		var arr_money     = money.split(".");
		if(arr_money[1].length > 2){
			alert("소숫점2자리까지 입력가능 합니다.");
			return false;
		}
		if(arr_money[1].length == 0){
			alert("점(.)입력만은 불가합니다.");
			return false;
		}
	}
	
	if(money.indexOf("-")>=0){
		alert("양수로 입력하십시오");
		return false;
	}
	su = new Array("0","1","2","3","4","5","6","7","8","9");
	km = new Array("영","일","이","삼","사","오","육","칠","팔","구");
	danwi = new Array("","십","백","천","만","십","백","천","억","십","백","천","조");
	for(j=1;j<=money.length;j++){
		for(index=0;index<10;index++){
			money = money.replace(su[index],km[index]);
		}
	}
	for(index = money.length;index>0;index=index-1){
		result = money.substring(index-1,index);

		if(result=="영"){
			if(i<4 || i>8){
				result = "";
			}
			else if(i>=4 && i<8 && newResult.indexOf("만")<0){
				result = "만";
			}
			else if(i>=8 && i<12 && newResult.indexOf("억")<0){
				result = "억";
			}
			}else{
			result = result + danwi[i];
			//alert(danwi[i]);
		}
		i++;
		newResult = result + newResult;
		//alert(newResult);
	}
	for(j=1;j<newResult.length;j++){
		newResult = newResult.replace("영","");
	}
	if((newResult.indexOf("만")-newResult.indexOf("억"))==1)
		newResult = newResult.replace("만","");
	if((newResult.indexOf("억")-newResult.indexOf("조"))==1)
		newResult = newResult.replace("억","");

		if (sw == 7) {
			document.forms[0].BID_AMT_H.value = newResult + " 원";
			//document.forms[0].BID_AMT_H.size = newResult.length*2;
			//document.forms[0].BID_AMT_CONF.value = commaDel(document.forms[0].BID_AMT_CONF.value);

		} else if (sw == 0) {
			return newResult;
        }
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작--> 

<form name="form" >
<input type="hidden" name="CRYP_CERT" value="<%=CRYP_CERT%>">
<input type="hidden" name="ESTM_KIND" value="<%=ESTM_KIND%>">
<input type="hidden" name="SIGN_CERT" value="">
<input type="hidden" name="bid_no" 	  id="bid_no" 	         value="<%=BID_NO%>">                     
<input type="hidden" name="bid_count" 	  id="bid_count" 	 value="<%=BID_COUNT%>">                 
<input type="hidden" name="VOTE_COUNT" 	  id="VOTE_COUNT" 	 value="<%=VOTE_COUNT%>">   
<input type="hidden" name="att_show_flag">
<input type="hidden" name="attach_seq">	
<input type="hidden" name="isGridAttach">
<input type="hidden" name="only_attach" id="only_attach" value="">

<%@ include file="/include/sepoa_milestone.jsp"%>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
    						<colgroup>
        						<col width="15%" />
						        <col width="35%" />
						        <col width="15%" />
						        <col width="35%" />
    						</colgroup>  
    						<tr>
								<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공고번호</td>
							    <td width="35%" class="data_td">
        							<%=ANN_NO%>
      							</td>
      							<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰건명</td>
      							<td width="35%" class="data_td">
        							<%=ANN_ITEM%>
      							</td>
    						</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>     
    						<tr>
      							<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰방법</td>
      							<td width="35%" class="data_td">
      								<%=CONT_TYPE1_TEXT %>
      								<!--  <%=CONT_TYPE1_TEXT_D%> <%=CONT_TYPE2_TEXT_D%> --> 
      							</td>
      							<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자명</td>
      							<td width="35%" class="data_td">
      								<%=CHANGE_USER_NAME_LOC%>
      							</td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>  
    						<tr>
      							<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰금액 (KRW)</td>
      							<td width="35%" class="data_td">
        							<input type="text" name="BID_AMT" id="BID_AMT" value="" onblur="javascript:setOnBlur(this);" onFocus="javascript:setOnFocus(this);" onkeyup="javascript:changeMoney2(this, 7);" class="div_empty_num" <%=readonly%> <%=disabled%> style="text-align: right;">&nbsp;(VAT 포함)
      							</td>
      							<td class="title_td" width="15%">
      								<%if("true".equals(X_ESTM_CHECK)){%>
      								&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예정가격
      								<%}%>      
      							</td>
      							<td width="35%" class="data_td">
      								<%if("true".equals(X_ESTM_CHECK)){%>
      								<%= SepoaMath.SepoaNumberType(BASIC_AMT, "###,###,###,###,###,###,###,###")  %> 원
      								<%}%>            
        							<input type="hidden" name="BID_AMT_H" id="BID_AMT_H" value="" readonly="readonly" size="40" class="div_empty_num_left">
      							</td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr> 
							
							<%--
    						<tr>
      							<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;파일첨부</td>
      							<td colspan="3" class="data_td">
                        			<TABLE>
                        				<TR>
                            				<td><input type="hidden" name="attach_no" id="attach_no" readonly value="<%=ATTACH_NO%>"></td>
                            				<td>
                                				<script language="javascript">btn("javascript:attach_file(document.forms[0].attach_no.value,'TEMP');document.forms[0].attach_seq.value=1","파일첨부" )</script>
                            				</td> 
                            				<td>
                                				<input type="text" name="attach_cnt" id="attach_cnt" class="div_empty_num_no" size="2" readonly value="<%=ATTACH_CNT%>">
                                				<input type="text" size="5" readOnly class="div_empty_no" value="<%=text.get("MESSAGE.file_count")%>" name="file_count">
                            				</td>
                            				<td width="170">
                                				<div id="attach_no_text"></div>
                           					</td>
                        				</TR>
                        			</TABLE>
      							</td>
    						</tr>
    						--%>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>	
<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
    	<td width="98%" height="30">
        	<div align="right">
        		<table>
        			<tr>
          				<td><script language="javascript">btn("javascript:doBid()", "입찰서제출")</script></td>
          				<td><script language="javascript">btn("javascript:history.back(-1)", "취소")</script></td> 
		  			</tr>
				</table>  
			</div>
		</td>
	</tr>
</table> 
<br>

<%-- START GRID BOX 그리기 --%>
<div id="gridbox" name="gridbox" width="100%"   style="background-color:white;<%=gridDisplayMode%>"></div>
<div id="pagingArea"></div>
</br>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
    						<tr>
      							<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자<img src='../images/mail_point.gif' border='0'></td>
      							<td  width="35%" class="data_td">&nbsp;이름<img src='../images/mail_point.gif' border='0'>
      								<input type="text" name="USER_NAME" id="USER_NAME" size="12" class="input_re" value="<%=USER_NAME%>" onKeyUp="return chkMaxByte(50, this, '이름');">  직위 <input type="text" name="USER_POSITION" size="8" class="inputsubmit" value="<%=USER_POSITION%>" onKeyUp="return chkMaxByte(20, this, '직위');">
      							</td>
      							<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;전화번호</td>
      							<td  width="35%" class="data_td">&nbsp;
        							<input type="text" name="USER_PHONE" id="USER_PHONE" size="20" class="inputsubmit" value="<%=USER_PHONE%>" style="ime-mode:disabled;" onKeyPress="checkNumberFormat('[0-9]', this)" onKeyUp="return chkMaxByte(20, this, '전화번호');">
      							</td>
    						</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>    
    						<tr>
      							<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;핸드폰<img src='../images/mail_point.gif' border='0'></td>
      							<td  width="35%" class="data_td">&nbsp;
        							<input type="text" name="USER_MOBILE" id="USER_MOBILE" size="20" class="input_re" value="<%=USER_MOBILE%>" style="ime-mode:disabled;" onKeyPress="checkNumberFormat('[0-9]', this)" onKeyUp="return chkMaxByte(20, this, '핸드폰');" maxlength="11">
      							</td>
      							<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;EMAIL<img src='../images/mail_point.gif' border='0'></td>
      							<td  width="35%" class="data_td">&nbsp;
        							<input type="text" name="USER_EMAIL" id="USER_EMAIL" size="40" class="input_re" value="<%=USER_EMAIL%>" onKeyUp="return chkMaxByte(100, this, 'EMAIL');">
      							</td>
    						</tr>
						</table>
					</td>
				</tr>
			</table>	
		</td>
	</tr>
</table>	
</br>
<table border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="black">
	<tr align="center">
		<td class="title_td"  height="30">
			<span style="font-size:14px; font-weight:bold; color:black">Clean계약 이행 확약서</span>
		</td>
	</tr>
	<tr>
		<td class="data_td">
			<span style="font-size:12px; color:black">
				<br>
				&nbsp;&nbsp;당사는 투명한 기업경영과 공정한 경쟁이 우리은행과 당사간 상호 이익창출은 물론, 사회발전과 기업경쟁력 향상의 관건임을 깊이 인식하며,  우리은행의 &nbsp;&nbsp;<br>
				&nbsp;&nbsp;Clean계약제도 시행에 부응하여 다음 사항을 준수할 것을 확약합니다. &nbsp;&nbsp;<br><br>
				&nbsp;&nbsp;1. 업체와 협정, 결의 등으로  입찰의 자유경쟁을 부당하게 저해하는 일체의 불공정한 행위를 하지 아니한다. &nbsp;&nbsp;<br><br>
				
				&nbsp;&nbsp;2. 당사는 입찰, 계약체결 및 계약이행 과정에서 은행의 계약 및 구매  관련 임직원에게 직·간접적으로 금품, 향응, 사적금전대차(알선 포함) 등을<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;제공하지 아니한다. &nbsp;&nbsp;<br><br>
				
				&nbsp;&nbsp;3. 당사는 입찰, 계약체결 및 계약이행 과정에서 은행의 계약 및 구매  관련 임직원에게 금품, 향응, 사적금전대차(알선 포함) 등을 제공하였을 &nbsp;&nbsp;<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;경우에는 입찰제한, 계약해지, 거래중단 등 어떠한 불이익도 감수한다. &nbsp;&nbsp;<br><br>
				
				&nbsp;&nbsp;4. 당사는 입찰, 계약체결 및 계약이행 과정에서 은행의 계약 및 구매  관련 임직원에게  금품, 향응, 사적금전대차(알선 포함) 등을  제공한 사실이 &nbsp;&nbsp;<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;드러날 경우, 계약해지 등 은행의 불이익 처분과 관련하여  민·형사상 일체의 이의를 제기하지 아니한다. &nbsp;&nbsp;<br><br>
				
				&nbsp;&nbsp;5. 당사는 계약이행과정에서 환경, 인권, 회계 등에서 비윤리적인 영업행위가 발생할 경우, 거래중단과 향후 귀행  계약 및 구매 참여제한 등의  불이익 &nbsp;&nbsp;<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처분에 대해 이의를 제기하지 아니한다.
				<br><br>
			</span>
		</td>
	</tr>
	<tr align="center">
		<td height="40">
			<input type="checkbox" id="chkOK" name="chkOK" class="input_data0"> <b>위의 내용에 동의합니다.</b>
		</td>
	</tr>
</table>
<br>
<br>
<table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
    <tr align="center">
      <td><center>
			본인은 위의 번호로 공고한 귀행의  입찰에 참가하고자 입찰유의서 및 입찰공고사항과 계약조건 등 <br>
			입찰 및 계약에 필요한 모든 사항을 숙지하고 이를 승낙하며 입찰서를 제출합니다.
      </td>
    </tr>
</table>
<br>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr  align="center">
		<td>
			<b>신청인 : <%=VENDOR_NAME%> </b>
		</td>
	</tr>
    <tr  align="center">
		<td>
			<b><%=disp_current_date%></b>
      	</td>
	</tr>
</table>
</form>
<!---- END OF USER SOURCE CODE ----> 
</s:header>

<%-- END GRID BOX 그리기 --%>
<s:footer/>
</body>
</html>


