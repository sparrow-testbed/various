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
	info = SepoaSession.getAllValue(request);
	if(info.getSession("ID") != null) {
        house_code      = info.getSession("HOUSE_CODE");
	    user_id		    = info.getSession("ID");
    } else {
	    info = new SepoaInfo(house_code, null);
	}

    String ann_no        = "";
    String ann_date      = "";
    String subject       = "";
    String ra_type1      = "";   //역경매타입1 (O:공개,C:지명)
    String vendor_count  = "";
    String vendor_select = "";
    String start_date    = "";
    String start_time    = "";
    String end_date      = "";
    String end_time      = "";
    String cur           = "";
    String reserve_price = "";
    String bid_dec_amt   = "";
    String limit_crit    = "";
    String prom_crit     = "";
    String PROM_CRIT_TYPE_NAME	= "";
    String remark        = "";
    String attach_count  = "";
    String attach_no     = "";
    String RD_DATE     	 = "";
    String DELY_PLACE    = "";
    String ra_no        = JSPUtil.nullToRef(request.getParameter("RA_NO"), "");
    String ra_count     = JSPUtil.nullToRef(request.getParameter("RA_COUNT"), "");
    String pr_no        = JSPUtil.nullToRef(request.getParameter("REQ_PR_NO"), "");

	Object[] args = {house_code,ra_no, ra_count};

    SepoaOut rtn   = null;
    SepoaRemote wr = null;

    String nickName   = "p1008";
    String conType    = "CONNECTION";
    String MethodName = "getratbdupd1_1";

    SepoaOut value2 = null;
    SepoaRemote wr2 = null;
    String nickName2 = "p1008";
    String MethodName2 = "getRADTDisplay";
    String conType2 = "CONNECTION";
    SepoaFormater wf2 = null;

    SepoaOut value3 = null;
    SepoaRemote wr3 = null;
    String nickName3 = "p9001";
    String MethodName3 = "getFile_name";
    String conType3 = "CONNECTION";
    SepoaFormater wf3 = null;

    try {
    	Map<String, String> wr2Param = new HashMap<String, String>();
    	
    	wr2Param.put("RA_NO" 	, ra_no);
    	wr2Param.put("RA_COUNT" , ra_count);
    	
    	Object[] argss = {wr2Param};
//     	Object[] argss = {ra_no, ra_count};
        wr2 = new SepoaRemote(nickName2,conType2,info);
        value2 = wr2.lookup(MethodName2,argss);
        wf2 = new SepoaFormater(value2.result[0]);

    	wr = new SepoaRemote(nickName,conType,info);
    	rtn = wr.lookup(MethodName,args);
    	SepoaFormater wf = new SepoaFormater(rtn.result[0]);

       	int k = 0;
    	if ((wf != null) && (wf.getRowCount() > 0)) {
            ann_no        = wf.getValue("ANN_NO"        , k);
            ann_date      = wf.getValue("ANN_DATE"      , k);
            subject       = wf.getValue("SUBJECT"       , k);
            ra_type1      = wf.getValue("RA_TYPE1"      , k);
            vendor_count  = wf.getValue("VENDOR_COUNT"  , k);
            vendor_select = wf.getValue("VENDOR_SELECT" , k);
            start_date    = wf.getValue("START_DATE"    , k);
            start_time    = wf.getValue("START_TIME"    , k);
            end_date      = wf.getValue("END_DATE"      , k);
            end_time      = wf.getValue("END_TIME"      , k);
            cur           = wf.getValue("CUR"           , k);
            reserve_price = wf.getValue("RESERVE_PRICE" , k);
            bid_dec_amt   = wf.getValue("BID_DEC_AMT"   , k);
            limit_crit    = wf.getValue("LIMIT_CRIT"    , k);
            prom_crit     = wf.getValue("PROM_CRIT"     , k);
            PROM_CRIT_TYPE_NAME= wf.getValue("PROM_CRIT_TYPE_NAME"     , k);
            remark        = wf.getValue("REMARK"        , k);
            attach_count  = wf.getValue("ATTACH_COUNT"  , k);
            attach_no     = wf.getValue("ATTACH_NO"     , k);
            RD_DATE     	= wf.getValue("RD_DATE"     , k);
            DELY_PLACE     	= wf.getValue("DELY_PLACE"     , k);
            
            
            
    	}
    }catch(Exception e) {
    	Logger.dev.println(user_id, this, "servlet Exception = " + e.getMessage());
    }finally{
    	try{
    		wr.Release();
    		wr2.Release();
    		wr3.Release();
    	}catch(Exception e){}
    }
	
    String disp_ra_date  = start_date.substring(0, 4) + "년 " + start_date.substring(4, 6) + "월 " + start_date.substring(6, 8) + "일 "
                         + start_time.substring(0, 2) + "시 " + start_time.substring(2, 4) + "분 ~ "
                         + end_date.substring(0, 4) + "년 " + end_date.substring(4, 6) + "월 " + end_date.substring(6, 8) + "일 "
                         + end_time.substring(0, 2) + "시 " + end_time.substring(2, 4) + "분";
    String disp_ann_date = ann_date.substring(0, 4) + "/" + ann_date.substring(4, 6) + "/" + ann_date.substring(6, 8) + "";
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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
			//f.action = "/rMateFM/file_download.jsp";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0">
<form name="form1" >
	<input type="hidden" name="attach_no" value="<%=attach_no%>">
	<input type="hidden" name="attach_count" value="">
	<input type="hidden" name="att_mode"   value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="att_no" 	   value="<%=attach_no%>">
</form>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
<!-- 		<td class="cell_title1" width="78%" align="left">&nbsp; -->
<%-- 	  	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12"> --%>
<!-- 	  	&nbsp; -->
		<td height="20" align="left" class="title_page" vAlign="bottom">
	  	역경매공고 상세조회
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
<table width="100%" border="0" cellspacing="1" cellpadding="0">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
   		<tr>
     		<td align="left" class="cell_title1">&nbsp;◆  역경매 개요</td>
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
		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
		<td width="603" class='data_td'><div align="left"><%=ra_no%></div></td>
	</tr>
	<tr>
		<td colspan="2" height="1" bgcolor="#dedede"></td>
	</tr>  
	<tr>
		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고일자</td>
		<td width="242" class='data_td'><div align="left"><%=disp_ann_date%></div></td>
	</tr>
	<tr>
		<td colspan="2" height="1" bgcolor="#dedede"></td>
	</tr>	
	<tr>
		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매건명</td>
		<td class='data_td'><div align="left"><%=subject.replaceAll("\"", "&quot")%></div></td>
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
      <td height="30" align="right">
      	<TABLE cellpadding="0">
      		<tr>
	  			<td><script language="javascript">btn("javascript:window.close()","닫 기")</script> </td>
			</tr>
	  	</TABLE>
       </td>
    </tr>
  </table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆  역경매 정보</td>
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
		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매방법 </td>
		<td align="middle" class='data_td'><div align="left">&nbsp;<%=((ra_type1.equals("GC"))? "일반경쟁" : "지명경쟁")%></div></td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  		
	<tr>
	  <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매일시</td>
      <td align="middle" class='data_td'><div align="left">&nbsp;<%=disp_ra_date%></div></td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  		
	<tr>
	  <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰참가자격</td>
      <td align="left" class='data_td'><textarea cols="95" class="inputsubmit" rows="3" readonly><%=limit_crit%></textarea></td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  		
	<tr>
	  <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 낙찰자선정</td>
      <td align="middle" class='data_td'><div align="left"><%=PROM_CRIT_TYPE_NAME%>&nbsp;&nbsp;&nbsp;&nbsp;<%=prom_crit.replaceAll("\"", "&quot")%></div></td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  		
	<tr>
	  <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 납기장소</td>
      <td align="middle" class='data_td'><div align="left">&nbsp;<%=DELY_PLACE%></div></td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>  		
	<tr>
	  <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 기타사항</td>
      <td align="left" class='data_td'><textarea cols="95" class="inputsubmit" rows="10" readonly><%=remark%></textarea></td>
  </tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td align="left" class="cell_title1">&nbsp;◆  첨부파일</td>
   </tr>
 </table>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
    <tr>
      <td class="data_td" height="30" colspan="4">
		
		<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=attach_no%>&view_type=VI" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
		<br>&nbsp;
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
		<td class="title_td" width="80" align="middle" height="25">품목코드</td>
		<td class="title_td" align="middle" height="25">품목명</td>
		<td class="title_td" align="middle" height="25">사양</td>
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
</body>
</html>
<%-- <script language="javascript">rMateFileAttach('S','R','RA',form1.attach_no.value);</script> --%>
<iframe name=magic width=0 height=0 src="">
