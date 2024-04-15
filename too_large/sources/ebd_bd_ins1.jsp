

<% //PROCESS ID ì ì¸ %>
<% String WISEHUB_PROCESS_ID="PROCESSID001";%>

<% //ì¬ì© ì¸ì´ ì¤ì   %>
<% String WISEHUB_LANG_TYPE="KR";%>

<!-- JSP import or useBean tags here. -->
<!-- Wisehub FrameWork ê³µíµ ëª¨ë Import ë¶ë¶(ë¬´ì¡°ê±´ ì¬ì©) -->
<script language='javascript' for='WiseGrid' event='Initialize()'>
	javascript:init();
	GD_setProperty(document.WiseGrid);
</script>
<script language='javascript' for='WiseGrid' event='ChangeCell(strColumnKey,nRow,vtOldValue,vtNewValue)'>
	GD_ChangeCell(document.WiseGrid,strColumnKey,nRow,vtOldValue,vtNewValue);
</script>
<script language='javascript' for='WiseGrid' event='ChangeCombo(strColumnKey, nRow, vtOldIndex, vtNewIndex)'>
	GD_ChangeCombo(document.WiseGrid,strColumnKey, nRow, vtOldIndex, vtNewIndex);
</script>
<script language='javascript' for='WiseGrid' event='CellClick(strColumnKey, nRow)'>
	GD_CellClick(document.WiseGrid,strColumnKey, nRow);
</script>
<script language='javascript' for='WiseGrid' event='EndQuery()'>
	GD_EndQuery(document.WiseGrid);
</script>
<script language='javascript' for='WiseGrid' event='HDClick(strColumnKey)'>
	GD_HDClick(document.WiseGrid,strColumnKey);
</script>
<%@ include file="/include/wisehub_common.jsp"%>
<%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_auth.jsp" %>
<%@ include file="/include/wisetable_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/wise_cert.jsp"%>

<%!
	public String[] parseValue(String value) {
		String token = "@";
		if(value == null) return null;

		Vector v = new Vector();

		String subvalue;
		boolean token_flag = true;
		int start_token_count = 0;
		int end_token_count = 0;

		while(token_flag) {
			end_token_count = value.indexOf(token, end_token_count);

			if(end_token_count == -1) token_flag = false;
			else {
				subvalue = value.substring(start_token_count, end_token_count);
				end_token_count += token.length();
				start_token_count = end_token_count;
				v.addElement(subvalue);
			}
		}

		String[] szvalue = new String[v.size()];
		v.copyInto(szvalue);

		return szvalue;
	}

	public String[] parseValueOp(String value) {
		String token = "@";
		if(value == null) return null;
		//System.out.println("value===>"+value);

		Vector v = new Vector();

		String subvalue;
		boolean token_flag = true;
		int start_token_count = 0;
		int end_token_count = 0;

		while(token_flag) {
			end_token_count = value.indexOf(token, end_token_count);

			if(end_token_count == -1) token_flag = false;
			else {
				subvalue = value.substring(start_token_count, end_token_count);
				end_token_count += token.length();
				start_token_count = end_token_count;
				v.addElement(subvalue.replaceAll("#","@"));
			}
		}

		String[] szvalue = new String[v.size()];
		v.copyInto(szvalue);

		return szvalue;
	}
%>
<%


	// ëê¸ê²°ì ì¡°ê±´ì ì ííì¬ ì ì¥íë ê²ì¼ë¡ ë³ê²½
	// ì¥ì¬ì ì°¨ì¥ SR ìì²­(2007-12-31)
	String[] aRadioTitles = new String[3];
	String[] aRadioValues = new String[3];
	aRadioTitles[0]="ë©í ê¸°ì¼ë´ ë¬¼íì ë¹íì´ ì§ì íë ì¥ìì ë©í ìë£í ì¸ìì¦<b>(ê²ìì¡°ì)</b>ì<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ì²¨ë¶íì¬ ëê¸ ì²­êµ¬íë©´ ë¹íìì ë©í íì¸ ìë£í 20ì¼ì´ë´ <b>íê¸ ê²°ì í¨</b>";
	aRadioTitles[1]="ë©í ê¸°ì¼ë´ ë¬¼íì ë¹íì´ ì§ì íë ì¥ìì ë©í ìë£í ì¸ìì¦<b>(ê²ìì¡°ì)</b>ì<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ì²¨ë¶íì¬ ëê¸ ì²­êµ¬íë©´ ë¹íìì ë©í íì¸ ìë£í 20ì¼ì´ë´<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>ë¬¼íêµ¬ë§¤ ì ì©ì¹´ë(ìì¢ë³ììë£)ë¡ ê²°ì í¨</b>";
	aRadioTitles[2]="ì°ë¦¬ìíìì´ìì¤ ëê¸ ì§ê¸ ë°©ë²ì ë°ë¦";
	aRadioValues[0]="ë©í ê¸°ì¼ë´ ë¬¼íì ë¹íì´ ì§ì íë ì¥ìì ë©í ìë£í ì¸ìì¦<b>(ê²ìì¡°ì)</b>ì ì²¨ë¶íì¬ ëê¸ ì²­êµ¬íë©´ ë¹íìì ë©í íì¸ ìë£í 20ì¼ì´ë´ <b>íê¸ ê²°ì í¨</b>";
	aRadioValues[1]="ë©í ê¸°ì¼ë´ ë¬¼íì ë¹íì´ ì§ì íë ì¥ìì ë©í ìë£í ì¸ìì¦<b>(ê²ìì¡°ì)</b>ì ì²¨ë¶íì¬ ëê¸ ì²­êµ¬íë©´ ë¹íìì ë©í íì¸ ìë£í 20ì¼ì´ë´ <b>ë¬¼íêµ¬ë§¤ ì ì©ì¹´ë(ìì¢ë³ììë£)ë¡ ê²°ì í¨</b>";
	aRadioValues[2]="ì°ë¦¬ìíìì´ìì¤ ëê¸ ì§ê¸ ë°©ë²ì ë°ë¦";
	

	String GUBUN     	     = request.getParameter("GUBUN");			// ê³µê³ ë¬¸ ê´ë¦¬ììë 'C' ëë¨¸ì§ë ìë¯¸ ìì.
	String M_TYPE     	     = request.getParameter("M_TYPE");
	String CURR_VERSION      = request.getParameter("CURR_VERSION");
                             
	String PR_NO             = request.getParameter("REQ_PR_NO");
	String BID_TYPE          = request.getParameter("BID_TYPE");
	String BID_STATUS        = request.getParameter("BID_STATUS");
	String CTRL_AMT          = request.getParameter("CTRL_AMT");		// íµì ê¸ì¡
	String ITEM_NAME         = request.getParameter("ITEM_NAME");
	String BID_NO            = request.getParameter("BID_NO");			// ìì±/ìì /íì /ìì¸ì¡°í
	String BID_COUNT         = request.getParameter("BID_COUNT");		// ìì±/ìì /íì /ìì¸ì¡°í
	String SCR_FLAG          = request.getParameter("SCR_FLAG");		// ìì±/ìì /íì /ìì¸ì¡°í flag
	String REQ_PR_SEQ        = request.getParameter("REQ_PR_SEQ");		// PR_NO $@$ PR_SEQ $#$
	String NEXT_AUTH_ID      = request.getParameter("NEXT_AUTH_ID");	// ë¤ìê²°ì¬ì
	String NEXT_AUTH_NM      = request.getParameter("NEXT_AUTH_NM");	// ë¤ìê²°ì¬ìëª
	String AUTH_FLAG 	     = info.getSession("AUTH_FLAG");			// ê²°ì¬ê¶í(0001=ê°ì¬íµí ì, 0002=íì¥)

	if(PR_NO == null)       PR_NO       ="";
	if(REQ_PR_SEQ == null)  REQ_PR_SEQ  ="";
	if(BID_TYPE == null)    BID_TYPE    ="D";
	if(BID_STATUS == null)  BID_STATUS  ="";
	if(CTRL_AMT == null)    CTRL_AMT    ="0";
	if(ITEM_NAME == null)   ITEM_NAME   ="";

	if(BID_NO == null)      BID_NO      ="";
	if(BID_COUNT == null)   BID_COUNT   ="";
	if(SCR_FLAG == null)    SCR_FLAG    ="I";
	if(GUBUN == null)       GUBUN       ="";
	if(M_TYPE == null)      M_TYPE      ="";
	
	if(NEXT_AUTH_ID == null)      NEXT_AUTH_ID      ="";
	if(NEXT_AUTH_NM == null)      NEXT_AUTH_NM      ="";

	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");

	String current_date = WiseDate.getShortDateString();//íì¬ ìì¤í ë ì§
	String current_time = WiseDate.getShortTimeString();//íì¬ ìì¤í ìê°
	//////////////////////////////////////////////////////////////////////

	String script = "";
	String abled = "";

	if(SCR_FLAG.equals("C") || SCR_FLAG.equals("D")) {
		script  = "readonly";
		abled   = "disabled";
	}
	///////////////////////////////
	String CONT_TYPE1         = "";
	String BASIC_AMT = "";
	String CONT_TYPE2         = "";
	String ANN_TITLE          = "";
	String ANN_NO             = "";
	String ANN_DATE           = "";
	String ANN_ITEM           = ITEM_NAME;
	String RD_DATE            = "";
	String DELY_PLACE         = "";
	String LIMIT_CRIT         = "";
	String PROM_CRIT          = "";
	String APP_BEGIN_DATE     = "";
	String APP_BEGIN_TIME     = "";
	String APP_END_DATE       = "";
	String APP_END_TIME       = "";
	String APP_PLACE          = "";
	String APP_ETC            = "";
	String ATTACH_NO          = "";
	String ATTACH_CNT         = "0";
	String VENDOR_CNT         = "0";
	String VENDOR_VALUES      = "";
	String LOCATION_CNT       = "0";
	String LOCATION_VALUES    = "";
	String ANNOUNCE_DATE      = "";
	String ANNOUNCE_TIME_FROM = "";
	String ANNOUNCE_TIME_TO   = "";
	String ANNOUNCE_AREA      = "";
	String ANNOUNCE_PLACE     = "";
	String ANNOUNCE_NOTIFIER  = "";
	String ANNOUNCE_RESP      = "";
	String DOC_FRW_DATE       = "";
	String ANNOUNCE_COMMENT   = "";
	String ANNOUNCE_FLAG      = "";
	String ANNOUNCE_TEL       = "";
	String ESTM_FLAG          = "";
	String COST_STATUS        = "";
	String BID_BEGIN_DATE     = "";
	String BID_BEGIN_TIME     = "";
	String BID_END_DATE       = "";
	String BID_END_TIME       = "";
	String BID_PLACE          = "";
	String BID_ETC            = "";
	String OPEN_DATE          = "";
	String OPEN_TIME          = "";
	String X_PERSON_IN_CHARGE = "";
	String X_ESTM_CHECK       = "";
	String X_ESTM_PRICE       = "";
	String X_PURCHASE_QTY     = "";
	String X_MAKE_SPEC        = "";
	String X_BASIC_ADD        = "";
	String X_DOC_SUBMIT_DATE  = "";
	String X_DOC_SUBMIT_TIME_HOUR_MINUTE = "";
	String X_DIFFERENCE_GRT   = "";
	String X_PERFORM_GRT      = "";
	String X_ANNOUNCE         = ""; // ì¤ëªí.
	String X_RELATIVE_ADD     = "";
	String X_QUALIFICATION    = "";

	String APP_BEGIN_TIME_HOUR_MINUTE = "0000";
	String APP_END_TIME_HOUR_MINUTE   = "0000";
	String BID_BEGIN_TIME_HOUR_MINUTE = "0000";
	String BID_END_TIME_HOUR_MINUTE   = "0000";
	String OPEN_TIME_HOUR_MINUTE      = "0000";

	String origin_bid_status = SCR_FLAG+BID_STATUS;

	String ESTM_KIND		= "";
	String ESTM_RATE        = "";
	String ESTM_MAX         = "";
	String ESTM_VOTE        = "";
	String FROM_CONT        = "";
	String FROM_CONT_TEXT	= "";
	String FROM_LOWER_BND   = "";
	String ASUMTN_OPEN_YN   = "";

	String CONT_TYPE_TEXT  	= "";
	String CONT_PLACE      	= "";
	String BID_PAY_TEXT    	= "";
	String BID_CANCEL_TEXT 	= "";
	String BID_JOIN_TEXT   	= "";
	String REMARK          	= "";
	String ESTM_MAX_VOTE   	= "";

	String STANDARD_POINT   = "";
	String TECH_DQ   		= "";
	String AMT_DQ   		= "";
	String COST_SETTLE_TERMS= "";	// ëê¸ê²°ì ì¡°ê±´
	
	//[R200711270859]ì ììì°°ìì¤í íë©´ ìì  ìì²­
	String LIMIT_CRIT_CD    = "";  
	String APPV_STATUS      = "";	// ë¬¸ì ê²°ì¬ ìí
	String AUTH_SEQ         = "";	// ê²°ì¬ì ê²°ì¬ìì
	String REJECT_OPINION   = "";	// ë°ë ¤ìê²¬
	
	String ITEM_TYPE       = "";  // íëª©êµ¬ë¶ ì½ë
	
	String OPEN_GB         = "";  // ê°ì°°êµ¬ë¶
	



	String [][] aAuthList   = new String[100][2];	// ê²°ì¬ì ëª©ë¡ì ë¯¸ë¦¬ ì ì¸(100,2)

	
	// ë°°ì´ ì´ê¸°í
	for (int i = 0; i < 100 ; i++)
	{
		aAuthList[i][0] = "";
		aAuthList[i][1] = "";
	}


	Object[] args = {BID_NO, BID_COUNT};
	
	WiseOut value = null;
	WiseRemote wr = null;
	String nickName = "p1009";
	String MethodName = "";
	String conType = "CONNECTION";
	WiseFormater wf = null;
		
		

	//ë¤ìì ì¤íí  classì loadingíê³  Methodí¸ì¶ì ê²°ê³¼ë¥¼ returníë ë¶ë¶ì´ë¤.
	try {
		MethodName = "getBDHDPRHDDisplay";
		wr = new WiseRemote(nickName,conType,info);
		value = wr.lookup(MethodName,args);

		wf = new WiseFormater(value.result[0]);

		int rw_cnt = wf.getRowCount();

		if(!(origin_bid_status).equals("IAR"))
		{
				// ìì°°ê³µê³  ìì±ì íë ¤ë ê²½ì°ì¸ìë ê¸°ì¡´ì dataë¥¼ ì¡°íí´ ì¨ë¤.
	
				CONT_TYPE1                   = wf.getValue("CONT_TYPE1"            ,0);
				CONT_TYPE2                   = wf.getValue("CONT_TYPE2"            ,0);
				ANN_TITLE                    = wf.getValue("ANN_TITLE"             ,0);
				ANN_NO                       = wf.getValue("ANN_NO"                ,0);
				ANN_DATE                     = wf.getValue("ANN_DATE"              ,0);
				ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);
				RD_DATE                      = wf.getValue("RD_DATE"               ,0);
				DELY_PLACE                   = wf.getValue("DELY_PLACE"            ,0);
				LIMIT_CRIT                   = wf.getValue("LIMIT_CRIT"            ,0);
				
				//[R200711270859]ì ììì°°ìì¤í íë©´ ìì  ìì²­
				LIMIT_CRIT_CD                = wf.getValue("LIMIT_CRIT_CD"         ,0);
				
				PROM_CRIT                    = wf.getValue("PROM_CRIT"             ,0);
				APP_BEGIN_DATE               = wf.getValue("APP_BEGIN_DATE"        ,0);
				APP_BEGIN_TIME               = wf.getValue("APP_BEGIN_TIME"        ,0);
				APP_END_DATE                 = wf.getValue("APP_END_DATE"          ,0);
				APP_END_TIME                 = wf.getValue("APP_END_TIME"          ,0);
				APP_PLACE                    = wf.getValue("APP_PLACE"             ,0);
				APP_ETC                      = wf.getValue("APP_ETC"               ,0);
				ATTACH_NO                    = wf.getValue("ATTACH_NO"             ,0);
				ATTACH_CNT                   = wf.getValue("ATTACH_CNT"            ,0);
				VENDOR_CNT                   = wf.getValue("VENDOR_CNT"            ,0);
				LOCATION_CNT                 = wf.getValue("LOCATION_CNT"          ,0);
				VENDOR_VALUES                = wf.getValue("VENDOR_VALUES"         ,0);
				LOCATION_VALUES              = wf.getValue("LOCATION_VALUES"       ,0);
				ANNOUNCE_DATE                = wf.getValue("ANNOUNCE_DATE"         ,0);
				ANNOUNCE_TIME_FROM           = wf.getValue("ANNOUNCE_TIME_FROM"    ,0);
				ANNOUNCE_TIME_TO             = wf.getValue("ANNOUNCE_TIME_TO"      ,0);
				ANNOUNCE_AREA                = wf.getValue("ANNOUNCE_AREA"         ,0);
				ANNOUNCE_PLACE               = wf.getValue("ANNOUNCE_PLACE"        ,0);
				ANNOUNCE_NOTIFIER            = wf.getValue("ANNOUNCE_NOTIFIER"     ,0);
				ANNOUNCE_RESP                = wf.getValue("ANNOUNCE_RESP"         ,0);
				DOC_FRW_DATE                 = wf.getValue("DOC_FRW_DATE"          ,0);
				ANNOUNCE_COMMENT             = wf.getValue("ANNOUNCE_COMMENT"      ,0);
				ANNOUNCE_FLAG                = wf.getValue("ANNOUNCE_FLAG"         ,0);
				ANNOUNCE_TEL                 = wf.getValue("ANNOUNCE_TEL"          ,0);
				BID_STATUS                   = wf.getValue("BID_STATUS"            ,0);
				ESTM_FLAG                    = wf.getValue("ESTM_FLAG"             ,0);
				COST_STATUS                  = wf.getValue("COST_STATUS"           ,0);
				BID_BEGIN_DATE               = wf.getValue("BID_BEGIN_DATE"        ,0);
				BID_BEGIN_TIME               = wf.getValue("BID_BEGIN_TIME"        ,0);
				BID_END_DATE                 = wf.getValue("BID_END_DATE"          ,0);
				BID_END_TIME                 = wf.getValue("BID_END_TIME"          ,0);
				BID_PLACE                    = wf.getValue("BID_PLACE"             ,0);
				BID_ETC                      = wf.getValue("BID_ETC"               ,0);
				OPEN_DATE                    = wf.getValue("OPEN_DATE"             ,0);
				OPEN_TIME                    = wf.getValue("OPEN_TIME"             ,0);
				X_DOC_SUBMIT_DATE            = wf.getValue("X_DOC_SUBMIT_DATE", 0);
		        X_DOC_SUBMIT_TIME_HOUR_MINUTE= wf.getValue("X_DOC_SUBMIT_TIME_HOUR", 0) + wf.getValue("X_DOC_SUBMIT_TIME_MINUTE", 0);
	
				APP_BEGIN_TIME_HOUR_MINUTE   = wf.getValue("APP_BEGIN_TIME_HOUR"   ,0)+wf.getValue("APP_BEGIN_TIME_MINUTE" ,0);
				APP_END_TIME_HOUR_MINUTE     = wf.getValue("APP_END_TIME_HOUR"     ,0)+wf.getValue("APP_END_TIME_MINUTE"   ,0);
				BID_BEGIN_TIME_HOUR_MINUTE   = wf.getValue("BID_BEGIN_TIME_HOUR"   ,0)+wf.getValue("BID_BEGIN_TIME_MINUTE" ,0);
				BID_END_TIME_HOUR_MINUTE     = wf.getValue("BID_END_TIME_HOUR"     ,0)+wf.getValue("BID_END_TIME_MINUTE"   ,0);
				OPEN_TIME_HOUR_MINUTE        = wf.getValue("OPEN_TIME_HOUR"        ,0)+wf.getValue("OPEN_TIME_MINUTE"      ,0);
	
				PR_NO                        = wf.getValue("PR_NO"                 ,0);
				BID_TYPE                     = wf.getValue("BID_TYPE"              ,0);
	
				ESTM_KIND                    = wf.getValue("ESTM_KIND"             ,0);
				ESTM_RATE                    = wf.getValue("ESTM_RATE"             ,0);
				ESTM_MAX                     = wf.getValue("ESTM_MAX"              ,0);
				ESTM_VOTE                    = wf.getValue("ESTM_VOTE"             ,0);
				FROM_CONT                    = wf.getValue("FROM_CONT"             ,0);
				FROM_CONT_TEXT               = wf.getValue("FROM_CONT_TEXT"        ,0);
				FROM_LOWER_BND               = wf.getValue("FROM_LOWER_BND"        ,0);
				ASUMTN_OPEN_YN               = wf.getValue("ASUMTN_OPEN_YN"        ,0);
	
				CONT_TYPE_TEXT               = wf.getValue("CONT_TYPE_TEXT"        ,0);
				CONT_PLACE                   = wf.getValue("CONT_PLACE"            ,0);
				BID_PAY_TEXT                 = wf.getValue("BID_PAY_TEXT"          ,0);
				BID_CANCEL_TEXT              = wf.getValue("BID_CANCEL_TEXT"       ,0);
				BID_JOIN_TEXT                = wf.getValue("BID_JOIN_TEXT"         ,0);
	
				REMARK                       = wf.getValue("REMARK"                ,0);
				ESTM_MAX_VOTE                = wf.getValue("ESTM_MAX_VOTE"         ,0);
	
				STANDARD_POINT               = wf.getValue("STANDARD_POINT"        ,0);
				TECH_DQ                		 = wf.getValue("TECH_DQ"               ,0);
				AMT_DQ                		 = wf.getValue("AMT_DQ"                ,0);
				
				X_PURCHASE_QTY  	         = wf.getValue("X_PURCHASE_QTY"        ,0);
				X_MAKE_SPEC 			     = wf.getValue("X_MAKE_SPEC"           ,0);
				X_BASIC_ADD 			     = wf.getValue("X_BASIC_ADD"           ,0);
				X_RELATIVE_ADD 	             = wf.getValue("X_RELATIVE_ADD"        ,0);
				X_ESTM_CHECK 	             = wf.getValue("X_ESTM_CHECK"          ,0);
				X_PERSON_IN_CHARGE 	         = wf.getValue("X_PERSON_IN_CHARGE"    ,0);
				X_QUALIFICATION              = wf.getValue("X_QUALIFICATION"       ,0);
				COST_SETTLE_TERMS            = wf.getValue("COST_SETTLE_TERMS"     ,0);	// ëê¸ê²°ì ì¡°ê±´
				
				NEXT_AUTH_ID                 = wf.getValue("NEXT_AUTH_ID"          ,0);	// ë¤ìê²°ì¬ì
				NEXT_AUTH_NM                 = wf.getValue("NEXT_AUTH_NM"          ,0);
				APPV_STATUS                  = wf.getValue("APPV_STATUS"           ,0);	// ê²°ì¬ìí(C=ìì±ì¤,A:ê²°ì¬ì¤,D:ë°ë ¤,Y:ìë£)
				AUTH_SEQ                     = wf.getValue("AUTH_SEQ"              ,0);	// ê²°ì¬ìì
				REJECT_OPINION               = wf.getValue("REJECT_OPINION"        ,0);	// ê²°ì¬ìì
				
				ITEM_TYPE                    = wf.getValue("ITEM_TYPE"             ,0);	     // íëª©êµ¬ë¶ì½ë
				
				OPEN_GB                      = wf.getValue("OPEN_GB"               ,0);	     // ê°ì°°êµ¬ë¶
				
				wf = new WiseFormater(value.result[1]);
				rw_cnt = wf.getRowCount();
				if (rw_cnt > 0 )
				{
					CTRL_AMT = wf.getValue("CTRL_AMT", 0); // íµì ê¸ì¡
				}

		}

		// íì¥ ê²°ì¬ì ëª©ë¡ ê°ì ¸ì¤ê¸°.
		wf = new WiseFormater(value.result[2]);
		rw_cnt = wf.getRowCount();

		for (int i = 0; i < rw_cnt ; i++)
		{
			aAuthList[i][0] = wf.getValue("USER_ID",i);
			aAuthList[i][1] = wf.getValue("USER_NAME_LOC",i);
		}

	}catch(Exception e) {
		Logger.err.println(info.getSession("ID"),this,"ebd_bd_ins1 = " + e.getMessage());
		Logger.dev.println(e.getMessage());

	}finally{
		wr.Release();
	} // finally ë
		
	if(origin_bid_status.equals("IUR")) // ì ì ê³µê³  ìì± ëìê±´ì¼ ê²½ì°ìë BID_STATUS = 'UR' ë¡ íì íë¤.
		BID_STATUS = "UR";
%>


<%
	//íí
	String code = "";
	String desc = "";
	String result = "";
	WiseListBox wlb = new WiseListBox();
	String node_code = wlb.Table_ListBox(request, "SL0034", HOUSE_CODE+"#" + "M002" + "#", "#", "@");
	StringTokenizer st = new StringTokenizer(node_code,"@");
	int count = st.countTokens();
	String[] line = new String[count];
	
	for ( int i = 0 ; i < count ; i++ ){
		line[i] = st.nextToken().trim();
	}

	for( int j=0; j< line.length ; j++){
		StringTokenizer std = new StringTokenizer(line[j],"#");
		code =std.nextToken();
		desc =std.nextToken();
		result += desc + "&" + code + "#";
	}

%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<!-- META TAG ì ì  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="../../css/body.css" type="text/css">
<style type="text/css">

table.sep
{
border-collapse: separate
}
</style>

<!-- ì¬ì©ì ì ì Script -->
<!-- HEADER START (JavaScript here)-->

<%@ include file="/include/wisehub_scripts.jsp"%>

<Script language="javascript">
	var G_FLAG = "N";

	var MSG_DODATA;
	var mode;
	var button_flag = false;

	var Bid_Values      = "";       // íì°¨ Data
	var Vendor_values   = "";       // ìì²´ Data
	var Location_values = "";       // ì§ì­ Data
	var Bid_Vendors     = "";       // ë³µìëì°° Data
	var Bid_Location    = "";       // ë³µìëì°° Data
	var explanation_modify_flag = "false";
	<%
	if(!(ANNOUNCE_DATE.equals("") || ANNOUNCE_DATE == null)) {
		%>
		explanation_modify_flag = "true";
		<%
	}
	%>

	var date_flag;
	var Current_Row;
	var TOT_OPERATING;              // /kr/dt/pr/pr1_pp_lis5_frame.jsp ìì ì¬ì©...
	var TOT_CUR;

	var current_date = "<%=current_date%>";
	var current_time = "<%=current_time%>";

	var INDEX_SELECTED         ;
	var INDEX_DESCRIPTION_LOC  ;
	var INDEX_UNIT_MEASURE     ;
	var INDEX_QTY              ;
	var INDEX_CUR              ;
	var INDEX_UNIT_PRICE       ;
	var INDEX_AMT              ;

	var INDEX_PR_NO       		;
	var INDEX_PR_SEQ            ;

	function setHeader() {
		document.WiseGrid.ClearGrid();
		<%
		if(SCR_FLAG.equals("C")) {
			%>
			document.WiseGrid.AddHeader("SELECTED",  "ì í","t_checkbox",1100,0,true);
			<%
		}else{
			%>
			document.WiseGrid.AddHeader("SELECTED",  "ì í","t_checkbox",100,30,true);
			<%
		}
		%>
		document.WiseGrid.AddHeader("PR_NO"				,"êµ¬ë§¤ìì²­ë²í¸","t_text",500,100,false);
		document.WiseGrid.AddHeader("DESCRIPTION_LOC"	,"ê±´ëª","t_text",500,200,true);
		document.WiseGrid.AddHeader("DET"				,"ê·ê²©","t_text",4,60,false);
		document.WiseGrid.AddHeader("QTY"				,"ìë","t_number",22,100,true);
		document.WiseGrid.AddHeader("UNIT_PRICE"		,"ìì ë¨ê°","t_number",22.2,100,false);
		document.WiseGrid.AddHeader("AMT"				,"ìì ê°ê²©(VATí¬í¨)","t_number",22.2,130,false);
		document.WiseGrid.AddHeader("CUR"				,"íí","t_combo",100,60,false);
		document.WiseGrid.AddHeader("UNIT_MEASURE"		,"ë¨ì","t_text",1004,0,false);
		document.WiseGrid.AddHeader("PR_SEQ"			,"SEQ","t_text",500,60,false);

		document.WiseGrid.BoundHeader();

		document.WiseGrid.SetColCellBgColor("PR_NO","254|251|226");
		document.WiseGrid.SetColCellSortEnable("PR_NO",false);
		document.WiseGrid.SetColCellBgColor("PR_SEQ","254|251|226");
		document.WiseGrid.SetColCellSortEnable("PR_SEQ",false);
		document.WiseGrid.SetColCellBgColor("DESCRIPTION_LOC","254|251|226");
		document.WiseGrid.SetColCellSortEnable("DESCRIPTION_LOC",false);
		document.WiseGrid.SetColCellBgColor("DET","254|251|226");
		document.WiseGrid.SetColCellSortEnable("DET",false);
		document.WiseGrid.SetNumberFormat("QTY","##,###,###,###,###,###");
		document.WiseGrid.SetColCellBgColor("QTY","254|251|226");
		document.WiseGrid.SetNumberFormat("UNIT_PRICE","##,###,###,###,###,###.##");
		document.WiseGrid.SetColCellBgColor("UNIT_PRICE","254|251|226");
		document.WiseGrid.SetNumberFormat("AMT","##,###,###,###,###,###.##");
		document.WiseGrid.SetColCellBgColor("AMT","255|255|255");
		document.WiseGrid.SetColCellBgColor("UNIT_MEASURE","254|251|226");
		document.WiseGrid.SetColCellSortEnable("UNIT_MEASURE",false);
		
		INDEX_SELECTED          = document.WiseGrid.GetColHDIndex("SELECTED");
		INDEX_DESCRIPTION_LOC   = document.WiseGrid.GetColHDIndex("DESCRIPTION_LOC");
		INDEX_UNIT_MEASURE      = document.WiseGrid.GetColHDIndex("UNIT_MEASURE");
		INDEX_QTY               = document.WiseGrid.GetColHDIndex("QTY");
		INDEX_CUR               = document.WiseGrid.GetColHDIndex("CUR");
		
		INDEX_UNIT_PRICE        = document.WiseGrid.GetColHDIndex("UNIT_PRICE");
		INDEX_AMT               = document.WiseGrid.GetColHDIndex("AMT");
		
		INDEX_PR_NO        		= document.WiseGrid.GetColHDIndex("PR_NO");
		INDEX_PR_SEQ            = document.WiseGrid.GetColHDIndex("PR_SEQ");
		
		document.forms[0].bid_no.value = "<%=BID_NO%>";
		document.forms[0].bid_count.value = "<%=BID_COUNT%>";
			
	}

	var thistime    = "<%=current_time%>".substring(0,2);
	var thisminute  = "<%=current_time%>".substring(2,4);

	//ë¡ë©ì ë,ì,ì,ë¶ì ê°ì ¸ì¤ë í¨ì
	var j=0;
	function Init_Date()
	{
		document.form1.ANN_DATE.value = current_date;
    }

	function init() {

		//ìì±ì ëí´í¸ê° ì¸í
		<% if ( SCR_FLAG.equals("I") && !BID_STATUS.equals("UR")) { %>
				document.form1.LIMIT_CRIT.value = "ìë¥ì ì¶ ë§ê°ì¼ íì¬ ì¬ìì¥ë±ë¡ì¦ì ìì§í ìì²´ë¡ì ë¹íì´ ì ìí ì¬ìì¼ë¡ ë©íê¸°ì¼ ë´ ì ë ë©íì´ ê°ë¥í ìì²´";		

				<% if ( BID_TYPE.equals("D")) { %>
					// êµ¬ë§¤ìì°°
					document.form1.X_MAKE_SPEC.value = "ë¶ì [ì ì¡°ì¬ìì] íì¼ì²¨ë¶ ì°¸ì¡°";
					document.form1.X_BASIC_ADD.value = "ëì°°ìë ëì°°íµì§ë¥¼ ë°ì í 10ì¼ ì´ë´ì ê³ì½ì ì²´ê²°í´ì¼ í¨";
					document.form1.BID_ETC.value = "(1) ìì°°ê¸ì¡ì ì´ì¤, ë¶ê°ê°ì¹ì¸, í¬ì¥ë¹, ë°°ì¡ë¹ ë± ì¼ì²´ì ê´ë ¨ë¹ì©ì í¬í¨í ê¸ì¡ì\r\n(2) ìì ìë, ìì°°ì¼ì, ë©íê¸°ì¼ ë± ê¸°í ëª¨ë ì¬í­ì ì°ë¦¬ìí ì¬ì ì ë°ë¼ ë³ê²½ ë  ì ìì\r\n(3) ë´í© ë° ê²½ìì°¸ê°ë¥¼ ë°©í´í ìì ìì°°ì ë¬´í¨ë¡ í¨\r\n(4) ê¸°í ê³ì½ì ê´í ì¼ë°ì ì¸ ì¬í­ì ãì°ë¦¬ìí ê³ì½ì¬ë¬´ì§ì¹¨ì ë°ë¦\r\n(5) ë¬¸ìì² : ì°ë¦¬ìí ì´ë¬´ë¶";						
				<% } else {%>
					// ê³µì¬ìì°°
					document.form1.BID_ETC.value = "(1) ì¤ê³ëì(ìë°©ì,ëë©´) ë° ê¸°ì ê´ë ¨íì¬ ë¬¸ìì² : ë´ë¹ê¸°ì ì­\r\n(2) ë³¸ ê³µì¬ë ê±´ì¤ì°ìê¸°ë³¸ë² ì 29ì¡°ì ìê±° ë¤ë¥¸ ê³µì¬ìììê² ì¼ê´íì¬ íëê¸ìì¤ ì ìì\r\n(3) ë´í© ë° ê²½ìì°¸ê°ë¥¼ ë°©í´í ìì ìì°°ì ë¬´í¨ë¡ í¨\r\n(4) ê¸°í ìì°°ì ê´í ì¬í­ì ë¹í ê³ì½ì¬ë¬´ì§ì¹¨ì ì¤ì©í¨\r\n(5) ìê¸° ì¬í­ì ì°ë¦¬ìí ì¬ì ì ë°ë¼ ë³ê²½ë  ì ìì\r\n(6) ë¬¸ìì² : ì°ë¦¬ìí ì´ë¬´ë¶\r\n";
					
					//document.form1.X_BASIC_ADD.value = "â  ëê¸ì§ê¸ë°©ë² : íê¸ê²°ì  \n    * ìê¸°ì¬í­ì ì°¸ê³ íì¬ ìì°°íìê¸° ë°ëëë¤.";
				
					document.form1.COST_SETTLE_TERMS_C.value = "íê¸ê²°ì "								
				<% } %>

				
				document.form1.X_RELATIVE_ADD.value = "(1) ì´ì¡ìì°°(ìì°°íëª©ì ëí íëª©ë³ ë¨ê°ì ì ì¡°ìì  ìëì ê³±íì¬ í©ì°í ì´ê¸ì¡)\r\n(2) ë¹ê³µê° 1í í¬ì°°ë°©ì";			
				document.form1.BID_CANCEL_TEXT.value = "ì ì¶í ìë¥ê° íìë ìë³ì¡°ë¡ íëªë  ê²½ì° ë± ë¹í ê³ì½ì¬ë¬´ì§ì¹¨ ì 64ì¡°ì í´ë¹íë ìì°°ì ë¬´í¨ë¡ í¨";
				//document.form1.BID_JOIN_TEXT.value = "(1) ì ì¶ìë¥ëª©ë¡\r\n    ê°. ìì¸ë³´ì¦ë³´í(ì£¼) ì´ì©ìì²´ : ë¹íì´ ë³´ì¦ì ë°ê¸ íí© íì¸\r\n    ë. ê¸°í ë³´ì¦ê¸°ê´ ì´ì©ìì²´ : ìì°°ë³´ì¦ì FAX ë°ì¡(02-2130-5552)\r\n    ë¤. ëì°°ìì²´ë ê³ì½ì ì ì¶ì ë³´ì¦ì ìë³¸ì ì ì¶íì¬ì¼ íë¤.\r\n        (ë¨, ê³µì¬ë¶ë¬¸ì ìì ê°ê²© 3ì²ë§ìì´í êµ¬ë§¤ë¶ë¬¸ì ìì ê°ê²©\r\n         1ì²ë§ì ì´íì¸ ê²½ì°ìë ìì°°ë³´ì¦ê¸ ì§ê¸ê°ìì ì ì¶ë¡\r\n         ìëµí  ì ìë¤.)";
				//document.form1.BID_JOIN_TEXT.value = "(1) ì ì¶ìë¥ëª©ë¡\r\n    ê°. ìì¸ë³´ì¦ë³´í(ì£¼) ì´ì©ìì²´ : ë¹íì´ ë³´ì¦ì ë°ê¸ íí© íì¸\r\n    ë. ê¸°í ë³´ì¦ê¸°ê´ ì´ì©ìì²´ : ìì°°ë³´ì¦ì FAX ë°ì¡(02-3151-2277)\r\n    ë¤. ëì°°ìì²´ë ê³ì½ì ì ì¶ì ë³´ì¦ì ìë³¸ì ì ì¶íì¬ì¼ íë¤.\r\n        (ë¨, ê³µì¬ë¶ë¬¸ì ìì ê°ê²© 3ì²ë§ìì´í êµ¬ë§¤ë¶ë¬¸ì ìì ê°ê²©\r\n         1ì²ë§ì ì´íì¸ ê²½ì°ìë ìì°°ë³´ì¦ê¸ ì§ê¸ê°ìì ì ì¶ë¡\r\n         ìëµí  ì ìë¤.)";
				//document.form1.BID_JOIN_TEXT.value = "(1) ì ì¶ìë¥ëª©ë¡\r\n    ê°. ìì¸ë³´ì¦ë³´í(ì£¼) ì´ì©ìì²´ : ë¹íì´ ë³´ì¦ì ë°ê¸ íí© íì¸\r\n    ë. ê¸°í ë³´ì¦ê¸°ê´ ì´ì©ìì²´ : ìì°°ë³´ì¦ì ìë³¸ ë°ì¡\r\n    ë¤. ëì°°ìì²´ë ê³ì½ì ì ì¶ì ë³´ì¦ì ìë³¸ì ì ì¶íì¬ì¼ íë¤.\r\n        (ë¨, ê³µì¬ë¶ë¬¸ì ìì ê°ê²© 3ì²ë§ìì´í êµ¬ë§¤ë¶ë¬¸ì ìì ê°ê²©\r\n         1ì²ë§ì ì´íì¸ ê²½ì°ìë ìì°°ë³´ì¦ê¸ ì§ê¸ê°ìì ì ì¶ë¡\r\n         ìëµí  ì ìë¤.)";
				document.form1.BID_JOIN_TEXT.value = "(1)ìì°°ë³´ì¦ì : ìì¸ë³´ì¦ë³´í(ì£¼) ë° ê¸°í ë³´ì¦ê¸°ê´ ë°ê¸ ë³´ì¦ì\r\n(2)[ìì°°ë³´ì¦ê¸ ì§ê¸ê°ì] ì ì¶ë¡ [ìì°°ë³´ì¦ì] ìëµ ê°ë¥í ê²½ì°\r\n    (ê°)ê³µì¬ìì°° : ìì ê°ê²© 3ì²ë§ì ì´í ìì°°\r\n    (ë)êµ¬ë§¤ìì°° : ìì ê°ê²© 1ì²ë§ì ì´í ìì°°\r\n â» ëì°°ìì²´ë ê³ì½ì ì ì¶ ì [ìì°°ë³´ë³´ì¦ì] ë° [ìì°°ë³´ì¦ê¸ ì§ê¸ê°ì]\r\n    ìë³¸ì ì ì¶íì¬ì¼ í¨\r\n";
				//document.form1.CONT_PLACE.value = "ìì¸í¹ë³ì ì¤êµ¬ ììë¬¸ë 135ë²ì§ ì¬ë¦¬ë¸íì 11ì¸µ ì°ë¦¬ìí ì´ë¬´ë¶";
				//document.form1.CONT_PLACE.value = "ìì¸ì ë§í¬êµ¬ ììë 1585ë²ì§ ì°ë¦¬ê¸ìµ ììì¼í° 9ì¸µ ãì°ë¦¬ìí ì´ë¬´ë¶";
				document.form1.CONT_PLACE.value = "ì ììì°°ìì¤íå§ ìì°°ì°¸ì¬ ê³µê³ ê±´ì ë³´ì¦ì íì¼ì²¨ë¶(ê³µì§ì¬í­ì°¸ì¡°)";				
				document.form1.FROM_LOWER_BND.value = 85;
				document.form1.TECH_DQ.value = 90;
				document.form1.AMT_DQ.value = 10;    
		    
		<% } %>
		
		<%
			if (LIMIT_CRIT.equals("ê±´ì¤ì°ìê¸°ë³¸ë²ì ìí ì ë¬¸ê±´ì¤ì ë©´íë¥¼ ìì§í ìì²´ì¤ ìì°°ë±ë¡ìë¥ë¥¼ ì ì¶í ìì²´")) 
					// ë¬¸êµ¬ìì ì¼ë¡ ì¬ì©ìë¨(20100601) : Q6ì¼ë¡ ëì²´
					LIMIT_CRIT = "Q1"; 
			else if (LIMIT_CRIT.equals("ê±´ì¤ì°ìê¸°ë³¸ë²ì ìí ì¤ë¹ê³µì¬ì ë©´íë¥¼ ìì§í ìì²´ì¤ ìì°°ë±ë¡ìë¥ë¥¼ ì ì¶í ìì²´")) 
					LIMIT_CRIT = "Q2"; 
			else if (LIMIT_CRIT.equals("ê±´ì¤ì°ìê¸°ë³¸ë²ì ìí ì ê¸°ê³µì¬ì ë©´íë¥¼ ìì§í ìì²´ì¤ ìì°°ë±ë¡ìë¥ë¥¼ ì ì¶í ìì²´")) 
					LIMIT_CRIT = "Q3"; 
			else if (LIMIT_CRIT.equals("ê±´ì¤ì°ìê¸°ë³¸ë²ì ìí ì ë³´íµì ê³µì¬ì ë©´íë¥¼ ìì§í ìì²´ì¤ ìì°°ë±ë¡ìë¥ë¥¼ ì ì¶í ìì²´")) 
					LIMIT_CRIT = "Q4"; 
			else if (LIMIT_CRIT.equals("ê±´ì¤ì°ìê¸°ë³¸ë²ì ìí ì¤ë´ê±´ì¶ê³µì¬ì ë©´íë¥¼ ìì§í ìì²´ì¤ ìì°°ë±ë¡ìë¥ë¥¼ ì ì¶í ìì²´")) 
					LIMIT_CRIT = "Q6"; 
			else if (LIMIT_CRIT.equals("ê¸°í")) 
					LIMIT_CRIT = "Q5"; 
		%>

		<% if (X_ESTM_CHECK.equals("Y")) { %> document.forms[0].X_ESTM_CHECK.checked = true; <%}%>
		setHeader();
		Init_Date();
		doSelect();
		setVisibleVendor();
		setVisiblePeriod();
		setVisibleESTM();
		
		// êµ¬ë§¤ìì°°ì¸ ê²½ì°ë§ ì ì©íë¤.
		<% if (BID_TYPE.equals("D")) {%>
		
				<%if ( COST_SETTLE_TERMS.equals("") ) {%>
					// 20080612 ê¹ê´ì§ ê³¼ì¥ ìì²­ì ìíì¬ ëë²ì§¸ ê²ì ê¸°ë³¸ì¼ë¡ ì¤ì 
					// 20120604 ì ì¸ê¸¸ ê³¼ì¥ ìì²­ ì¹´ëê²°ì  ê¸°ë³¸ì¼ë¡ ë³ê²½
					document.form1.COST_SETTLE_TERMS[0].checked=true;
					fnCostSettleTerms(0);
				<%}else{%>
					document.form1.hidCOST_SETTLE_TERMS.value="<%=COST_SETTLE_TERMS%>";
				<%}%>
		
		<%}%>

		//checkExplanation();
	}

	function doSelect() {
		if("<%=SCR_FLAG%>" == "U") {
			mode = "getBDDTDisplay";
		} else if("<%=SCR_FLAG%>" == "C") {
			mode = "getBDDTDisplay";
		} else if("<%=SCR_FLAG%>" == "D") {
			mode = "getBDDTDisplay";
		} else if("<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "UR") {
			// ì ì ê³µê³  ìì±ê±´ì ê²½ì°ìë ê¸°ì¡´ ë°ì´í°ë¥¼ ê°ì ¸ì¨ë¤.
			mode = "getBDDTDisplay";
		} else {
			mode = "getPrDTDisplay_VAT";
		}
		servletUrl = "/servlets/dt.bidd.ebd_bd_ins1";
		
		document.WiseGrid.SetParam("mode"      , mode);
		document.WiseGrid.SetParam("PR_NO"     , "<%=PR_NO%>");
		document.WiseGrid.SetParam("REQ_PR_SEQ", "<%=REQ_PR_SEQ%>");
		document.WiseGrid.SetParam("BID_NO"    , "<%=BID_NO%>");
		document.WiseGrid.SetParam("BID_COUNT" , "<%=BID_COUNT%>");

		document.WiseGrid.bSendDataFuncDefaultValidate=false;
		document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","0");
		document.WiseGrid.SendData(servletUrl);
		document.WiseGrid.strHDClickAction="sortmulti";
	}

	function doSelect2(REQ_PR_SEQ) {
		var	mode = "getPrDTDisplay_VAT";

		var basic_pr_no_seq = "";

		for(row=0; row<document.WiseGrid.GetRowCount();	row++) {
			basic_pr_no_seq += GD_GetCellValueIndex(document.WiseGrid,row,	INDEX_PR_NO) + "$@$" + GD_GetCellValueIndex(document.WiseGrid,row,	INDEX_PR_SEQ) + "^#^";
		}
		servletUrl = "/servlets/dt.bidd.ebd_bd_ins1";
		
		document.WiseGrid.SetParam("mode", mode);
		document.WiseGrid.SetParam("PR_NO", "<%=PR_NO%>");
		document.WiseGrid.SetParam("REQ_PR_SEQ", basic_pr_no_seq+REQ_PR_SEQ);
		document.WiseGrid.SetParam("BID_NO", "<%=BID_NO%>");
		document.WiseGrid.SetParam("BID_COUNT", "<%=BID_COUNT%>");
		document.WiseGrid.SetParam("ITEM_FIND", "ITEM_FIND");
		
		document.WiseGrid.bSendDataFuncDefaultValidate=false;
		document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","0");
		document.WiseGrid.SendData(servletUrl);
		document.WiseGrid.strHDClickAction="sortmulti";
	}	 
		 
		 
	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		if(msg1 == "doQuery")
		{
			if (mode == "getBidPRDisplay")
			{
			}
		}
		else if(msg1 == "doData")
		{
			// ì ì¡/ì ì¥ì
			if(mode != "setDataToGW" && mode != "setSignStatus")
			{
				if(document.WiseGrid.GetStatus() == "0")
				{
					// ì¤í¨ íì ê²½ì°ì...
					alert(GD_GetParam(document.WiseGrid,0));
					//location.href="ebd_bd_lis3.jsp";
				}

				if(document.WiseGrid.GetStatus() == "1")
				{
					// ì±ê³µì¼ ê²½ì°ì...
					if(G_FLAG == "T" || G_FLAG == "C" || G_FLAG == "A" || G_FLAG == "D")
					{
						// ììì ì¥, íì , ê²°ì¬ì¬ë¦¼ ê²½ì°ìë§....
						alert(GD_GetParam(document.WiseGrid,0));

						if("<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "AR") { // ìì°°ê³µê³ ê±´ì ê²½ì°ìë§ êµ¬ë§¤ê²í ëª©ë¡ì¼ë¡ REDIRECTION
							<% if (BID_TYPE.equals("D")) {%>
								location.href = "ebd_bd_lis3.jsp";
							<% } else { %>
								location.href = "/kr/dt/bidc/ebd_bd_lis3.jsp";
							<% }%>
						} else {
							<% if (BID_TYPE.equals("D")) {%>
							location.href = "ebd_bd_lis3.jsp";
							<% } else { %>
								location.href = "/kr/dt/bidc/ebd_bd_lis3.jsp";
							<% }%>
						}
					}
					else if(G_FLAG == "P")
					{
						// ê²°ì¬ìì²­ì¼ ê²½ì°ì...
						MSG_DODATA      = GD_GetParam(document.WiseGrid,0);

						var bid_no      = GD_GetParam(document.WiseGrid,1);
						var bid_count   = GD_GetParam(document.WiseGrid,2);
						var ann_no      = GD_GetParam(document.WiseGrid,3);

						document.forms[0].bid_no.value    = bid_no;
						document.forms[0].bid_count.value = bid_count;

						mode = "setDataToGW";

						servletUrl = "/servlets/dt.bidd.ebd_bd_ins1"; //p1009

						document.WiseGrid.SetParam("mode", mode);

						document.WiseGrid.SetParam("BID_NO", bid_no);
						document.WiseGrid.SetParam("BID_COUNT", bid_count);
						document.WiseGrid.SetParam("ANN_NO", ann_no);
						document.WiseGrid.bSendDataFuncDefaultValidate=false;
						document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","1");
						document.WiseGrid.SendData(servletUrl, "ALL", "ALL");
					
					}
				}
			}
			else if(mode == "setDataToGW")
			{
				if(document.WiseGrid.GetStatus() == "0")
				{	// ì¤í¨ íì ê²½ì°ì...
					alert(GD_GetParam(document.WiseGrid,0));
					G_FLAG = "N"; // ë¤ì ì´ê¸°í í´ì¤ë¤.
					button_flag = false; // ë²í¼ action ...  actionì ì·¨í ììëë¡...
					return;
				}
				else
				{
					<%
					String G_groupware_info = "";
					try
					{
						Config conf = new Configuration();
						
						G_groupware_info = conf.get("wise.groupware.info");
					}
					catch(Exception e)
					{
						System.out.println("ConfigurationException:"+e.getMessage());
					}
					
					%>

					var url = "<%=G_groupware_info%>/bid_approval_D.htm";

					window.open( url , "GW_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=500,left=0,top=0");
					location.href = "ebd_bd_lis3.jsp";
				}
			}
			else if(mode == "setSignStatus")
			{
				if(document.WiseGrid.GetStatus() == "0")
				{
					// ì¤í¨ íì ê²½ì°ì...
					alert(GD_GetParam(document.WiseGrid,0));
					G_FLAG = "N"; // ë¤ì ì´ê¸°í í´ì¤ë¤.
					button_flag = false; // ë²í¼ action ...  actionì ì·¨í ììëë¡...
					return;
				}
				else
				{
					if("<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "AR") { // ìì°°ê³µê³ ê±´ì ê²½ì°ìë§ êµ¬ë§¤ê²í ëª©ë¡ì¼ë¡ REDIRECTION
						location.href = "../pr/pr3_bd_lis1.jsp";
					} else {
						location.href = "ebd_bd_lis3.jsp";
					}
				}
			}
			else if(mode == "setCopy")
			{
			    alert(document.WiseGrid.GetMessage());
			}
		} else if(msg1 == "t_imagetext") {
			
		} else if(msg1 == "t_header") {
			
		} else if(msg1 == "t_insert") {
			if(msg3 == INDEX_UNIT_PRICE || msg3 == INDEX_QTY) {
				var tmp_amt = GD_GetCellValueIndex(document.WiseGrid,msg2, INDEX_UNIT_PRICE);
				var tmp_qty = GD_GetCellValueIndex(document.WiseGrid,msg2, INDEX_QTY);
				
				if(isNull(tmp_amt)) tmp_amt = 0;
				if(isNull(tmp_qty)) tmp_qty = 0;
				var tmp_amt = (parseFloat(tmp_amt) * parseFloat(tmp_qty));
				
				GD_SetCellValueIndex(document.WiseGrid,msg2, INDEX_AMT, tmp_amt);
			}	
			if(msg3 == INDEX_SELECTED){
            	for(row=0; row<document.WiseGrid.GetRowCount();	row++) {
					if(	GD_GetCellValueIndex(document.WiseGrid,msg2, INDEX_PR_NO) == GD_GetCellValueIndex(document.WiseGrid,row, INDEX_PR_NO)) {
						if(GD_GetCellValueIndex(document.WiseGrid,msg2, INDEX_SELECTED) == "true"){
							GD_SetCellValueIndex(document.WiseGrid,row, INDEX_SELECTED , "true&", "&");
						}else {
							GD_SetCellValueIndex(document.WiseGrid,row, INDEX_SELECTED , "false&", "&");
						}
					}
				}
			}
		}
	}	
		
	function setSignStatus() {

		mode = "setSignStatus";
		servletUrl = "/servlets/dt.bidd.ebd_bd_ins1"; //p1009
		
		document.WiseGrid.SetParam("mode", mode);
		document.WiseGrid.SetParam("BID_NO", document.forms[0].bid_no.value);
		document.WiseGrid.SetParam("BID_COUNT", document.forms[0].bid_count.value);
		document.WiseGrid.SetParam("SIGN_STATUS", "P"); // ê²°ì¬ìì²­ ìí('P')ë¡ UPDATEíë¤.
		
		document.WiseGrid.bSendDataFuncDefaultValidate=false;
		document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","1");
		document.WiseGrid.SendData(servletUrl, "ALL", "ALL");
		
	}

	function POPUP_Open(url, title, left, top, width, height) {
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		code_search.focus();
	}

	function attach_file() {
		var ATTACH_VALUE = LRTrim(document.form1.attach_values.value);

		//if("" == ATTACH_VALUE) {
		//	FileAttach('BD','','');
		//} else {
		//	FileAttachChange('BD', ATTACH_VALUE);
		//}
		FileAttach('BD',ATTACH_VALUE,'');
	}

	function setAttach(attach_key, arrAttrach, attach_count) {
		document.form1.attach_values.value = attach_key;
		document.form1.attach_count.value = attach_count;
	}

	//--------------------------------------------
	function getVendor() {      //ìì²´ì§ì 
		var mode;
		var shipper_type = "KR";
		var szRow = "-1";
		var cnt = document.form1.vendor_count.value;
		
		var url;
		
		if( cnt == "" || cnt == 0 ) {
			mode = "E";
			url = "../rfq/rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		} else {
			mode = "I";
			url = "../rfq/rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		}

		if("<%=SCR_FLAG%>" == "U" || "<%=SCR_FLAG%>" == "C" || "<%=SCR_FLAG%>" == "D" || ( "<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "UR" )) { // ì ì ê³µê³ ê±´ì ê²½ì°ìë ê¸°ì¡´ ë°ì´í°ë¥¼ ê°ì ¸ì¨ë¤.
			mode = "BID";
			url = "../rfq/rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&shipper_type="+shipper_type+"&BID_NO=<%=BID_NO%>&BID_COUNT=<%=BID_COUNT%>&SCR_FLAG=<%=SCR_FLAG%>";
		}

		window.open( url , "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=500,left=0,top=0");
	}

	function vendorInsert(szRow, VANDOR_SELECTED, SELECTED_COUNT) {
		Vendor_values = VANDOR_SELECTED;
		document.form1.vendor_values.value = Vendor_values;
		document.form1.vendor_count.value = SELECTED_COUNT;
	}

	function getCompany(szRow) {
		return Vendor_values;  
	}

	function setVendor(values, count) {
		Bid_Vendors = values;

		for(var i = 0; i < document.form1.bid_vendor.length; i++) {
			if (count == document.form1.bid_vendor.options(i).value) {
				document.form1.bid_vendor.selectedIndex = i;
				break;
			}
		}
	}

	//--------------------------------------------
	function getLocation() {      //ì íì¡°ê±´
		var mode;
		var shipper_type = "KR";
		var szRow = "-1";
		var cnt = document.form1.location_count.value;

		var url;

		if( cnt == "" || cnt == 0 ) {
			mode = "E";
			url = "../rfq/rfq_pp_ins11.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		} else {
			mode = "I";
			url = "../rfq/rfq_pp_ins11.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		}

		if("<%=SCR_FLAG%>" == "U" || "<%=SCR_FLAG%>" == "C" || "<%=SCR_FLAG%>" == "D" || ( "<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "UR" )) { // ì ì ê³µê³ ê±´ì ê²½ì°ìë ê¸°ì¡´ ë°ì´í°ë¥¼ ê°ì ¸ì¨ë¤.
			mode = "BID";
			url = "../rfq/rfq_pp_ins11.jsp?mode=" + mode + "&szRow=" + szRow + "&shipper_type="+shipper_type+"&BID_NO=<%=BID_NO%>&BID_COUNT=<%=BID_COUNT%>&SCR_FLAG=<%=SCR_FLAG%>";
		}

		window.open( url , "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=650,height=400,left=0,top=0");
	}

	function locationInsert(szRow, LOCATION_SELECTED, SELECTED_COUNT) {
		Location_values = LOCATION_SELECTED;
		document.form1.location_values.value = Location_values;
		document.form1.location_count.value = SELECTED_COUNT;
	}

	function getLocation_value(szRow) {
		return Location_values;
	}

	function setLocation(values, count) {
		Bid_Location = values;

		for(var i = 0; i < document.form1.bid_location.length; i++) {
			if (count == document.form1.bid_location.options(i).value) {
				document.form1.bid_location.selectedIndex = i;
				break;
			}
		}
	}

	function checkData() {
	
		if("<%=BID_TYPE%>" == "O") {
			if(LRTrim(document.form1.ANN_NO.value) == "") {
				alert("ê³µê³ ë²í¸ë¥¼ ìë ¥íì¸ì. ");
				document.forms[0].ANN_NO.focus();
				return false;
			}
		}

		if(LRTrim(document.form1.ANN_DATE.value) == "") {
			alert("ê³µê³ ì¼ìë¥¼ ìë ¥íì¸ì. ");
			document.forms[0].ANN_DATE.focus();
			return false;
		}

		if(!checkDateCommon(document.form1.ANN_DATE.value)){
			document.forms[0].ANN_DATE.select();
			alert("ê³µê³ ì¼ìë¥¼ íì¸íì¸ì.");
			return false;
		}

		if("<%=SCR_FLAG%>" == "C") {
			if(parseFloat(document.form1.ANN_DATE.value) < parseFloat(current_date)) {
				alert("ê³µê³ ì¼ìê° ì§ë ê±´ì íì í  ì ììµëë¤.");
				return false;
			}
		}

		if(LRTrim(document.form1.ANN_ITEM.value) == "") {
			alert("ìì°°ê±´ëªì ìë ¥íì¸ì. ");
			document.forms[0].ANN_ITEM.focus();
			return false;
		}
		
		
		
		

		if(LRTrim(document.form1.CONT_TYPE1.value) == "NC") {
			if(LRTrim(document.form1.vendor_count.value) == "0")  {
				alert("ìì²´ì§ì ì íìì¼ í©ëë¤.");
				return false;
			}
		} else {
			if(eval(LRTrim(document.form1.vendor_count.value)) > 0)  {
				alert("ìì²´ì§ì ì íì¤ì ììµëë¤.");
				return false;
			}
		}

//		if(LRTrim(document.form1.CONT_TYPE1.value) == "LC") {
//			if(LRTrim(document.form1.location_count.value) ==   "0")  {
//				alert("ì§ì­ì§ì ì íìì¼ í©ëë¤.");
//				return false;
//			}
//		} else {
//			if(eval(LRTrim(document.form1.location_count.value)) > 0)    {
//				alert("ì§ì­ì§ì ì íì¤ì ììµëë¤.");
//				return false;
//			}
//		}
		
		// [ìµì ê°], [ì íì íê· ê°],[ì íì ìµì ê°] ìëê²½ì°...
		if(   LRTrim(document.form1.CONT_TYPE2.value) != "LP" && LRTrim(document.form1.CONT_TYPE2.value) != "RA" && LRTrim(document.form1.CONT_TYPE2.value) != "RL" )
		{ 
			if(LRTrim(document.form1.APP_BEGIN_DATE.value) == "") {
				alert("íê°ìì ì¶ì¼ìë¥¼ ìë ¥íì¸ì. ");
				document.forms[0].APP_BEGIN_DATE.focus();
				return false;
			}

			if(!checkDateCommon(document.form1.APP_BEGIN_DATE.value)){
				document.forms[0].APP_BEGIN_DATE.select();
				alert("íê°ìì ì¶ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}

			if(LRTrim(document.form1.APP_END_DATE.value) == "") {
				alert("íê°ìì ì¶ì¼ìë¥¼ ìë ¥íì¸ì. ");
				document.forms[0].APP_END_DATE.focus();
				return false;
			}

			if(!checkDateCommon(document.form1.APP_END_DATE.value)){
				document.forms[0].APP_END_DATE.select();
				alert("íê°ìì ì¶ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}
		}

		// [ìµì ê°], [ì íì íê· ê°],[ì íì ìµì ê°] ê²½ì°
		if(LRTrim(document.form1.CONT_TYPE2.value) == "LP" || LRTrim(document.form1.CONT_TYPE2.value) == "RA"  || LRTrim(document.form1.CONT_TYPE2.value) == "RL")
		{ 
			if(LRTrim(document.form1.BID_BEGIN_DATE.value) == "")  {
				alert("ìì°°ìì ì¶ì¼ìë¥¼ ìë ¥íìì¼ í©ëë¤.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			}

			if(!checkDateCommon(document.form1.BID_BEGIN_DATE.value)){
				document.forms[0].BID_BEGIN_DATE.select();
				alert("ìì°°ìì ì¶ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}

			if(LRTrim(document.form1.BID_END_DATE.value) == "")  {
				alert("ìì°°ìì ì¶ì¼ìë¥¼ ìë ¥íìì¼ í©ëë¤.");
				document.forms[0].BID_END_DATE.focus();
				return false;
			}

			if(!checkDateCommon(document.form1.BID_END_DATE.value)){
				document.forms[0].BID_END_DATE.select();
				alert("ìì°°ìì ì¶ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}


			if(LRTrim(document.form1.OPEN_DATE.value) == "")  {
				alert("ê°ì°°ì¼ìë¥¼ ìë ¥íìì¼ í©ëë¤.");
				document.forms[0].OPEN_DATE.focus();
				return false;
			}

			if(!checkDateCommon(document.form1.OPEN_DATE.value)){
				document.forms[0].OPEN_DATE.select();
				alert("ê°ì°°ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}

		}
		
		if(LRTrim(document.form1.X_DOC_SUBMIT_DATE.value) == "")  {
				alert("ì ì¶ì¼ìë¥¼ ìë ¥íìì¼ í©ëë¤.");
				document.forms[0].X_DOC_SUBMIT_DATE.focus();
				return false;
		}
		
		if(LRTrim(document.form1.X_DOC_SUBMIT_TIME_HOUR_MINUTE.value) == "")  {
				alert("ì ì¶ì¼ìë¥¼ ìë ¥íìì¼ í©ëë¤.");
				document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.focus();
				return false;
		}
		 
		if(LRTrim(document.form1.LIMIT_CRIT.value) == "") {
			alert("ìì°°ì°¸ê°ìê²©ì ìë ¥íì¸ì. ");
			document.forms[0].LIMIT_CRIT.focus();
			return false;
		}

		if(LRTrim(document.form1.ESTM_KIND.value) == "M")   {
			if(LRTrim(document.form1.ESTM_RATE.value) == "") {
				alert("ìë¹ê°ê²©ë²ìë¥¼ ìë ¥íì¸ì. ");
				document.forms[0].ESTM_RATE.focus();
				return false;
			}
			if(LRTrim(document.form1.ESTM_MAX.value) == "") {
				alert("ì¬ì©ìë¹ê°ê²©ìë¥¼ ìë ¥íì¸ì. ");
				document.forms[0].ESTM_MAX.focus();
				return false;
			}
			if(LRTrim(document.form1.ESTM_VOTE.value) == "") {
				alert("ì¶ì²¨ìë¥¼ ìë ¥íì¸??. ");
				document.forms[0].ESTM_VOTE.focus();
				return false;
			}
		}

		if(LRTrim(document.form1.FROM_CONT.value) == "") {
			alert("ëì°°ìì ì  ê¸°ì¤ì ì ííì¸ì.    ");
			return false;
		}

		if(LRTrim(document.form1.FROM_LOWER_BND.value) == "") {
			alert("ìµì ííì¨ì ìë ¥íì¸ì. ");
			document.forms[0].FROM_LOWER_BND.focus();
			return false;
		}

		//if(LRTrim(document.form1.PROM_CRIT.value) == "") {
		//	alert("ëì°°ìì ì  ê¸°ì¤ì ìë ¥íì¸ì.    ");
		//	document.forms[0].PROM_CRIT.focus();
		//	return false;
		//}

		<% if (BID_TYPE.equals("D")) { %>
				if(LRTrim(document.form1.RD_DATE.value) == "") {
					alert("ë©íìë£ì¼ìë¥¼ ìë ¥íì¬ ì£¼ì­ìì¤. ");
					document.forms[0].RD_DATE.focus();
					return false;
				}
		
				//if(!checkDateCommon(document.form1.RD_DATE.value)){
				//	document.forms[0].RD_DATE.select();
				//	alert("ë©íìë£ì¼ì íìì íì¸íì¬ ì£¼ì­ìì¤.");
				//	return false;
				//}
		<%}%>
		var cur_hh   = current_time.substring(0,2);
		var cur_mm   = current_time.substring(2,4);

		var ANN_DATE                		= document.forms[0].ANN_DATE.value; // ê³µê³ ì¼ì

		var APP_BEGIN_DATE          		= document.forms[0].APP_BEGIN_DATE.value; // íê°ìì ì¶ì¼ì (from)
		var APP_BEGIN_TIME_HOUR_MINUTE      = document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.value; // íê°ìì ì¶ì¼ì (fromhour)
		var APP_END_DATE            		= document.forms[0].APP_END_DATE.value; // íê°ìì ì¶ì¼ì   (to)
		var APP_END_TIME_HOUR_MINUTE        = document.forms[0].APP_END_TIME_HOUR_MINUTE.value; //  íê°ìì ì¶ì¼ì (tohour)

		var BID_BEGIN_DATE          		= document.forms[0].BID_BEGIN_DATE.value; // ìì°°ìì ì¶ì¼ì (from)
		var BID_BEGIN_TIME_HOUR_MINUTE      = document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value; // ìì°°ìì ì¶ì¼ì (fromhour)
		var BID_END_DATE            		= document.forms[0].BID_END_DATE.value; // ìì°°ìì ì¶ì¼ì (to)
		var BID_END_TIME_HOUR_MINUTE        = document.forms[0].BID_END_TIME_HOUR_MINUTE.value; //  ìì°°ìì ì¶ì¼ì (tohour)

		var OPEN_DATE               		= document.forms[0].OPEN_DATE.value; // ê°ì°°ì¼ì (from)
		var OPEN_TIME_HOUR_MINUTE           = document.forms[0].OPEN_TIME_HOUR_MINUTE.value; // ê°ì°°ì¼ì (tohour)

		var ANNOUNCE_DATE					= document.forms[0].szdate.value; // ì¤ëªí ì¼ì

		if (eval(ANN_DATE) < eval(current_date)) {
			alert ("ê³µê³ ì¼ìë ì¤ëë³´ë¤ ì´í ë ì§ì´ì´ì¼ í©ëë¤.");
			document.forms[0].ANN_DATE.focus();
			return false;
		}

		// [ìµì ê°], [ì íì íê· ê°],[ì íì ìµì ê°] ìëê²½ì°...
		if(LRTrim(document.form1.CONT_TYPE2.value) != "LP" && LRTrim(document.form1.CONT_TYPE2.value) != "RA"  && LRTrim(document.form1.CONT_TYPE2.value) != "RL")
		{ 
			if(document.form1.APP_BEGIN_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.focus();
				alert("íê°ìì ì¶ì¼ìë¥¼ ìë ¥íì¸ì.");
				return false;
			}

			if(!TimeCheck(document.form1.APP_BEGIN_TIME_HOUR_MINUTE.value)){
				document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.focus();
				alert("íê°ìì ì¶ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}

			if(document.form1.APP_END_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
				alert("íê°ìì ì¶ì¼ìë¥¼ ìë ¥íì¸ì.");
				return false;
			}

			if(!TimeCheck(document.form1.APP_END_TIME_HOUR_MINUTE.value)){
				document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
				alert("íê°ìì ì¶ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}

			// íê°ìì ì¶ì¼ì
			if (eval(APP_BEGIN_DATE) < eval(current_date)) {
				alert ("íê°ìì ì¶ì¼ìì ììì¼ìë ì¤ëë³´ë¤ ì´í ë ì§ì´ì´ì¼ í©ëë¤.");
				document.forms[0].APP_BEGIN_DATE.focus();
				return false;
			} else if (eval(APP_BEGIN_DATE) == eval(current_date)) {
				if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) <   eval(cur_hh)) {
					alert ("íê°ìì ì¶ì¼ìì ìììê°ì íì¬ìê°ë³´ë¤ ì´íì¬ì¼   í©ëë¤.");
					document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(cur_hh)) {
					if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert ("íê°ìì ì¶ì¼ìì ìììê°   ì¤ì ì´ ìëª»ëììµëë¤.");
						document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			if (eval(APP_END_DATE) < eval(current_date)) {
				alert ("íê°ìì ì¶ì¼ìì ì¢ë£ì¼ìë ì¤ëë³´ë¤ ì´í   ë ì§ì´ì´ì¼ í©ëë¤.");
				document.forms[0].APP_END_DATE.focus();
				return false;
			} else if (eval(APP_END_DATE) == eval(current_date)) {
				if (eval(APP_END_TIME_HOUR_MINUTE.substring(0,2))   < eval(cur_hh)) {
					alert ("íê°ìì ì¶ì¼ìì ì¢ë£ìê°ì íì¬ìê°ë³´ë¤ ì´íì¬ì¼   í©ëë¤.");
					document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(APP_END_TIME_HOUR_MINUTE.substring(0,2)) == eval(cur_hh))   {
					if (eval(APP_END_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert (" íê°ìì ì¶ì¼ìì   ì¢ë£ìê° ì¤ì ì´ ìëª»ëììµëë¤.");
						document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			if (eval(APP_BEGIN_DATE) > eval(APP_END_DATE)) {
				alert ("íê°ìì ì¶ì¼ìì ì¢ë£ì¼ìë ììì¼ìë³´ë¤ ì»¤ì¼í©ëë¤.");
				document.forms[0].APP_BEGIN_DATE.focus();
				return false;
			} else if (eval(APP_BEGIN_DATE) == eval(APP_END_DATE)) {
				if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) >   eval(APP_END_TIME_HOUR_MINUTE.substring(0,2))) {
					alert ("íê°ìì ì¶ì¼ìì ì¢ë£ìê°ì ìììê°ë³´ë¤ ì»¤ì¼í©ëë¤.");
					document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(APP_END_TIME_HOUR_MINUTE.substring(0,2))) {
					if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) >= eval(APP_END_TIME_HOUR_MINUTE.substring(2,4))) {
						alert ("íê°ìì ì¶ì¼ìì ì¢ë£ìê°   ì¤ì ì´ ìëª»ëììµëë¤.");
						document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			// ê³µê³ ì¼ì
			if (eval(APP_BEGIN_DATE) < eval(ANN_DATE)) {
				alert ("íê°ìì ì¶ì¼ì ììì¼ìë ê³µê³ ì¼ìë³´ë¤ ì´í ë ì§ì´ì´ì¼ í©ëë¤.");
				document.forms[0].APP_BEGIN_DATE.focus();
				return false;
			}

			// ì¤ëªíì¼ì
			if (eval(APP_BEGIN_DATE) < eval(ANNOUNCE_DATE)) {
				alert ("ì¤ëªí ê°ìµì¼ì íê°ìì ì¶ì¼ë³´ë¤ ì´ì  ë ì§ì´ì´ì¼ í©ëë¤.");
				return false;
			}

			if(LRTrim(document.form1.CONT_TYPE2.value) == "NE") {
				if(document.form1.STANDARD_POINT.value == ""){
					document.forms[0].STANDARD_POINT.focus();
					alert ("ê¸°ì¤ì ìë¥¼ ìë ¥íì¸ì.");
					return false;
				}

				if(!IsNumber(document.form1.STANDARD_POINT.value)){
					alert("ê¸°ì¤ ì ìë ì«ìë§ ìë ¥ ê°ë¥í©ëë¤.");
					document.forms[0].STANDARD_POINT.focus();
					return;
				}

				if(!IsNumber(document.form1.AMT_DQ.value)||!IsNumber(document.form1.TECH_DQ.value)){
					alert("ì ìë¹ì¨ì ì«ìë§ ìë ¥ ê°ë¥í©ëë¤.");
					return;
				}

				if(LRTrim(document.form1.CONT_TYPE2.value) == "PQ" || LRTrim(document.form1.CONT_TYPE2.value) == "NE"){
					if(document.form1.AMT_DQ.value == "" || document.form1.TECH_DQ.value == ""){
						alert ("ì ìë¹ì¨ì ìë ¥íì¸ì.");
						return false;
					}
				}
			}

		}


		// [ìµì ê°], [ì íì íê· ê°],[ì íì ìµì ê°] ê²½ì°...
		if(LRTrim(document.form1.CONT_TYPE2.value) == "LP" || LRTrim(document.form1.CONT_TYPE2.value) == "RA" || LRTrim(document.form1.CONT_TYPE2.value) == "RL")
		{ 

			if(document.form1.BID_BEGIN_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
				alert("ìì°°ìì ì¶ì¼ìë¥¼ ìë ¥íì¸ì.");
				return false;
			}

			if(!TimeCheck(document.form1.BID_BEGIN_TIME_HOUR_MINUTE.value)){
				document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
				alert("ìì°°ìì ì¶ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}

			if(document.form1.BID_END_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
				alert("ìì°°ìì ì¶ì¼ìë¥¼ ìë ¥íì¸ì.");
				return false;
			}

			if(!TimeCheck(document.form1.BID_END_TIME_HOUR_MINUTE.value)){
				document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
				alert("ìì°°ìì ì¶ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}

			if(document.form1.OPEN_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
				alert("ê°ì°°ì¼ìë¥¼ ìë ¥íì¸ì.");
				return false;
			}

			if(!TimeCheck(document.form1.OPEN_TIME_HOUR_MINUTE.value)){
				document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
				alert("ê°ì°°ì¼ìë¥¼ íì¸íì¸ì.");
				return false;
			}


			// ìì°°ìì ì¶ì¼ì
			if (eval(BID_BEGIN_DATE) < eval(current_date)) {
				alert ("ìì°°ìì ì¶ì¼ìì ììì¼ìë ì¤ëë³´ë¤ ì´í ë ì§ì´ì´ì¼ í©ëë¤.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			} else if (eval(BID_BEGIN_DATE) == eval(current_date)) {
				if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) <   eval(cur_hh)) {
					alert ("ìì°°ìì ì¶ì¼ìì ìììê°ì íì¬ìê°ë³´ë¤ ì´íì¬ì¼ í©ëë¤.");
					document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(cur_hh)) {
					if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert ("ìì°°ìì ì¶ì¼ìì ìììê° ì¤ì ì´ ìëª»ëììµëë¤.");
						document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			if (eval(BID_END_DATE) < eval(current_date)) {
				alert ("ìì°°ìì ì¶ì¼ìì ì¢ë£ì¼ìë ì¤ëë³´ë¤ ì´í ë ì§ì´ì´ì¼ í©ëë¤.");
				document.forms[0].BID_END_DATE.focus();
				return false;
			} else if (eval(BID_END_DATE) == eval(current_date)) {
				if (eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))   < eval(cur_hh)) {
					alert ("ìì°°ìì ì¶ì¼ìì ì¢ë£ìê°ì íì¬ìê°ë³´ë¤ ì´íì¬ì¼ í©ëë¤.");
					document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(BID_END_TIME_HOUR_MINUTE.substring(0,2)) == eval(cur_hh))   {
					if (eval(BID_END_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert ("ìì°°ìì ì¶ì¼ìì ì¢ë£ ìê° ì¤ì ì´ ìëª»ëììµëë¤.");
						document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			if (eval(BID_BEGIN_DATE) > eval(BID_END_DATE)) {
				alert ("ìì°°ìì ì¶ì¼ìì ì¢ë£ì¼ìë ììì¼ìë³´ë¤ ì»¤ì¼í©ëë¤.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			} else if (eval(BID_BEGIN_DATE) == eval(BID_END_DATE)) {
				if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) >   eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))) {
					alert ("ìì°°ìì ì¶ì¼ìì ì¢ë£ìê°ì ìììê°ë³´ë¤ ì»¤ì¼í©ëë¤.");
					document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))) {
					if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) >= eval(BID_END_TIME_HOUR_MINUTE.substring(2,4))) {
						alert ("ìì°°ìì ì¶ì¼ìì ì¢ë£ìê° ì¤ì ì´ ìëª»ëììµëë¤.");
						document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			// ê°ì°°ì¼ì
			if (eval(OPEN_DATE) < eval(current_date)) {
				alert ("ê°ì°°ì¼ìì ììì¼ìë ì¤ëë³´ë¤ ì´í ë ì§ì´ì´ì¼ í©ëë¤.");
				document.forms[0].OPEN_DATE.focus();
				return false;
			} else if (eval(OPEN_DATE) == eval(current_date)) {
				if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2)) < eval(cur_hh)) {
					alert ("ê°ì°°ì¼ìì ìììê°ì íì¬ìê°ë³´ë¤ ì´íì¬ì¼ í©ëë¤.");
					document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2))   == eval(cur_hh)) {
					if (eval(OPEN_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert ("ê°ì°°ì¼ììê° ì¤ì ì´ ìëª»ëììµëë¤.");
						document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			// ê³µê³ ì¼ì ~ ìì°°ìì ì¶ì¼ì
			if (eval(ANN_DATE) > eval(BID_BEGIN_DATE)) {
				alert ("ìì°°ìì ì¶ì¼ì ììì¼ìë ê³µê³ ë±ë¡ì¼ìë³´ë¤  ì»¤ì¼í©ëë¤.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			}

			// ìì°°ìì ì¶ì¼ì ~ ê°ì°°ì¼ì
			if (eval(OPEN_DATE) < eval(BID_END_DATE)) {
				alert ("ê°ì°°ì¼ìë ìì°°ìì ì¶ì¼ì ì¢ë£ì¼ìë³´ë¤ ì»¤ì¼í©ëë¤.");
				document.forms[0].OPEN_DATE.focus();
				return false;
			} else if (eval(OPEN_DATE) == eval(BID_END_DATE)) {
				if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2)) < eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))) {
					alert ("ê°ì°°ì¼ìë ìì°°ìì ì¶ì¼ì ì¢ë£ìê°ë³´ë¤ ì´íì¬ì¼ í©ëë¤.");
					document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2))   == eval(BID_END_TIME_HOUR_MINUTE.substring(0,2)))   {
					if (eval(OPEN_TIME_HOUR_MINUTE.substring(2,4)) < eval(BID_END_TIME_HOUR_MINUTE.substring(2,4))) {
						alert ("ê°ì°°ì¼ìë ìì°°ìì ì¶ì¼ì ì¢ë£ìê°ë³´ë¤ ì´íì¬ì¼ í©ëë¤.");
						document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			// ì¤ëªíì¼ì
			if (eval(BID_BEGIN_DATE) < eval(ANNOUNCE_DATE)) {
				alert ("ì¤ëªí ê°ìµì¼ì ìì°°ìì ì¶ì¼ë³´ë¤ ì´ì  ë ì§ì´ì´ì¼ í©ëë¤.");
				return false;
			}
			
				
		
		}

		rowcount = document.WiseGrid.GetRowCount();

		checked_count = 0;
		var TOT_AMT = 0;

		for(row = rowcount - 1; row >= 0; row--) {
			if(GD_GetCellValueIndex(document.WiseGrid,row, INDEX_SELECTED) == "true") {

				var DESCRIPTION_LOC = GD_GetCellValueIndex(document.WiseGrid,row, INDEX_DESCRIPTION_LOC);
				var UNIT_MEASURE    = GD_GetCellValueIndex(document.WiseGrid,row, INDEX_UNIT_MEASURE);
				var QTY             = GD_GetCellValueIndex(document.WiseGrid,row, INDEX_QTY);
				var CUR             = GD_GetCellValueIndex(document.WiseGrid,row, INDEX_CUR);
				var UNIT_PRICE      = GD_GetCellValueIndex(document.WiseGrid,row, INDEX_UNIT_PRICE);
				var AMT             = GD_GetCellValueIndex(document.WiseGrid,row, INDEX_AMT);

				if (DESCRIPTION_LOC == "") {
					alert("ë¬¼íëªì¸ê° ìë ¥ëì§ ìììµëë¤.");
					return false;
				}

				if (UNIT_MEASURE == "") {
					alert("ë¨ìê° ìë ¥ëì§ ìììµëë¤.");
					return false;
				}

				if( "WON" != CUR) {
					alert("íµíë WONë§ ê°ë¥ í©ëë¤.");
					return false;
				}

				if (QTY == "" || QTY == "0") {
					alert("ìëì´ ìë ¥ëì§ ìììµëë¤.");
					return false;
				}

				if (UNIT_PRICE == "" || UNIT_PRICE == "0") {
					alert("ìì ë¨ê°ê° ìë ¥ëì§ ìììµëë¤.");
					return false;
				}

				TOT_AMT += parseFloat(AMT);

				checked_count++;
			}

		}


		if(checked_count == 0) {
			alert("ì íë ë¬¼íì´ ììµëë¤.");
			return false;
		}
		
		if(LRTrim(document.form1.ITEM_TYPE.value) == "0")  {
				alert("íëª©êµ¬ë¶ì ì ííì¸ì.");
				document.forms[0].ITEM_TYPE.focus();
				return false;
		}

		return true;
	}

	function Approval(pflag)
	{
		// ì ì¥ = 'T', ê²°ì¬ìì²­='P', íì = 'C',  D:ë°ë ¤
		
		var cert_result;
		var AUTH_USER_ID = "";	// ê²°ì¬ì(íì¥) íë²
		var REJECT_TXT   = "";	// ë°ë ¤ì ìê²¬
		
		<% if (BID_TYPE.equals("D")) {%>
			//ë©íìë£ì¼ì ìë ¥ ì íì ì¬ì©íì§ ìë ê²ì¼ë¡ ìì (R101402115253)
			//if(eval(document.forms[0].RD_DATE.value) < eval(document.forms[0].ANN_DATE.value))
			//{
			//	document.forms[0].RD_DATE.select();
			//	alert("ë©íìë£ì¼ìë ê³µê³ ì¼ìë³´ë¤ ì´íì¼ìì¬ì¼ í©ëë¤.");
			//	return;
			//}
			//else if(eval(document.forms[0].RD_DATE.value) < eval(document.forms[0].APP_END_DATE.value))
			//{
			//	document.forms[0].RD_DATE.select();
			//	alert("ë©íìë£ì¼ìë íê°ìì ì¶ì¼ìë³´ë¤ ì´í ì¼ìì¬ì¼ í©ëë¤.");
			//	return;
			//}
			//else if(eval(document.forms[0].RD_DATE.value) < eval(document.forms[0].OPEN_DATE.value))
			//{
			//	document.forms[0].RD_DATE.select();
			//	alert("ë©íìë£ì¼ìë ê°ì°°ì¼ìë³´ë¤ ì´íì¼ìì¬ì¼ í©ëë¤.");
			//	return;
			//}
			//else if(eval(document.forms[0].RD_DATE.value) < eval(document.forms[0].BID_END_DATE.value))
			//{
			//	document.forms[0].RD_DATE.select();
			//	alert("ë©íìë£ì¼ìë ìì°°ìì ì¶ì¼ìë³´ë¤ ì´íì¼ìì¬ì¼ í©ëë¤.");
			//	return;
			//}
		<% } %>
		//10000
		
		/*
		if ("<%=NEXT_AUTH_ID%>" != "<%=info.getSession("ID")%>" && "<%=NEXT_AUTH_ID%>" !="" )
		{
			alert("ì²ë¦¬í  ê¶íì´ ììµëë¤. ì²ë¦¬íì¤ ë¶ì [<%=NEXT_AUTH_NM%>]ë ìëë¤.");
			return;
		}
		*/

		G_FLAG = pflag;

		button_flag = true;

		if (checkData() == false)
		{
			button_flag = false;
			return;
		}

		var rowcount = document.WiseGrid.GetRowCount();

		var checked_count = 0;
		for(row = rowcount - 1; row >= 0; row--) {
			if(GD_GetCellValueIndex(document.WiseGrid,row, INDEX_SELECTED) == "true") {
				checked_count++;
			}
		}

		var rowcount = document.WiseGrid.GetRowCount();

		if(pflag == "T")
		{
			if(confirm(checked_count+"ê±´ì ë¬¼íì ì ííì¨ìµëë¤. \n ì ì¥ íìê² ìµëê¹?") != 1) {
				button_flag = false;
				return;
			}
		} else if(pflag == "P") {
			if(confirm(checked_count+"ê±´ì ë¬¼íì ì ííì¨ìµëë¤. \n ê²°ì¬ìì  íìê² ìµëê¹?") != 1) {
				button_flag = false;
				return;
			}
		} else if(pflag == "C" ) {
			if(confirm("íì (ê²°ì¬) íìê² ìµëê¹?") != 1) {
				button_flag = false;
				return;
			}
		} else if(pflag == "A"  ) {
			AUTH_USER_ID = document.forms[0].selAuth.value;
			if (AUTH_USER_ID == "")
			{
				alert("ê²°ì¬ìë¥¼ ì ííì¬ ì£¼ì­ìì¤.");
				return;
			}

			if(confirm("ê²°ì¬ ì¬ë¦¼ ì²ë¦¬ë¥¼ íìê² ìµëê¹?") != 1) {
				button_flag = false;
				return;
			}
		} else if(pflag == "D" ) {
			REJECT_TXT = document.forms[0].txtReject.value;
			if (REJECT_TXT == "")
			{
				alert("ë°ë ¤ìê²¬ì ìë ¥íì¬ ì£¼ìê¸° ë°ëëë¤.");
				button_flag = false;
				return;
			}

			if(confirm("ë°ë ¤ íìê² ìµëê¹?") != 1) {
				button_flag = false;
				return;
			}
		}

		var ApprovalUpYes = "";
		// ê²°ì¬
		if ( pflag == "A" )
		{
			mode = "setApprovalUP";		// ê²°ì¬ì¬ë¦¼
			mode = "setGonggoModify";	// ê²°ì¬ì¬ë¦¼
			ApprovalUpYes = "Y";
		}
		else if ( pflag == "D" )
		{
			mode = "setApprovalNo";	// ê²°ì¬ë°ë ¤
		}
		else
		{
			if("<%=SCR_FLAG%>" == "I")           // ìì±
				mode = "setGonggoCreate";
			if("<%=SCR_FLAG%>" == "U")           // ìì 
				mode = "setGonggoModify";
			if("<%=SCR_FLAG%>" == "C")           // íì (ê²°ì¬)
				mode = "setGonggoConfirm";
			if("<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "UR")          // ì ì ê³µê³  ìì±
				mode = "setUGonggoCreate";
		}

		servletUrl = "/servlets/dt.bidd.ebd_bd_ins1"; //p1009

		document.WiseGrid.SetParam("mode", mode);

		var ANN_NO                      = document.forms[0].ANN_NO.value;
		var ANN_DATE                    = document.forms[0].ANN_DATE.value;
		var ANN_ITEM                    = document.forms[0].ANN_ITEM.value;
		var CONT_TYPE1                  = document.forms[0].CONT_TYPE1.value;	// ìì°°ë°©ë²1
		var CONT_TYPE2                  = document.forms[0].CONT_TYPE2.value;	// ìì°°ë°©ë²2
		var vendor_values               = document.forms[0].vendor_values.value;
		var location_values             = document.forms[0].location_values.value;
		var attach_values               = document.forms[0].attach_values.value;

		var APP_BEGIN_DATE          	= document.forms[0].APP_BEGIN_DATE.value;
		var APP_BEGIN_TIME_HOUR_MINUTE  = document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.value;
		var APP_BEGIN_TIME          	= APP_BEGIN_TIME_HOUR_MINUTE +  "00";
		var APP_END_DATE            	= document.forms[0].APP_END_DATE.value;
		var APP_END_TIME_HOUR_MINUTE    = document.forms[0].APP_END_TIME_HOUR_MINUTE.value;
		var APP_END_TIME            	= APP_END_TIME_HOUR_MINUTE +    "00";

		var BID_BEGIN_DATE          	= document.forms[0].BID_BEGIN_DATE.value;
		var BID_BEGIN_TIME_HOUR_MINUTE  = document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value;
		var BID_BEGIN_TIME          	= BID_BEGIN_TIME_HOUR_MINUTE +  "00";

		var BID_END_DATE            	= document.forms[0].BID_END_DATE.value;
		var BID_END_TIME_HOUR_MINUTE    = document.forms[0].BID_END_TIME_HOUR_MINUTE.value;
		var BID_END_TIME            	= BID_END_TIME_HOUR_MINUTE +    "00";

		var OPEN_DATE               	= document.forms[0].OPEN_DATE.value;
		var OPEN_TIME_HOUR_MINUTE       = document.forms[0].OPEN_TIME_HOUR_MINUTE.value;
		var OPEN_TIME               	= OPEN_TIME_HOUR_MINUTE + "00";
		
		var X_DOC_SUBMIT_DATE             = document.forms[0].X_DOC_SUBMIT_DATE.value;
		var X_DOC_SUBMIT_TIME_HOUR_MINUTE = document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.value;
		var X_DOC_SUBMIT_TIME             = X_DOC_SUBMIT_TIME_HOUR_MINUTE + "00";

		
		
		var LIMIT_CRIT              = document.forms[0].LIMIT_CRIT.value    ;
		var PROM_CRIT               = "";
		var BID_ETC                 = document.forms[0].BID_ETC.value;
		var BID_NO                  = document.forms[0].bid_no.value        ;
		var BID_COUNT               = document.forms[0].bid_count.value     ;
		var SZDATE                  = document.forms[0].szdate.value        ;
		var START_TIME              = document.forms[0].start_time.value    ;
		var END_TIME                = document.forms[0].end_time.value      ;
		var AREA                    = document.forms[0].area.value          ;
		var PLACE                   = document.forms[0].place.value         ;
		var NOTIFIER                = document.forms[0].notifier.value      ;
		var ANNOUNCE_FLAG           = document.forms[0].ANNOUNCE_FLAG.value ;
		var ANNOUNCE_TEL            = document.forms[0].ANNOUNCE_TEL.value  ;
		var DOC_FRW_DATE            = document.forms[0].doc_frw_date.value  ;
		var RESP                    = document.forms[0].resp.value          ;
		var COMMENT                 = document.forms[0].comment.value       ;

		//var ESTM_KIND				= document.forms[0].ESTM_KIND.value       ;
		var ESTM_RATE               = document.forms[0].ESTM_RATE.value       ;
		var ESTM_MAX                = document.forms[0].ESTM_MAX.value        ;
		var ESTM_VOTE               = document.forms[0].ESTM_VOTE.value       ;
		var FROM_CONT               = document.forms[0].FROM_CONT.value       ;
		var FROM_LOWER_BND          = document.forms[0].FROM_LOWER_BND.value  ;
 		var CONT_TYPE_TEXT 			= ""       ;
		var CONT_PLACE              = document.forms[0].CONT_PLACE.value      ;
		var BID_PAY_TEXT            = ""       ;
		var BID_CANCEL_TEXT         = document.forms[0].BID_CANCEL_TEXT.value ;

		var BID_JOIN_TEXT         	= document.forms[0].BID_JOIN_TEXT.value   ;
		var REMARK              	= ""       ;
		var ESTM_MAX_VOTE           = ""       ;

		
		var X_RELATIVE_ADD          = document.forms[0].X_RELATIVE_ADD.value  ;		
		
		var ITEM_TYPE               = document.forms[0].ITEM_TYPE.value;	// íëª©êµ¬ë¶
		
		var OPEN_GB                 = document.forms[0].OPEN_GB.value;	// íëª©êµ¬ë¶
		
		
		<% if ( BID_TYPE.equals("D")) { %>
				var COST_SETTLE_TERMS       = document.forms[0].hidCOST_SETTLE_TERMS.value;	// ëê¸ê²°ì ì¡°ê±´		
				var X_BASIC_ADD     = document.forms[0].X_BASIC_ADD.value     ;
				var RD_DATE			= document.forms[0].RD_DATE.value;
				var DELY_PLACE      = document.forms[0].DELY_PLACE.value;
				var X_PURCHASE_QTY  = document.forms[0].X_PURCHASE_QTY.value;
				var X_MAKE_SPEC 	= document.forms[0].X_MAKE_SPEC.value;
		<% } else {%>
			    var COST_SETTLE_TERMS       = document.forms[0].COST_SETTLE_TERMS_C.value;	// ëê¸ê²°ì ì¡°ê±´		
				var X_BASIC_ADD     = ""     ;
				var X_PERSON_IN_CHARGE = document.forms[0].X_PERSON_IN_CHARGE.value;
				var X_QUALIFICATION = document.forms[0].X_QUALIFICATION.value;
		<% } %>
		if (document.forms[0].X_ESTM_CHECK.checked)
			var X_ESTM_CHECK = "Y";
		else 
			var X_ESTM_CHECK = "N";


		//LP	ìµì ê°
		//RA	ì íì íê· ê°
		//SC	2ë¨ê³ê²½ì
		//RL	ì íì ìµì ê°
		
		
		// [ìµì ê°], [ì íì íê· ê°],[ì íì ìµì ê°] ìëê²½ì°...'ìì°°ìì ì¶ì¼'ê³¼ 'ê°ì°°ì¼ì'ë¥¼ ìì±í  ììë¤.
		if(CONT_TYPE2 != "LP" && CONT_TYPE2 != "RA" && CONT_TYPE2 != "RL")
		{
			BID_BEGIN_DATE       = "";
			BID_BEGIN_TIME       = "";

			BID_END_DATE         = "";
			BID_END_TIME         = "";

			OPEN_DATE            = "";
			OPEN_TIME            = "";
		}

		var STANDARD_POINT       = document.forms[0].STANDARD_POINT.value       ;
		var TECH_DQ              = document.forms[0].TECH_DQ.value       ;
		var AMT_DQ           	 = document.forms[0].AMT_DQ.value       ;

		//NEì½ëë ìë¤.(comment by ihStone 20100211)
		if(CONT_TYPE2 != "NE")
		{
			// ê¸°ì¤ì ì, ì ìë¹ì¨ì ìì±í  ììë¤.
			STANDARD_POINT      = "";
			TECH_DQ       		= "";
			AMT_DQ         		= "";
		}

		//Header

		document.WiseGrid.SetParam("PR_NO"			, "<%=PR_NO%>");		//êµ¬ë§¤ ìêµ¬ë²í¸
		document.WiseGrid.SetParam("BID_TYPE"		, "<%=BID_TYPE%>"); 	//ë´ì¸ì êµ¬ë¶
		document.WiseGrid.SetParam("ANN_NO"			, ANN_NO          );
		document.WiseGrid.SetParam("ANN_DATE"		, ANN_DATE        );
		document.WiseGrid.SetParam("ANN_ITEM"		, ANN_ITEM        );
		document.WiseGrid.SetParam("CONT_TYPE1"		, CONT_TYPE1      );
		document.WiseGrid.SetParam("CONT_TYPE2"		, CONT_TYPE2      );
		document.WiseGrid.SetParam("vendor_values"	, vendor_values   );
		document.WiseGrid.SetParam("location_values", location_values );
		document.WiseGrid.SetParam("attach_values"	, attach_values   );
		document.WiseGrid.SetParam("AUTH_FLAG"		, "<%=AUTH_FLAG%>");
		document.WiseGrid.SetParam("AUTH_SEQ"		, "<%=AUTH_SEQ%>");
		document.WiseGrid.SetParam("REJECT_TXT"		, REJECT_TXT);
		document.WiseGrid.SetParam("APPV_UP"		, ApprovalUpYes);		// ê²°ì¬ì¬ë¦¼ì¼ë¡ ì ì¥ëëì§ ì¬ë¶



		if(CONT_TYPE2 == "LP" || CONT_TYPE2 == "RA" || CONT_TYPE2 == "RL")
		{
			//alert("APP_BEGIN_DATE:" + BID_BEGIN_DATE);
			//alert("APP_BEGIN_TIME:" + BID_BEGIN_TIME);
			//alert("APP_END_DATE:" + BID_END_DATE);
			//alert("APP_END_TIME:" + BID_END_TIME);
			document.WiseGrid.SetParam("APP_BEGIN_DATE",   BID_BEGIN_DATE          );
			document.WiseGrid.SetParam("APP_BEGIN_TIME",   BID_BEGIN_TIME          );
			document.WiseGrid.SetParam("APP_END_DATE",     BID_END_DATE            );
			document.WiseGrid.SetParam("APP_END_TIME",     BID_END_TIME            );
		}
		else
		{
			document.WiseGrid.SetParam("APP_BEGIN_DATE",   APP_BEGIN_DATE          );
			document.WiseGrid.SetParam("APP_BEGIN_TIME",   APP_BEGIN_TIME          );
			document.WiseGrid.SetParam("APP_END_DATE",     APP_END_DATE            );
			document.WiseGrid.SetParam("APP_END_TIME",     APP_END_TIME            );
		}
		document.WiseGrid.SetParam("BID_BEGIN_DATE",       BID_BEGIN_DATE          );
		document.WiseGrid.SetParam("BID_BEGIN_TIME",       BID_BEGIN_TIME          );
		document.WiseGrid.SetParam("BID_END_DATE",         BID_END_DATE            );
		document.WiseGrid.SetParam("BID_END_TIME",         BID_END_TIME            );
		document.WiseGrid.SetParam("OPEN_DATE",            OPEN_DATE               );
		document.WiseGrid.SetParam("OPEN_TIME",            OPEN_TIME               );		
		
		<% if ( BID_TYPE.equals("D")) { %>
				document.WiseGrid.SetParam("RD_DATE",      RD_DATE                 );
				document.WiseGrid.SetParam("DELY_PLACE",   DELY_PLACE              );
		<% } %>
		document.WiseGrid.SetParam("LIMIT_CRIT",           LIMIT_CRIT              );
		document.WiseGrid.SetParam("PROM_CRIT",            PROM_CRIT               );
		document.WiseGrid.SetParam("BID_ETC",              BID_ETC                 );
		document.WiseGrid.SetParam("BID_NO",               BID_NO                  );
		document.WiseGrid.SetParam("BID_COUNT",            BID_COUNT               );
		document.WiseGrid.SetParam("SZDATE",               SZDATE                  );
		document.WiseGrid.SetParam("START_TIME",           START_TIME              );
		document.WiseGrid.SetParam("END_TIME",             END_TIME                );
		document.WiseGrid.SetParam("AREA",                 AREA                    );
		document.WiseGrid.SetParam("PLACE",                PLACE                   );
		document.WiseGrid.SetParam("NOTIFIER",             NOTIFIER                );
		document.WiseGrid.SetParam("ANNOUNCE_FLAG",        ANNOUNCE_FLAG           );
		document.WiseGrid.SetParam("ANNOUNCE_TEL",         ANNOUNCE_TEL            );
		document.WiseGrid.SetParam("DOC_FRW_DATE",         DOC_FRW_DATE            );
		document.WiseGrid.SetParam("RESP",                 RESP                    );
		document.WiseGrid.SetParam("COMMENT",              COMMENT                 );
		document.WiseGrid.SetParam("FLAG",                 pflag                   ); // ì ì¥, ê²°ì¬ìì²­
		document.WiseGrid.SetParam("BID_STATUS",           "<%=BID_STATUS%>"       );
		document.WiseGrid.SetParam("CTRL_AMT",             "<%=CTRL_AMT%>"         );

		document.WiseGrid.SetParam("ESTM_KIND",         	ESTM_KIND            	);
		document.WiseGrid.SetParam("ESTM_RATE",         	ESTM_RATE            	);
		document.WiseGrid.SetParam("ESTM_MAX",         		ESTM_MAX            	);
		document.WiseGrid.SetParam("ESTM_VOTE",         	ESTM_VOTE            	);
		document.WiseGrid.SetParam("FROM_CONT",         	FROM_CONT            	);
		document.WiseGrid.SetParam("FROM_LOWER_BND",        FROM_LOWER_BND          );

		document.WiseGrid.SetParam("CONT_TYPE_TEXT",        CONT_TYPE_TEXT          );

		document.WiseGrid.SetParam("CONT_PLACE",         	CONT_PLACE            	);
		document.WiseGrid.SetParam("BID_PAY_TEXT",          BID_PAY_TEXT           	);
		document.WiseGrid.SetParam("BID_CANCEL_TEXT",       BID_CANCEL_TEXT        	);

		document.WiseGrid.SetParam("BID_JOIN_TEXT",         BID_JOIN_TEXT           );
		document.WiseGrid.SetParam("REMARK",         		REMARK            		);
		document.WiseGrid.SetParam("ESTM_MAX_VOTE",         ESTM_MAX_VOTE           );

		document.WiseGrid.SetParam("STANDARD_POINT",        STANDARD_POINT          );
		document.WiseGrid.SetParam("TECH_DQ",        		TECH_DQ                 );
		document.WiseGrid.SetParam("AMT_DQ",        		AMT_DQ                  );

		// ëê¸ê²°ì ì¡°ê±´ ì¶ê°
		document.WiseGrid.SetParam("COST_SETTLE_TERMS",     COST_SETTLE_TERMS       );
		// íì¼ í¼ ë²ì 
		document.WiseGrid.SetParam("CURR_VERSION",     		"<%=CURR_VERSION%>"     );
		// ê²°ì¬ì(íì¥) ì í
		document.WiseGrid.SetParam("AUTH_USER_ID",     		AUTH_USER_ID            );
		
		
		// ê³µì¬ìì°°
		<% if ( BID_TYPE.equals("D")) { %>
				document.WiseGrid.SetParam("X_PURCHASE_QTY"  	, X_PURCHASE_QTY);
				document.WiseGrid.SetParam("X_MAKE_SPEC" 		, X_MAKE_SPEC);
		<% } %>
		
		document.WiseGrid.SetParam("X_BASIC_ADD" 		, X_BASIC_ADD);
		document.WiseGrid.SetParam("X_RELATIVE_ADD" 	, X_RELATIVE_ADD);

		document.WiseGrid.SetParam("X_DOC_SUBMIT_DATE"  , X_DOC_SUBMIT_DATE);
		document.WiseGrid.SetParam("X_DOC_SUBMIT_TIME"  , X_DOC_SUBMIT_TIME);
		document.WiseGrid.SetParam("X_ESTM_CHECK"       , X_ESTM_CHECK);
		<% if ( BID_TYPE.equals("C")) { %>
				document.WiseGrid.SetParam("X_PERSON_IN_CHARGE"  , X_PERSON_IN_CHARGE);
				document.WiseGrid.SetParam("X_QUALIFICATION"  , X_QUALIFICATION);
		<% } %>

		document.WiseGrid.bSendDataFuncDefaultValidate=false;
		document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","1");
		
		//íëª©êµ¬ë¶
		document.WiseGrid.SetParam("ITEM_TYPE"  , ITEM_TYPE);
		
		//ê°ì°°êµ¬ë¶
		document.WiseGrid.SetParam("OPEN_GB"  , OPEN_GB);		
		
		
		if("<%=SCR_FLAG%>" == "C") 
		{          // íì 
				cert_data = "<%=BID_TYPE%>" + ANN_NO + ANN_DATE + ANN_ITEM + CONT_TYPE1 + CONT_TYPE2
	                      + APP_BEGIN_DATE + APP_BEGIN_TIME + APP_END_DATE + APP_END_TIME 
	                      + BID_BEGIN_DATE + BID_BEGIN_TIME + BID_END_DATE + BID_END_TIME + OPEN_DATE + OPEN_TIME
	                      + LIMIT_CRIT + BID_ETC + BID_NO + BID_COUNT + "<%=CTRL_AMT%>";
			
				Sign(cert_data);
					
		} 
		else 
		{
				document.WiseGrid.sendData(servletUrl, "ALL", "ALL");
		}


	}

	
	function valid_date(year,month,day,week)
	{
		if (date_flag == 1)
		{
			GD_SetCellValueIndex(document.WiseGrid,Current_Row, INDEX_VALID_FROM_DATE, year+month+day);
		} else {
			GD_SetCellValueIndex(document.WiseGrid,Current_Row, INDEX_VALID_TO_DATE, year+month+day);
		}
	}

	function ANN_DATE(year,month,day,week)
	{
		<%
		if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
			%>
			document.form1.ANN_DATE.value=year+month+day;
			<%
		}
		%>
	}

	function APP_BEGIN_DATE(year,month,day,week)
	{
		<%
		if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
			%>
			document.form1.APP_BEGIN_DATE.value=year+month+day;
			<%
		}
		%>
	}

	function APP_END_DATE(year,month,day,week)
	{
		<%
		if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
			%>
			document.form1.APP_END_DATE.value=year+month+day;
			<%
		}
		%>
	}

	function BID_BEGIN_DATE(year,month,day,week)
	{
		<%
		if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
			%>
			document.form1.BID_BEGIN_DATE.value=year+month+day;
			<%
		}
		%>
	}
	
	function X_DOC_SUBMIT_DATE(year,month,day,week)
	{
		<%
		if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
			%>
			document.form1.X_DOC_SUBMIT_DATE.value=year+month+day;
			<%
		}
		%>
	}

	function BID_END_DATE(year,month,day,week)
	{
		<%
		if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
			%>
			document.form1.BID_END_DATE.value=year+month+day;
			<%
		}
		%>
	}

	function OPEN_DATE(year,month,day,week)
	{
		<%
		if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
			%>
			document.form1.OPEN_DATE.value=year+month+day;
			<%
		}
		%>
	}

	function setVisibleVendor()
	{
		var CONT_TYPE1 = document.forms[0].CONT_TYPE1.value;

		if ( CONT_TYPE1 == "NC" ) {
			for(n=1;n<=4;n++) {
				document.all["h"+n].style.visibility = "visible";
			}

			for(m=1;m<=4;m++) {
				document.all["h1"+m].style.visibility = "hidden";
				
			}

			//document.forms[0].location_values.value = "";
			document.forms[0].location_count.value = "0";

		} else if ( CONT_TYPE1 == "LC" ) {
			for(m=1;m<=4;m++) {
				document.all["h1"+m].style.visibility = "visible";
			}

			for(n=1;n<=4;n++) {
				document.all["h"+n].style.visibility = "hidden";
			}	
				
			document.forms[0].vendor_values.value = "";
			document.forms[0].vendor_count.value = "0";
		}else {
			for(n=1;n<=4;n++) {
				document.all["h"+n].style.visibility = "hidden";
			}
			document.forms[0].vendor_values.value = "";
			document.forms[0].vendor_count.value = "0";

			for(m=1;m<=4;m++) {
				document.all["h1"+m].style.visibility = "hidden";
			}

			//document.forms[0].location_values.value = "";
			document.forms[0].location_count.value = "0";
		}
	}

	function setVisiblePeriod()
	{
		/* ìì°°ë°©ë² ì½ë ìë´:
			1. ìµì ê°: LP(Low Price)
			2. ì íì  íê· ê°: RA(Restrict Average)
			3. 2ë¨ê³ ê²½ì: TS(Two Step)
			4. ì íì  ìµì ê°: RL(Restrict Low)
		*/

		var CONT_TYPE2 = document.forms[0].CONT_TYPE2.value;

		if ( CONT_TYPE2 == "LP" ) {
			for(n=1;n<=22;n++) {
				//document.all["g"+n].style.display = "";
			}

			for(m=1;m<=13;m++) {
				document.all["i"+m].style.display = "none";
			}

			for(x=1;x<=12;x++) {
				document.all["q"+x].style.display = "none";
			}
			//document.getElementById("okVendor").value = "ë´ì ê° ì´í ìµì ê°ê²© ëì°°";
			document.form1.FROM_CONT_TEXT.value = "ë´ì ê° ì´í ìµì ê°ê²© ëì°°";
			document.form1.FROM_CONT.value = "LP";

		} else if ( CONT_TYPE2 == "RA" ) {
			for(n=1;n<=22;n++) {
				//document.all["g"+n].style.display = "";
			}

			for(m=1;m<=13;m++) {
				document.all["i"+m].style.display = "none";
			}

			for(x=1;x<=12;x++) {
				document.all["q"+x].style.display = "none";
			}
			//document.getElementById("okVendor").value = "ì íì  íê· ê° ëì°°";
			document.form1.FROM_CONT_TEXT.value = "ì íì  íê· ê° ëì°°";
			document.form1.FROM_CONT.value = "RA";
		} else if ( CONT_TYPE2 == "RL" ) {
			for(n=1;n<=22;n++) {
				//document.all["g"+n].style.display = "";
			}

			for(m=1;m<=13;m++) {
				document.all["i"+m].style.display = "none";
			}

			for(x=1;x<=12;x++) {
				document.all["q"+x].style.display = "none";
			}
			document.form1.FROM_CONT_TEXT.value = "ì íì  ìµì ê° ëì°°";
			document.form1.FROM_CONT.value = "RL";
		} else if ( CONT_TYPE2 == "TS" ) {
			for(n=1;n<=22;n++) {
				document.all["g"+n].style.display = "none";
			}

			for(m=1;m<=13;m++) {
				document.all["i"+m].style.display = "";
			}
			for(x=1;x<=6;x++) {
				document.all["q"+x].style.display = "";
			}
			//document.getElementById("okVendor").value = "2ë¨ê³ ê²½ì ëì°°";
			document.form1.FROM_CONT_TEXT.value = "2ë¨ê³ ê²½ì ëì°°";
			document.form1.FROM_CONT.value = "TS";
		}
	}


	function setVisibleESTM()
	{
		var ESTM_KIND = document.forms[0].ESTM_KIND.value;

		if ( ESTM_KIND  == "M"  ) {
			for(n=1;n<=5;n++) {
				document.all["e"+n].style.display = "";
			}


		//ìì±ì ëí´í¸ê° ì¸í
		<% if ( SCR_FLAG.equals("I")) { %>
			document.form1.ESTM_RATE.value = 2;
		<% } %>

		} else {
			for(n=1;n<=4;n++) {
				document.all["e"+n].style.display = "none";
			}
			document.forms[0].ESTM_VOTE.value = "";
			document.forms[0].ESTM_MAX.value = "";
			document.forms[0].ESTM_RATE.value = "";
		}
	}


	function doExplanation()
	{

		mode= "I";
		if("true" == explanation_modify_flag) mode= "IM";

		cnt = document.WiseGrid.GetRowCount();
		if(cnt == 0 ) {
			alert("ìì°°ê³µê³ ëìê±´ì´ ììµëë¤.");
			return;
		}

		if("I" == mode) {
			//alert(mode);
			if(cnt > 0) window.open('ebd_pp_ins1.jsp?mode=' + mode + '&SCR_FLAG=<%=SCR_FLAG%>&cnt=' + cnt ,"ebd_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=760,height=200,left=0,top=0");

		} else if("IM" == mode) {

			BID_NO = form1.bid_no.value;
			BID_COUNT = form1.bid_count.value;
			SZDATE = form1.szdate.value;
			START_TIME = form1.start_time.value;

			END_TIME = form1.end_time.value;
			PLACE = form1.place.value;
			ANNOUNCE_FLAG = form1.ANNOUNCE_FLAG.value;
			ANNOUNCE_TEL = form1.ANNOUNCE_TEL.value;

			resp = form1.resp.value;
			comment = form1.comment.value;
			//alert(mode);

			szurl = 'ebd_pp_ins1.jsp?mode=' + mode + '&BID_NO=' + BID_NO;
			szurl += '&BID_COUNT=' + BID_COUNT + '&SZDATE=' + SZDATE;
			szurl += '&START_TIME=' + START_TIME + '&END_TIME=' + END_TIME;
			szurl += '&PLACE=' + PLACE + '&ANNOUNCE_FLAG=' + ANNOUNCE_FLAG + '&ANNOUNCE_TEL=' + ANNOUNCE_TEL;
			szurl += '&resp=' + resp + '&SCR_FLAG=<%=SCR_FLAG%>&comment=' + comment;

			if(cnt > 0) window.open(szurl,"ebd_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=760,height=200,left=0,top=0");
		}
	}

	
	function setExplanation(szdate, start_time, end_time, place)
	{

		form1.szdate.value          = szdate;
		form1.start_time.value      = start_time;

		form1.end_time.value        = end_time;
		form1.place.value           = place;
		//form1.ANNOUNCE_FLAG.value           = ANNOUNCE_FLAG;
		//form1.ANNOUNCE_TEL.value            = ANNOUNCE_TEL;

		//form1.resp.value            = resp;
		//form1.comment.value         = comment;

		explanation_modify_flag = "true";
		//checkExplanation();
	}

	function  LineInsert()
	{

		document.WiseGrid.AddRow();
		;
		rownum = document.WiseGrid.GetRowCount();


		GD_SetCellValueIndex(document.WiseGrid,rownum - 1, INDEX_SELECTED, "true&", "&");

		var bCur = "<%=result%>".split("#");
		var sel_index = -1;
		for(var r=0; r < bCur.length - 1 ; r++)
		{
			var rCur = bCur[r].split("&");
			if(rCur[0] == "KRW")
			{
				sel_index = r;
				break;
			}
		}

		GD_SetCellValueIndex(document.WiseGrid,rownum - 1, INDEX_CUR, "<%= result %>", "&", "#", sel_index);

	}

	function  LineDelete()
	{
		rowcount = document.WiseGrid.GetRowCount();
		if(rowcount == 0) {
			alert("ì­ì í  ëìì´ ììµëë¤.");
			return;
		}
		if(rowcount > 0) {
			if(confirm("ì­ì  íìê² ìµëê¹?") == 1) {
				for(row=rowcount-1; row>=0; row--) {
					if( "true" == GD_GetCellValueIndex(document.WiseGrid,row, INDEX_SELECTED)) {
						document.WiseGrid.DeleteRow(row);
					}
				}
			}
		}
	}

	function check_ESTM_MAX()
	{

		var ESTM_MAX = parseInt(document.forms[0].ESTM_MAX.value);
		var ESTM_VOTE = parseInt(document.forms[0].ESTM_VOTE.value);
		if( ESTM_MAX != "" && (ESTM_MAX < 1 || ESTM_MAX > 15)){
			alert("ì¬ì©ìë¹ê°ê²©ìë 1 ~ 15 ìëë¤.");
			document.forms[0].ESTM_MAX.focus();
			return;
		}
		if( ESTM_VOTE > ESTM_MAX){
			alert("ì¶ì²¨ìê° ì¬ì©ìë¹ê°ê²©ìë³´ë¤ ë§ìµëë¤.");
			return;
		}
	}

	function check_ESTM_VOTE()
	{
		var ESTM_VOTE =parseInt( document.forms[0].ESTM_VOTE.value);
		var ESTM_MAX = parseInt(document.forms[0].ESTM_MAX.value);
		if( ESTM_VOTE != "" && (ESTM_VOTE < 1 || ESTM_VOTE > 4)){
			alert("ì¶ì²¨ìë 1 ~ 4 ìëë¤.");
			document.forms[0].ESTM_VOTE.focus();
			return;
		}
		if( ESTM_VOTE > ESTM_MAX){
			alert("ì¶ì²¨ìê° ì¬ì©ìë¹ê°ê²©ìë³´ë¤ ë§ìµëë¤.");
			return;
		}
	}

	function setFROM_CONT()
	{
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0230&function=D&values=<%=HOUSE_CODE%>&values=M958";
		Code_Search(url,'','','','','');
	}

	function SP0230_getCode(code, text2, text3)
	{
		<%
		if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
			%>
			document.forms[0].FROM_CONT.value = code;
			document.forms[0].FROM_CONT_TEXT.value = text2;
			document.forms[0].FROM_LOWER_BND.value = text3;
			<%
		}
		%>
	}

	function RD_DATE(year,month,day,week)
	{
		<%
		if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
			%>
			document.form1.RD_DATE.value=year+month+day;
			<%
		}
		%>
	}

	function TimeCheck(str)
	{
	
		var hh,mm;
		
		if(str.length == 0)
			return true;
		
		if(IsNumber1(str)==false || str.length !=4 )
			return false;
		
		hh=str.substring(0,2);
		mm=str.substring(2,4);
		
		if(parseInt(hh)<0 || parseInt(hh)>23)
			return false;
		
		if(parseInt(mm)<0 || parseInt(mm)>59)
			return false;
		
		return true;
	}

	function checkExplanation(){
		var Explanation_YN = "";
		
		if(document.form1.szdate.value==""){
			Explanation_YN = "N";
		}
		else
		{
			Explanation_YN = "Y";
		}
		
		document.form1.Explanation_YN.value = Explanation_YN
	}

	function ItemInsert()
	{

		window.open('ebd_pp_ins15.jsp?' ,"ebd_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=900,height=450,left=0,top=0");

	}


	function check_STANDARD_POINT(){
		if(!IsNumber(document.form1.STANDARD_POINT.value)){
			alert("ê¸°ì¤ ì ìë ì«ìë§ ìë ¥ ê°ë¥í©ëë¤.");
			document.forms[0].STANDARD_POINT.focus();
			return;
		}

		var check = parseFloat(document.form1.STANDARD_POINT.value);
		if(check > 100){
			alert("ê¸°ì¤ ì ìë 100ì ëìì ììµëë¤.");
			document.forms[0].STANDARD_POINT.focus();
			return;
		}
	}

	function check_AMT_DQ(){
		if(!IsNumber(document.form1.AMT_DQ.value)||!IsNumber(document.form1.TECH_DQ.value)){
			alert("ì ìë¹ì¨ì ì«ìë§ ìë ¥ ê°ë¥í©ëë¤.");
			//document.forms[0].STANDARD_POINT.focus();
			return;
		}

		var AMT_DQ = parseFloat(document.form1.AMT_DQ.value);
		var TECH_DQ = parseFloat(document.form1.TECH_DQ.value);
		if(TECH_DQ+AMT_DQ != 100 && document.form1.TECH_DQ.value != "" && document.form1.AMT_DQ.value != ""){
			alert("ì ìë¹ì¨ì 100% ìëë¤.");
			//document.forms[0].AMT_DQ.focus();
			return;
		}
	}

	function bin_end_time_event(){
	
		var bid_end_time = document.form1.BID_END_TIME_HOUR_MINUTE.value;
		var hh,modifyhh;
		
		
		if(!checkDateCommon(document.form1.BID_END_DATE.value)){
			document.form1.BID_END_DATE.focus();
			alert("ìì°°ì ì ì¶ì¼ë¥¼ íì¸íì¸ì.");
			return false;
		}
		
		if(!TimeCheck(bid_end_time)){
			document.form1.BID_END_TIME_HOUR_MINUTE.focus();
			alert("ìì°°ì ì ì¶ì¼ì íì¸íì¸ì.");
			return false;
		}
		
		hh = bid_end_time.substring(0,2);
		
		
		
		if((parseInt(hh) + 1) > 23) {
		
		}
		
		
		//modifyhh = (parseInt(hh) + 1);
		//alert(modifyhh);
		
		//document.form1.OPEN_DATE.value =  document.form1.BID_END_DATE.value;
		//document.form1.OPEN_TIME_HOUR_MINUTE.value = ;
	
	}


	function Sign(data)
	{
		var plainText, signMsg;
		var nRet, certdn, storage;
		
			
		var timestamp = current_date + current_time;
		var certv     = "111111111111111111111111111111111111111111";
		var sign_cert = "222222222222222222222222222222222222222222";
		var cryp_cert = "333333333333333333333333333333333333333333";
	        
		cert_data = timestamp + cert_data;
	 
		// ìëªí  ë¬¸ìì´ ë°ì´í ì¤ì .
		plainText = cert_data;

		// ëª¨ë  Condition ì¤ì .
		//	nRet = TSToolkit.SetConfig("test", CA_LDAP_INFO, CTL_INFO, POLICIES, 
		//							INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
		//							USING_CRL_CHECK, USING_ARL_CHECK);
		//	if (nRet > 0)
		//	{
		//		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		//		return false;
		//	}
			
			// ì¬ì©ìê° ìì ì ì¸ì¦ìë¥¼ ì í. 
		//	nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
		//	if (nRet > 0)
		//	{
		//		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		//		return false;
		//	}
		//
		//	nRet = TSToolkit.SignData(plainText); // ì±ê³µíë©´ 0ë°í
		//	
		//	if (nRet > 0)
		//	{
		//		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		//		return false;
		//	}
	
	
		//	sign_cert = TSToolkit.OutData;
		//	cryp_cert = TSToolkit.OutData;
		//	certv = TSToolkit.GetSignerCert(1);
		
		
		//sign_cert = sign_cert.substr(0,4000);
		//cryp_cert = cryp_cert.substr(0,4000);
		//
		//	alert(sign_cert)
		//	alert(cryp_cert)
		//	alert(certv)
	
	
		document.WiseGrid.SetParam("CERTV",                   certv);
		document.WiseGrid.SetParam("TIMESTAMP",               timestamp);
		document.WiseGrid.SetParam("SIGN_CERT",               sign_cert);
		document.WiseGrid.SetParam("CRYP_CERT",               cryp_cert);
		
		document.WiseGrid.sendData(servletUrl, "ALL", "ALL");
		
	}


	// ìëªê²ì¦.
	function Verify(form)
	{
		// ê²ì¦í  signedData ì¤ì .
		var signedData, dataMsg, signerDN;
		var nRet;
		
		signedData = form.data1.value;
		
		// ëª¨ë  Condition ì¤ì .
		nRet = TSToolkit.SetConfig("test", CA_LDAP_INFO, CTL_INFO, POLICIES, 
								INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
								USING_CRL_CHECK, USING_ARL_CHECK);
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
			return false;
		}
	
		nRet = TSToolkit.VerifySignedData(signedData, "");
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
			return false;
		}
	
		// ìëªë ë°ì´í êº¼ë´ê¸°.
		form.data2.value = TSToolkit.OutData;
		
		// ìëª ê°¯ì êº¼ë´ê¸°.
		var signerIndex;
		nRet = TSToolkit.GetSignerCount();
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
			return false;
		}
		signerIndex = TSToolkit.OutDataNum;
	
		for(i=1;i<=signerIndex;i++){
			// ìëªì ì¸ì¦ì DN êº¼ë´ê¸°.
			var signerDN;
			nRet = TSToolkit.GetSignerDN(i); // ì ìì´ë©´ 0
			
			if (nRet > 0)
			{
				alert(nRet + " : " + TSToolkit.GetErrorMessage());
				return false;
			}
			signerDN = TSToolkit.OutData;
			
			// ìëªì ì¸ì¦ì êº¼ë´ê¸°
			var signerCert;
			nRet = TSToolkit.GetSignerCert(i);
			if (nRet > 0)
			{
				alert(nRet + " : " + TSToolkit.GetErrorMessage());
				return false;
			}
			signerCert = TSToolkit.OutData;
			
			// ìëªìê° êº¼ë´ê¸°
			var signingTime;
			nRet = TSToolkit.GetSigningTime(i);
			if (nRet > 0)
			{
				alert(nRet + " : " + TSToolkit.GetErrorMessage());
				return false;
			}
			signingTime = TSToolkit.OutData;
			
			alert(i + " ë²ì§¸  : " + signerDN + "\r\nìëªìê° : " + signingTime);
			alert(signerCert);
			
			// ì¸ì¦ì ê²ì¦íê¸°
			nRet = TSToolkit.CertificateValidation(signerCert);
			if (nRet > 0)
			{
				alert(nRet + " : " + TSToolkit.GetErrorMessage());
				if (nRet == 141)
				{
					var revokedTime;
					revokedTime = TSToolkit.OutData;
					alert("íì§ ëë í¨ë ¥ì ì§ ìê° : " + revokedTime);
				}
			}
		}
	
		// ë©ëª¨ë¦¬ ì ë¦¬íê¸°.
		nRet = TSToolkit.ClearMemory();
		if (nRet > 0)
		{
			alert(nRet + " : " + TSToolkit.GetErrorMessage());
			return false;
		}
	
		alert("Sucess!!!");
		return true;
	}

	// ëê¸ê²°ì ì¡°ê±´ì ì ííìë..
	function fnCostSettleTerms(strFlag)
	{
		var strVal;
		if (strFlag == "0")
		{
			strVal = "<%=aRadioValues[0]%>";
		}
		else if (strFlag =="1")
		{
			strVal = "<%=aRadioValues[1]%>";
		}
		else if (strFlag = "2")
		{
			strVal = "<%=aRadioValues[2]%>";
		}
		document.form1.hidCOST_SETTLE_TERMS.value = strVal;
		//alert(document.form1.hidCOST_SETTLE_TERMS.value);
	}


	function setCopy()  //2010.10.27 ê³µê³ ë¬¸ ë²ì ê´ë¦¬ë¥¼  ìí´ copyê¸°ë¥ ì¶ê°
	{ 

		servletUrl = "/servlets/dt.bidd.ebd_bd_ins1"; //p1009

		document.WiseGrid.SetParam("mode", "setCopy");
		document.WiseGrid.SetParam("BID_TYPE", "<%=BID_TYPE%>");
		document.WiseGrid.SetParam("M_TYPE", "<%=M_TYPE%>");
		document.WiseGrid.SetParam("CURR_VERSION", "<%=CURR_VERSION%>");
  
		document.WiseGrid.bSendDataFuncDefaultValidate=false;
		document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","1"); 
		document.WiseGrid.sendData(servletUrl, "ALL", "ALL"); 


	}

</Script>
</head>

<body bgcolor="#FFFFFF" text="#000000" onload="">
<jsp:include page="/include/us_template_start.jsp" flush="true" />

<form name="form1" >

	<input type="hidden" name="attach_values"   value="<%=ATTACH_NO%>">
	<input type="hidden" name="vendor_values"   value="<%=VENDOR_VALUES%>">
	<input type="hidden" name="location_values" value="<%=LOCATION_VALUES%>">


	<!-- hidden(ì¬ìì¤ëªí) //-->
	<input type="hidden" name="bid_no"     value="<%=BID_NO%>">
	<input type="hidden" name="bid_count"  value="<%=BID_COUNT%>">
	<input type="hidden" name="start_time" value="<%=ANNOUNCE_TIME_FROM%>">

	<input type="hidden" name="end_time"      value="<%=ANNOUNCE_TIME_TO%>">
	<input type="hidden" name="ANNOUNCE_FLAG" value="<%=ANNOUNCE_FLAG%>">
	<input type="hidden" name="ANNOUNCE_TEL"  value="<%=ANNOUNCE_TEL%>">
	<input type="hidden" name="area"          value="<%=ANNOUNCE_AREA%>">
	<input type="hidden" name="place"         value="<%=ANNOUNCE_PLACE%>">
	<input type="hidden" name="notifier"      value="<%=ANNOUNCE_NOTIFIER%>">

	<input type="hidden" name="doc_frw_date"  value="<%=DOC_FRW_DATE%>">
	<input type="hidden" name="resp"          value="<%=ANNOUNCE_RESP%>">
	<input type="hidden" name="comment"       value="<%=ANNOUNCE_COMMENT%>">

	<input type="hidden" name="data1"                value="">
	<input type="hidden" name="ESTM_KIND"            value="U">
	<input type="hidden" name="FROM_LOWER_BND" size="3" maxlength="2" value="<%=FROM_LOWER_BND%>" <%=script%> >	
	<input type="hidden" name="hidCOST_SETTLE_TERMS" value="">

	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="title_table_top">
		<tr >
			<td class="title_table_top" >
				<%@ include file="/include/wisehub_milestone.jsp" %>
			</td>
		</tr>
	</table>

	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<% if ( BID_TYPE.equals("D")) { %>êµ¬ë§¤ìì°°ê³µê³  íì¤(ì) <% } else { %>ê³µì¬ìì°°ê³µê³  íì¤(ì) <%}%>
			</td>
		</tr>
	</table>

	<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		<tr>
			<td width="20%" class="cell_title_wrb" height="15px">1. ê³µê³ ì¼ì ë° ë²í¸</td>
			<td width="80%">
				<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
					<tr>
						<td  width="20%" height="15px">
							<span class="cell_data_middle">ê°. ê³µê³ ì¼ì</span>
						</td>
						<td width="80%">
							<input type="text" name="ANN_DATE" value="<%=ANN_DATE%>" size="8"  maxlength="8"  class="input_re_2" value=""  <%=script%>>
							<a href="javascript:Calendar_Open('ANN_DATE');">
								<span class=".image_padding_left">
<!-- 								<img src="../../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0"> -->
								<span>
							</a>
						</td>
					</tr>
					<tr>
						<td  width="20%" height="15px">
							<span class="cell_data_middle">ë. ê³µê³ ë²í¸</span>
						</td>
						<td width="80%">
							<input type="text" name="ANN_NO" value="<%=ANN_NO%>" class="input_re_2" readonly style="background-color:white">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<% if(BID_TYPE.equals("D")) { %>
			<table  width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
				<tr>
					<td  width="20%" class="cell_title_wrb">2. ìì°°ì ë¶ì¹ë ì¬í­</td>
					<td  width="80%">
						<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
							<tr>
								<td  width="20%">
									<span class="cell_data_middle">ê°. ìì°°ê±´ëª</span>
								</td>
								<td width="80%">
									<input type="text" name="ANN_ITEM" size="70" value="<%=ANN_ITEM.replaceAll("\"", "&quot;")%>" class="input_re_2" <%=script%> style="ime-mode:active">
								</td>
							</tr>
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ë. ìì ê°ê²©</span>
								</td>
								<td width="80%">
									<SPAN CLASS=".general_padding_left">ê³µê°ì¬ë¶</SPAN> <input type="checkbox" name="X_ESTM_CHECK" <% if (X_ESTM_CHECK.equals("Y")) {%>checked<%}%><%=script%>>
								</td>
							</tr>
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ë¤. êµ¬ë§¤ìë</span>
								</td>
								<td width="80%">
									<input type="text" name="X_PURCHASE_QTY" size="70" value="<%=X_PURCHASE_QTY%>" class="input_re_2" <%=script%>>
								</td>
							</tr>
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ë¼. ì ì¡°ì¬ì</span>
								</td>
								<td width="80%">
									<input type="text" name="X_MAKE_SPEC" size="70" value="<%=X_MAKE_SPEC%>" class="input_re_2" <%=script%>>
								</td>
							</tr>
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ë§. ì ìì¬í­</span>
								</td>
								<td width="80%">
									<textarea name="X_BASIC_ADD" cols="70" rows="3" maxlength="500" class="input_re_2" <%=script%> style="ime-mode:active"><%=X_BASIC_ADD%></textarea>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>

	<% } else {%>

			<table  width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
				<tr>
					<td  width="20%" class="cell_title_wrb">2. ìì°°ì ë¶ì¹ë ì¬í­</td>
					<td  width="80%">
						<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
							<tr>
								<td  width="20%">
									<span class="cell_data_middle">ê°. ìì°°ê±´ëª</span>
								</td>
								<td width="80%">
									<input type="text" name="ANN_ITEM" size="70" value="<%=ANN_ITEM.replaceAll("\"", "&quot;")%>" class="input_re_2" <%=script%> style="ime-mode:active">
								</td>
							</tr>
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ë. ìì ê°ê²©</span>
								</td>
								<td width="80%">
									<SPAN CLASS=".general_padding_left">ê³µê°ì¬ë¶</SPAN> <input type="checkbox" name="X_ESTM_CHECK" <% if (X_ESTM_CHECK.equals("Y")) {%>checked<%}%><%=script%>>
								</td>
							</tr>
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ë¤. ë´ë¹ê¸°ì ì­</span>
								</td>
								<td width="80%">
									<input type="text"  name="X_PERSON_IN_CHARGE" value="<%=X_PERSON_IN_CHARGE%>" size="70" class="input_re_2" <%=script%>>
								</td>
							</tr>							
						</table>
					</td>
				</tr>
			</table>
	<%}%>



	<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		<tr>
			<td  width="20%" class="cell_title_wrb">3. ìì°°ì°¸ê°ìê²©</td>
			<td width="80%">
				<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
					<tr>
						<%
						if(BID_TYPE.equals("D")) {
							//êµ¬ë§¤ìì°°
							%>
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ì°¸ê°ìê²©</span>
								</td>
								<td width="80%">
									<textarea name="LIMIT_CRIT" cols="70" rows="3" maxlength="500" class="input_re_2" <%=script%>><%=LIMIT_CRIT%></textarea>
								</td>
							</tr>
							<%
						} else {
							%>
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ê°. ì°¸ê°ìê²©</span>
								</td>
								<td width="80%">
									<select name="LIMIT_CRIT" class="input_re_2" <%=script%>>
										<%
										String com1 = ListBox(request, "SL0018", "100" + "#" +"M948", LIMIT_CRIT_CD);
										out.println(com1);
										%>
									</select>
								</td>
							</tr>
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ë. ê¸°í</span>
								</td>
								<td width="80%">
									<textarea name="X_QUALIFICATION" cols="70" rows="3" maxlength="500" class="input_re_2" <%=script%>><%=X_QUALIFICATION%></textarea>
								</td>
							</tr>									
							<%
						}
						%>
				</table>
			</td>
		</tr>
	</table>

	<table  width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		<tr>
		  <td  width="20%" class="cell_title_wrb">4. ì ì¶ìë¥ ëª©ë¡ ë°<br> ì ì¶ê¸°ì¼</td>
		  <td  width="80%">
		  		<table  width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  			<tr>
		  				<td width="20%">
		  					<span class="cell_data_middle">ê°. ì ì¶ê¸°í</span>
		  				</td>
		  				<td width="80%">
							<input type="text" name="X_DOC_SUBMIT_DATE" size="10"  maxlength="8"  class="input_re_2" value="<%=X_DOC_SUBMIT_DATE%>" <%=script%>>
<!-- 							<a href="javascript:Calendar_Open('X_DOC_SUBMIT_DATE');"><span  class="image_padding_left" ><img src="../../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0"></span></a> ì¼ -->
							<input type="text" name="X_DOC_SUBMIT_TIME_HOUR_MINUTE"  value="<%=X_DOC_SUBMIT_TIME_HOUR_MINUTE%>" size="4"    maxlength="4"  class="input_re_2" <%=script%>> ê¹ì§
						  </span>
						</td>
					</tr>
					<tr>
		  				<td  width="20%">
		  					<span class="cell_data_middle">ë. ì ì¶ë°©ë²</span>
		  				</td>
		  				<td width="80%">
							<input type="text" name="CONT_PLACE" size="70" class="input_re_2" value="<%=CONT_PLACE%>" <%=script%>>
						</td>
					</tr>
					<tr>
		  				<td  width="20%">
		  					<span class="cell_data_middle">ë¤. ì ì¶ìë¥</span>
		  				</td>
		  				<td width="80%">
							<textarea name="BID_JOIN_TEXT" cols="70" rows="7" maxlength="500" class="input_re_2" <%=script%>><%=BID_JOIN_TEXT%></textarea>
						</td>
					</tr>
					<tr>
		  				<td  width="20%">
		  					<span class="cell_data_middle">ë¼. ì ìì¬í­</span>
		  				</td>
		  				<td width="80%">
							<textarea name="BID_CANCEL_TEXT" cols="70" rows="3" maxlength="500" class="input_re_2" <%=script%>><%=BID_CANCEL_TEXT%></textarea>
						</td>
					</tr>
				</table>
		  </td>
		</tr>
	</table>

	<table  width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		<tr>
		  <td  width="20%" class="cell_title_wrb"></td>
		  <td  width="80%">
		  		<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  			<tr>
		  				<td width="20%">
		  					<span class="cell_data_middle">ê°. ìì°°ë°©ë²</span>
		  				</td>
		  				<td width="40%">
							  <b><span class="general_padding_left">
								<select name="CONT_TYPE1" class="inputsubmit"onChange="setVisibleVendor()" <%=abled%>>
									<%
										String com1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M994", CONT_TYPE1);
										out.println(com1);
									%>
								</select>&nbsp;
								<select name="CONT_TYPE2" class="inputsubmit" onChange="setVisiblePeriod()" <%=abled%>>
									<%
										String com2 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M993", CONT_TYPE2);
										out.println(com2);
									%>
								</select></span>
							  </b>
						 </td>
						 <td  width="40%"><span class="general_padding_left" id="h1">ìì²´ì§ì 
							<a href="javascript:getVendor()" id=h2><img src="../../images/button/butt_query.gif" align="absmiddle" border="0"   id=h3 ></a>
							<input type="text" name="vendor_count" size="3" value="<%=VENDOR_CNT%>" style='border-style: none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly  id=h4>
							<span id="h11">ì§ì­ì§ì  
							<a href="javascript:getLocation()" id=h12><img src="../../images/button/butt_query.gif" align="absmiddle"   border="0" id=h13 ></a>
							<input type="text" name="location_count" size="3" value="<%=LOCATION_CNT%>" style='border-style:  none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly  id=h14>
							</span>
						  </td>
					</tr>
					<tr>
		  				<td width="20%">
		  					<span class="cell_data_middle">ë. ìì°°ì¼ì</span>
		  				</td>
		  				<td width="80%" colspan="2">
		  				<span id="g5">
						<input type="text" name="BID_BEGIN_DATE" size="10"  maxlength="8"  class="input_re_2"  value="<%=BID_BEGIN_DATE%>"  id=g6  <%=script%>>
<!-- 						<a href="javascript:Calendar_Open('BID_BEGIN_DATE');" id=g7><span  class="image_padding_left" ><img src="../../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" id=g8></span></a>ì¼ -->
						<input type="text" name="BID_BEGIN_TIME_HOUR_MINUTE"  value="<%=BID_BEGIN_TIME_HOUR_MINUTE%>" size="4"   maxlength="4"  class="input_re" <%=script%> id=g9>
						&nbsp;&nbsp;~&nbsp;&nbsp;
						<input type="text" name="BID_END_DATE" size="10"  maxlength="8"  class="input_re_2"  value="<%=BID_END_DATE%>"  id=g10     <%=script%>>
<!-- 						<a href="javascript:Calendar_Open('BID_END_DATE');" id=g11><span  class="image_padding_left" ><img src="../../images/button/butt_calender.gif" width="19" height="19" align="absmiddle"    border="0" id=g12</span></a>ì¼ -->
						<input type="text" name="BID_END_TIME_HOUR_MINUTE"  value="<%=BID_END_TIME_HOUR_MINUTE%>" size="4" maxlength="4"  class="input_re" <%=script%>  id=g13 onBlur="bin_end_time_event()">
						</span>
		  				</td>
					</tr>
					<tr>
		  				<td width="20%">
		  					<span class="cell_data_middle">ë¤. ê°ì°°ì¼ì</span>
		  				</td>
		  				<td width="80%" colspan="2">
		  				<span id="g18">
							<input type="text" name="OPEN_DATE" size="10"  maxlength="8"  class="input_re_2" value="<%=OPEN_DATE%>"  id=g19  <%=script%>>
<!-- 							<a href="javascript:Calendar_Open('OPEN_DATE');" id=g20><span  class="image_padding_left" ><img src="../../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" id=g21></span></a>ì¼ -->
							<input type="text" name="OPEN_TIME_HOUR_MINUTE"  value="<%=OPEN_TIME_HOUR_MINUTE%>" size="4"    maxlength="4"  class="input_re" <%=script%>  id=g22>ì´í
						</span>
		  				</td>
					</tr>
					<tr>
		  				<td width="20%">
		  					<span class="cell_data_middle">ë¼. ëì°°ë°©ë²</span>
		  				</td>
		  				<td width="80%" colspan="2">						
							<div>
							<!--[R200711270859]ì ììì°°ìì¤í íë©´ ìì  ìì²­-->
							<!--ì ì°¨ ë¥¼ ì ì°°ë¡ ë³ê²½ -->
							(1) ìì°°ê¸ì¡ì´ ì°ë¦¬ìí ë´ì ê°ê²© ì´ê³¼ì ì ì°°ë¡ ê°ì£¼íê³  ì¬ìì°°ì ì¤ìí  ì ìì<br>
						    (2) ëì°°ì´ ë  ì ìë ëì¼ê°ê²©ì¼ë¡ ìì°°í ìê° 2ì¸ ì´ìì¼ ëìë ì¦ì ì¶ì²¨ì ìíì¬ ëì°°ìë¥¼ ê²°ì í¨<br>
							<b><font color="red">â» ë¨, ì ììì°°ì¸ ê²½ì° ì ì°ìì¤íì ìí´ ìë(ë¨ë¤)ì¼ë¡ ëì°°ì ê²°ì </font></b>
							</div>
						</td>
					</tr>
					<tr>
		  				<td width="20%">
		  					<span class="cell_data_middle">ë§. ì ìì¬í­</span>
		  				</td>
		  				<td width="80%" colspan="2">						
							<textarea name="X_RELATIVE_ADD" cols="70" rows="3" maxlength="500" class="input_re_2" <%=script%>><%=X_RELATIVE_ADD.replaceAll("\"", "&quot;")%></textarea>
						</td>
					</tr>
				</table>
		  </td>
		</tr>
	</table>
	<%
	String pre01 = "";
	pre01 =   "<pre>\n"
			+ "(1) ìì°°ê¸ì¡ì 100ë¶ì 5ì´ì ê¸ì¡ì íê¸(ì²´ì ê´ì ëë ìíë²ì ì ì©ì ë°ë \n"
			+ "    ê¸ìµê¸°ê´ì´ ë°íí ìê¸°ììíë¥¼ í¬í¨) \n"
			+ "    ëë ë¤ì ê° í¸ì ë³´ì¦ì ë±ì¼ë¡ ì°ë¦¬ìíì ë©ë¶íì¬ì¼ í¨\n"
			+ "    (ê°) ê¸ìµê¸°ê´ì´ ë°íí ì§ê¸ë³´ì¦ì\n"
			+ "    (ë) ì¦ê¶ìë²ìíë ¹ ì  84ì¡°ì 16í¸ì ê·ì ë ì ê°ì¦ê¶\n"
			+ "    (ë¤) ë³´íìë²ì ìí ë³´íì¬ììê° ë°íí ë³´ì¦ë³´íì¦ê¶\n"
			+ "    (ë¼) ê¸ìµê¸°ê´ ë° ì¸êµ­ê¸ìµê¸°ê´ê³¼ ì²´ì ê´ìê° ë°íí ì ê¸°ìê¸ì¦ì\n"
			+ "    (ë§) ê±´ì¤ê³µì ì¡°í©ë²ì ìí ê±´ì¤ê³µì ì¡°í©, ì ë¬¸ê±´ì¤ê³µì ì¡°í©ë²ì ìí\n"
			+ "         ì ë¬¸ê±´ì¤ê³µì ì¡°í©Â·ìì¢ë³ê³µì ì¡°í©, ì ì©ë³´ì¦ê¸°ê¸ë²ì ìí ì ì©ë³´ì¦\n"
			+ "         ê¸°ê¸, ì ê¸°ì ì¬ìê¸ìµì§ììê´í ë²ë¥ ì ìí ê¸°ì ì ì©ë³´ì¦ê¸°ê¸,\n"
			+ "         ì ê¸°íµì ê³µì¬ìì ìí ì ê¸°íµì ê³µì ì¡°í©, ìì§ëì´ë§ê¸°ì ì§í¥ë²ì\n"
			+ "         ìí ìì§ëì´ë§ê³µì ì¡°í© ëë ê³µìë°ì ë²ì ìí ê³µì ì¬ìë¨ì²´,\n"
			+ "         ìíí¸ì¨ì´ê°ë°ì´ì§ë²ì ìíì¬ ì ë³´íµì ë¶ì¥ê´ì´ ê³µê³ í ê³µì ì¬ì\n"
			+ "         ê¸°ê´, ì ë ¥ê¸°ì ê´ë¦¬ë²ì ìí íêµ­ì ë ¥ê¸°ì ì¸íí ëë íê²½ì¹íì \n"
			+ "         ì°ìêµ¬ì¡°ë¡ì ì íì´ì§ì ê´íë²ë¥ ì ìíì¬ íê²½ì¤ë¹ì ëíì¬\n"
			+ "         íêµ­ê¸°ê³ê³µìì§í¥íê° ë°íí ì±ë¬´ì¡ ë±ì ì§ê¸ì ë³´ì¦íë ë³´ì¦ì\n"
			+ "(2) ìì°°ë±ë¡ë§ê°ìíê¹ì§ ìì°°ë³´ì¦ê¸ì ë©ë¶í ìì²´ë§ ë³¸ ìì°°ì ì°¸ì¬ ê°ë¥í¨.\n"
			+ "(3) ìì°°ì´íë³´ì¦ì ë³´ì¦ê¸°ê°ì ìì°°ì¼ ì´ì ë¶í° ìì°°ì¼ 30ì¼ ì´íì¼ ê².\n"
			+ "(4) ë³´ì¦ë´ì©\n"
			+ "    (ê°) í¼ë³´íì: (ì£¼)ì°ë¦¬ìí\n"
			+ "    (ë) ìì°°ì¼ì: ìëì¸í\n"
			+ "    (ë¤) ìì°°ê±´ëª: ìëì¸í<br>\n"
			+ "(5) ìì°°ë³´ì¦ê¸ ê·ì: ëì°°ìê° ìì ê¸°ì¼ ë´ì ê³ì½ì ì²´ê²°íì§ ìëí  ê²½ì°\n"
			+ "    ìì°°ë³´ì¦ê¸ì ë¹íì ê·ì ë¨\n"
			+ "</pre>\n";
	%>

	<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		<tr>
			  <td  width="20%" class="cell_title_wrb">6. ìì°°ì´íë³´ì¦ê¸(ì)</td>
			  	<td width="80%">
		  			<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  				<tr>
		  				<td width="20%">
		  					<span class="cell_data_middle"> ë´ì©</span>
		  				</td>
		  				<td width="80%">
		  					<%=pre01%>
			  			</td>
					</tr>
				</table>
		  </td>
		</tr>
	</table>
	<%
	String pre02 = "";
	pre02 =   "<pre>\n"
			+ "ëì°°ìë ë¤ì ê°í¸ì ê²½ì°ì í´ë¹íë ê²½ì° íê¸ ëë ë³´ì¦ì ë±ì¼ë¡ ì°¨ì¡ë³´ì¦ê¸ì \n"
			+ "ë©ë¶íì¬ì¼ í¨\n"
			+ "(1) ìì°°ê²°ê³¼ ë¹í ë´ì ê°ê²©ì 100ë¶ì 85ë¯¸ë§ì¼ë¡ ëì°°ë ê²½ì°\n"
			+ "    (ê°) íê¸ì¼ë¡ ë©ë¶íê³ ì íë ê²½ì°ìë ë´ì ê°ê²©ê³¼ ëì°°ê¸ì¡ì ì°¨ì¡\n"
			+ "    (ë) ë³´ì¦ì ë±ì¼ë¡ ë©ë¶íê³ ì íë ê²½ì°ìë ë´ì ê°ê²©ê³¼ ëì°°ê¸ì¡ì\n"
			+ "      ì°¨ì¡ì ìë¹íë ê¸ì¡<br>\n"
			+ "(2) ìì°°ê²°ê³¼ ë¹í ë´ì ê°ê²©ì 100ë¶ì 70ë¯¸ë§ì¼ë¡ ëì°°ë ê²½ì°\n"
			+ "    - ë´ì ê°ê²©ê³¼ ëì°°ê¸ì¡ì ì°¨ì¡ì íê¸ ëë ì°¨ì¡ì 2ë°°ì í´ë¹íë \n"
			+ "      ë³´ì¦ì ë±ì¼ë¡ ë©ë¶íì¬ì¼ í¨\n"
			+ "</pre>\n";
	%>

	<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		<tr>
			  <td  width="20%" class="cell_title_wrb">7. ì°¨ì¡ë³´ì¦ê¸</td>
			  	<td width="80%">
		  			<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  				<tr>
		  				<td width="20%">
		  					<span class="cell_data_middle"> ë´ì©</span>
		  				</td>
		  				<td width="80%">
		  					<%=pre02%>
			  			</td>
					</tr>
				</table>
		  </td>
		</tr>
	</table>

	<%
	String pre03 = "";
	pre03 =   "<pre>\n"
			+ " (1) ìì°°ê²°ê³¼ ëì°°ìë ê³ì½ì²´ê²°ì ê³ì½ê¸ì¡ì 100 ë¶ì 10 ì´ì ê¸ì¡ì\n"
			+ "     íê¸ (ì²´ì ê´ì ëë ìíë²ì ì ì©ì ë°ë ê¸ìµê¸°ê´ì´ ë°ííë ìê¸°ì\n"
			+ "     ìíë¥¼ í¬í¨) ëë ë¤ì ê°í¸ì ë³´ì¦ìë±ì¼ë¡ ì°ë¦¬ìíì \n"
			+ "     ë©ë¶í¨ (ë¨, ê³µì¬ê³ì½ì ìì´ì ì°ë ë³´ì¦ì¸ì´ ìë ê²½ì° 100ë¶ì 20)\n"
			+ "     (ê°) ê¸ìµê¸°ê´ì´ ë°íí ì§ê¸ë³´ì¦ì\n"
			+ "     (ë) ì¦ê¶ìë²ìíë ¹ ì 84ì¡°ì 16í¸ì ê·ì ë ì ê°ì¦ê¶\n"
			+ "     (ë¤) ë³´íìë²ì ìí ë³´íì¬ììê° ë°íí ë³´ì¦ë³´íì¦ê¶\n"
			+ "     (ë¼) ê¸ìµê¸°ê´ ë° ì¸êµ­ê¸ìµê¸°ê´ê³¼ ì²´ì ê´ìê° ë°íí ì ê¸°ìê¸ì¦ì\n"
			+ "     (ë§) ê±´ì¤ê³µì ì¡°í©ë²ì ìí ê±´ì¤ê³µì ì¡°í©, ì ë¬¸ê±´ì¤ê³µì ì¡°í©ë²ì ìí\n" 
			+ "          ì ë¬¸ê±´ì¤ê³µì ì¡°í©Â·ìì¢ë³ê³µì ì¡°í©, ì ì©ë³´ì¦ê¸°ê¸ë²ì ìí ì ì©ë³´ì¦\n"
			+ "          ê¸°ê¸, ì ê¸°ì ì¬ìê¸ìµì§ììê´í ë²ë¥ ì ìí ê¸°ì ì ì©ë³´ì¦ê¸°ê¸,\n"
			+ "          ì ê¸°íµì ê³µì¬ìì ìí ì ê¸°íµì ê³µì ì¡°í©, ìì§ëì´ë§ê¸°ì ì§í¥ë²ì\n"
			+ "          ìí ìì§ëì´ë§ê³µì ì¡°í© ëë ê³µìë°ì ë²ì ìí ê³µì ì¬ìë¨ì²´,\n"
			+ "          ìíí¸ì¨ì´ê°ë°ì´ì§ë²ì ìíì¬ ì ë³´íµì ë¶ì¥ê´ì´ ê³µê³ í ê³µì ì¬ì\n"
			+ "          ê¸°ê´, ì ë ¥ê¸°ì ê´ë¦¬ë²ì ìí íêµ­ì ë ¥ê¸°ì ì¸íí ëë íê²½ì¹íì \n"
			+ "          ì°ìêµ¬ì¡°ë¡ì ì íì´ì§ì ê´íë²ë¥ ì ìíì¬ íê²½ì¤ë¹ì ëíì¬\n"
			+ "          íêµ­ê¸°ê³ê³µìì§í¥íê° ë°íí ì±ë¬´ì¡ ë±ì ì§ê¸ì ë³´ì¦íë ë³´ì¦ì\n"
			+ "  \n"
			+ " (2) ê³ì½ìëìê° ê³ì½ìì ìë¬´ë¥¼ ì´ííì§ ìëí  ê²½ì° ê³ì½ì´í\n"
			+ "     ë³´ì¦ê¸ì ë¹íì ê·ìë¨<br>\n"
			+ " (3) ê³ì½ì´íê¸°ê°ì ê³ì½ê¸°ê°ì 60ì¼ ì´ìì ê°ì°í ê¸°ê°ì´ì´ì¼ í¨\n"
			+ "</pre>\n";
	%>

	<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		<tr>
			  <td  width="20%" class="cell_title_wrb">8. ê³ì½ì´íë³´ì¦ê¸</td>
			  	<td width="80%">
		  			<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  				<tr>
		  				<td width="20%">
		  					<span class="cell_data_middle"> ë´ì©</span>
		  				</td>
		  				<td width="80%">
		  					<%=pre03%>
			  			</td>
					</tr>
				</table>
		  </td>
		</tr>
	</table>

	<% if (BID_TYPE.equals("D")) {%>
			<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
				<tr>
					  <td  width="20%" class="cell_title_wrb">9. ê³ì½ê´ë ¨ì¬í­</td>
					  	<td width="80%">
				  			<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
				  				<tr>
				  				<td width="20%">
				  					<span class="cell_data_middle">ê°. ë©íìë£ì¼ì(ë©íê¸°ê°)</span>  			
				  				</td>
				  				<td width="80%">
									<span class="general_padding_left"><input type="text" name="RD_DATE" size="70"   maxlength="100"  class="input_re"   value="<%=RD_DATE%>"  <%=script%>></span>
<!-- 									<a href="javascript:Calendar_Open('RD_DATE');" ><span class="image_padding_left"><img src="../../images/button/butt_calender.gif" width="19"   height="19" align="absmiddle" border="0" ></span></a> -->
								</td>
							</tr>
							<tr>
				  				<td width="20%">
				  					<span class="cell_data_middle">ë. ë©íì¥ì</span>
				  				</td>
				  				<td width="80%">
									<input type="text" name="DELY_PLACE" size="70" value="<%=DELY_PLACE.replaceAll("\"", "&quot;")%>" class="input_re_2" <%=script%>>
								</td>
							</tr>
							<tr>
				  				<td width="20%">
				  					<span class="cell_data_middle">ë¤. êµ¬ë§¤ìë</span>
				  				</td>
				  				<td width="80%">
									<span class="general_padding_left">ìëìí</span>
								</td>
							</tr>
							<tr>
				  				<td width="20%">
				  					<span class="cell_data_middle">ë¼. ëê¸ê²°ì ì¡°ê±´</span>
				  				</td>
				  				<td width="80%">
									<% for (int i = 0 ; i < aRadioValues.length ; i++) { %>
										<input type="radio" name="COST_SETTLE_TERMS" value="<%=i%>" <%if ( COST_SETTLE_TERMS.equals(aRadioValues[i]) ) {%>checked<%}%> onclick="javascript:fnCostSettleTerms(<%=i%>);"><%=aRadioTitles[i]%>
										<br>
									<%}%>
								</td>
							</tr>
							<%
							String pre04 = "";
							pre04 =   "<pre>"
									+ "ë©í ê¸°1ì¼ë´ ë¬¼íì ë¹íì´ ì§ì íë ì¥ìì ë©ííì§ ëª»íìì ë \n"
									+ "ì§ì°ì¼ì ë§¤ ì¼ë§ë¤ ë¯¸ë©íëê¸ì 1,000ë¶ì 1.5ì í´ë¹íë ì§ì²´ìê¸ì \n"
									+ "ë¹íì ë©ë¶íì¬ì¼ í¨"
									+ "<pre>";
							%>
							
							<tr>
				  				<td width="20%">
				  					<span class="cell_data_middle">ë§. ì§ì²´ìê¸</span>
				  				</td>
				  				<td width="80%"><%=pre04%>
								</td>
							</tr>
						</table>
				  </td>
				</tr>
			</table>
			<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
				<tr>
					    <td  width="20%" class="cell_title_wrb">10. ê¸°íì¬í­</td>
					  	<td width="80%">
				  			<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
				  				<tr>
				  				<td width="20%">
				  					<span class="cell_data_middle">ê°. ë´ì©</span>
				  				</td>
				  				<td width="80%">
					  				<textarea name="BID_ETC" cols="70" rows="3" maxlength="500" class="input_re_2" <%=script%>><%=BID_ETC%></textarea>
					  			</td>
							    </tr>
							    <tr>
				  				<td width="20%">
				  					<span class="cell_data_middle">ë. íëª©êµ¬ë¶</span>
				  				</td>
				  				<td width="80%">
					  				<select name="ITEM_TYPE" class="input_re" <%=abled%>>
											<option value="0">ì ííì¸ì</option>
											<%
												String com3 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M150", ITEM_TYPE);
										    out.println(com3);
											%>
										</select>
					  			</td>
							    </tr>
							    <tr style="display:none;">
							    <td width="20%">
							  		<span class="cell_data_middle">ë¤. ê°ì°°êµ¬ë¶</span>
							  	</td>
							  	<td width="80%">
								  	<select name="OPEN_GB" class="input_re" <%=abled%>>
											<%
												String com4 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M152", OPEN_GB);

										    out.println(com4);
											%>
										</select>
								  </td>
								</tr>  	    				
						    </table>
				      </td>
				</tr>
			</table>
			<%

	 } else {

	 	%>
	 	
	 	<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
			<tr>
				  <td  width="20%" class="cell_title_wrb">9. ê³ì½ê´ë ¨ì¬í­</td>
				  	<td width="80%">
			  			<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
			  				<tr>
			  				<td width="20%">
			  					<span class="cell_data_middle"> ëê¸ì§ê¸ë°©ë²</span>
			  				</td>
			  				<td width="80%">
			  					<input type="text" name="COST_SETTLE_TERMS_C" size="70" value="<%=COST_SETTLE_TERMS.replaceAll("\"", "&quot;")%>" class="input_re_2" <%=script%>>
				  			</td>
						</tr>
					</table>
			  </td>
			</tr>
		</table>

		<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
			<tr>
				<td  width="20%" class="cell_title_wrb">10. ê¸°íì¬í­</td>
				<td width="80%">
					<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
						<tr>
							<td width="20%">
								<span class="cell_data_middle">ê°. ë´ì©</span>
							</td>
							<td width="80%">
								<textarea name="BID_ETC" cols="70" rows="3" maxlength="500" class="input_re_2" <%=script%>><%=BID_ETC%></textarea>
							</td>
						</tr>
						<tr>
					  	<td width="20%">
					  		<span class="cell_data_middle">ë. íëª©êµ¬ë¶</span>
					  	</td>
					  	<td width="80%">
						  	<select name="ITEM_TYPE" class="input_re" <%=abled%>>
									<option value="0">ì ííì¸ì</option>
									<%
										String com3 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M151", ITEM_TYPE);
								    out.println(com3);
									%>
								</select>
						  </td>
						</tr>
						<tr  style="display:none;">
						<td width="20%">
					  		<span class="cell_data_middle">ë¤. ê°ì°°êµ¬ë¶</span>
					  	</td>
					  	<td width="80%">
						  	<select name="OPEN_GB" class="input_re" <%=abled%>>
									<%
										String com4 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M152", OPEN_GB);
								    out.println(com4);
									%>
								</select>
						  </td>
						</tr>  	  				
					</table>
				</td>
			</tr>
		</table>
		<%
	}
	%>
	
	<%
	// ìµì´ ê³µê³ ë¬¸ ìì±ì, ìì ì... ê²°ì¬ë¼ì¸ íì
	if(  (!SCR_FLAG.equals("I")) &&  (APPV_STATUS.equals("C") || APPV_STATUS.equals("D") || APPV_STATUS.equals("") )  )
	{
			%>
			<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
				<tr>
					<td width="20%" class="cell_title_wrb">ã ê²°ì¬ì¬í­ ã</td>
					<td width="80%">
						<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ê²°ì¬ì(íì¥) ì í</span>
								</td>
								<td width="80%">&nbsp;
									<select name="selAuth" class="inputsubmit">
										<option value = "">---------</option>
										<%
										for (int i = 0; i < 99 ; i++)
										{
											if ( aAuthList[i][0].equals("") )
											{
												break;
											}
											else
											{
												%>
												<option value = "<%=aAuthList[i][0]%>"><%=aAuthList[i][1]%></option>
												<%
											}
										}
										%>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<%
	}
	%>

	<%if(  APPV_STATUS.equals("A")  ) {%>
			<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
				<tr>
					<td width="20%" class="cell_title_wrb">ã ë°ë ¤ì ìê²¬ ã</td>
					<td width="80%">
						<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ë°ë ¤ì ìê²¬ìë ¥</span>
								</td>
								<td width="80%">&nbsp;
									<textarea name="txtReject" class="inputsubmit" rows="3" cols="70"></textarea>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	<%}%>
	
	<%if(  APPV_STATUS.equals("D") ) {%>
			<script language="Javascript">
				alert("ë°ë ¤ìê²¬ì´ ììµëë¤. íì¸ ë°ëëë¤.");
			</script>
			<table width="98%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
				<tr>
					<td width="20%" class="cell_title_wrb">ã ë°ë ¤ ìê²¬ ã</td>
					<td width="80%">
						<table width="100%" border="1" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
							<tr>
								<td width="20%">
									<span class="cell_data_middle">ë°ë ¤ìê²¬</span>
								</td>
								<td width="80%">&nbsp;
									<textarea class="inputsubmit" rows="3" cols="70"><%=REJECT_OPINION%></textarea>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	<%}%>

	<table>
		<tr id="q1">
			<td class="cell1_title_tta" width="15%" id="q2"> <span id="q3"></span></td>
			<td class="cell1_data_tta" width="35%" id="q4">
				<span id="q5">ê¸°ì¤ì ì
				<input type="text" name="STANDARD_POINT" size="4"  maxlength="3"  class="input_re"  onblur="check_STANDARD_POINT()" value="<%=STANDARD_POINT%>"  id=q6  <%=script%>>
				</span>
			</td>
			<td class="cell1_data_tta" width="15%" id="q7" colspan="2">
				<span id="q8">ì ìë¹ì¨</span> [
				<span id="q11">ê¸°ì </span><span id="q12">ì ìì</span>
				<input type="text" name="TECH_DQ" size="4"  maxlength="3"  class="input_re"  onblur="check_AMT_DQ()" value="<%=TECH_DQ%>"  id="q9"  <%=script%>>% : ê°ê²©
				<input type="text" name="AMT_DQ"  value="<%=AMT_DQ%>" size="4"   maxlength="4"  onblur="check_AMT_DQ()" class="input_re" <%=script%> id="q10">% ]
			</td>
		</tr>
		<tr id="i11">
			<td class="cell_title_tta" width="15%" id="i12"> <span id="i1"> íê°ìì ì¶ì¼ì</span></td>
			<td class="cell_data_tta" width="35%" colspan="3"    id="i13">
				<span id="i5">
				<input type="text" name="APP_BEGIN_DATE" size="10"  maxlength="8"  class="input_re"  value="<%=APP_BEGIN_DATE%>"  id=i2  <%=script%>>
<!-- 				<a href="javascript:Calendar_Open('APP_BEGIN_DATE');" id=i3><img src="../../images/button/butt_calender.gif" width="19" height="19" align="absmiddle"   border="0" id=i4></a>ì¼ -->
				<input type="text" name="APP_BEGIN_TIME_HOUR_MINUTE" size="4"  value="<%=APP_BEGIN_TIME_HOUR_MINUTE%>" maxlength="4"  class="input_re" <%=script%> id=i6>
				&nbsp;&nbsp;~&nbsp;&nbsp;
				<input type="text" name="APP_END_DATE" size="10"  maxlength="8"  class="input_re"  value="<%=APP_END_DATE%>"  id=i7  <%=script%>>
<!-- 				<a href="javascript:Calendar_Open('APP_END_DATE');" id=i8><img src="../../images/button/butt_calender.gif" width="19"   height="19" align="absmiddle" border="0" id=i9></a>ì¼ -->
				<input type="text" name="APP_END_TIME_HOUR_MINUTE"   value="<%=APP_END_TIME_HOUR_MINUTE%>" size="4" maxlength="4"  class="input_re" <%=script%>  id=i10>
			</td>
		</tr>
		<tr>
			<td  width="50%" class="cell_title_tta" colspan="2">
				<span    id="e1">ìë¹ê°ê²©ë²ì
				<input type="text" name="ESTM_RATE" size="3" maxlength="2" value="<%=ESTM_RATE%>" <%=script%>  id=e2>
				%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<span id="e3">ì¬ì©ìë¹/ì¶ì²¨ì
				
				<input type="hidden" name="ESTM_MAX_VOTE" >
				<!-- 2006-10-18 ESTM_MAX , ESTM_VOTEì´ ESTM_MAX_VOTEì¼ë¡ íµí©ëìë¤. ESTM_MAX , ESTM_VOTEë ìì
				 2006-10-19 ìë³µëë¤.
				-->
				<input type="text" name="ESTM_MAX" size="3" maxlength="2" value="<%=ESTM_MAX%>" onblur="check_ESTM_MAX()"   <%=script%>   id=e4>
				<input type="text" name="ESTM_VOTE" size="2" maxlength="1" value="<%=ESTM_VOTE%>" onblur="check_ESTM_VOTE()"    <%=script%>  id=e5>
				</span>
			</td>
		</tr>
	</table>

	<input type="hidden" size="20" value="<%=FROM_CONT_TEXT%>" name="FROM_CONT_TEXT" class="inputsubmit" readonly >
	<input type="hidden" size="3" value="<%=FROM_CONT%>" name="FROM_CONT" class="inputsubmit" readonly >
		
	<br>

	<%
	if(!GUBUN.equals("C")) {
			%>
			<table width="98%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="30" width="25%">
						<div align="right">
				  		<table>
				  			<tr> 
				  				<td><script language="javascript">btn("javascript:doExplanation()",7,"ì¤ëªí")</script><td>
								<td><input type="text" name="szdate" size="8" value="<%=ANNOUNCE_DATE%>" style='border-style: none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly ></td>
								<%
								if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
									%>
									<td height="30"><script language="javascript">btn("javascript:attach_file()",7,"íì¼ì²¨ë¶")</script></td>
									<%
								} else if(SCR_FLAG.equals("C")) {
									%>
									<td><script language="javascript">btn(";",7,"íì¼ì²¨ë¶")</script></td>
									<%
								}
								%>
				  				<td><input type="text" name="attach_count" value="<%=ATTACH_CNT%>" size="3"  value="0" style='border-style: none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly ></td>

								<%
								if (SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
									%>
					  				<td><script language="javascript">btn("javascript:Approval('T')",1,"ì  ì¥")</script></td>
									<%
								}
								%>
								
								<%
								if ( NEXT_AUTH_ID.equals("") && (!SCR_FLAG.equals("D")) && (!SCR_FLAG.equals("I"))  ) {
									%>
					  				<td><script language="javascript">btn("javascript:Approval('A')",1,"ê²°ì¬ì¬ë¦¼")</script></td>
									<%
								}
								%>

								<%if (    (SCR_FLAG.equals("C")) && ( (NEXT_AUTH_ID.equals(info.getSession("ID")) ) )      ) {%>
					  				<td><script language="javascript">btn("javascript:Approval('D')",7,"ë°ë ¤")</script></td>
					  				<td><script language="javascript">btn("javascript:Approval('C')",7,"íì (ê²°ì¬)")</script></td>
								<%}%>

	   							<td><script language="javascript">btn("javascript:history.back(-1)",7,"ì·¨ ì")</script></td>

								<%
								if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
									%>
						 			<td><script language="javascript">btn("javascript:LineDelete()",3,"íì­ì ")</script></td>
									<%
								}
								%>
							</tr>
						</table>
						</div>
					</td>
				</tr>
			</table>
			<%

	}  else   {

			%> 
			<table width="98%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="30" width="20%">
						<div align="right">
						<table>
							<tr>
								<td><script language="javascript">btn("javascript:setCopy()",1,"copy")</script><td>
							</tr>
						</table>
						</div>
					</td>
				</tr>
			</table>
			<%
	}
	%>

	<script language="JavaScript" >
	</script>

	<table width="98%" border="0" cellpadding="2" cellspacing="1" class="jtable_bgcolor">
		<%=WiseTable_Scripts("100%","230")%>
	</table>

	<script language="JavaScript" >
	</script>

	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="20%">
				<div align="left"></div>
			</td>
			<td width="80%" height="30">
			</td>
		</tr>
	</table>
	<br>

</form>

<!---- END OF USER SOURCE CODE ---->
<jsp:include page="/include/us_template_end.jsp" flush="true" />

<!---- TMAX ---->
<%
	if(SCR_FLAG.equals("C")) {
		%>
		<!-- ìëªì¸ì¦ ë¶ë¶ object setting -->
		<%
	}
%>
<!--SCR_FLAG:<%=SCR_FLAG%><BR>-->
<!--APPV_STATUS:<%=APPV_STATUS%>-->

</body>
</html>
