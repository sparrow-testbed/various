package dt.app;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;
 
public class app_bd_lis1 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getWaitList".equals(mode)){
    			gdRes = this.getWaitList(gdReq, info);
    		}
    		else if("setPRCopy".equals(mode)){
    			Logger.debug.println();
    		}
    		else if("gwDraft".equals(mode)){
    			gdRes = this.gwDraft(gdReq, info);
    		}
    		else if("gwDraft2".equals(mode)){
    			gdRes = this.gwDraft2(gdReq, info);
    		}
    		else if("gwPop".equals(mode)){
    			gdRes = this.gwPop(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    	}
    	finally {
    		try{
    			if(
    				("gwDraft".equals(mode)) ||
    				("gwDraft2".equals(mode)) ||
    				("gwPop".equals(mode))
    			){
    				out.println(gdRes.getMessage());
    			}
    			else{
    				OperateGridData.write(req, res, gdRes, out);
    			}
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getWaitList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String              ctrl_code  = "";
	    String[]            gridColAry = null;
	    StringTokenizer     st         = null;
	    int                 rowCount   = 0;
	    int                 cnt        = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	
	    	st = new StringTokenizer(header.get("ctrl_code"), "&");
	    	
			while(st.hasMoreElements()){
				if(cnt == 0){
					ctrl_code = st.nextToken();
				}
				else{
					ctrl_code += ",'" + st.nextToken();
				}
				
				cnt++;
			}
			
			header.put("ctrl_code", ctrl_code);
	    	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {header};
	    	value = ServiceConnector.doService(info, "p1062", "CONNECTION","getWaitList", obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		String SOURCING_TYPE_NAME = "";
		    		for (int i = 0; i < rowCount; i++){
			    		for(int k=0; k < gridColAry.length; k++){
			    			if("SELECTED".equals(gridColAry[k])){
			    				gdRes.addValue("SELECTED", "0");
			    			}
			    			else if("RFQ_TYPE_STATUS_TEXT".equals(gridColAry[k])){
			    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k].replaceAll("_TEXT", ""), i));
			    			}
			    			else if("RFQ_TYPE_TEXT".equals(gridColAry[k])){
			    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k].replaceAll("_TEXT", ""), i));
			    			}
			    			else if("SOURCING_TYPE_NAME".equals(gridColAry[k])){
			    				/*
			    				1	PC	수의견적
			    				2	CL	사전견적
			    				3	MA	입력대행
			    				*/
			    				SOURCING_TYPE_NAME = sf.getValue(gridColAry[k], i);
								if ("PC".equals(sf.getValue("RFQ_TYPE", i))) {
									SOURCING_TYPE_NAME += "(수의계약)";
			    				}else if ("CL".equals(sf.getValue("RFQ_TYPE", i))) {
									SOURCING_TYPE_NAME += "(예가산정)";
			    				}else if ("MA".equals(sf.getValue("RFQ_TYPE", i))) {
									SOURCING_TYPE_NAME += "(입력대행)";
			    				}
			    				gdRes.addValue(gridColAry[k], SOURCING_TYPE_NAME);
			    			}
			    			else if("GW_STATUS_NM".equals(gridColAry[k])){
			    				String gwStatus   = sf.getValue("GW_STATUS",    i);
			    				String gwStatusNm = sf.getValue("GW_STATUS_NM", i);
			    				
			    				if("E".equals(gwStatus)){
			    					gwStatusNm = "<font color='blue'>" + gwStatusNm + "</font>";
			    				}
			    			
			    				String bdGwStatus   = sf.getValue("BD_GW_STATUS",    i);
			    				if("E".equals(bdGwStatus)){
			    					gwStatusNm = "<font color='blue'>품의완료</font>";			    					
			    				}
			    				
			    				gdRes.addValue(gridColAry[k], gwStatusNm);			    				
			    			}
			    			else if("GW_STATUS_NM2".equals(gridColAry[k])){
			    				String gwStatus2   = sf.getValue("GW_STATUS2",    i);
			    				String gwStatusNm2 = sf.getValue("GW_STATUS_NM2", i);
			    				
			    				if("E".equals(gwStatus2)){
			    					gwStatusNm2 = "<font color='blue'>" + gwStatusNm2 + "</font>";
			    				}
			    				
			    				gdRes.addValue(gridColAry[k], gwStatusNm2);
			    			}
			    			else{
			    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
			    			}
			    		}
			    	}
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
    
	private String insertSinfhdInfo(SepoaInfo info, String infCode, String infSend, String USRUSRID) throws Exception{
		Map<String, String> param = new HashMap<String, String>();
		Object[]            obj   = new Object[1];
		SepoaOut            value = null;
		String              infNo = null;
		boolean             flag  = false;
		
		param.put("HOUSE_CODE", "000");
		param.put("INF_TYPE",   "G");
		param.put("INF_CODE",   infCode);
		param.put("INF_SEND",   infSend);
		param.put("INF_ID",     USRUSRID);
		
		obj[0] = param;
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfhdInfo", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception("900");
		}
		else{
			infNo = value.result[0];
		}
		
		return infNo;
	}
	
	private String enCode(String param){
		StringBuffer sb = new StringBuffer();
		
		if(param == null){
			sb.append("");
		}
		else{
			if(param.length() > 0){
				for(int i = 0; i < param.length(); i++){
					String len = "" + (int)param.charAt(i);
					sb.append(len.length());
					sb.append((int)param.charAt(i));
				}
			}
		}
		
		return sb.toString();
	}
	
	private String getPrNoPrSeqInConditionStr(String[] prNoArray, String[] prSeqArray) throws Exception{
		String              result                = null;
		String              prNo                  = null;
		String              prSeq                 = null;
		StringBuffer        stringBuffer          = new StringBuffer();
		int                 recvdataSize          = prNoArray.length;
		int                 i                     = 0;
		int                 recvdataSizeLastIndex = recvdataSize - 1;
		
		for(i = 0; i < recvdataSize; i++){
			prNo         = prNoArray[i];
			prSeq        = prSeqArray[i];
			
			if(i == recvdataSizeLastIndex){
				stringBuffer.append("('").append(prNo).append("', '").append(prSeq).append("') ");
			}
			else{
				stringBuffer.append("('").append(prNo).append("', '").append(prSeq).append("'), ");
			}
		}
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private List<Map<String, String>> selectIcoyprdtGwList(SepoaInfo info, String[] prNoArray, String[] prSeqArray) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		Object[]                  obj        = new Object[1];
		Map<String, String>       objInfo    = new HashMap<String, String>();
		Map<String, String>       resultInfo = null;
		String                    houseCode  = info.getSession("HOUSE_CODE");
		String                    prNoSeq    = this.getPrNoPrSeqInConditionStr(prNoArray, prSeqArray);
		SepoaOut                  value      = null;
		SepoaFormater             sf         = null;
		boolean                   isStatus   = false;
		int                       rowCount   = 0;
		int                       i          = 0;
		
		objInfo.put("HOUSE_CODE", houseCode);
		objInfo.put("prNoSeq",    prNoSeq);
		
		obj[0]   = objInfo;
		value    = ServiceConnector.doService(info, "p1062", "CONNECTION", "selectIcoyprdtGwList", obj);
		isStatus = value.flag;
		
		if(isStatus){
    		sf = new SepoaFormater(value.result[0]);
    		
	    	rowCount = sf.getRowCount();
	
	    	for(i = 0; i < rowCount; i++){
	    		resultInfo = new HashMap<String, String>();
	    		
	    		resultInfo.put("PR_NO",                   sf.getValue("PR_NO",                   i));
	    		resultInfo.put("PR_SEQ",                  sf.getValue("PR_SEQ",                  i));
	    		resultInfo.put("SUBJECT",                 sf.getValue("SUBJECT",                 i));
	    		resultInfo.put("ADD_DATE",                sf.getValue("ADD_DATE",                i));
	    		resultInfo.put("PR_PROCEEDING_FLAG",      sf.getValue("PR_PROCEEDING_FLAG",      i));
	    		resultInfo.put("DESCRIPTION_LOC",         sf.getValue("DESCRIPTION_LOC",         i));
	    		resultInfo.put("ITEM_NO",                 sf.getValue("ITEM_NO",                 i));
	    		resultInfo.put("SPECIFICATION",           sf.getValue("SPECIFICATION",           i));
	    		resultInfo.put("MAKER_NAME",              sf.getValue("MAKER_NAME",              i));
	    		resultInfo.put("MAKER_CODE",              sf.getValue("MAKER_CODE",              i));
	    		resultInfo.put("PR_QTY",                  sf.getValue("PR_QTY",                  i));
	    		resultInfo.put("UNIT_PRICE",              sf.getValue("UNIT_PRICE",              i));
	    		resultInfo.put("PR_AMT",                  sf.getValue("PR_AMT",                  i));
	    		resultInfo.put("PURCHASER_NAME",          sf.getValue("PURCHASER_NAME",          i));
	    		resultInfo.put("PURCHASER_ID",            sf.getValue("PURCHASER_ID",            i));
	    		resultInfo.put("PR_TOT_AMT",              sf.getValue("PR_TOT_AMT",              i));
	    		resultInfo.put("CTRL_CODE",               sf.getValue("CTRL_CODE",               i));
	    		resultInfo.put("CUR",                     sf.getValue("CUR",                     i));
	    		resultInfo.put("ATTACH_NO",               sf.getValue("ATTACH_NO",               i));
	    		resultInfo.put("REMARK",                  sf.getValue("REMARK",                  i));
	    		resultInfo.put("PR_TYPE",                 sf.getValue("PR_TYPE",                 i));
	    		resultInfo.put("CREATE_TYPE",             sf.getValue("CREATE_TYPE",             i));
	    		resultInfo.put("CONTRACT_DIV",            sf.getValue("CONTRACT_DIV",            i));
	    		resultInfo.put("ORDER_SEQ",               sf.getValue("ORDER_SEQ",               i));
	    		resultInfo.put("PRE_CONT_SEQ",            sf.getValue("PRE_CONT_SEQ",            i));
	    		resultInfo.put("PRE_CONT_COUNT",          sf.getValue("PRE_CONT_COUNT",          i));
	    		resultInfo.put("MATERIAL_CLASS2",         sf.getValue("MATERIAL_CLASS2",         i));
	    		resultInfo.put("PR_PROCEEDING",           sf.getValue("PR_PROCEEDING",           i));
	    		resultInfo.put("PR_UNIT_PRICE",           sf.getValue("PR_UNIT_PRICE",           i));
	    		resultInfo.put("WBS_NO",                  sf.getValue("WBS_NO",                  i));
	    		resultInfo.put("WBS_NAME",                sf.getValue("WBS_NAME",                i));
	    		resultInfo.put("SOURCING_TYPE",           sf.getValue("SOURCING_TYPE",           i));
	    		resultInfo.put("ADD_USER_ID",             sf.getValue("ADD_USER_ID",             i));
	    		resultInfo.put("PR_PROCEEDING_FLAG_NAME", sf.getValue("PR_PROCEEDING_FLAG_NAME", i));
	    		resultInfo.put("CTRL_NAME",               sf.getValue("CTRL_NAME",               i));
	    		resultInfo.put("SOURCING_TYPE_NAME",      sf.getValue("SOURCING_TYPE_NAME",      i));
	    		resultInfo.put("CREATE_TYPE_NAME",        sf.getValue("CREATE_TYPE_NAME",        i));
	    		resultInfo.put("PR_TYPE_TEXT",            sf.getValue("PR_TYPE_TEXT",            i));
	    		resultInfo.put("GO_FLAG",                 sf.getValue("GO_FLAG",                 i));
	    		resultInfo.put("PO_VENDOR_CODE",          sf.getValue("PO_VENDOR_CODE",          i));
	    		resultInfo.put("PO_UNIT_PRICE",           sf.getValue("PO_UNIT_PRICE",           i));
	    		resultInfo.put("PO_ITEM_AMT",             sf.getValue("PO_ITEM_AMT",             i));
	    		resultInfo.put("PO_VENDOR_NAME",          sf.getValue("PO_VENDOR_NAME",          i));
	    		resultInfo.put("CUSTOMER_PRICE",          sf.getValue("CUSTOMER_PRICE",          i));
	    		resultInfo.put("CONTRACT_DIV_NAME",       sf.getValue("CONTRACT_DIV_NAME",       i));
	    		resultInfo.put("PREFERRED_BIDDER",        sf.getValue("PREFERRED_BIDDER",        i));
	    		resultInfo.put("GW_STATUS",               sf.getValue("GW_STATUS",               i));
	    		resultInfo.put("GW_STATUS_NM",            sf.getValue("GW_STATUS_NM",            i));
	    		resultInfo.put("SOURCING_DETAIL_TYPE",    sf.getValue("SOURCING_DETAIL_TYPE",    i));
	    		resultInfo.put("RFQ_TYPE_STATUS",         sf.getValue("RFQ_TYPE_STATUS",         i));
	    		resultInfo.put("SOURCING_STATUS",         sf.getValue("SOURCING_STATUS",         i));
	    		resultInfo.put("FINAL_ESTM_PRICE",        sf.getValue("FINAL_ESTM_PRICE",        i));
	    		resultInfo.put("PO_VENDOR_NAME",          sf.getValue("PO_VENDOR_NAME",          i));
	    		resultInfo.put("ADD_DATE",          	  sf.getValue("ADD_DATE",          	     i));
	    		
	    		result.add(resultInfo);
	    	}
    	}
    	else{
    		throw new Exception();
    	}
		
		return result;
	}
	
	private StringBuffer gwDraftObjBodyContentTypeA(StringBuffer stringBuffer, List<Map<String, String>> prdtList) throws Exception{
		Map<String, String> prdtListInfo = null;
		int                 i            = 0;
		int                 prdtListSize = prdtList.size();
		
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("1. 구입근거");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("2. 구입품목 및 예정금액");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<table width='100%' border='0' cellspacing='0' cellpadding='0'>");
		stringBuffer.append(	"<TR>");
		stringBuffer.append(		"<TD style='text-align: right;'>(단위 : 원, 부가세포함)</TD>");
		stringBuffer.append(	"</TR>");
		stringBuffer.append("</TABLE>");
		stringBuffer.append("<table width='100%' border='1' cellspacing='0' cellpadding='0'>");
		stringBuffer.append(	"<TR>");
		stringBuffer.append(		"<TD width='35%'><p align='center'>품명</p></TD>");
		stringBuffer.append(		"<TD width='15%'><p align='center'>수량</p></TD>");
		stringBuffer.append(		"<TD width='15%'><p align='center'>예정단가</p></TD>");
		stringBuffer.append(		"<TD width='15%'><p align='center'>예정금액</p></TD>");
		stringBuffer.append(		"<TD width='20%'><p align='center'>비고</p></TD>");
		stringBuffer.append(	"</TR>");
		
		for(i = 0; i < prdtListSize; i++){
			prdtListInfo = prdtList.get(i);
			
			stringBuffer.append("<TR>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		prdtListInfo.get("DESCRIPTION_LOC"));
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("PR_QTY")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("PO_UNIT_PRICE")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("PO_ITEM_AMT")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>&nbsp;</TD>");
			stringBuffer.append("</TR>");
		}
		
		stringBuffer.append("</TABLE>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("3. 구입방법");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("4. 낙찰방법");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("5. 처리계정");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("6. 추진일정");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("7. 기타");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("붙임");
		
		return stringBuffer;
	}
	
	private StringBuffer gwDraftObjBodyContentTypeB(StringBuffer stringBuffer, List<Map<String, String>> prdtList) throws Exception{
		Map<String, String> prdtListInfo = null;
		int                 i            = 0;
		int                 prdtListSize = prdtList.size();
		
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("1. 구입근거");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("2. 구입품목 및 예정금액");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<table width='100%' border='0' cellspacing='0' cellpadding='0'>");
		stringBuffer.append(	"<TR>");
		stringBuffer.append(		"<TD style='text-align: right;'>(단위 : 원, 부가세포함)</TD>");
		stringBuffer.append(	"</TR>");
		stringBuffer.append("</TABLE>");
		stringBuffer.append("<table width='100%' border='1' cellspacing='0' cellpadding='0'>");
		stringBuffer.append(	"<TR>");
		stringBuffer.append(		"<TD width='20%'><p align='center'>품명</p></TD>");
		stringBuffer.append(		"<TD width='12%'><p align='center'>예정금액</p></TD>");
		stringBuffer.append(		"<TD width='12%'><p align='center'>내정금액</p></TD>");
		stringBuffer.append(		"<TD width='12%'><p align='center'>수량</p></TD>");
		stringBuffer.append(		"<TD width='12%'><p align='center'>단가</p></TD>");
		stringBuffer.append(		"<TD width='12%'><p align='center'>낙찰금액</p><p align='center'>(계약금액)</p></TD>");
		stringBuffer.append(		"<TD width='20%'><p align='center'>입찰방법</p></TD>");
		stringBuffer.append(	"</TR>");
		
		for(i = 0; i < prdtListSize; i++){
			prdtListInfo       = prdtList.get(i);
			
			stringBuffer.append("<TR>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		prdtListInfo.get("DESCRIPTION_LOC"));
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("PR_AMT")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("FINAL_ESTM_PRICE")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("PR_QTY")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("PO_UNIT_PRICE")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("PO_ITEM_AMT")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='center'>");
			stringBuffer.append(			prdtListInfo.get("SOURCING_DETAIL_TYPE"));
			stringBuffer.append(		"</p>");
//			stringBuffer.append(		"<p align='center'>");
//			stringBuffer.append(			prdtListInfo.get("SOURCING_STATUS"));
//			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append("</TR>");
		}
		
		stringBuffer.append("</TABLE>");
		
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("3. 입찰일 및 계약업체");
		stringBuffer.append("<p>&nbsp;</p>");		
		
		stringBuffer.append("<table width='100%' border='1' cellspacing='0' cellpadding='0'>");
		stringBuffer.append(	"<TR>");
		stringBuffer.append(		"<TD width='20%'><p align='center'>품명</p></TD>");
		stringBuffer.append(		"<TD width='20%'><p align='center'>입찰방법</p></TD>");
		stringBuffer.append(		"<TD width='20%'><p align='center'>입 찰 일</p></TD>");
		stringBuffer.append(		"<TD width='20%'><p align='center'>계약업체</p></TD>");
		stringBuffer.append(	"</TR>");
		
		for(i = 0; i < prdtListSize; i++){
			prdtListInfo       = prdtList.get(i);
			
			stringBuffer.append("<TR>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		prdtListInfo.get("DESCRIPTION_LOC"));
			stringBuffer.append(	"</TD>");
			
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='center'>");
			stringBuffer.append(			prdtListInfo.get("SOURCING_DETAIL_TYPE"));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='center'>");
			stringBuffer.append(			prdtListInfo.get("ADD_DATE"));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='center'>");
			stringBuffer.append(			prdtListInfo.get("PO_VENDOR_NAME"));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append("</TR>");
		}
		
		stringBuffer.append("</TABLE>");
		
		
		
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		
		stringBuffer.append("4. 처리계정");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("5. 추진일정");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("6. 기타");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("붙임");

//		stringBuffer.append("3. 입 찰 일");
//		stringBuffer.append("<p>&nbsp;</p>");
//		stringBuffer.append("<p>&nbsp;</p>");
//		
//		stringBuffer.append("4. 계약업체");
//		stringBuffer.append("<p>&nbsp;</p>");
//		stringBuffer.append("<p>&nbsp;</p>");
//		
//		stringBuffer.append("5. 처리계정");
//		stringBuffer.append("<p>&nbsp;</p>");
//		stringBuffer.append("<p>&nbsp;</p>");
//		stringBuffer.append("6. 추진일정");
//		stringBuffer.append("<p>&nbsp;</p>");
//		stringBuffer.append("<p>&nbsp;</p>");
//		stringBuffer.append("<p>&nbsp;</p>");
//		stringBuffer.append("7. 기타");
//		stringBuffer.append("<p>&nbsp;</p>");
//		stringBuffer.append("<p>&nbsp;</p>");
//		stringBuffer.append("붙임");
		
		return stringBuffer;
	}
	
	private String gwDraftObjBodyContent(Map<String, Object> param) throws Exception{
		SepoaInfo                 info         = (SepoaInfo)param.get("info");
		String                    result       = null;
		String                    infNo        = (String)param.get("infNo");
		String                    kind         = (String)param.get("kind");
		String                    subject      = null;
		String[]                  prNoArray    = (String[])param.get("prNoArray");
		String[]                  prSeqArray   = (String[])param.get("prSeqArray");
		StringBuffer              stringBuffer = new StringBuffer();
		List<Map<String, String>> prdtList     = this.selectIcoyprdtGwList(info, prNoArray, prSeqArray);
		
		if("A".equals(kind)){
			subject = "사전품의";
		}
		else if("B".equals(kind)){
			subject = "계약품의";
		}
		
		stringBuffer.append("<DOCLINKS></DOCLINKS>");
		stringBuffer.append("<SYSKEY>");
		stringBuffer.append(	infNo);
		stringBuffer.append("</SYSKEY>");
		stringBuffer.append("<EDATE></EDATE>");
		stringBuffer.append("<SEL_Secrecy></SEL_Secrecy>");
		stringBuffer.append("<DOC_KIND></DOC_KIND>");
		stringBuffer.append("<RULENAUTH></RULENAUTH>");
		stringBuffer.append("<sY></sY>");
		stringBuffer.append("<sN></sN>");
		stringBuffer.append("<PRERULE_DATA></PRERULE_DATA>");
		stringBuffer.append("<LIMIT_DATA></LIMIT_DATA>");
		stringBuffer.append("<YPUBLIC></YPUBLIC>");
		stringBuffer.append("<NPUBLIC></NPUBLIC>");
		stringBuffer.append("<SUBJECT>");
		stringBuffer.append(	subject);
		stringBuffer.append("</SUBJECT>");
		stringBuffer.append("<HtmlBody><![CDATA[");
		stringBuffer.append(	"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">");
		stringBuffer.append(	"<HTML>");
		stringBuffer.append(	"<HEAD>");
		stringBuffer.append(		"<META http-equiv=Content-Type content=\"text/html; charset=utf-8\">");
		stringBuffer.append(		"<META content=http://schemas.microsoft.com/intellisense/ie5   name=vs_targetSchema>");
		stringBuffer.append(		"<STYLE type=text/css>");
		stringBuffer.append(			"p {font-size:12px; font-family:굴림; margin:0pt;}");
		stringBuffer.append(		"</STYLE>");
		stringBuffer.append(		"<META content=\"MSHTML 6.00.2900.5969\" name=GENERATOR>");
		stringBuffer.append(	"</HEAD>");
		stringBuffer.append(	"<BODY>");
		
		if("A".equals(kind)){
			stringBuffer = this.gwDraftObjBodyContentTypeA(stringBuffer, prdtList);
		}
		else if("B".equals(kind)){
			stringBuffer = this.gwDraftObjBodyContentTypeB(stringBuffer, prdtList);
		}
		
		stringBuffer.append(	"</BODY>");
		stringBuffer.append("]]></HtmlBody>");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private Object[] gwDraftObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result           = new Object[1];
		Map<String, Object>       resultInfo       = new HashMap<String, Object>();
		Map<String, String>       data             = new HashMap<String, String>();
		Map<String, String>       listInfo         = null;
		Map<String, Object>       bodyContentParam = new HashMap<String, Object>();
		String                    prNo             = gdReq.getParam("prNo");
		String                    prSeq            = gdReq.getParam("prSeq");
		String                    kind             = gdReq.getParam("kind");
		String                    houseCode        = info.getSession("HOUSE_CODE");
		String                    infNo            = this.insertSinfhdInfo(info, "GWAPP", "S", " ");
		String                    bodyContent      = null;
		String                    seq              = null;
		String                    prNoArrayInfo    = null;
		String                    prSeqArrayInfo   = null;
		String[]                  prNoArray        = prNo.split(",");
		String[]                  prSeqArray       = prSeq.split(",");
		List<Map<String, String>> list             = new ArrayList<Map<String, String>>();
		int                       prNoArrayLength  = prNoArray.length;
		int                       i                = 0;
		
		bodyContentParam.put("infNo",      infNo);
		bodyContentParam.put("prNoArray",  prNoArray);
		bodyContentParam.put("prSeqArray", prSeqArray);
		bodyContentParam.put("kind",       kind);
		bodyContentParam.put("info",       info);
		
		bodyContent = this.gwDraftObjBodyContent(bodyContentParam);
		
		data.put("HOUSE_CODE",   houseCode);
		data.put("INF_NO",       infNo);
		data.put("BODY_CONTENT", bodyContent);
		data.put("TYPE",         "G");
		
		for(i = 0; i < prNoArrayLength; i++){
			listInfo = new HashMap<String, String>();
			
			seq            = Integer.toString(i + 1);
			prNoArrayInfo  = prNoArray[i];
			prSeqArrayInfo = prSeqArray[i];
			
			listInfo.put("HOUSE_CODE", houseCode);
			listInfo.put("INF_NO",     infNo);
			listInfo.put("SEQ",        seq);
			listInfo.put("PR_NO",      prNoArrayInfo);
			listInfo.put("PR_SEQ",     prSeqArrayInfo);
			listInfo.put("kind",     kind);
			
			list.add(listInfo);
		}
		
		resultInfo.put("data", data);
		resultInfo.put("list", list);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	private String gwDraftSuccessJson(Object[] obj) throws Exception{
		String              result       = null;
		String              bodyContent  = null;
		String              infNo        = null;
		StringBuffer        stringBuffer = new StringBuffer();
    	Map<String, Object> objInfo      = null;
    	Map<String, String> objInfoData  = null;
		
		objInfo     = (Map<String, Object>)obj[0];
		objInfoData = (Map<String, String>)objInfo.get("data");
		bodyContent = objInfoData.get("BODY_CONTENT");
		infNo       = objInfoData.get("INF_NO");
		bodyContent = this.enCode(bodyContent);
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'200',");
		stringBuffer.append(	"bodyContextValue:'").append(bodyContent).append("',");
		stringBuffer.append(	"infNo:'").append(infNo).append("'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private String gwDraftFailJson() throws Exception{
		String       result       = null;
		StringBuffer stringBuffer = new StringBuffer();
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'900',");
		stringBuffer.append(	"message:'상신 내용 작성 중 문제가 발생하였습니다.'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private String getExceptionStackTrace(Exception e){
		Writer      writer      = null;
		PrintWriter printWriter = null;
		String      s           = null;
		
		writer      = new StringWriter();
		printWriter = new PrintWriter(writer);
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		return s;
	}
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
	
	private GridData gwDraft(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	SepoaOut value        = null;
    	Object[] obj          = null; 
    	String   gdResMessage = null;
    	boolean  flag         = false;
   
    	try {
    		obj   = this.gwDraftObj(gdReq, info);
    		value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertGwappprInfo", obj);
    		flag  = value.flag;
    		
    		if(flag == false){
    			throw new Exception();
    		}
    		
    		gdResMessage = this.gwDraftSuccessJson(obj);
    	}
    	catch(Exception e){
    		this.loggerExceptionStackTrace(e);
    		
    		gdResMessage = this.gwDraftFailJson();
    	}
    	
    	gdRes.setMessage(gdResMessage);
    	
    	return gdRes;
    }
	
	private GridData gwDraft2(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	SepoaOut value        = null;
    	Object[] obj          = null; 
    	String   gdResMessage = null;
    	boolean  flag         = false;
   
    	try {
    		obj   = this.gwDraftObj(gdReq, info);
    		value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertGwappprInfo2", obj);
    		flag  = value.flag;
    		
    		if(flag == false){
    			throw new Exception();
    		}
    		
    		gdResMessage = this.gwDraftSuccessJson(obj);
    	}
    	catch(Exception e){
    		this.loggerExceptionStackTrace(e);
    		
    		gdResMessage = this.gwDraftFailJson();
    	}
    	
    	gdRes.setMessage(gdResMessage);
    	
    	return gdRes;
    }
	
	private Object[] gwPopObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result    = new Object[1];
    	Map<String, String> header    = new HashMap<String, String>();
    	String              prNo      = gdReq.getParam("prNo");
    	String              prSeq     = gdReq.getParam("prSeq");
    	String              type      = gdReq.getParam("type");
    	String              houseCode = info.getSession("HOUSE_CODE");
    	
    	header.put("HOUSE_CODE", houseCode);
    	header.put("PR_NO",      prNo);
    	header.put("PR_SEQ",     prSeq);
    	header.put("TYPE",       type);
    	
    	result[0] = header;
    	
    	return result;
    }
	
	private String gwPopJson(Object[] obj, SepoaOut value) throws Exception{
		String        result       = null;
		String        gwPopUrl     = null;
		StringBuffer  stringBuffer = new StringBuffer();
		SepoaFormater sf           = new SepoaFormater(value.result[0]);
		
		gwPopUrl = sf.getValue("DOC_LINK", 0);
		gwPopUrl = this.enCode(gwPopUrl);
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'200',");
		stringBuffer.append(	"gwPopUrl:'").append(gwPopUrl).append("'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private GridData gwPop(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	SepoaOut value        = null;
    	Object[] obj          = null; 
    	String   gdResMessage = null;
    	boolean  flag         = false;
    	Logger.err.println("selectGwPopUrl==================================");
    	try {
    		obj   = this.gwPopObj(gdReq, info);
    		value = ServiceConnector.doService(info, "p1062", "TRANSACTION", "selectGwPopUrl", obj);
    		flag  = value.flag;
    		
    		if(flag == false){
    			throw new Exception();
    		}
    		
    		gdResMessage = this.gwPopJson(obj, value);
    	}
    	catch(Exception e){
    		this.loggerExceptionStackTrace(e);
    		
    		gdResMessage = this.gwDraftFailJson();
    	}
    	
    	gdRes.setMessage(gdResMessage);
    	
    	return gdRes;
    }
}