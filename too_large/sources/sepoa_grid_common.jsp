<%@ page contentType = "text/html; charset=UTF-8" %>
<%

	String page_count = sepoa.fw.util.CommonUtil.getConfig("grid.view.rowcount");
    String screen_info = (String)text.get(screen_id + ".DHTMLX_GRID_INFO");
    SepoaFormater sf  = new SepoaFormater(screen_info);

    String KRW_AMT_TYPE = "0,000";
	String USD_AMT_TYPE = "0,000.00";
	String QTY_TYPE     = "0,000";
	String PRICE_TYPE   = "0,000.00";
	String SMALL_AMT_TYPE = "0,000.0";

	String Mcolor = "#ffff63";
	String Ocolor = "#fdfdd4";
	String Rcolor = "#f7f7f7";
	String Scolor = "#f9f7b7";
	String Lcolor = "#fef0c5";

    String grid_header      = "";
    String grid_init_widths = "";
    String grid_col_align   = "";
    String grid_col_id      = "";
    String grid_col_color   = "";
    String grid_col_sort    = "";
    String grid_col_type    = "";
    String grid_combo_data  = "";
    String grid_num_format  = "";
    String grid_date_format = "";
    String grid_col_visible = "";
    String grid_selected    = "";
    String grid_footer_msg  = "\"Msg,";
    String grid_read_only_col = "";
    String grid_column_type  = "";
    String grid_back_color   = "";
    String grid_bk_color     = "";
    String grid_header_style = "";
    int    grid_read_check  = 0;
    int    grid_footer_cnt  = 0;
    
	int    grid_head_merge_cnt 	= 0;
	int    merge_twoLine_cnt 	= 0;
	String grid_attach_header_1 = "";
	String grid_attach_header 	= "";
	String twoLine_header_value = "";
	String grid_attach_header_value 	= "";
	String grid_attach_header_element 	= "";
	String grid_attach_header_name 		= "";
 	
	for(int depth=0; depth < sf.getRowCount(); depth++)
	{
	
	
		// TYPE 값이 = 'B' 인값만 그리드의 데이터만 그려줍니다.
    	if(screen_id.equals(sf.getValue("SCREEN_ID", depth)) && sf.getValue("TYPE", depth).equals("B"))
    	{
    	
    		grid_init_widths  += sf.getValue("COL_WIDTH", depth) + ",";
    		grid_col_align    += sf.getValue("COL_ALIGN", depth) + ",";
    		grid_col_id       += sf.getValue("CODE"     , depth) + ",";
    		grid_column_type   = sf.getValue("COL_TYPE", depth);
    		grid_header_style  = grid_header_style + "'background-color:#dddee1;height: 20px;',";
    		
    		String comboBoxImg 	= "";
    		String calendarImg 	= ""; 
    		String popupImg 	= "";
			String edTxtImg     = "";
//     		String comboBoxImg 	= "&nbsp;&nbsp;<img src='"+POASRM_CONTEXT_NAME+"/dhtmlx/dhtmlx_full_version/imgs/combo_select_dhx_skyblue.gif' style='vertical-align:top;'/>";
//     		String calendarImg 	= "&nbsp;&nbsp;<img src='"+POASRM_CONTEXT_NAME+"/images/dhtml/dhtmlxcalendar_icon.gif' style='vertical-align:top;'/>"; 
//     		String popupImg 	= "&nbsp;&nbsp;<img src='"+POASRM_CONTEXT_NAME+"/images/dhtml/dhtmlxwindows_icon.gif' style='vertical-align:top;'/>";
// 			String edTxtImg     = "&nbsp;&nbsp;<img src='"+POASRM_CONTEXT_NAME+"/images/dhtml/dhtmlxeditor_icon.gif' style='vertical-align:top;'/>";
			
			
			

			//헤더 머지 기능 추가
			if(dhtmlx_head_merge_cols_vec != null && dhtmlx_head_merge_cols_vec.size() > 0) {
				
				grid_head_merge_cnt = 0;
				merge_twoLine_cnt   = 0;

				for( int mr_depth =0; mr_depth < dhtmlx_head_merge_cols_vec.size(); mr_depth++ ) {
	    			boolean twoLine_check      = false;
	    			grid_attach_header_element = (String)dhtmlx_head_merge_cols_vec.elementAt(mr_depth);
	    			
					if( grid_attach_header_element.indexOf("@") != -1 ) twoLine_check = true;
	    			
	    			grid_attach_header_name = grid_attach_header_element.substring(0, grid_attach_header_element.indexOf("="));
	    			
	    			if( twoLine_check ){
	    				grid_attach_header_value = grid_attach_header_element.substring(grid_attach_header_element.indexOf("=") + 1, grid_attach_header_element.indexOf("@"));
	    				twoLine_header_value     = grid_attach_header_element.substring(grid_attach_header_element.indexOf("@") + 1, grid_attach_header_element.length());
	    			}else{
						grid_attach_header_value = grid_attach_header_element.substring(grid_attach_header_element.indexOf("=") + 1, grid_attach_header_element.length()).toLowerCase();
	    			}

	    			if( grid_attach_header_name.equals(sf.getValue("CODE", depth)) ) {
	    				grid_header += grid_attach_header_value + ",";
	    				if( twoLine_check ){
	    					grid_attach_header   += "\""+ twoLine_header_value + "\",";
							grid_attach_header_1 += "\""+ sf.getValue("CONTENTS" , depth) +"\",";	    					
	    					merge_twoLine_cnt++;
	    				}else{
	    					grid_attach_header   += "\""+ sf.getValue("CONTENTS" , depth) +"\",";
	    				}
	    				grid_head_merge_cnt++;
	    				break;
	    			} 
	    		}
	    		
	    		if(grid_head_merge_cnt == 0) {
	    			grid_header        += sf.getValue("CONTENTS" , depth) + ",";
	    			grid_attach_header += "\"#rspan\",";
	    			if( merge_twoLine_cnt == 0 ) grid_attach_header_1 += "\"#rspan\",";
	    		}
				
			} else {
				//grid_header += sf.getValue("CONTENTS" , depth) + ",";
	    		if("coro".equals(grid_column_type)){
	    			//콤보박스인 경우 header에 icon 넣기
		    		grid_header += sf.getValue("CONTENTS" , depth) + comboBoxImg + ",";
	    		}else if("dhxCalendar".equals(grid_column_type)){
	    			//dhtmlx calendar 인 경우
	    			grid_header += sf.getValue("CONTENTS" , depth) + calendarImg + ",";
	    		}else if("Lcolor".equals(sf.getValue("COL_COLOR", depth))){
	    			grid_header += sf.getValue("CONTENTS" , depth) + popupImg + ",";
	    		}
	    		else if("edtxt".equals(grid_column_type)){ // edit
					grid_header += sf.getValue("CONTENTS" , depth) + edTxtImg + ",";
				}
	    		else if("txttxt".equals(grid_column_type)){ // textarea
					grid_header += sf.getValue("CONTENTS" , depth) + edTxtImg + ",";
				}
	    		else if("edn".equals(grid_column_type)){ // editnumber
					grid_header += sf.getValue("CONTENTS" , depth) + edTxtImg + ",";
				}
	    		else{
	    			//기본
	    			grid_header += sf.getValue("CONTENTS" , depth) + ",";
	    		}				
			}

			grid_head_merge_cnt = dhtmlx_head_merge_cols_vec.size();
			
			if( grid_head_merge_cnt > 0 ){
				String element = (String)dhtmlx_head_merge_cols_vec.elementAt(0);
				if( element.indexOf("@") != -1 ) merge_twoLine_cnt = 1;
			}
///////////////////////////////////////////////// 헤더머지 끝		
			
    		
//     		if("coro".equals(grid_column_type)){
//     			//콤보박스인 경우 header에 icon 넣기
// 	    		grid_header += sf.getValue("CONTENTS" , depth) + comboBoxImg + ",";
//     		}else if("dhxCalendar".equals(grid_column_type)){
//     			//dhtmlx calendar 인 경우
//     			grid_header += sf.getValue("CONTENTS" , depth) + calendarImg + ",";
//     		}else if("Lcolor".equals(sf.getValue("COL_COLOR", depth))){
//     			grid_header += sf.getValue("CONTENTS" , depth) + popupImg + ",";
//     		}
//     		else if("edtxt".equals(grid_column_type)){ // edit
// 				grid_header += sf.getValue("CONTENTS" , depth) + edTxtImg + ",";
// 			}
//     		else if("txttxt".equals(grid_column_type)){ // textarea
// 				grid_header += sf.getValue("CONTENTS" , depth) + edTxtImg + ",";
// 			}
//     		else if("edn".equals(grid_column_type)){ // editnumber
// 				grid_header += sf.getValue("CONTENTS" , depth) + edTxtImg + ",";
// 			}
//     		else{
//     			//기본
//     			grid_header += sf.getValue("CONTENTS" , depth) + ",";
//     		}
    		//grid_col_color    += sf.getValue("COL_COLOR", depth) + ",";
    		//grid_col_sort     += sf.getValue("COL_SORT" , depth) + ",";

    		// 한 화면 SCREEN_ID 기준으로 Buyer 화면일 경우에는 컬럼이 ReadOnly 이고
			// Supplier 화면일 경우에 edit 일 경우에는 아래의 벡터 클래스에다가 컬럼명을 addElement 하시면 됩니다.
			// 변환되는 컬럼타입 기준은 아래와 같습니다.
			// ed -> ro(EditBox -> ReadOnlyBox),
			// edn, -> ron(NumberEditBox -> NumberReadOnlyBox),
			// dhxCalendar -> ro(CalendarBox -> ReadOnlyBox),
			// txt -> ro(TextBox -> ReadOnlyBox)
			// sepoa_grid_common.jsp 에서 컬럼타입을 변경 시켜 줍니다.
			// 참고로 Vector dhtmlx_read_cols_vec 객체는 sepoa_common.jsp에서 생성 시켜 줍니다.
			if(dhtmlx_read_cols_vec != null && dhtmlx_read_cols_vec.size() > 0) {
				grid_read_check  = 0;

				for(int ro_depth =0; ro_depth < dhtmlx_read_cols_vec.size(); ro_depth++)
	    		{
	    			grid_read_only_col = (String)dhtmlx_read_cols_vec.elementAt(ro_depth);

	    			if(grid_read_only_col != null && grid_read_only_col.indexOf("=") > 0) {
	    				if(grid_read_only_col != null && grid_read_only_col.startsWith(sf.getValue("CODE", depth))) {
	    					grid_column_type   = grid_read_only_col.substring(grid_read_only_col.indexOf("=") + 1, grid_read_only_col.length()).toLowerCase();
	    					grid_read_only_col = grid_read_only_col.substring(0, grid_read_only_col.indexOf("=") - 1);
	    					grid_col_type      += grid_column_type + ",";
		    				grid_read_check++;
		    				break;
	    				}
	    			} else {
	    				if(grid_read_only_col != null && grid_read_only_col.equals(sf.getValue("CODE", depth))) {
	    					if(grid_column_type.equals("edn")) {
		    					grid_col_type += "ron,";
		    					grid_read_check++;
		    					break;
		    				} else if(grid_column_type.equals("ed") || grid_column_type.equals("edtxt") || grid_column_type.equals("txt") || grid_column_type.equals("txttxt") || grid_column_type.equals("dhxCalendar")) {
		    					grid_col_type += "ro,";
		    					grid_read_check++;
		    					break;
		    				}
		    			}
	    			}
	    		}

	    		if(grid_read_check == 0) {
	    			grid_col_type += grid_column_type + ",";
	    		}
			} else {
				grid_col_type += grid_column_type + ",";
			}
			
    		//'SL0400','M210',''
    		if(grid_column_type.equals("coro") && sf.getValue("COL_COMBO", depth).length() > 0) {
    			grid_combo_data += " doRequestUsingPOST_dhtmlxGrid( " + sf.getValue("COL_COMBO", depth) + " ); \n";
    		}

    		if((grid_column_type.equals("edn") || grid_column_type.equals("ron"))
    		   && sf.getValue("COL_FORMAT", depth).length() > 0)
    		{
    			if(sf.getValue("COL_FORMAT", depth).equals("KRW_AMT_TYPE"))  {
    				grid_num_format += grid_obj + ".setNumberFormat(\"" + KRW_AMT_TYPE + "\", " + grid_obj + ".getColIndexById(\""+sf.getValue("CODE", depth)+"\"));";
    			} else if(sf.getValue("COL_FORMAT", depth).equals("USD_AMT_TYPE"))  {
    				grid_num_format += grid_obj + ".setNumberFormat(\"" + USD_AMT_TYPE + "\", " + grid_obj + ".getColIndexById(\""+sf.getValue("CODE", depth)+"\"));";
    			} else if(sf.getValue("COL_FORMAT", depth).equals("QTY_TYPE"))  {
    				grid_num_format += grid_obj + ".setNumberFormat(\"" + QTY_TYPE + "\", " + grid_obj + ".getColIndexById(\""+sf.getValue("CODE", depth)+"\"));";
    			} else if(sf.getValue("COL_FORMAT", depth).equals("PRICE_TYPE"))  {
    				grid_num_format += grid_obj + ".setNumberFormat(\"" + PRICE_TYPE + "\", " + grid_obj + ".getColIndexById(\""+sf.getValue("CODE", depth)+"\"));";
    			}else if(sf.getValue("COL_FORMAT", depth).equals("SMALL_AMT_TYPE"))  {
    				grid_num_format += grid_obj + ".setNumberFormat(\"" + SMALL_AMT_TYPE + "\", " + grid_obj + ".getColIndexById(\""+sf.getValue("CODE", depth)+"\"));";
    			}
    		}

/*임시 색 지정 해제*/

				if(dhtmlx_back_cols_vec != null && dhtmlx_back_cols_vec.size() > 0) {
    			grid_read_check  = 0;

    			for(int co_depth =0; co_depth < dhtmlx_back_cols_vec.size(); co_depth++)
		    	{
		    		grid_back_color = (String)dhtmlx_back_cols_vec.elementAt(co_depth);

		    		if(grid_back_color != null && grid_back_color.indexOf("=") > 0) {
	    				if(grid_back_color != null && grid_back_color.startsWith(sf.getValue("CODE", depth))) {
	    					grid_bk_color = grid_back_color.substring(grid_back_color.indexOf("=") + 1, grid_back_color.length()).toUpperCase();
	    					
	    					if(grid_bk_color.equals("MCOLOR"))  {
			    				grid_col_color    += Mcolor + ",";
			    				grid_read_check++;
			    			} else if(grid_bk_color.equals("OCOLOR"))  {
			    				grid_col_color    += Ocolor + ",";
			    				grid_read_check++;
			    			} else if(grid_bk_color.equals("RCOLOR"))  {
			    				grid_col_color    += Rcolor + ",";
			    				grid_read_check++;
			    			} else if(grid_bk_color.equals("SCOLOR"))  {
			    				grid_col_color    += Scolor + ",";
			    				grid_read_check++;
			    			} else if(grid_bk_color.equals("LCOLOR"))  {
			    				grid_col_color    += Lcolor + ",";
			    				grid_read_check++;
			    			} else {
			    				grid_col_color    += grid_bk_color + ",";
			    				grid_read_check++;
			    			}
	    					break;
	    				}
	    			}
		    	}

		    	if(grid_read_check == 0) {
	    			if(sf.getValue("COL_COLOR", depth).length() > 0)
		    		{
		    			if(sf.getValue("COL_COLOR", depth).equals("Mcolor"))  {
		    				grid_col_color    += Mcolor + ",";
		    			} else if(sf.getValue("COL_COLOR", depth).equals("Ocolor"))  {
		    				grid_col_color    += Ocolor + ",";
		    			} else if(sf.getValue("COL_COLOR", depth).equals("Rcolor"))  {
		    				grid_col_color    += Rcolor + ",";
		    			} else if(sf.getValue("COL_COLOR", depth).equals("Scolor"))  {
		    				grid_col_color    += Scolor + ",";
		    			} else if(sf.getValue("COL_COLOR", depth).equals("Lcolor"))  {
		    				grid_col_color    += Lcolor + ",";
		    			}
		    		}
	    		}
		    } else {
		    	if(sf.getValue("COL_COLOR", depth).length() > 0)
	    		{
	    			if(sf.getValue("COL_COLOR", depth).equals("Mcolor"))  {
	    				grid_col_color    += Mcolor + ",";
	    			} else if(sf.getValue("COL_COLOR", depth).equals("Ocolor"))  {
	    				grid_col_color    += Ocolor + ",";
	    			} else if(sf.getValue("COL_COLOR", depth).equals("Rcolor"))  {
	    				//grid_col_color    += Rcolor + ",";
	    				grid_col_color    += "white,";
	    			} else if(sf.getValue("COL_COLOR", depth).equals("Scolor"))  {
	    				grid_col_color    += Scolor + ",";
	    			} else if(sf.getValue("COL_COLOR", depth).equals("Lcolor"))  {
	    				grid_col_color    += Lcolor + ",";
	    			}
	    		}
	    	} 

    		if(grid_column_type.equals("edn") || grid_column_type.equals("ron"))
    		{
    			grid_col_sort += "int,";
    		}
    		else
    		{
    			if(grid_column_type.equals("ch"))
    			{
    				grid_col_sort += "na,";
    			}
    			else if(sf.getValue("COL_SORT", depth).trim().length() > 0)
    			{
    				grid_col_sort += sf.getValue("COL_SORT", depth) + ",";
    			}
    			else
    			{
    				grid_col_sort += "str,";
    			}
    		}

    		if(grid_column_type.equals("dhxCalendar") && sf.getValue("COL_FORMAT", depth).length() > 0 && grid_date_format.length()== 0)
    		{
    			grid_date_format = grid_obj + ".setDateFormat(\"" + sf.getValue("COL_FORMAT", depth) + "\");";
    		}

    		if(sf.getValue("COL_VISIBLE", depth).length() > 0 && sf.getValue("COL_VISIBLE", depth).equals("false"))
    		{
    			grid_col_visible += grid_obj + ".setColumnHidden(" + grid_obj + ".getColIndexById(\""+sf.getValue("CODE", depth)+"\")"+", true);";
    		}

    		if(sf.getValue("SELECTED_YN", depth).equals("Y") && grid_selected.length()== 0)
    		{
    			grid_selected = sf.getValue("CODE", depth);
    		}

    		grid_footer_cnt++;
    		
    		
    		if(grid_footer_cnt == 1) grid_footer_msg += "<div id='message'></div>";
    		else if(grid_footer_cnt >= 2) grid_footer_msg += ",#cspan";
    		
    		//System.out.println( "grid_footer_msg="+grid_footer_msg);
    	}
		
		
		
		
		
		
		
		
    }

    if(grid_header.length() > 0)      grid_header      = grid_header.substring(0, grid_header.length() - 1);
    if(grid_init_widths.length() > 0) grid_init_widths = grid_init_widths.substring(0, grid_init_widths.length() - 1);
    if(grid_col_align.length() > 0)   grid_col_align   = grid_col_align.substring(0, grid_col_align.length() - 1);
    if(grid_col_id.length() > 0)      grid_col_id      = grid_col_id.substring(0, grid_col_id.length() - 1);
    if(grid_col_color.length() > 0)   grid_col_color   = grid_col_color.substring(0, grid_col_color.length() - 1);
    if(grid_col_sort.length() > 0)    grid_col_sort    = grid_col_sort.substring(0, grid_col_sort.length() - 1);
    if(grid_col_type.length() > 0)    grid_col_type    = grid_col_type.substring(0, grid_col_type.length() - 1);
    if(grid_header_style.length() > 0)    grid_header_style    = grid_header_style.substring(0, grid_header_style.length() - 1);
    if(grid_footer_msg.indexOf("cspan") > 0) grid_footer_msg += "\" ";
    
//     System.out.println("["+grid_header+"]"+grid_header.split("\\,").length);
//     System.out.println("["+grid_init_widths+"]"+grid_init_widths.split("\\,").length);
//     System.out.println("["+grid_col_align+"]"+grid_col_align.split("\\,").length);
//     System.out.println("["+grid_col_id+"]"+grid_col_id.split("\\,").length);
//     System.out.println("["+grid_col_color+"]"+grid_col_color.split("\\,").length);
//     System.out.println("["+grid_col_sort+"]"+grid_col_sort.split("\\,").length);
//     System.out.println("["+grid_col_type+"]"+grid_col_type.split("\\,").length);
    
%>

<script language='JavaScript'>
    var grid_col_id = '<%=grid_col_id%>';
    var col_ids = '<%=grid_col_id%>';
    
	var dhtmlx_start_row_id = 0;
	var dhtmlx_end_row_id = 0;
	var dhtmlx_cur_pagenumber = 1;
	var dhtmlx_last_row_id = 0;
	var dhtmlx_cur_page_last_idx = 0;
	var dhtmlx_before_row_id = 0;
	var dhtmlx_modal_cnt = 0;
	var dhxWins;
	var prg_win;
	var dhxWins_Filter;
	var prg_win_filter;

	function <%=grid_obj%>_setGridDraw()
    {
    	//<%=grid_obj%> = new dhtmlXGridObject('gridbox');
    	<%=grid_obj%> = new SepoaDhtmlXGridObject('gridbox');	// dhtmlXGridObject 생성자 함수를 sepoa_dhtmlXGridObject함수에서 상속받아서 사용한다.
<%--   		<%=grid_obj%>.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxGrid/codebase/imgs/"); --%>
 		<%=grid_obj%>.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/imgs/");
		<%=grid_obj%>.setHeader("<%=grid_header%>", null, [<%=grid_header_style%>]);
		<%=grid_obj%>.setInitWidths("<%=grid_init_widths%>");
	    <%=grid_obj%>.setColAlign("<%=grid_col_align%>");
		<%=grid_obj%>.setColumnIds("<%=grid_col_id%>");
	    <%=grid_obj%>.setColumnColor("<%=grid_col_color%>");
		<%=grid_obj%>.setColSorting("<%=grid_col_sort%>");
		<%=grid_obj%>.setColTypes("<%=grid_col_type%>");
		
		// 헤더머지
		<% if (grid_head_merge_cnt > 0) { 
// 			System.out.println("grid_attach_header     ["+grid_attach_header.split("\\,").length+"] : " +grid_attach_header.substring(0,grid_attach_header.length()-1));
		%>
			<%=grid_obj%>.attachHeader([<%=grid_attach_header.substring(0,grid_attach_header.length()-1)%>]);
		<% } %>
		
		<% if( merge_twoLine_cnt == 1 ){ 
// 			System.out.println("grid_attach_header_1   ["+grid_attach_header_1.split("\\,").length+"] : " +grid_attach_header_1.substring(0,grid_attach_header_1.length()-1));
		%>
			<%=grid_obj%>.attachHeader([<%=grid_attach_header_1.substring(0,grid_attach_header_1.length()-1)%>]);
		<%}%>
		
		<%
		
		%>		
		
		
		
		<%=grid_combo_data%>

		GridObj.setColumnMinWidth(50,0);

		//MenuObj = new dhtmlXMenuObject(null,"standard");
		MenuObj = new dhtmlXMenuObject(null,"dhx_skyblue");
<%--  		MenuObj.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxMenu/codebase/imgs/"); --%>
		MenuObj.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/imgs/");
		MenuObj.setIconsPath("<%=POASRM_CONTEXT_NAME%>/images/");
		MenuObj.renderAsContextMenu();
		MenuObj.setOpenMode("web");
		MenuObj.attachEvent("onClick", doOnMouseRightButtonClick);
<%-- 		MenuObj.loadXML("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxMenu/dyn_context.xml"); --%>
		MenuObj.loadXML("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/dyn_context.xml");

		<%=grid_obj%>.enableContextMenu(MenuObj);
		<%=grid_obj%>.enableMultiselect(true);

		<%=grid_obj%>.attachEvent("onRowSelect",doOnRowSelected);
		//팝업오픈 원클릭 onRowSelect
        //팝업오픈 더블클릭 onRowDblClicked
        <%=grid_obj%>.enableEditEvents(true,false,false); // dbl click를 추가한 후 edit event 추가함.click, dbl click, f2key
        
		<%=grid_obj%>.attachEvent("onBeforeContextMenu", doOnRightButtonShowMenu);
		<%=grid_obj%>.attachEvent("onBeforePageChanged", doOnBeforePageChanged);
		<%=grid_obj%>.attachEvent("onKeyPress", doOnKeyPressed);
		<%=grid_obj%>.attachEvent("onXLS",doQueryDuring);
		<%=grid_obj%>.attachEvent("onXLE",doQueryModalEnd);
		<%=grid_obj%>.attachEvent("onXLE",doQueryEnd);

		//<%=grid_obj%>.setSkin("light");
		 //<%=grid_obj%>.setSkin("dhx_blue");
		 <%=grid_obj%>.setSkin("dhx_skyblue");	//3.6에서 변경해봄

		// 조회전용 화면은 CellChangeEvent 및 PageNavigation을 하질 않습니다.
		// <%=grid_obj%>.attachEvent("onPageChanged", doOnPageChanged);
		// <%=grid_obj%>.enablePaging(true, <%=page_count%>, 10, "pagingArea", true);
	    // <%=grid_obj%>.setPagingSkin("bricks");

		<% if(!isSelectScreen) { %>
		    <%=grid_obj%>.attachEvent("onEditCell",doOnCellEdit);
		 	//<%=grid_obj%>.attachEvent("onEditCell",doOnCellChange);
		<% } %>

	    //<%=grid_obj%>.enableHeaderMenu();
	    <%=grid_obj%>.enableUndoRedo();
	    //<%=grid_obj%>.enableRowsHover(true,'grid_hover');
	    <%=grid_obj%>.enableBlockSelection(false);

	    <%=grid_obj%>.enableAutoSizeSaving();
        <%=grid_obj%>.enableOrderSaving();
        //<%=grid_obj%>.loadOrderFromCookie();
	    //<%=grid_obj%>.loadSizeFromCookie();

	    //<%=grid_obj%>.enableMultiline(true);
		<%=grid_obj%>.enableColumnMove(true);

		<%=grid_obj%>.attachFooter(<%=grid_footer_msg%>);

		<%=grid_num_format%>
	    <%=grid_date_format%>
	    <%=grid_col_visible%>

	    // 행머지 기능과 SmartRendering 기능을 같이 사용을 할수가 없어서 아래와 같이 사용하였습니다.
	    <% if(isRowsMergeable) { %>
	    	<%=grid_obj%>.enableRowspan(true);
	    <% } %>

	    // 조회전용 화면은 SmartRendering 을 합니다.
		//<% if(isSelectScreen) { %>
		//	<%=grid_obj%>.enableSmartRendering(true);
		//<% } %>

		<%=grid_obj%>.init();
		<%=grid_obj%>.setAwaitedRowHeight(21);
		
		// 새끼 그리드 추가 부분
        <%if(grid_col_type.indexOf("sub_row_grid") != -1) { %>
            <%=grid_obj%>.attachEvent("onSubGridCreated", sub_grid_callback);
        <% } %>
        
        if(typeof document.form_footer != "undefined" && typeof document.form_footer.setGridDrawEnd != "undefined"){
			document.form_footer.setGridDrawEnd.value = 'true';	// 그리드 초기화가 완료되면, 값을 true로 갱신한다.
        }
    }

    function doOnKeyPressed(code,ctrl,shift)
    {
    	if(code==67 && ctrl){
	        <%=grid_obj%>.setCSVDelimiter("\t");
			<%=grid_obj%>.copyBlockToClipboard();
	    }
	    return true;
    }

    function doOnMouseRightButtonClick(menuitemId)
    {
	    var data = <%=grid_obj%>.contextID.split("_"); //rowInd_colInd
		var rId  = data[0];
		var cInd = data[1];

        switch(menuitemId) {
        	case "SaveCookie":
            	gridOrderWidthSave(<%=grid_obj%>, '<%=screen_id%>', '<%=info.getSession("ID")%>');
            	alert("현재상태저장 기능을 사용하시려면 반드시 화면을 새로고침 해야 합니다.\nF5를 누르거나 메뉴를 다시 클릭하세요");
                break;
            case "LoadCookie":
                //<%=grid_obj%>.loadSizeFromCookie();
            	//<%=grid_obj%>.loadOrderFromCookie();
                break;
            case "ClearCookie":
                gridOrderWidthClear(<%=grid_obj%>, '<%=screen_id%>', '<%=info.getSession("ID")%>');
                break;
            case "AllCheckLock":
            	if(<%=grid_obj%>.getColType(cInd) == "ch" && <%=isSelectScreen%> == false) {
            		if(<%=grid_obj%>.getRowsNum() > 1000) {
            			alert("데이터 조회 건수가 많습니다. 1000 건 까지만 처리 가능합니다.");
            			break;
            		} else {
            			for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
						{
							//<%=grid_obj%>.cells(row, cInd).setValue("1");
							<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("1");
							<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).cell.wasChanged = true;
					    }
            		}
            	}
                break;
            case "AllCheckUnLock":
                if(<%=grid_obj%>.getColType(cInd) == "ch" && <%=isSelectScreen%> == false) {
                	if(<%=grid_obj%>.getRowsNum() > 1000) {
            			alert("데이터 조회 건수가 많습니다. 1000 건 까지만 처리 가능합니다.");
            			break;
            		} else {
	                	for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
						{
							<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("0");
							<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).cell.wasChanged = false;
					    }
					}
            	}
                break;
            case "CellCopy":
            	if(<%=grid_obj%>.getColType(cInd) == "coro") {
            		window.clipboardData.setData("Text", <%=grid_obj%>.cells(rId, cInd).getTitle());
            	} else {
            		window.clipboardData.setData("Text", <%=grid_obj%>.cells(rId, cInd).getValue().toString());
            	}
                break;
            case "ColFrozen":
                //<%=grid_obj%>.splitAt(cInd);
                break;
            case "ExcelSave":
                gridExport(<%=grid_obj%>);
                break;
            case "PrintView":
                PrintView(<%=grid_obj%>);
                break;
            case "Undo":
                <%=grid_obj%>.doUndo();
                break;
            case "Redo":
                <%=grid_obj%>.doRedo();
                break;
            case "Filter":
                doFiltering(<%=grid_obj%>);
                break;
            case "CellDataInit":
                <%=grid_obj%>.cells(rId, cInd).setValue("");
                break;
        }
        //return true;
	}

	function doOnRightButtonShowMenu(rowId,celInd,grid) {
		return true;
	}

	function doOnPageChanged(cur_page, first_page, last_page)
	{
		if(dhxWins != null && prg_win != null && dhxWins.window("prg_win").isModal()) {
			//dhxWins.window("prg_win").setModal(false);
			//dhxWins.window("prg_win").hide();
		}

		var page_cnt = parseInt("<%=page_count%>");
		dhtmlx_start_row_id   = (cur_page - 1) * page_cnt;
		dhtmlx_end_row_id = cur_page * page_cnt;
		dhtmlx_cur_pagenumber = cur_page;

		if(GridObj.getRowsNum() <= <%=page_count%>) {
			dhtmlx_end_row_id = GridObj.getRowsNum();
			dhtmlx_cur_page_last_idx = GridObj.getRowsNum();
		} else {
			dhtmlx_cur_page_last_idx = cur_page * <%=page_count%>;
		}

		if(dhtmlx_end_row_id > GridObj.getRowsNum()) {
			dhtmlx_end_row_id = GridObj.getRowsNum();
		}

		return true;
	}

	function doOnBeforePageChanged(cur_page, page_cnt)
	{
		if(dhxWins != null && prg_win != null && !dhxWins.window("prg_win").isModal()) {
			//dhxWins.window("prg_win").setModal(true);
			//dhxWins.window("prg_win").show();
		}

		return true;
	}

	function gridExport(mygrid)
	{
	    var html="";
	    var headText="";
	    var gridColids="";
	    var numCols = mygrid.getColumnsNum();

	    if(mygrid.getRowsNum() < 1) return;

	    for(i=0; i < numCols; i++)
	    {
	    	if(!mygrid.isColumnHidden(i) && mygrid.getColumnId(i) != "<%=grid_selected%>") {
	    		var colLabel = "";
	    	try {
	    		colLabel = mygrid.getColumnLabel(i, 1); 
	    	} catch (Exception) {}
	    		if(colLabel == "") {
	    			colLabel = mygrid.getColumnLabel(i);
	    		}
	    		headText   = headText + colLabel + "<%=col_del%>";
	    	    gridColids = gridColids + mygrid.getColumnId(i)+ "<%=col_del%>";
	    	}
	    }
	    
	    //alert("headText"+headText);
	    
	    document.formstyle.headText.value=headText;
	    document.formstyle.gridColids.value=gridColids;
        document.formstyle.method='POST';
	    document.formstyle.action='<%=POASRM_CONTEXT_NAME%>/common/csvExport.jsp';
	    document.formstyle.target='WholeHidden';
	    document.formstyle.submit();
	    return;
	}

	function gridOrderWidthSave(mygrid, screen_id, user_id)
	{
	    var html="";
	    var headText="";
	    var headWidth="";
	    var numCols = mygrid.getColumnsNum();

	    if(mygrid.getRowsNum() < 1) return;

	    for(i=0; i < numCols; i++)
	    {
	    	headText  = headText + mygrid.getColumnId(i)+ "<%=col_del%>";
	    	headWidth = headWidth+ mygrid.getColWidth(i)+ "<%=col_del%>";
	    }

	    headText = headText + "<%=row_del%>";
	    headWidth = headWidth + "<%=row_del%>";

	    document.formstyle.headText.value=headText;
        document.formstyle.headWidth.value=headWidth;
        document.formstyle.screen_id.value=screen_id;
        document.formstyle.user_id.value=user_id;
        <%--         document.formstyle.method='POST';
	    document.formstyle.action='<%=POASRM_CONTEXT_NAME%>/common/gridOrderWidthSave.jsp';
	    document.formstyle.target='WholeHidden';
	    document.formstyle.submit(); --%>
	    var jqa = new jQueryAjax("formstyle");
	    jqa.action = '<%=POASRM_CONTEXT_NAME%>/common/gridOrderWidthSave.jsp';
	    jqa.successF = function(){};
	    jqa.submit();
	    return;
	}

	function gridOrderWidthClear(mygrid, screen_id, user_id)
	{
		if(mygrid.getRowsNum() < 1) return;

	    document.formstyle.screen_id.value=screen_id;
        document.formstyle.user_id.value=user_id;
        <%--         document.formstyle.method='POST';
	    document.formstyle.action='<%=POASRM_CONTEXT_NAME%>/common/gridOrderWidthClear.jsp';
	    document.formstyle.target='WholeHidden';
	    document.formstyle.submit(); --%>
	    var jqa = new jQueryAjax("formstyle");
	    jqa.action = '<%=POASRM_CONTEXT_NAME%>/common/gridOrderWidthClear.jsp';
	    jqa.successF = function(){};
	    jqa.submit();
	    return;
	}

	function PrintView(mygrid)
	{
	    var html="";
	    var headText="";
	    var gridColids="";
	    var numCols = mygrid.getColumnsNum();

	    if(mygrid.getRowsNum() < 1) return;

	    for(i=0; i < numCols; i++)
	    {
	    	if(!mygrid.isColumnHidden(i) && mygrid.getColumnId(i) != "<%=grid_selected%>") {
	    		headText   = headText + mygrid.getColumnLabel(i)+ "<%=col_del%>";
	    	    gridColids = gridColids + mygrid.getColumnId(i)+ "<%=col_del%>";
	    	}
	    }

	    document.formstyle.headText.value=headText;
	    document.formstyle.gridColids.value=gridColids;
        document.formstyle.method='POST';
	    document.formstyle.action='<%=POASRM_CONTEXT_NAME%>/common/printView.jsp';
	    document.formstyle.target='_blank';
	    document.formstyle.submit();
	    return;
	}

	function BwindowWidth() {
	 if (window.innerWidth) {
	 return window.innerWidth;
	 } else if (document.body && document.body.offsetWidth) {
	 return document.body.offsetWidth;
	 } else {
	 return 0;
	}
	}

	function BwindowHeight() {
	 if (window.innerHeight) {
	 return window.innerHeight;
	 } else if (document.body && document.body.offsetHeight) {
	 return document.body.offsetHeight;
	 } else {
	 return 0;
	}
	}

	function doQueryDuring()
	{
		var dim  = new Array(2);
		var win_width = 190;	//프로그레스바의 너비
		var win_height = 80;	//프로그레스바의 높이
 		var gridbox_temp = document.getElementById('gridbox');
 		var content_temp = document.getElementById('content');
		var content_temp_height="";
 		if(content_temp == null){	//popup일때 content가 없다.
 			content_temp_height = BwindowHeight();	//content 대신 창 전체 높이
 		}else{
 			content_temp_height = content_temp.offsetHeight;	//content의 높이 
 		}
 		var left = (parseInt(gridbox_temp.style.width) - win_width)/2;	//gridbox_temp.style.width 값에서 'px'문자를 제거하기 위해 parseInt함수를 사용.
 		var top = parseInt(content_temp_height) - parseInt(gridbox_temp.offsetHeight)/2 - win_height;
  		/* var left = (BwindowWidth() - parseInt(treebox.style.width) - win_width)/2;	
		var top  = (BwindowHeight() - win_height)/2; */  
		if(dhxWins == null) {
        	dhxWins = new dhtmlXWindows();
        	//dhxWins.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxWindows/codebase/imgs/");
        	dhxWins.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/imgs/");
  			dhxWins.enableAutoViewport(false);		//추가함
  			if(content_temp != null){	//popup일때 content가 없다.
			    dhxWins.attachViewportTo("content");	//추가함 - div id가 content인 영역안에서 window 효과를 나타낸다. (setModal 효과를 JSP내용안으로만 한정하기 위해)
  	 		}
        }
		if(prg_win == null) {
//			prg_win = dhxWins.createWindow("prg_win", left, top, 180, 73);
			//prg_win = dhxWins.createWindow("prg_win", left, top, win_width, win_height);
			prg_win = dhxWins.createWindow("prg_win", left, top, win_width, win_height);
			
			prg_win.setText("Please wait for a moment.");
			prg_win.button("close").hide();
			prg_win.button("minmax1").hide();
			prg_win.button("minmax2").hide();
			prg_win.button("park").hide();
			dhxWins.window("prg_win").setModal(true);
			prg_win.attachURL("<%=POASRM_CONTEXT_NAME%>/common/progress_ing.htm");
		} else {
			dhxWins.window("prg_win").setPosition(left,top);		//위치 이동 추가함
			dhxWins.window("prg_win").setModal(true);
		    dhxWins.window("prg_win").show();
		}
		<% if(!isRowsMergeable) { %>
	    	<%=grid_obj%>.enableSmartRendering(true);
	    <% } %>
		return true;
	}

	function doFiltering(mygrid)
	{
		var dim  = new Array(2);
		var width  = "550";
		var height = "120";
		var top = BwindowWidth()/2 - 180;
		var left  = BwindowHeight()/2 - 73;
		var headText="";
	    var numCols = mygrid.getColumnsNum();
	    var gridColids = "";

	    if(mygrid.getRowsNum() < 1) return;

	    for(i=0; i < numCols; i++)
	    {
	    	if(!mygrid.isColumnHidden(i)) {
	    		headText = headText + mygrid.getColumnLabel(i)+ ",";
	    		gridColids = gridColids + mygrid.getColumnId(i)+ ",";
	    	}
	    }

	    if(headText.length > 0) {
	    	headText = headText.substring(0, headText.length - 1);
	    }

	    if(gridColids.length > 0) {
	    	gridColids = gridColids.substring(0, gridColids.length - 1);
	    }

		var url = "<%=POASRM_CONTEXT_NAME%>/common/do_filter.jsp?grid_col_id="+gridColids+"&grid_col_lable="+headText;
		CodeSearchCommon(url, 'FiterScreen', left, top, width, height);
	}

	function doFilterSearch(filter_column, filter_word)
	{
		<%=grid_obj%>.filterBy(<%=grid_obj%>.getColIndexById(filter_column), filter_word);
	}

	function doQueryModalEnd(GridObj, RowCnt)
	{
		var msg = GridObj.getUserData("", "message");
		
		if(dhxWins == null) {
        	dhxWins = new dhtmlXWindows();
        	//dhxWins.setImagePath("<%=POASRM_CONTEXT_NAME%>/dthmlx/dhtmlxWindows/codebase/imgs/");
        }

		if(prg_win == null) {
			var top = BwindowWidth()/2 - 180;
			var left  = BwindowHeight()/2 - 73;
		
			prg_win = dhxWins.createWindow("prg_win", top, left, 180, 73);
			prg_win.setText("Please wait for a moment.");
			prg_win.button("close").hide();
			prg_win.button("minmax1").hide();
			prg_win.button("minmax2").hide();
			prg_win.button("park").hide();
			dhxWins.window("prg_win").setModal(true);
			prg_win.attachURL("<%=POASRM_CONTEXT_NAME%>/common/progress_ing.htm");
		}

		dhxWins.window("prg_win").setModal(false);
		dhxWins.window("prg_win").hide();
		dhtmlx_modal_cnt++;

		dhtmlx_end_row_id = GridObj.getRowsNum();
	    document.getElementById("message").innerHTML = msg + " Rows : " + GridObj.getRowsNum();

		//document.formstyle.csvBuffer.value = GridObj.getUserData("", "excel_data");

		//조회 화면 전용일 경우에는 PageNavigation을 하지 않기 때문에 dhtmlx_end_row_id이 전체행의 값입니다.
		//<% if(isSelectScreen) { %>
		//	    dhtmlx_end_row_id = GridObj.getRowsNum();
		//	    document.getElementById("message").innerHTML = msg + " Rows : " + GridObj.getRowsNum();
		//<% } else { %>
		//	document.getElementById("message").innerHTML = msg;

		//	if(GridObj.getRowsNum() <= <%=page_count%>) {
		//		dhtmlx_end_row_id = GridObj.getRowsNum();
		//	} else {
		//		var page_cnt = parseInt("<%=page_count%>");
		//		dhtmlx_end_row_id = page_cnt;
		//	}
		//<% } %>

		dhtmlx_last_row_id = GridObj.getRowsNum();
		return true;
	}

	function doOnCellEdit(stage,rowId,cellInd)
    {

    	var max_value = <%=grid_obj%>.cells(rowId, cellInd).getValue();

    	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    	if(stage==0) {
			return doOnCellChange(stage,rowId,cellInd);
			return true;
		} else if(stage==1) {
			if(<%=grid_obj%>.getColType(cellInd) == "ch" && cellInd != <%=grid_obj%>.getColIndexById("<%=grid_selected%>")) {
				if(max_value == "1") {
					<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).setValue("1");
					<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).cell.wasChanged = true;
					return doOnCellChange(stage,rowId,cellInd);
					return true;
				} else {
					<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).setValue("0");
					<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).cell.wasChanged = false;
					return false;
				}
			}
			return doOnCellChange(stage,rowId,cellInd);
			return true;
		} else if(stage==2) {
			<% if(!isSelectScreen) {
			       for(int depth=0; depth < sf.getRowCount(); depth++)
			       {
			            if(sf.getValue("TYPE", depth).equals("B"))
                        {
		    		        grid_column_type = sf.getValue("COL_TYPE", depth);

							for(int ro_depth =0; ro_depth < dhtmlx_read_cols_vec.size(); ro_depth++)
				    		{
				    			grid_read_only_col = (String)dhtmlx_read_cols_vec.elementAt(ro_depth);

				    			if(grid_read_only_col != null && grid_read_only_col.indexOf("=") > 0) {
				    				if(grid_read_only_col != null && grid_read_only_col.startsWith(sf.getValue("CODE", depth))) {
				    					grid_column_type   = grid_read_only_col.substring(grid_read_only_col.indexOf("=") + 1, grid_read_only_col.length()).toLowerCase();
				    					break;
				    				}
				    			} else {
					    			if(grid_read_only_col != null && grid_read_only_col.equals(sf.getValue("CODE", depth))) {
					    				if(grid_column_type.equals("edn")) {
					    					grid_column_type = "ron";
					    					break;
					    				} else if(grid_column_type.equals("ed") || grid_column_type.equals("edtxt") || grid_column_type.equals("txt") || grid_column_type.equals("txttxt") || grid_column_type.equals("dhxCalendar")) {
					    					grid_column_type = "ro";
					    					break;
					    				}
					    			}
					    		}
				    		}

			    		    if(grid_column_type.equals("edn") && sf.getValue("COL_MAX_LEN", depth).length() > 0 && sf.getValue("COL_FORMAT", depth).length() > 0)
		    			    {
		    %>
		    				   if(cellInd == <%=grid_obj%>.getColIndexById("<%=sf.getValue("CODE", depth)%>"))
		    			   	   {
		    					   
									if(isNaN(max_value)) {
// 									if(max_value == "0" || isNaN(max_value)) {
								    	<% if(grid_selected != null && grid_selected.length() > 0) { %>
											<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).setValue("0");
										<% } %>
										alert("숫자만 입력 가능합니다.");
										return false;
									} else if(getLength(max_value) > <%=sf.getValue("COL_MAX_LEN", depth)%>) {
										<% if(grid_selected != null && grid_selected.length() > 0) { %>
											alert("칼럼의 최대 입력 길이를 초과했습니다. 입력가능 Bytes : <%=sf.getValue("COL_MAX_LEN", depth)%>, 입력한 Bytes : " + getLength(max_value));
											<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).setValue("0");
										<% } %>
										return false;
									} else {
										<% if(grid_selected != null && grid_selected.length() > 0) { %>
											<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).setValue("1");
											<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).cell.wasChanged = true;
										<% } %>
										return doOnCellChange(stage,rowId,cellInd);
										return true;
									}
								}
		    <%
		    		   	   }
			    		   else if((grid_column_type.equals("ed") || grid_column_type.equals("edtxt") || grid_column_type.equals("txt") || grid_column_type.equals("txttxt")) && sf.getValue("COL_MAX_LEN", depth).length() > 0 && sf.getValue("COL_FORMAT", depth).length() == 0)
			    		   {
			    %>
			    			   if(cellInd == <%=grid_obj%>.getColIndexById("<%=sf.getValue("CODE", depth)%>"))
			    			   {
									//19번 Column MaxLength 조회시점에는 불가능하고 수정 시점에만 체크하여 처리할수 있습니다.
									if(getLength(max_value) > <%=sf.getValue("COL_MAX_LEN", depth)%>) {
										<% if(grid_selected != null && grid_selected.length() > 0) { %>
											alert("칼럼의 최대 입력 길이를 초과했습니다. 입력가능 Bytes : <%=sf.getValue("COL_MAX_LEN", depth)%>, 입력한 Bytes : " + getLength(max_value));
											<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).setValue("0");
										<% } %>
										return false;
									} else {
										<% if(grid_selected != null && grid_selected.length() > 0) { %>
											<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).setValue("1");
											<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).cell.wasChanged = true;
										<% } %>
										return doOnCellChange(stage,rowId,cellInd);
										return true;
									}
							   }
			    <%
			    		   }
		    	   	   }
		    	   }
	    	   }
		    %>

			<% if(grid_selected != null && grid_selected.length() > 0) { %>
				<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).setValue("1");
				<%=grid_obj%>.cells(rowId, <%=grid_obj%>.getColIndexById("<%=grid_selected%>")).cell.wasChanged = true;
			<% } %>
			return doOnCellChange(stage,rowId,cellInd);
			return true;
		}

		return false;
    }
</script>
