<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MT_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MT_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
    Title      	: confirm_bd_lis1.jsp  <p>
    Description	: 품목번호 등록 승인 목록 <p>
    Copyright  	: Copyright (c) <p>
    Company    	: ICOMPIA <p>
    @author    	: 이용수(2005.11.04)<p>
    @version   	: 1.0
    @Comment   	: 품목번호 신규 등록 승인을 조회하는 화면이다.
--%>


<%
    String house_code           = info.getSession("HOUSE_CODE");
    String company_code       	= info.getSession("COMPANY_CODE");
    String user_id              = info.getSession("ID");
    String name_loc             = info.getSession("NAME_LOC");
    String department           = info.getSession("DEPARTMENT");
    String ctrl_code            = info.getSession("CTRL_CODE");

    String create_date_to      	= SepoaDate.getShortDateString();
    String create_date_from   	= SepoaDate.addSepoaDateMonth(create_date_to, -1);
%>

<html>
    <head>

    <script language="javascript">

        var INDEX_SELECTED					;
        var INDEX_REQ_ITEM_NO				;
        var INDEX_ITEM_NO					;
        var INDEX_REQ_DATE					;
        var INDEX_DESCRIPTION_LOC			;
        var INDEX_SPECIFICATION				;
        var INDEX_BASIC_UNIT				;
        var INDEX_REQ_NAME_LOC				;
        var INDEX_REQ_TYPE					;
        var INDEX_DATA_TYPE					;
        var INDEX_CONFIRM_DATE				;
        var INDEX_CONFIRM_NAME_LOC			;
        var INDEX_CONFIRM_STATUS			;
        var INDEX_VENDOR_NAME				;
        var INDEX_DATA_OCCUR_NAME			;
        var INDEX_Z_PURCHASE_TYPE  			;
        var INDEX_DELIVERY_LT       		;
        var INDEX_QI_FLAG        			;
        var INDEX_DO_FLAG        			;
        var INDEX_Z_WORK_STAGE_FLAG         ;
        var INDEX_Z_DELIVERY_CONFIRM_FLAG   ;

        var INDEX_REQ_CODE					;
        var INDEX_CONFIRM_CODE				;
        var INDEX_CONTRACT_FROM_DATE		;
        var INDEX_CONTRACT_TO_DATE			;
        var INDEX_DATA_OCCUR_TYPE			;
        var INDEX_IMAGE						;

        var INDEX_ITEM_GROUP				;
        var INDEX_Z_REMARK					;
        var INDEX_Z_PURCHASE_TYPE_COLOR		;

        function Init()
        {
setGridDraw();
setHeader();
           // doQuery();<%-- 테스트위해서 주석처리--%>
        }

        function setHeader()
        {



            //GridObj.AddHeader(  "CONTRACT_FROM_DATE", 	"계약적용일자","t_text",1020,0,true);
            //GridObj.AddHeader(    "CONTRACT_TO_DATE", 	"계약끝일자","t_text",1020,0,true);

			GridObj.SetDateFormat("REQ_DATE", "yyyy/MM/dd");
			GridObj.SetDateFormat("CONFIRM_DATE", "yyyy/MM/dd");


            INDEX_SELECTED                        =   GridObj.GetColHDIndex("SELECTED"					);
            INDEX_REQ_ITEM_NO                     =   GridObj.GetColHDIndex("REQ_ITEM_NO"				);
            INDEX_ITEM_NO                         =   GridObj.GetColHDIndex("ITEM_NO"					);
            INDEX_REQ_DATE                        =   GridObj.GetColHDIndex("REQ_DATE"					);
            INDEX_DESCRIPTION_LOC                 =   GridObj.GetColHDIndex("DESCRIPTION_LOC"			);
            INDEX_SPECIFICATION                   =   GridObj.GetColHDIndex("SPECIFICATION"				);
            INDEX_BASIC_UNIT                      =   GridObj.GetColHDIndex("BASIC_UNIT"					);
            INDEX_Z_PURCHASE_TYPE  				  =	  GridObj.GetColHDIndex("Z_PURCHASE_TYPE"  	  		);
            INDEX_DELIVERY_LT       		      =	  GridObj.GetColHDIndex("DELIVERY_LT"       	  		);
            INDEX_QI_FLAG        			      =	  GridObj.GetColHDIndex("QI_FLAG"        		  	);
            INDEX_DO_FLAG        			      =	  GridObj.GetColHDIndex("DO_FLAG"        		  	);
            INDEX_Z_WORK_STAGE_FLAG               =	  GridObj.GetColHDIndex("Z_WORK_STAGE_FLAG"	  		);
            INDEX_Z_DELIVERY_CONFIRM_FLAG         =	  GridObj.GetColHDIndex("Z_DELIVERY_CONFIRM_FLAG"	);

            INDEX_REQ_NAME_LOC                    =   GridObj.GetColHDIndex("REQ_NAME_LOC"				);
            INDEX_REQ_TYPE                        =   GridObj.GetColHDIndex("REQ_TYPE"					);
            INDEX_DATA_TYPE                       =   GridObj.GetColHDIndex("DATA_TYPE"					);
            INDEX_CONFIRM_DATE                    =   GridObj.GetColHDIndex("CONFIRM_DATE"				);
            INDEX_CONFIRM_NAME_LOC                =   GridObj.GetColHDIndex("CONFIRM_NAME_LOC"			);
            INDEX_CONFIRM_STATUS                  =   GridObj.GetColHDIndex("CONFIRM_STATUS"				);
            INDEX_VENDOR_NAME                     =   GridObj.GetColHDIndex("VENDOR_NAME"				);
            INDEX_DATA_OCCUR_NAME                 =   GridObj.GetColHDIndex("DATA_OCCUR_NAME"			);

            INDEX_REQ_CODE                        =   GridObj.GetColHDIndex("REQ_CODE"					);
            INDEX_CONFIRM_CODE                    =   GridObj.GetColHDIndex("CONFIRM_CODE"				);
            //INDEX_CONTRACT_FROM_DATE              =   GridObj.GetColHDIndex("CONTRACT_FROM_DATE"		);
            //INDEX_CONTRACT_TO_DATE                =   GridObj.GetColHDIndex("CONTRACT_TO_DATE"			);
            INDEX_DATA_OCCUR_TYPE                 =   GridObj.GetColHDIndex("DATA_OCCUR_TYPE"	  		);
            INDEX_IMAGE                           =   GridObj.GetColHDIndex("IMAGE"				  		);

            INDEX_ITEM_GROUP                      =   GridObj.GetColHDIndex("ITEM_GROUP"			  		);
            INDEX_Z_REMARK                        =   GridObj.GetColHDIndex("REMARK"				  		);
            INDEX_REJECT_REMARK                   =   GridObj.GetColHDIndex("REJECT_REMARK"				);
            INDEX_Z_PURCHASE_TYPE_COLOR			  =	  GridObj.GetColHDIndex("Z_PURCHASE_TYPE_COLOR"		);
        }

        function doQuery()
        {
        	var G_SERVLETURL = "/master/item_confirm_list";
		    <%--var cols_ids = "<%=grid_col_id%>";--%>
		    var params = "mode=query";
		    params += "&cols_ids=" + cols_ids;
		    params += dataOutput();
		    GridObj.post( G_SERVLETURL, params );
		    GridObj.clearAll(false);

            
        }


        function JavaCall(msg1, msg2, msg3, msg4, msg5)
        {
           max_row = GridObj.GetRowCount();
		   var maxcol  = GridObj.GetColCount();

			for(var i=0;i<GridObj.GetRowCount();i++) {
				if(i%2 == 1){
					for (var j = 0;	j<GridObj.GetColCount(); j++){
						//GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
					}
				}
			}
			if(msg1 == "doQuery") {
				//for( j = 0; j<max_row; j++){
				//	for(k=0; k<maxcol; k++){
				//		var COLOR= GD_GetCellValueIndex(GridObj,j,INDEX_Z_PURCHASE_TYPE_COLOR);
				//	    if(COLOR=="")COLOR='255|255|255';
			    //		GridObj.setCellbgColor(GridObj.GetColHDKey(k),j,COLOR);
				//	}
				//}
			}
			if(msg1 == "t_insert") {
				if(msg3 == INDEX_SELECTED)
				{
					selectCond(GridObj, msg2);
				}
			}

      		if(msg1 == "t_imagetext")
    		{
    		    var left = 50;
                var top = 100;
                var toolbar = 'no';
                var menubar = 'no';
                var status = 'yes';
                var scrollbars = 'yes';
                var resizable = 'no';
                var width = "";
                var height = "";

               if(msg3 == GridObj.GetColHDIndex("DESCRIPTION_LOC"))
               {
                   var data_occur_type = GD_GetCellValueIndex(GridObj,msg2,INDEX_DATA_OCCUR_TYPE);
                   var temp_item_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_REQ_ITEM_NO);
                   var item_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);

                    width = 750;
                    height = 580;

                   if(data_occur_type == "L")
                   {

                   //		if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "2" ){
                   //     	var url = 'req_pp_ins1_1.jsp?REQ_ITEM_NO='+temp_item_no+"&item_no="+item_no+"&BUY=";
                   //     } else if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "1" ){
                   //     	var url = 'req_pp_ins1_2.jsp?REQ_ITEM_NO='+temp_item_no+"&item_no="+item_no+"&BUY=";
                   //     } else if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "3" ){
                   //
                        	var url = 'req_pp_ins1_3.jsp?REQ_ITEM_NO='+temp_item_no+"&item_no="+item_no+"&BUY=";
                   //     } else if(GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_GROUP) == "5" ){
                   //    	var url = 'req_pp_ins1_4.jsp?REQ_ITEM_NO='+temp_item_no+"&item_no="+item_no+"&BUY=";
                   //    } else {
                   //
                   //     	var url = 'req_pp_ins1.jsp?REQ_ITEM_NO='+temp_item_no+"&item_no="+item_no+"&BUY=";
                   //     }

                   }
                   else
                   {
                   		var url = 'confirm_pp_vew3.jsp?REQ_ITEM_NO='+temp_item_no;
                   }
				   var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
                   PoDisWin.focus();

               }

               if(msg3 == INDEX_REJECT_REMARK)
               {
                        var Z_REMARK = GD_GetCellValueIndex(GridObj,msg2, INDEX_REJECT_REMARK);
                        var mode = "update";
                        var url = "/kr/master/new_material/confirm_pp_dis1.jsp?Z_REMARK="+Z_REMARK+"&msg2="+msg2+"&mode="+mode;
						var left = 150;
						var top = 150;
						var width = 600;
						var height = 300;
						var toolbar = 'no';
						var menubar = 'no';
						var status = 'yes';
						var scrollbars = 'yes';
						var resizable = 'no';
						var SpecCodeWin = window.open( url, 'Category', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
						SpecCodeWin.focus();
               }

            }
            if(msg1 == "doData")
            {
    		    var sflag = GD_GetParam(GridObj,0);
    			if ( sflag == "OK" )
    		    {
    		        alert(" 정상적으로 수행하였습니다.");
    				doQuery();
    		    }
    		    else if (sflag == "DOUBLE")
    		    {
    		        alert("이전 요청건수가 있습니다.");
    		    }
    		    else if (sflag == "CHKERR")
    		    {
    		        alert("처리완료된 항목입니다.");
    		        doQuery();
    		    }
    			else
    		    {
    		        alert(" 에러가 발생되었습니다.");
    			}

	       }
           if(msg3 == "0")
           {
                oneSelect(max_row, msg1, msg2);
           }
        }

        function selectCond(wise, selectedRow)
		{
			var wise = GridObj;
			var cur_vbeln_code  = GD_GetCellValueIndex(wise,selectedRow, INDEX_REQ_ITEM_NO);
			var iRowCount   	 = wise.GetRowCount();

			for(var i=0;i<iRowCount;i++)
			{
				if(i==selectedRow)
					continue;

				if(cur_vbeln_code == GD_GetCellValueIndex(wise,i,INDEX_REQ_ITEM_NO))
				{
					var flag = "true";
					if(GD_GetCellValueIndex(wise,i,INDEX_SELECTED) == "true")
						flag = "false";

					GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
				}else{
					var flag = "false";
					GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
				}
			}
		}

        function getZ_REMARK(value, msg2) {

        	var wise = GridObj;
			if(value.length < 1 || value == null){
				GD_SetCellValueIndex(GridObj,msg2, INDEX_REJECT_REMARK  , ""+"&&", "&");
			} else {
				GD_SetCellValueIndex(GridObj,msg2, INDEX_REJECT_REMARK, '/kr/images/button/query.gif&'+""+'&'+value, '&');
			}
			
			
        	if(confirm("반려 하시겠습니까?")){

    			servletUrl = "/master/new_material/confirm_bd_upd2";

        		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
				GridObj.SendData(servletUrl,"ALL","ALL");
            	GridObj.strHDClickAction="sortmulti";

            }
        }


        function create_date_to(year,month,day,week) {
            form1.create_date_to.value=year+month+day;
        }

        function create_date_from(year,month,day,week) {
            form1.create_date_from.value=year+month+day;
        }

        function oneSelect(max_row, msg1, msg2) {
        	var noSelect = "";

        	if(msg1 != "t_header" && GD_GetCellValueIndex(GridObj,msg2,"0") == "false") noSelect = "Y";

        	for(var i=0;i<max_row;i++)  {
             	GD_SetCellValueIndex(GridObj,i,"0","false", "&");
            }

           	if(msg1 != "t_header" && noSelect != "Y") GD_SetCellValueIndex(GridObj,msg2,"0","true", "&");
        }

        function Change(flag)
        {

         	var	wise = GridObj;
        	var	sel_row	= -1;
	        var selectedCnt = 0;


        	for(var	i=0; i<GridObj.GetRowCount();i++)
            {
        		var	temp = GD_GetCellValueIndex(GridObj,i,0);
        		if(temp	== "true")
        	    {
        			sel_row = i;
        		    var confirm_code = GD_GetCellValueIndex(GridObj,sel_row,INDEX_CONFIRM_CODE);
        		    if(confirm_code == "E")
        		    {
        		    	alert("이미 승인됐습니다.");
        		    	return;
        		    }
        			selectedCnt ++;
        			//break;
        		}
        	}
        	if(selectedCnt == 0)
            {
        	    alert("항목을 선택해주세요.");
        	    return;
        	}
        	else if(selectedCnt > 1)
        	{
        	    alert("한개의 행만 선택해주세요.");
        	    return;
        	}
        	else
        	{
        		if(flag == "con")
        		{

        		    //var sel_from_date = GD_GetCellValueIndex(GridObj,sel_row,INDEX_CONTRACT_FROM_DATE);
        		    //var sel_to_date = GD_GetCellValueIndex(GridObj,sel_row,INDEX_CONTRACT_TO_DATE);
        		    var req_code = GD_GetCellValueIndex(GridObj,sel_row,INDEX_REQ_CODE);
        		    var data_type = GD_GetCellValueIndex(GridObj,sel_row,INDEX_DATA_TYPE);

                	//if( data_type != "공급사" && req_code != "D" && RTrim(sel_from_date).length == 8 && sel_from_date <= "<%=create_date_to%>") {
                        //alert("계약적용일이 오늘일자 이전이므로 승인할수 없습니다. ");
                        //return;
                    //} else if( data_type != "마스터" && req_code != "D" && RTrim(sel_to_date).length == 8 && sel_to_date <= "<%=create_date_to%>") {
                        //alert("계약만료일이 오늘일자 이전이므로 승인할수 없습니다. ");
                        //return;
                    <%-- } else if(confirm("승인 하시겠습니까?")) { --%>
                    //} else {

                    	var ITEM_NO 	= "";
					    var left 		= 30;
					    var top 		= 30;
					    var toolbar 	= 'no';
					    var menubar 	= 'no';
					    var status 		= 'yes';
					    var scrollbars 	= 'yes';
					    var resizable 	= 'no';
					    var width 		= "";
					    var height 		= "";
					    var wise 		= GridObj;
					    var max_row 	= GridObj.GetRowCount();
						var BUY 		= "";
						width 			= 750;
					    height 			= 580;
					    var url 		= "";

                    	REQ_ITEM_NO 	= GD_GetCellValueIndex(GridObj,sel_row	,INDEX_REQ_ITEM_NO);
                    	ITEM_NO 		= GD_GetCellValueIndex(GridObj,sel_row	,INDEX_ITEM_NO);
						//alert(REQ_ITEM_NO +"=="+ ITEM_NO);
                    	for(var	i=0; i<GridObj.GetRowCount();i++){
                    		var selectCheck = GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED);
			        		if(selectCheck == "true"){
				    			var flag_gubun = GD_GetCellValueIndex(GridObj,sel_row,INDEX_ITEM_GROUP);
				    		}
                    	}
                    	/*
                    	if(flag_gubun == "2"){
        					url = "real_pp_upd1_1.jsp?REQ_ITEM_NO="+REQ_ITEM_NO+"&ITEM_NO="+ITEM_NO;
        				} else if(flag_gubun == "1"){
        					url = "real_pp_upd1_2.jsp?REQ_ITEM_NO="+REQ_ITEM_NO+"&ITEM_NO="+ITEM_NO;
        				} else if(flag_gubun == "3"){
        					url = "real_pp_upd1_3.jsp?REQ_ITEM_NO="+REQ_ITEM_NO+"&ITEM_NO="+ITEM_NO;
        				} else if(flag_gubun == "5"){
        					url = "real_pp_upd1_4.jsp?REQ_ITEM_NO="+REQ_ITEM_NO+"&ITEM_NO="+ITEM_NO;
        				} else {*/
        				url = "real_pp_upd1.jsp?REQ_ITEM_NO="+REQ_ITEM_NO+"&ITEM_NO="+ITEM_NO;
        				//}
        				var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

                    //}

        		} else if(flag == "rej") {

        			for(var	i=0; i<GridObj.GetRowCount();i++)
	             	{
	            		var	temp = GD_GetCellValueIndex(GridObj,i,0);
	            		if(temp	== "true")
	            	    {
	            			if(GD_GetCellValueIndex(GridObj,i,INDEX_REJECT_REMARK) == ""){
	            				var Z_REMARK = GD_GetCellValueIndex(GridObj,i, INDEX_REJECT_REMARK);
	            				var msg2 = i;
                        		var mode = "update";
                        		var url = "/kr/master/new_material/confirm_pp_dis1.jsp?Z_REMARK="+Z_REMARK+"&msg2="+msg2+"&mode="+mode;
								var left = 150;
								var top = 150;
								var width = 600;
								var height = 300;
								var toolbar = 'no';
								var menubar = 'no';
								var status = 'yes';
								var scrollbars = 'yes';
								var resizable = 'no';
								var SpecCodeWin = window.open( url, 'Category', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
								SpecCodeWin.focus();
								return;
	            			}
	            		}

	            	}

	            	if(confirm("반려 하시겠습니까?")){

            			servletUrl = "/master/item_confirm_list";
                		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
						GridObj.SendData(servletUrl,"ALL","ALL");
                    	GridObj.strHDClickAction="sortmulti";

                    }

        	    }
        		else return;
        	}
        }

    </script>


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
<body onload="Init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		기준정보 > 품목관리 > 품목 등록요청 > 품목승인 
		<//%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<form name="form1">
<table width="100%">

<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 요청일자</div>
	</td>
	<td class="c_data_1" width="35%">
	<%-- 
		<input type="text" name="create_date_from" value="<%=create_date_from%>" size="10" class="input_re" maxlength=8>
			<a href="javascript:Calendar_Open('create_date_from');"><img src="/kr/images/button/butt_calender.gif" align="absmiddle" border="0"></a>
			~
		<input type="text" name="create_date_to" value="<%=create_date_to%>" size="10" class="input_re" maxlength=8>
			<a href="javascript:Calendar_Open('create_date_to');"><img src="/kr/images/button/butt_calender.gif" align="absmiddle" border="0"></a>
	--%>
	
		<s:calendar id_from="create_date_from"  default_from="<%=SepoaString.getDateSlashFormat(create_date_from)%>" 
									id_to="create_date_to" 	 default_to="<%=SepoaString.getDateSlashFormat(create_date_to)%>" 
									format="%Y/%m/%d" />
									
									
	
	</td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 요청자</td>
	<td class="c_data_1" width="35%">
		<input type="text" name="req_name_loc" value="" style="width:95%" class="inputsubmit">
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 품목명</td>
	<td class="c_data_1" width="35%">
		<input type="text" name="description" value="" style="width:95%" class="inputsubmit">
	</td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 처리상태</td>
	<td class="c_data_1" width="35%">
		<select name="sel_proceeding_type" class="inputsubmit">
		<option value="" selected>전체</option>
<%
		String listbox2 = ListBox(request, "SL0018", house_code + "#M185", "P");
		out.println(listbox2);
%>
		</select>
	</td>
</tr>
</table>

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<TD><script language="javascript">btn("javascript:doQuery()","조 회")</script></TD>
			<TD><script language="javascript">btn("javascript:Change('con')","승 인")</script></TD>
			<TD><script language="javascript">btn("javascript:Change('rej')","반 려")</script></TD>
		</TR>
		</TABLE>
</TR>

</TABLE>

</form>

</s:header>
<s:grid screen_id="MT_003" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
 </body>
</html>


