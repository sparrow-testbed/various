<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AR_001_4");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AR_001_4";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String user_id         = info.getSession("ID");
	String company_code    = info.getSession("COMPANY_CODE");
	String house_code      = info.getSession("HOUSE_CODE");
	String toDays          = SepoaDate.getShortDateString();
	String toDays_1        = SepoaDate.addSepoaDateMonth(toDays,-1);
	String user_name   	   = info.getSession("NAME_LOC");
	String ctrl_code       = info.getSession("CTRL_CODE");
	
	String convert_date = SepoaString.getDateSlashFormat(toDays);
	
	String po_no		   = JSPUtil.nullToEmpty(request.getParameter("po_no"));
	String EXEC_AMT		   = JSPUtil.nullToEmpty(request.getParameter("exec_amt"));
	String total_amt		= JSPUtil.nullToEmpty(request.getParameter("total_amt"));
	// 대금지불방식은 초기 일괄지급(AM)으로 세팅
	String dp_type		   = JSPUtil.nullToRef(request.getParameter("dp_type"),"AM");
	String cur		   	   = JSPUtil.nullToEmpty(request.getParameter("cur"));
	String mode			   = JSPUtil.nullToEmpty(request.getParameter("mode"));
	String dp_div		   = JSPUtil.nullToEmpty(request.getParameter("dp_div"));
	String pre_cont_seq	   = JSPUtil.nullToEmpty(request.getParameter("pre_cont_seq"));
	
	String pFirst_method = JSPUtil.nullToEmpty(request.getParameter("first_method"));
	String pContract_method = JSPUtil.nullToEmpty(request.getParameter("contract_method"));
	String pMengel_method = JSPUtil.nullToEmpty(request.getParameter("mengel_method"));

	String readOnly = mode.equals("popup") ? "readOnly" : "" ;

	String dp_type_list = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M134", dp_type);
	SepoaListBox LB = new SepoaListBox();
	String shipper_type = cur.equals("KRW")? "D":"O";
	String COMBO_M000 = LB.Table_ListBox(request, "SL0127", house_code+"#M010#"+shipper_type, "&" , "#");

	StringTokenizer st = new StringTokenizer(COMBO_M000,"#");
	int tokenCount = st.countTokens();
	String COMBO_M010 = "";
	String temp_text = "";
	for( int i=0; i<tokenCount; i++){
		StringTokenizer temp_st = new StringTokenizer(st.nextToken(),"&");
		temp_text = temp_st.nextToken()+"#";
		COMBO_M010 += temp_st.nextToken()+"&"+temp_text;
	}
	
	COMBO_M010 = COMBO_M010.replace(System.getProperty("line.separator"), "");
	
	String first_method =  ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M355", pFirst_method);
	String contract_method =  ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M355", pContract_method);
	String mengel_method =  ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M355", pMengel_method);

%>
<% String WISEHUB_PROCESS_ID="AR_001_4";%> 

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script language="javascript">
var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_pp_ins3";
var mode = "<%=mode%>";
var checked_count = 0;
var EXEC_AMT = <%=EXEC_AMT%>;
var IDX_SEL				;
var IDX_DP_SEQ			;
var IDX_PAY_TERMS		;
var IDX_PAY_TERMS_TEXT	;
var IDX_DP_PERCENT		;
var IDX_DP_AMT			;
var IDX_DP_PLAN_DATE	;

var chkrow;

function setHeader() {
	GridObj.bHDMoving 			= false;
	GridObj.bHDSwapping 			= false;
	GridObj.bRowSelectorVisible 	= false;
	GridObj.strRowBorderStyle 	= "none";
	GridObj.nRowSpacing 			= 0 ;
	GridObj.strHDClickAction 		= "select";

	var editFlag = true;
	if(mode == "popup"){
		editFlag = false;
		document.forms[0].pay_term.disabled = true;
	}

// 	GridObj.SetNumberFormat("DP_AMT"			 	,G_format_amt);
// 	GridObj.SetNumberFormat("DP_PERCENT"		 	,G_format_pctg);
// 	GridObj.SetDateFormat("DP_PLAN_DATE","yyyy/MM/dd");


	IDX_SEL				= GridObj.GetColHDIndex("SEL"				    );
	IDX_DP_SEQ			= GridObj.GetColHDIndex("DP_SEQ"			    );
	IDX_PAY_TERMS		= GridObj.GetColHDIndex("PAY_TERMS"			);
	IDX_PAY_TERMS_TEXT	= GridObj.GetColHDIndex("PAY_TERMS_TEXT"	    );
	IDX_DP_PERCENT		= GridObj.GetColHDIndex("DP_PERCENT"		    );
	IDX_DP_AMT			= GridObj.GetColHDIndex("DP_AMT"			    );

	getList();
}

function RoundEx(val, pos){
    var rtn;
    
    rtn = Math.round(val * Math.pow(10, Math.abs(pos)-1))
    rtn = rtn / Math.pow(10, Math.abs(pos)-1)

    return rtn;
}


function add_comma(input, num)
{
    var output = "";
    var output1 = "";
    var output2 = "";
    var temp1 = IsTrimStr(input);

    if(temp1 != "") {
        var temp = fixed_number(temp1);

        i = temp.length ;

        var k = i / 3 ;
        var m = i % 3 ;
        var n= 0;
        if(m==0) {
            for(j = 0; j < k-1; j++) {
                output1 += temp.substring(n, j*3+3)+",";
                n=j*3+3;
            }
        } else {
            for(j = 0; j < k-1; j++){
                output1 += temp.substring(n, j*3+m)+",";
                n=j*3+m;
            }
        }

        output1 += temp.substring(n,temp.length);
        var h = searchDot(temp1);
        if(num != "0") {
            //output2 += "." ;
        }
        if(h == ""){
            for(p=0; p < num; p++){
                //output2 += "0" ;
            }
        } else {
            var temp2 = decimal_number(temp1,num)+"" ;
            temp2 = temp2.substring(1,temp2.length);
            output2 = temp2;
        }
        output = output1 + output2 ;

    } else if(temp1 == "") {
        if(num == "0"){
            output += "" ;
        }else{
            output += "0." ;
        }

        for(p=0; p < num; p++){
            output += "0" ;
        }
    }
    var tmp1 = "";

    if(output.charAt(0)=="-"){
        if(output.charAt(1)==",") {
            tmp1 = output.substring(2, output.length);
            output = "-"+tmp1;
        }
    }
    return output;
}

function del_comma(input){
	var s = 0;
   	for(i=0; i < input.length; i++){
        if(input.charAt(i)==","){
            s++ ;
        }
    }
    for(i = 0;i < s; i++){
        input = input.replace(",", "");
    }
    return input;
}


function getList()
{
	var openGrid = opener.GridObj2;
	var rowCount = GridObj.GetRowCount();
	for( row = rowCount ; row > 0 ; row--){
		GridObj.DeleteRow(row-1);
	}
	var openGridRowCount = 0;
	for(var i=0; i<openGrid.GetRowCount(); i++){
		if(openGrid.GetCellValue("DP_DIV", i) == "<%=dp_div%>"){
			openGridRowCount++;
		}
	}
	document.forms[0].t_count.value = openGridRowCount;

	var dp_div_index = -1;
	var pay_amt = 0;
	var dp_code = "";

	GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).clear();
	if(document.forms[0].pay_term.value != "AM"){
		GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).put("1", "선급금");
		GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).put("2", "중도금");
		GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).put("3", "잔금");
	}else{
		GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).put("3", "일시금");
	}

	
	for( row = 0 ; row < openGrid.GetRowCount() ; row++){
		if(openGrid.GetCellValue("DP_DIV", row) == "<%=dp_div%>"){
			dp_div_index++;
			var newId = (new Date()).valueOf() + row;
			GridObj.addRow(newId,"");
			//GridObj.AddRow();
			var tmpDate = openGrid.GetCellValue("DP_PLAN_DATE",row);
			
//			alert(tmpDate.substring(0,4) + "-" + tmpDate.substring(4,6) + "-" + tmpDate.substring(6,8)); 
			
			GridObj.cells(GridObj.getRowId(dp_div_index), GridObj.getColIndexById("SELECTED"		)).setValue( "1"	);
			GridObj.cells(GridObj.getRowId(dp_div_index), GridObj.getColIndexById("DP_SEQ"			)).setValue( (dp_div_index+1)+"차");
			GridObj.cells(GridObj.getRowId(dp_div_index), GridObj.getColIndexById("DP_PERCENT"      )).setValue( openGrid.GetCellValue("DP_PERCENT"		,row));
			GridObj.cells(GridObj.getRowId(dp_div_index), GridObj.getColIndexById("DP_AMT"          )).setValue( openGrid.GetCellValue("DP_AMT"			,row));
			GridObj.cells(GridObj.getRowId(dp_div_index), GridObj.getColIndexById("PAY_TERMS_TEXT"  )).setValue( openGrid.GetCellValue("DP_PAY_TERMS_TEXT",row));
			GridObj.cells(GridObj.getRowId(dp_div_index), GridObj.getColIndexById("DP_PLAN_DATE"	)).setValue( tmpDate );
			GridObj.cells(GridObj.getRowId(dp_div_index), GridObj.getColIndexById("DP_CODE"	)).setValue( "3" );
			if(dp_div_index == 0){	//최초 한번만 값을 setting한다.
				document.forms[0].FIRST_DEPOSIT.value     = add_comma(openGrid.GetCellValue("FIRST_DEPOSIT"       , row ),0);
				document.forms[0].FIRST_PERCENT.value     = add_comma(openGrid.GetCellValue("FIRST_PERCENT"       , row ),0);
				document.forms[0].CONTRACT_DEPOSIT.value  = add_comma(openGrid.GetCellValue("CONTRACT_DEPOSIT"    , row ),0);
				document.forms[0].CONTRACT_PERCENT.value  = add_comma(openGrid.GetCellValue("CONTRACT_PERCENT"    , row ),0);
				document.forms[0].MENGEL_DEPOSIT.value    = add_comma(openGrid.GetCellValue("MENGEL_DEPOSIT"      , row ),0);
				document.forms[0].MENGEL_PERCENT.value    = add_comma(openGrid.GetCellValue("MENGEL_PERCENT"	  , row ),0);
			}
<%-- 			GD_SetCellValueIndex(GridObj,dp_div_index, IDX_PAY_TERMS 	,"<%=COMBO_M010%>", "&","#"); --%>
			GD_SetCellValueIndex(GridObj,dp_div_index, IDX_PAY_TERMS 	,openGrid.GetCellValue("DP_PAY_TERMS",row));

// 			GridObj.SetComboSelectedHiddenValue("PAY_TERMS", dp_div_index,openGrid.GetCellValue("DP_PAY_TERMS",row));

			pay_amt +=  parseFloat(GridObj.GetCellValue("DP_AMT", dp_div_index)) ;
		}
	}
	
	if(openGrid.GetRowCount() > 0 && dp_div_index == -1){
		document.forms[0].FIRST_PERCENT.value     = add_comma(openGrid.GetCellValue("FIRST_PERCENT"       , 0 ),0);
		document.forms[0].CONTRACT_PERCENT.value  = add_comma(openGrid.GetCellValue("CONTRACT_PERCENT"    , 0 ),0);
		document.forms[0].MENGEL_PERCENT.value    = add_comma(openGrid.GetCellValue("MENGEL_PERCENT"	  , 0 ),0);
		
	}
	
	
	//변경계약일 경우 전체금액을 입력하도록 한다.
	if(!"<%=pre_cont_seq%>"==""){
		pay_amt = "<%=EXEC_AMT%>";
		
		//변경계약시 기승인금액이면 %를 계산하여 입력한다.
		for(var row=0; row < GridObj.GetRowCount(); row++){
			if(GridObj.GetCellValue("PRE_CONT_YN",row)=='Y'){
				GridObj.SetRowActivation(row, 'disable');	//Row 수정 불가처리.
				var ls_pay_amt = pay_amt;
				var ls_dp_amt = del_comma(openGrid.GetCellValue("DP_AMT", row));
				GridObj.SetCellValueIndex(IDX_DP_PERCENT, row, RoundEx( ls_dp_amt/parseFloat(del_comma(ls_pay_amt))*10000/100, 3) );
			}
		}
	}

	if(GridObj.GetRowCount() == 0){	// 최초등록시

		var S_item_amt = 0; // 용역공급가액 합
		var I_item_amt = 0; // 물품공급가액 합

		var sub_item = "";
		var openGrid = opener.GridObj;

		for( i = 0 ; i <openGrid.GetRowCount(); i++ ){
			if(openGrid.GetCellValue("ITEM_NO",i) == ""){
				continue;
			}

			sub_item	= openGrid.GetCellValue("ITEM_GBN",i);
			if(sub_item != "S" ){
				I_item_amt += parseInt(openGrid.GetCellValue("ITEM_AMT",i) == "" ? "0" : openGrid.GetCellValue("ITEM_AMT",i));
			}else {
				S_item_amt += parseInt(openGrid.GetCellValue("ITEM_AMT",i) == "" ? "0" : openGrid.GetCellValue("ITEM_AMT",i));
			}
		}
		if("I" == "<%=dp_div%>"){
			document.forms[0].pay_amt.value = add_comma(RoundEx(I_item_amt, 3), 2);
			document.forms[0].total_amt.value = add_comma(RoundEx(I_item_amt, 3), 2);
		}else if("S" == "<%=dp_div%>"){
			document.forms[0].pay_amt.value = add_comma(RoundEx(S_item_amt, 3), 2);
			document.forms[0].total_amt.value = add_comma(RoundEx(S_item_amt, 3), 2);
		}
		
	}else {										// 기존에 등록시
		document.forms[0].pay_amt.value = add_comma(RoundEx(pay_amt, 3), 2);
		document.forms[0].total_amt.value = add_comma(RoundEx(pay_amt, 3), 2);
	}
}

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	var f0              = document.forms[0];
	var row             = GridObj.GetRowCount();
	var po_no           = "";
	var shipper         = "";
	var sign_flag       = "";
	var pay_amt			= document.forms[0].pay_amt.value == "" ? "0" : document.forms[0].pay_amt.value;
	if(msg1 == "t_insert")
	{
		if(msg3==IDX_DP_PERCENT){
			if(parseFloat(pay_amt) == 0){
				alert("용역/물품대금을 입력하여 주십시요.");
				GridObj.SetCellValueIndex(msg3,msg2,msg4);
				document.forms[0].pay_amt.focus();
				return;
			}
			if(msg5 <= 0 || msg5 > 100){
				alert("지급율은 1보다 작거나 100보다 클 수 없습니다.");
				GridObj.SetCellValueIndex(msg3,msg2,msg4);
				return;
			}
			GridObj.SetCellValueIndex(IDX_DP_AMT,msg2,setAmt(RoundEx(msg5/100*parseFloat(del_comma(pay_amt))*100/100, 3)));
			if(msg2==0)
				changeDeposit();
		}
		if(msg3==IDX_DP_AMT){
			if(parseFloat(pay_amt) == 0){
				alert("용역/물품대금을 입력하여 주십시요.");
				GridObj.cells(GridObj.getRowId(msg2), GridObj.getColIndexById("DP_AMT")).setValue(msg4);
// 				GridObj.SetCellValueIndex(msg3,msg2,msg4);
				document.forms[0].pay_amt.focus();
				return;
			}
			if(msg5 <= 0 || msg5 > parseFloat(del_comma(pay_amt))){
				alert("지급 금액이 0원 이거나 용역/물품대금 가능금액을 넘을수 없습니다.");
				GridObj.SetCellValueIndex(msg3,msg2,msg4);
				return;
			}
			GridObj.SetCellValueIndex(IDX_DP_PERCENT,msg2,RoundEx(msg5/parseFloat(del_comma(pay_amt))*10000/100, 3));
			if(msg2==0) changeDeposit();
		}
		var empty_cnt 		= 0;
		var empty_row 		= -1;
		var sum_DP_PERCENT 	= 0;
		var sum_DP_AMT		= 0;
		for(var i=0; i<GridObj.GetRowCount(); i++){
			sum_DP_PERCENT	+= parseFloat(del_comma(GridObj.GetCellValue("DP_PERCENT", i) == "" ? "0" : RoundEx(GridObj.GetCellValue("DP_PERCENT", i),2)  ));
			sum_DP_AMT		+= parseFloat(del_comma(GridObj.GetCellValue("DP_AMT", i)		== "" ? "0" : GridObj.GetCellValue("DP_AMT", i)));
			if(GridObj.GetCellValue("DP_PERCENT", i) == ""){
				empty_cnt++;
				empty_row = i;
			}
		}
		
		//alert(sum_DP_PERCENT + " : " + sum_DP_AMT);
		
		if(empty_cnt == 1){
			GridObj.cells(GridObj.getRowId(empty_row), GridObj.getColIndexById("DP_PERCENT")).setValue( RoundEx(100 - sum_DP_PERCENT, 2) );
			GridObj.cells(GridObj.getRowId(empty_row), GridObj.getColIndexById("DP_AMT")).setValue(parseFloat(del_comma(pay_amt)) - sum_DP_AMT);
			
// 			GridObj.SetCellValue("DP_PERCENT"	, empty_row, 100 - sum_DP_PERCENT);
// 			GridObj.SetCellValue("DP_AMT"		, empty_row, parseFloat(del_comma(pay_amt)) - sum_DP_AMT);
			if(empty_row == 0){
				changeDeposit();
			}
		}
	}
	else if(msg1 == "doQuery") {
		changePay("AM");
	}
}

function changePay(val_1){
	
	if(val_1 == "AM"){
		document.all.span_count.style.display = "none";
		document.all.t_count.value = 1;
		document.forms[0].FIRST_PERCENT.value		= "";
		document.forms[0].CONTRACT_PERCENT.value	= "";
		document.forms[0].MENGEL_PERCENT.value		= "";
		document.forms[0].FIRST_DEPOSIT.value  		= "";
		document.forms[0].CONTRACT_DEPOSIT.value 	= "";
		document.forms[0].MENGEL_DEPOSIT.value 		= "";
		addRow();

// 		GridObj.SetCellValue("DP_PERCENT"	, 0, 100);
// 		GridObj.SetCellValue("DP_AMT"		, 0, del_comma(document.forms[0].pay_amt.value));
		
		GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DP_PERCENT")).setValue(100);
		GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DP_AMT")).setValue(del_comma(document.forms[0].pay_amt.value));		
		
	}else{
		document.all.span_count.style.display = "block";
		addRow();
		document.all.FIRST_PERCENT.disabled = false;
	}
}

function changeDeposit(){
	var pay_amt	 = document.forms[0].pay_amt.value == "" ? "0" : document.forms[0].pay_amt.value;
	var total_amt	 = document.forms[0].total_amt.value == "" ? "0" : document.forms[0].total_amt.value;
	var f_percent = document.forms[0].FIRST_PERCENT.value;
	var c_percent = document.forms[0].CONTRACT_PERCENT.value;
	var m_percent = document.forms[0].MENGEL_PERCENT.value;
	if(f_percent < 0 || c_percent < 0 || m_percent < 0 || f_percent > 100 || c_percent > 100 || c_percent > 100 ){
		alert("백분율은 0이상 100 이하여야 합니다.");
		document.forms[0].FIRST_PERCENT.value		= 0;
		document.forms[0].CONTRACT_PERCENT.value	= 0;
		document.forms[0].MENGEL_PERCENT.value		= 0;
		document.forms[0].FIRST_DEPOSIT.value  		= 0;
		document.forms[0].CONTRACT_DEPOSIT.value 	= 0;
		document.forms[0].MENGEL_DEPOSIT.value 		= 0;
		return;
	}
	var rowCount = GridObj.GetRowCount();
	var first_amt = 0;
	if(rowCount > 0){
		
		first_amt = GridObj.GetCellValue("DP_AMT",0);
		
// 		if(typeof(first_amt)=="undefined"){
// 			first_amt = 0;
// 		}
		
// 		var tmp = parseFloat(LRTrim(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DP_AMT")).getValue()));
// 		first_amt = parseFloat(LRTrim(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DP_AMT")).getValue()) == "" ? "0" : LRTrim(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DP_AMT")).getValue()));
// 		first_amt = tmp == NaN ? 0 : tmp;
		
// 		alert(tmp + " : " + first_amt);
		
		
		
		
		//document.forms[0].FIRST_DEPOSIT.value 	= add_comma(RoundEx((first_amt*f_percent/100*1.1), 3),2);
// 		document.forms[0].FIRST_DEPOSIT.value 	= add_comma(setAmt(RoundEx((first_amt*f_percent/100*1.1), 3)),2);
		document.forms[0].FIRST_DEPOSIT.value 	= add_comma(setAmt(RoundEx((first_amt*f_percent/100), 3)),2);
	}

	//document.forms[0].CONTRACT_DEPOSIT.value 	= add_comma(RoundEx((parseFloat(del_comma(pay_amt))*c_percent/100*1.1),3),2);
	//document.forms[0].MENGEL_DEPOSIT.value 		= add_comma(RoundEx((parseFloat(del_comma(pay_amt))*m_percent/100*1.1),3),2);
// 	document.forms[0].CONTRACT_DEPOSIT.value 	= add_comma(setAmt(RoundEx((parseFloat(del_comma(total_amt))*c_percent/100*1.1),3)),2);
// 	document.forms[0].MENGEL_DEPOSIT.value 		= add_comma(setAmt(RoundEx((parseFloat(del_comma(total_amt))*m_percent/100*1.1),3)),2);
	document.forms[0].CONTRACT_DEPOSIT.value 	= add_comma(setAmt(RoundEx((parseFloat(del_comma(total_amt))*c_percent/100),3)),2);
	document.forms[0].MENGEL_DEPOSIT.value 		= add_comma(setAmt(RoundEx((parseFloat(del_comma(total_amt))*m_percent/100),3)),2);
}

function IsNumber(num){
	var i;
	pcnt = 0;

	for(i=0;i < num.length;i++){
		if (num.charAt(i) == '.'){
			pcnt ++;
		}
		if((num.charAt(i) < '0' || num.charAt(i) > '9') && (num.charAt(i) != '.' ||  pcnt>1)){
		  	return false;
		}
	}
	return true;
}

function addRow(){
	var rowCount = document.forms[0].t_count.value;
	if(!IsNumber(rowCount)){
		alert("숫자를 입력해 주세요");
		document.forms[0].t_count.value="";
		document.forms[0].t_count.focus();
		return;
	}
	if('<%=pre_cont_seq%>'== ''){
		GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).clear();
		if(document.forms[0].pay_term.value != "AM"){
			GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).put("1", "선급금");
			GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).put("2", "중도금");
			GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).put("3", "잔금");
		}else{
			GridObj.getCombo(GridObj.getColIndexById("DP_CODE")).put("3", "일시금");
		}
	}

	var dp_code = "";
	var gridRowCount = GridObj.GetRowCount();
	for(var i = gridRowCount ; i > 0 ; i--){
		if(GridObj.GetCellValue("PRE_CONT_YN", i-1) != 'Y'){//변경계약일 때 기 지급금액이 아니라면 삭제하도록한다.
			GridObj.deleteRow(GridObj.getRowId(i-1));
			//GridObj.deleteRow(i-1);
		}	
	}
	
	for(var i = GridObj.GetRowCount() ; i < rowCount ; i++){
//		GridObj.AddRow();
		var newId = (new Date()).valueOf() + i;
		GridObj.addRow(newId,"");
		
		if(i==0 && rowCount ==1){
			dp_code="3";
		}else if(i==0){
			dp_code="1";
		}else if(i == rowCount-1){
			dp_code="3";
		}else{
			dp_code="2";
		}
		//변경계약에 해당하는 지급 조건일 경우 모두 잔금으로 처리합니다.
		if(!'<%=pre_cont_seq%>'== ''){
			dp_code="3";
		}
// 		GridObj.SetCellValue("DP_SEQ",i,(i+1)+"차" );
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("DP_SEQ")).setValue((i+1)+"차");
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("DP_CODE")).setValue(dp_code);
// 		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("PAY_TERMS")).setValue(payTerms);
		
// 		GridObj.SetComboSelectedHiddenValue("DP_CODE" 				, i, dp_code);
<%-- 		GD_SetCellValueIndex(GridObj,i, IDX_PAY_TERMS 	,"<%=COMBO_M010%>", "&","#",0); --%>
	}
// 	GridObj.ClearSummaryBar();
// 	GridObj.AddSummaryBar( "SUMMARY1","합 계","summaryall","sum","DP_PERCENT,DP_AMT");
// 	GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
	changeDeposit();
}

function setAmt(value) {
	rlt = 0;
	if(value == "" || value == 0) return 0;

	rlt = Math.floor(new Number(value) * 1) / 1;

	return rlt;
}

function Save(){
	
	changeDeposit();
	
	var pay_amt				= document.forms[0].pay_amt.value == "" ? "0" : document.forms[0].pay_amt.value;
	var insurance = "N";
	var openGrid 	 		= opener.GridObj2;
	var DP_TYPE 	 		= document.forms[0].pay_term.value;
	var DP_TYPE_TEXT 		= document.forms[0].pay_term.options[document.all.pay_term.selectedIndex].text;
	var FIRST_DEPOSIT       = del_comma(document.forms[0].FIRST_DEPOSIT.value	);
	var FIRST_PERCENT       = del_comma(document.forms[0].FIRST_PERCENT.value	);
	var CONTRACT_DEPOSIT    = del_comma(document.forms[0].CONTRACT_DEPOSIT.value);
	var CONTRACT_PERCENT    = del_comma(document.forms[0].CONTRACT_PERCENT.value);
	var MENGEL_DEPOSIT      = del_comma(document.forms[0].MENGEL_DEPOSIT.value	);
	var MENGEL_PERCENT		= del_comma(document.forms[0].MENGEL_PERCENT.value	);
	var FIRST_METHOD		= document.forms[0].first_method.value;
	var CONTRACT_METHOD		= document.forms[0].contract_method.value;
	var MENGEL_METHOD 		= document.forms[0].mengel_method.value;
	
	var openGridRowCount = openGrid.GetRowCount();
	for( i = openGridRowCount ; i > 0 ; i--){		
		if(openGrid.GetCellValue("DP_DIV", i-1) == "<%=dp_div%>"){
			openGrid.deleteRow(openGrid.getRowId(i-1));
// 			openGrid.DeleteRow(i-1);
		}
	}
	for(var j = 0 ; j < GridObj.GetRowCount() ; j++ ){
		if(GridObj.GetCellValue("PAY_TERMS", j ) == ""){
			alert("대급지급방법을 선택하셔야 합니다.");
			return;
		}			
		
		if(GridObj.GetCellValue("DP_PLAN_DATE", j ) == ""){
			alert("대급예정일을 입력하셔야 합니다.");
			return;
		}
		
	} 

	if(FIRST_PERCENT!=""||CONTRACT_PERCENT!=""||MENGEL_PERCENT!="")
		insurance = "Y"

	var rowCount = GridObj.GetRowCount();

	if(parseFloat(del_comma(pay_amt)) == 0){
		alert("물품대금을 입력하여 주십시요.");
		document.forms[0].pay_amt.focus();
		return;
	}

	if(rowCount == 0 ){
		alert("대금지불 정보를 입력하여 주십시요.");
		return;
	}
	<%
		if("I".equals(dp_div)){
	%>
		opener.document.forms[0].i_dp_type.value 	  	= DP_TYPE;
		opener.document.forms[0].i_dp_type_text.value 	= DP_TYPE_TEXT;
		opener.document.forms[0].i_dp_count.value 		= rowCount;
		opener.document.forms[0].i_insurance.value 		= insurance;
	<%
		}else if("S".equals(dp_div)){
	%>
		opener.document.forms[0].s_dp_type.value 	  	= DP_TYPE;
		opener.document.forms[0].s_dp_type_text.value 	= DP_TYPE_TEXT;
		opener.document.forms[0].s_dp_count.value 		= rowCount;
		opener.document.forms[0].s_insurance.value 		= insurance;
	<%
	}
	%>
	
	//var DP_PERCENT = openGrid.GetCellValue("DP_PERCENT",0);
	var DP_AMT = 0;
	if(openGrid.GetRowCount() > 0){
		DP_AMT = openGrid.GetCellValue("DP_AMT",0);	
	}
	
	var checkPer = 0;
	for( i = 0 ; i < openGrid.GetRowCount(); i++){
		
// 		openGrid.cells(openGrid.getRowId(0), openGrid.getColIndexById("FIRST_DEPOSIT")).setValue(setAmt(RoundEx((DP_AMT*FIRST_PERCENT/100*1.1), 3)));
		
		openGrid.cells(openGrid.getRowId(i), openGrid.getColIndexById("FIRST_DEPOSIT"       )).setValue( setAmt(RoundEx((DP_AMT*FIRST_PERCENT/100*1.1), 3)));
		openGrid.cells(openGrid.getRowId(i), openGrid.getColIndexById("FIRST_PERCENT"       )).setValue( FIRST_PERCENT       );
		openGrid.cells(openGrid.getRowId(i), openGrid.getColIndexById("CONTRACT_DEPOSIT"    )).setValue( CONTRACT_DEPOSIT    );
		openGrid.cells(openGrid.getRowId(i), openGrid.getColIndexById("CONTRACT_PERCENT"    )).setValue( CONTRACT_PERCENT    );
		openGrid.cells(openGrid.getRowId(i), openGrid.getColIndexById("MENGEL_DEPOSIT"      )).setValue( MENGEL_DEPOSIT      );
		openGrid.cells(openGrid.getRowId(i), openGrid.getColIndexById("MENGEL_PERCENT"		)).setValue( MENGEL_PERCENT		 );
		openGrid.cells(openGrid.getRowId(i), openGrid.getColIndexById("FIRST_METHOD"		)).setValue( FIRST_METHOD		 );
		openGrid.cells(openGrid.getRowId(i), openGrid.getColIndexById("CONTRACT_METHOD"		)).setValue( CONTRACT_METHOD		 );
		openGrid.cells(openGrid.getRowId(i), openGrid.getColIndexById("MENGEL_METHOD"		)).setValue( MENGEL_METHOD		 );

// 		openGrid.SetCellValue("FIRST_DEPOSIT"       , i, setAmt(RoundEx((DP_AMT*FIRST_PERCENT/100*1.1), 3))       );
// 		openGrid.SetCellValue("FIRST_PERCENT"       , i, FIRST_PERCENT       );
// 		openGrid.SetCellValue("CONTRACT_DEPOSIT"    , i, CONTRACT_DEPOSIT    );
// 		openGrid.SetCellValue("CONTRACT_PERCENT"    , i, CONTRACT_PERCENT    );
// 		openGrid.SetCellValue("MENGEL_DEPOSIT"      , i, MENGEL_DEPOSIT      );
// 		openGrid.SetCellValue("MENGEL_PERCENT"		, i, MENGEL_PERCENT		 );
// 		openGrid.SetCellValue("FIRST_METHOD"		, i, FIRST_METHOD		 );
// 		openGrid.SetCellValue("CONTRACT_METHOD"		, i, CONTRACT_METHOD		 );
// 		openGrid.SetCellValue("MENGEL_METHOD"		, i, MENGEL_METHOD		 );
	}
	for( i = 0 ; i < rowCount ; i++){
// 		openGrid.AddRow();
		var newId = (new Date()).valueOf() + i;
		openGrid.addRow(newId,"");
		
		openIndex = openGrid.GetRowCount() -1;
		checkPer += parseFloat(GridObj.GetCellValue("DP_AMT",i) == "" ? "0" : GridObj.GetCellValue("DP_AMT",i));
		
		
// 		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("FIRST_DEPOSIT"       )).setValue( setAmt(RoundEx((DP_AMT*FIRST_PERCENT/100*1.1), 3)));
		
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("SEL"					)).setValue( "1");
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("DP_SEQ"			    )).setValue( i+1);
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("DP_TYPE"             )).setValue( DP_TYPE);
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("DP_PERCENT"          )).setValue( GridObj.GetCellValue("DP_PERCENT",i));
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("DP_AMT"              )).setValue( GridObj.GetCellValue("DP_AMT",i));
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("DP_PLAN_DATE"        )).setValue( GridObj.GetCellValue("DP_PLAN_DATE",i));
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("DP_PAY_TERMS"        )).setValue( GridObj.GetCellValue("PAY_TERMS",i));
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("DP_PAY_TERMS_TEXT"   )).setValue( GridObj.GetCellValue("PAY_TERMS_TEXT",i));
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("FIRST_DEPOSIT"       )).setValue( FIRST_DEPOSIT       );
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("FIRST_PERCENT"       )).setValue( FIRST_PERCENT       );
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("CONTRACT_DEPOSIT"    )).setValue( CONTRACT_DEPOSIT    );
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("CONTRACT_PERCENT"    )).setValue( CONTRACT_PERCENT    );
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("MENGEL_DEPOSIT"      )).setValue( MENGEL_DEPOSIT      );
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("MENGEL_PERCENT"		)).setValue( MENGEL_PERCENT		 );
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("DP_DIV"				)).setValue( "<%=dp_div%>"		 );
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("DP_CODE"          	)).setValue( GridObj.GetCellValue("DP_CODE",i));
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("PRE_CONT_YN"         )).setValue( GridObj.GetCellValue("PRE_CONT_YN",i));
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("FIRST_METHOD"		)).setValue( FIRST_METHOD		 );
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("CONTRACT_METHOD"		)).setValue( CONTRACT_METHOD		 );
		openGrid.cells(openGrid.getRowId(openIndex), openGrid.getColIndexById("MENGEL_METHOD"		)).setValue( MENGEL_METHOD		 );
	}

	if(checkPer != parseFloat(del_comma(pay_amt))){

		alert("지급금액의 총합이 "+add_comma(parseFloat(del_comma(pay_amt)), 2)+" 여야 합니다.");
		openGridRowCount = openGrid.GetRowCount();
		for( i = openGridRowCount ; i > 0 ; i--){

			if(openGrid.GetCellValue("DP_DIV", i-1) == "<%=dp_div%>"){
// 				openGrid.DeleteRow(i-1);
				openGrid.deleteRow(openGrid.getRowId(i-1));
			}

		}
		return;
	}

	var gridObj = opener.GridObj;
	var gridObjRowCount = gridObj.GetRowCount();
	for( i = 0 ; i < gridObjRowCount ; i++){
// 		gridObj.cells(gridObj.getRowId(openIndex), gridObj.getColIndexById("PAY_TERMS_HD_DESC"	)).setValue( DP_TYPE_TEXT);
// 		gridObj.cells(gridObj.getRowId(openIndex), gridObj.getColIndexById("PAY_TERMS_HD"	  	)).setValue( DP_TYPE);
// 		gridObj.cells(gridObj.getRowId(openIndex), gridObj.getColIndexById("PAY_TERMS"		  	)).setValue( "1");
// 		gridObj.SetComboSelectedHiddenValue("INSURANCE"		, i, insurance);
// 		gridObj.cells(gridObj.getRowId(openIndex), gridObj.getColIndexById("INSURANCE"			)).setValue( insurance);
	}

	<%
		if("S".equals(dp_div)){
	%>
		opener.document.forms[0].s_pay_amt.value = pay_amt;
	<%
		}else if("I".equals(dp_div)){
	%>
		opener.document.forms[0].i_pay_amt.value = pay_amt;
	<%
	}
	%>
	alert("저장되었습니다.");
	window.close();
}

function checkNumber(obj){

	if(!isNumberCommon(obj.value)){
		alert("숫자만 입력가능합니다.");
		obj.focus();
		return;
	}

	if(obj.name == "pay_amt"){
		if(parseFloat(EXEC_AMT) < parseFloat(obj.value)){
			alert("물품대금은 품의금액보다 클 수 없습니다.");
			obj.focus();
			return;
		}
	}
	obj.value = add_comma(obj.value, 2);
}

function chagneDpAmt(){

	var pay_amt		= document.forms[0].pay_amt.value == "" ? "0" : document.forms[0].pay_amt.value;
	var dp_percent	= 0;

	for(var i=0; i<GridObj.GetRowCount(); i++){
		dp_percent  = GridObj.GetCellValue("DP_PERCENT", i)	== "" ? 0 : GridObj.GetCellValue("DP_PERCENT", i);
		
		
		GridObj.SetCellValue("DP_AMT", i, RoundEx(parseFloat(dp_percent)/100*parseFloat(del_comma(pay_amt))*100/100, 3));
	}
}

function init(){
	if(new Number(getDpCnt()) == 0){
		document.all.span_count.style.display = "none";
		form1.t_count.value = "1";
		addRow();
		
// 		GridObj.SetCellValue("DP_PERCENT"	, 0, 100);
// 		GridObj.SetCellValue("DP_AMT"		, 0, del_comma(document.forms[0].pay_amt.value));
		GridObj.setColumnExcellType( GridObj.getColIndexById( LRTrim( "DP_AMT " ) ), LRTrim( "ron " ) );//edn 속성을 ron으로 변경
		GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DP_PERCENT")).setValue(100);
		GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DP_AMT")).setValue(del_comma(document.forms[0].pay_amt.value));
		
		GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("PAY_TERMS")).setValue("001");
 		GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DP_PLAN_DATE")).setValue("<%=convert_date %>");
	}
}

function getDpCnt(){
	var openGrid = opener.GridObj2;
	var dpDivCnt=0;
	for( var v1=0; v1 < openGrid.GetRowCount(); v1++){
		if( openGrid.GetCellValue("DP_DIV", v1) == "<%=dp_div%>"){
			dpDivCnt++;	
		}
	}
	return dpDivCnt;
}

/**
 * 지급방법 일괄적용
 */
function payTemrsApply() {
	if (GridObj.GetRowCount() > 0) {
		pay_terms 		= LRTrim(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("PAY_TERMS")).getValue());
		
		if (pay_terms == "") {
			alert('첫번째 행의 복사하려는 지급방법이  선택되지 않았습니다.');
			return;
		}
		
		for(var i = 0; i < GridObj.GetRowCount(); i++) {
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("PAY_TERMS")).setValue(pay_terms);
// 			GridObj.SetComboSelectedHiddenValue("PAY_TERMS", i, pay_terms);
		}
	}
}

/**
 * 지급조건 일괄적용
 */
function payTemrsTxtApply() {
	if (GridObj.GetRowCount() > 0) {
		pay_terms_txt 	= GridObj.GetCellValue("PAY_TERMS_TEXT", 0);
		if (pay_terms_txt == "") {
			alert('첫번째 행의 복사하려는 지급조건이 없습니다.');
			return;
		}
		
		for(var i = 0; i < GridObj.GetRowCount(); i++) {
			GridObj.SetCellValue("PAY_TERMS_TEXT", i, pay_terms_txt);
		}
	}
}
</script>
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
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
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
var tmpVal = 0;
function doOnCellChange(stage,rowId,cellInd)
{
	var isReturn = false;
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
    	isReturn = true;
    } else if(stage==1) {
    	
    } else if(stage==2) {
	    var rowIndex = GridObj.getRowIndex(rowId);
	    tmpVal =  GridObj.cells(rowId, cellInd).getValue();
	    JavaCall('t_insert',rowIndex,cellInd,"",tmpVal);
    	isReturn = true;
    }
    
    return isReturn;
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
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  onload="javascript:setGridDraw();setHeader();init();">

<s:header popup="true" >
<!--내용시작-->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="left" class="title_page" vAlign="bottom">
		대금지불정보
	</td>
</tr>
</table>


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
<form id="form1" name="form1" >
<input type="hidden" id="kind" name="kind">
	<tr style="display: none;">
		<td width="15%" class="title_td">
				&nbsp;지급방식
		</td>
		<td width="35%" class="data_td" colspan="3">
			<select id="pay_term" name="pay_term" class="inputsubmit" onchange='changePay(pay_term.value)' <% if(!pre_cont_seq.equals("")){ %> disabled <%} %>>
				<%out.println(dp_type_list); %>
			</select>
       	</td>
	</tr>
	<tr style="display: none;">
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     	
	<tr style="display: none;">
		<td width="15%" class="title_td">
			&nbsp;차수
		</td>
		<td width="35%" class="data_td" colspan="3">
			<span id='span_count' style="display:block">
				<TABLE cellpadding="0">
	      		<TR>
    	  			<TD><input type="text" id="t_count" name="t_count" size="10" maxlength="4" class="inputsubmit" value="" <%=readOnly%>></TD>
    	  			<%if(!mode.equals("popup")){%>
    	  			<TD><script language="javascript">btn("javascript:addRow()","적 용")</script></TD>
    	  			<%}%>
    	  		</TR>
  			</TABLE>
			</span>
		</td>
	</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30" align="left">
			품의금액 : <%=SepoaMath.SepoaNumberType(EXEC_AMT,"###,###,###,###,###.##")%> (<%=cur%>)
			&nbsp;용역/물품대금 : <input type="text" class="input_re" size="20" style="text-align:right;" readonly id="pay_amt" name="pay_amt" onBlur="checkNumber(this);changeDeposit();" onFocus="this.value = del_comma(this.value); this.select();" >
<!-- 			&nbsp;용역/물품대금 : <input type="text" class="input_re" size="20" style="text-align:right;" readonly id="pay_amt" name="pay_amt" onBlur="checkNumber(this);chagneDpAmt();changeDeposit();" onFocus="this.value = del_comma(this.value); this.select();" > -->
		</td>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
	      			<%if(!mode.equals("popup")){%>
<%--     	  			<TD><script language="javascript">btn("javascript:payTemrsApply()","지급방법일괄적용")   </script></TD> --%>
<%--     	  			<TD><script language="javascript">btn("javascript:payTemrsTxtApply()","지급조건일괄적용")   </script></TD> --%>
    	  			<TD><script language="javascript">btn("javascript:Save()","저 장")   </script></TD>
    	  			<%}%>
    	  			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>
<s:grid screen_id="AR_001_4" grid_obj="GridObj" grid_box="gridbox"/>
</br>
  	계약금액 : <input type="text" id="total_amt" name="total_amt" value="<%=total_amt	%>" readOnly style="text-align:right;">
</br>  	
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="25%" class="title_td">
				차수
			</td>
			<td width="25%" class="title_td">
				이행보증금(VAT 포함)
			</td>
			<td width="30%" class="title_td">
				이행보증율
			</td>
			<td width="20%" class="title_td">
				이행보증방법
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>     		
		<tr>
			<td width="25%" class="data_td">
				선급금이행
			</td>
			<td width="25%" class="data_td">
				<input type="text" id="FIRST_DEPOSIT" name="FIRST_DEPOSIT" size="18" maxlength="27" value="" readonly style="text-align:right;">
			</td>
			<td width="30%" class="data_td">
				선급금액의&nbsp;<input type="text" id="FIRST_PERCENT" name="FIRST_PERCENT" size="3" maxlength="3" class="input_data" value="" onBlur="changeDeposit()" <%=readOnly%> style="text-align:right;">&nbsp;%
			</td>
			<td width="20%" class="data_td">
				<select id="first_method" name="first_method" class="inputsubmit" <% if(!pre_cont_seq.equals("")){ %> disabled <%} %>>
				<%out.println(first_method); %>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr> 		
		<tr>
			<td width="25%" class="data_td">
				계&nbsp;약&nbsp;&nbsp;이&nbsp;행
			</td>
			<td width="25%" class="data_td">
				<input type="text" id="CONTRACT_DEPOSIT" name="CONTRACT_DEPOSIT" size="18" maxlength="27" value="" readonly style="text-align:right;">
			</td>
			<td width="30%" class="data_td">
				계약금액의&nbsp;<input type="text" id="CONTRACT_PERCENT" name="CONTRACT_PERCENT" size="3" maxlength="3" class="input_data" value="" onBlur="changeDeposit()" <%=readOnly%> style="text-align:right;">&nbsp;%
			</td>
			<td width="20%" class="data_td">
				<select id="contract_method" name="contract_method" class="inputsubmit" <% if(!pre_cont_seq.equals("")){ %> disabled <%} %>>
				<%out.println(contract_method); %>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr> 		
		<tr>
			<td width="25%" class="data_td">
				하&nbsp;자&nbsp;&nbsp;이&nbsp;행
			</td>
			<td width="25%" class="data_td">
				<input type="text" id="MENGEL_DEPOSIT" name="MENGEL_DEPOSIT" size="18" maxlength="27" value="" readonly style="text-align:right;">
			</td>
			<td width="30%" class="data_td">
				계약금액의&nbsp;<input type="text" id="MENGEL_PERCENT" name="MENGEL_PERCENT" size="3" maxlength="3" class="input_data" value="" onBlur="changeDeposit()" <%=readOnly%> style="text-align:right;">&nbsp;%
			</td>
			<td width="20%" class="data_td">
				<select id="mengel_method" name="mengel_method" class="inputsubmit" <% if(!pre_cont_seq.equals("")){ %> disabled <%} %>>
				<%out.println(mengel_method); %>
				</select>
			</td>
		</tr>
	</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

</form>
<iframe id="getDescframe" name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>
<s:footer/>
</body>
</html>


