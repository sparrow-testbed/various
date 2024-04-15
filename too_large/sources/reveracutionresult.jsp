<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<%
	String house_code   = "100";
	String user_id		= "guest";
	String sessionUserId = "TTA";
	if(info.getSession("ID") != null) {
	    house_code      = info.getSession("HOUSE_CODE");
	    user_id		    = info.getSession("ID");
	} else {
	    info = new SepoaInfo(house_code, null);
	}
    String ann_no        = "";
    String subject       = "";
    String ra_type1      = "";  //역경매타입1 (O:공개,C:지명)
    String ra_type1_text = "";
    String reserve_price = "";  //추정금액
    String ra_bid_price  = "";  //낙찰금액
    String bid_rate      = "";  //낙찰율
    String bid_diff      = "";  //차액
    String bid_dec_rate  = "";  //절감율
    String bid_desc      = "";

    String sb_vendor_code   = "";

    String rownum        = "";
    String vendor_code   = "";
    String bid_price     = "";
    String name_loc      = "";
    String ceo_name_loc  = "";
    String vngl_address  = "";
    String SETTLE_FLAG   = "";

    String ann_date = "";
    String ATTACH_NO = "";

    String create_flag  = JSPUtil.nullToRef(request.getParameter("CREATE_FLAG"),"C");  // C:생성, R:조회, P:출력
    String ra_no        = JSPUtil.nullToEmpty(request.getParameter("RA_NO"));
    String ra_count     = JSPUtil.nullToEmpty(request.getParameter("RA_COUNT"));
    String pr_no        = JSPUtil.nullToEmpty(request.getParameter("REQ_PR_NO"));

    String[] pData = {house_code, ra_no, ra_count};
  	Object[] args  = {pData};

  	SepoaOut rtn   = null;
  	SepoaRemote wr = null;

    String nickName   = "p1008";
    String conType    = "CONNECTION";
    String MethodName = "getratbdins4_1";
    SepoaFormater wf   = null;

//     SepoaOut value3 = null;
//     SepoaRemote wr3 = null;
//     String nickName3 = "p9001";
//     String MethodName3 = "getFile_name";
//     String conType3 = "CONNECTION";
//     SepoaFormater wf3 = null;

    SepoaOut value2 = null;
    SepoaRemote wr2 = null;
    String nickName2 = "p1008";
    String MethodName2 = "getRADTDisplay";
    String conType2 = "CONNECTION";
    SepoaFormater wf2 = null;

    try {
    	
    	String[] strArr = {info.getSession("HOUSE_CODE"), ra_no, ra_count};
    	
    	Map<String, String> params = new HashMap<String, String>();
    	params.put("HOUSE_CODE"	, info.getSession("HOUSE_CODE"));
    	params.put("RA_NO"		, ra_no);
    	params.put("RA_COUNT"	, ra_count);
    			
    			
    	Object[] arg1 = {params};
    	Object[] argss = {ra_no, ra_count};
        wr2 = new SepoaRemote(nickName2,conType2,info);
        
        
        value2 = wr2.lookup(MethodName2,arg1);
        
        
        wf2 = new SepoaFormater(value2.result[0]);

    	wr = new SepoaRemote(nickName,conType,info);
    	rtn = wr.lookup(MethodName,args);
    	wf = new SepoaFormater(rtn.result[0]);
    	if ((wf != null) && (wf.getRowCount() > 0)) {
            ann_no           = wf.getValue("ANN_NO"        , 0);
            subject          = wf.getValue("SUBJECT"       , 0);
            ra_type1         = wf.getValue("RA_TYPE1"      , 0);
            ra_type1_text    = wf.getValue("RA_TYPE1_TEXT" , 0);
            reserve_price    = wf.getValue("RESERVE_PRICE" , 0);
            ann_date         = wf.getValue("ANN_DATE" , 0);
            ATTACH_NO         = wf.getValue("ATTACH_NO" , 0);

    	}

    	wf = new SepoaFormater(rtn.result[1]);
    	if ((wf != null) && (wf.getRowCount() > 0)) {               // 낙찰업체
            sb_vendor_code  = wf.getValue("VENDOR_CODE"    , 0);
            name_loc        = wf.getValue("VENDOR_NAME_LOC", 0);
            ceo_name_loc    = wf.getValue("CEO_NAME_LOC"   , 0);
            vngl_address    = wf.getValue("VNGL_ADDRESS"   , 0);
            SETTLE_FLAG     = wf.getValue("SETTLE_FLAG"    , 0);

            if ("Y".equals(SETTLE_FLAG)) {
	            ra_bid_price    = wf.getValue("BID_PRICE"      , 0);
            } else {
            	ra_bid_price = "0";
            }
    	}

		Object[] argsss = {new String[]{ATTACH_NO}};
        //wr3 = new SepoaRemote(nickName3,conType3,info);
        //value3 = wr3.lookup(MethodName3,argsss);
        //wf3 = new SepoaFormater(value3.result[0]);

    }catch(Exception e) {
    	Logger.dev.println(user_id, this, "servlet Exception = " + e.getMessage());
    }finally{
    	try{
    		wr.Release();
    		wr2.Release();
//     		wr3.Release();
    	}catch(Exception e){}
    }

    if (!ra_bid_price.equals("")) {
        double cal_ra_bid_price  = Double.parseDouble(ra_bid_price);
        double cal_reserve_price = Double.parseDouble(reserve_price);
        double cal_rate          = Math.round((cal_ra_bid_price / cal_reserve_price * 100) * 100);
        double cal_dec_rate      = (100 * 100) - cal_rate;

        bid_rate      = String.valueOf(cal_rate/100);

        bid_diff      = String.valueOf(Math.round(cal_reserve_price - cal_ra_bid_price));
        bid_dec_rate  = String.valueOf(cal_dec_rate/100) + "%";

        bid_rate      = bid_rate + "%";
        reserve_price = SepoaString.formatNum(Long.parseLong(reserve_price));
        ra_bid_price  = SepoaString.formatNum(Long.parseLong(ra_bid_price));
        bid_diff      = SepoaString.formatNum(Long.parseLong(bid_diff));

        bid_desc      = bid_diff + "&nbsp;(" + bid_dec_rate + ")";
    }
    int len = reserve_price.length() - ra_bid_price.length();
    for(int i = 0; i < len; i++) {
        ra_bid_price = ra_bid_price;
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>우리은행 전자구매시스템</title>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript">
<!--
	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];

		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		f.file_type.value  = file_type;
		f.tmp_att_no.value = att_no;

		if (att_mode == "S") {
			f.method = "POST";
			f.target = "attachFrame";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" onLoad="divkim()">
<form name="form1" >
	<input type="hidden" name="attach_no" value="<%=ATTACH_NO%>">
	<input type="hidden" name="attach_count" value="">
	<input type="hidden" name="att_mode"   value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
</form>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" align="left" class="title_page" vAlign="bottom">
	  	&nbsp;역경매결과
	  	</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="10" ></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆  입찰개요</td>
   </tr>
 </table>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	<tr>
		<td class="title_td" width="151">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
		<td width="603" class='data_td'><div align="left"><%=ra_no%></div></td>
	</tr>
	<tr>
		<td colspan="2" height="1" bgcolor="#dedede"></td>
	</tr>  	
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고명</td>
		<td class='data_td'><div align="left"><%=subject.replaceAll("\"", "&quot")%></div></td>
	</tr>
	<tr>
		<td colspan="2" height="1" bgcolor="#dedede"></td>
	</tr>  	
	<tr>
		<td class="title_td" width="151">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고일자</td>
		<td width="242" class='data_td'><div align="left"><%=ann_date%></div></td>
	</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	
      	<TABLE cellpadding="0" style="width: 100%">
      		<tr>
	  			<td align="right"><script language="javascript">btn("javascript:window.close()","닫 기")</script> </td>
			</tr>
	  	</TABLE>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆  입찰정보</td>
   </tr>
 </table>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	<tr>
		<td class="title_td" width="203">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 예상금액(VAT 포함)</td>
		<td class="data_td"><%=reserve_price%></td>
	</tr>
	<tr>
		<td colspan="2" height="1" bgcolor="#dedede"></td>
	</tr>  	
	<tr>
		<td class="title_td" width="203">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 낙찰금액(VAT 포함)</td>
		<td class="data_td"><%=ra_bid_price%></td>
	</tr>
	<tr>
		<td colspan="2" height="1" bgcolor="#dedede"></td>
	</tr>  	
	<tr>
		<td class="title_td" rowSpan="2" width="203">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 관련비율(%)</td>
		<td class="data_td" >예상금액: 낙찰금액</td>
	</tr>
	<tr>
		<td class="data_td"><div id=kim> %</div> </td>
	</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	
<script>
	function divkim() {
		var m1 = del_comma('<%=reserve_price%>');
		var m2 = del_comma('<%=ra_bid_price%>');

		if (m1==0 || m2==0) {

		} else {
			document.all.kim.innerHTML=add_comma(   Math.round(m1/m2*10000)/100    ,2)+" %";
		}
	}
</script>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆  입찰업체</td>
   </tr>
</table>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
		<td class="title_td" align="middle">업체명</td>
		<td class="title_td" align="middle">대표자</td>
		<td class="title_td" align="middle">투찰금액</td>
		<td class="title_td" align="middle">비     고</td>
	</tr>

<%
                for (int i = 0; i < wf.getRowCount(); i++) {
                    rownum          = wf.getValue("ROWNUM"         , i);
                    vendor_code     = wf.getValue("VENDOR_CODE"    , i);
                    bid_price       = wf.getValue("BID_PRICE"      , i);
                    name_loc        = wf.getValue("VENDOR_NAME_LOC"       , i);
                    ceo_name_loc    = wf.getValue("CEO_NAME_LOC"   , i);
%>
	<tr >
		<td align="middle" height="22" class="data_td"><%=name_loc%></td>
		<td align="middle" class="data_td"><%=ceo_name_loc%> </td>
		<td align="middle" class="data_td"><%=SepoaString.formatNum(Long.parseLong(bid_price))%></td>
		<td align="middle" class="data_td"><%="Y".equals(wf.getValue("SETTLE_FLAG", i)) ? "낙찰" : "&nbsp;"%></td>
	</tr>
<%
                }
%>
</table>

<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆  첨부서류</td>
   </tr>
 </table>
<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
    <tr>
      <td class="data_td" height="30" colspan="4">
			<table border="0" style="padding-top: 10px; width: 100%;">
				<tr>
					<td>
						<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
					</td>
				</tr>
			</table>
      </td>
    </tr>
</table>

<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆  품목내역</td>
   </tr>
 </table>
<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
		<td class="title_td" align="middle" height="25">품목코드</td>
		<td class="title_td" align="middle" height="25">품목명</td>
		<td class="title_td" align="middle" height="25">규격</td>
		<td class="title_td" align="middle" height="25">단위</td>
		<td class="title_td" align="middle" height="25">수량</td>
	</tr>
<%
	for(int i=0;i<wf2.getRowCount();i++) {
	String ra_qty = wf2.getValue("RA_QTY",i);
%>
	<tr>
		<td align="middle" height="25" class='data_td'><%=wf2.getValue("BUYER_ITEM_NO",i)%></td>
		<td align="middle" height="25" class='data_td'><%=wf2.getValue("DESCRIPTION_LOC",i)%></td>
		<td align="middle" height="25" class='data_td'><%=wf2.getValue("SPECIFICATION",i)%></td>
		<td align="middle" height="25" class='data_td'><%=wf2.getValue("UNIT_MEASURE",i)%></td>
		<td align="middle" height="25" class='data_td'><%=SepoaString.formatNum(Long.parseLong(ra_qty))%></td>
	</tr>
<%
	}
%>
</table>


<%-- <script language="javascript">rMateFileAttach('S','R','RA',form1.attach_no.value);</script> --%>
<iframe name=magic width=0 height=0 src="">
</body>
</html>