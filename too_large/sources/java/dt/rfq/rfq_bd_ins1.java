package dt.rfq;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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

import com.icompia.util.CommonUtil;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class rfq_bd_ins1 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("prDTQuerySourcing".equals(mode)){
    			gdRes = this.prDTQuerySourcing(gdReq, info);
    		}
    		else if("setRfqCreate".equals(mode)){
    			gdRes = this.setRfqCreate(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData prDTQuerySourcing(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
	    Map<String, Object> svcParam   = new HashMap<String, Object>();
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String              prData     = null;
	    String              prNoSeq    = null;
	    String[]            gridColAry = null;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq);
	    	prData     = header.get("PR_DATA");
	    	prNoSeq    = this.prDTQuerySourcingPrNoSeq(prData);
	    	
	    	gdRes.addParam("mode", "query");
	    	
	    	svcParam.put("prNoSeq", prNoSeq);
	
	    	Object[] obj = {svcParam};
	
	    	value = ServiceConnector.doService(info, "p1001", "CONNECTION", "prDTQuerySourcing", obj);
	    	gdRes = this.prDTQuerySourcingGdRes(value, gdRes, message, gridColAry);
	    }
	    catch (Exception e){
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
    
    @SuppressWarnings("rawtypes")
	private GridData prDTQuerySourcingGdRes(SepoaOut value, GridData gdRes, HashMap message, String[] gridColAry) throws Exception{
    	SepoaFormater sf           = null;
    	int           rowCount     = 0;
    	
    	if(value.flag){// 조회 성공
    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
    		gdRes.setStatus("true");
    		
    		sf= new SepoaFormater(value.result[0]);
    		
	    	rowCount = sf.getRowCount(); // 조회 row 수
	
	    	if(rowCount == 0){
	    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
	    	}
	    	else{
	    		for (int i = 0; i < rowCount; i++){
		    		for(int k=0; k < gridColAry.length; k++){
		    			if("SELECTED".equals(gridColAry[k])){
		    				gdRes.addValue("SELECTED", "0");
		    			}
		    			else if("ATTACH_NO".equals(gridColAry[k])){
		    				gdRes.addValue("ATTACH_NO", "");
		    			}
		    			else if("VENDOR_SELECTED".equals(gridColAry[k])){
		    				gdRes.addValue("VENDOR_SELECTED", "");
		    			}
		    			else if("PRICE_DOC".equals(gridColAry[k])){
		    				gdRes.addValue("PRICE_DOC", "");
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
    	
    	return gdRes;
    }
    
    private String prDTQuerySourcingPrNoSeq(String prData) throws Exception{
    	List<Map<String, String>> resultArray = new ArrayList<Map<String, String>>();
    	StringTokenizer           st1         = new StringTokenizer(prData, ",");
    	StringTokenizer           st2         = null;
    	String                    prDataToken = null;
    	String                    result      = null;
    	Map<String, String>       resultInfo  = null;
        int                       count1      = st1.countTokens();
        int                       j           = 0;
        
        for(j = 0; j< count1; j++){
        	resultInfo = new HashMap<String, String>();
        	
        	prDataToken = st1.nextToken();
        	
        	st2 = new StringTokenizer(prDataToken, "-");
        	
        	resultInfo.put("PR_NO", st2.nextToken());
        	resultInfo.put("PR_SEQ", st2.nextToken());
        	
        	resultArray.add(resultInfo);
        }
        
        result = this.getPrNoPrSeqInConditionStr(resultArray);
    	
    	return result;
    }
    
    private String getPrNoPrSeqInConditionStr(List<Map<String, String>> recvdata) throws Exception{
		String              result                = null;
		String              prNo                  = null;
		String              prSeq                 = null;
		StringBuffer        stringBuffer          = new StringBuffer();
		Map<String, String> recvdataInfo          = null;
		int                 recvdataSize          = recvdata.size();
		int                 i                     = 0;
		int                 recvdataSizeLastIndex = recvdataSize - 1;
		
		for(i = 0; i < recvdataSize; i++){
			recvdataInfo = recvdata.get(i);
			prNo         = recvdataInfo.get("PR_NO");
			prSeq        = recvdataInfo.get("PR_SEQ");
			
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
    
    @SuppressWarnings({ "rawtypes", "unchecked", "deprecation" })
    private GridData setRfqCreate(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes           = null;
    	HashMap                   message         = null;
    	SepoaOut                  value           = null;
    	Map<String, Object>       data            = null;
    	Map<String, Object>       svcParam        = null;
    	Map<String, String>       header          = null;
    	List<Map<String, String>> prhddata        = null;
    	List<Map<String, String>> rqhddata        = null;
    	List<Map<String, String>> rqandata        = new ArrayList<Map<String, String>>();
		String                    signStatus      = null;
    	String                    iRfgFlag        = null;
    	String                    rfqNo           = null;
    	String                    iCreateType     = null;
    	String                    iSzdate         = null;
    	String                    iRemark         = null;
    	String                    iRfqCloseDate   = null;
    	
    	message = this.setRfqCreateMessage(info);

    	try {
    		data          = SepoaDataMapper.getData(info, gdReq);
    		header        = MapUtils.getMap(data, "headerData"); // 헤더 정보 조회
    		iRfgFlag      = header.get("I_RFQ_FLAG");
    		iCreateType   = header.get("I_CREATE_TYPE");
    		iSzdate       = header.get("I_SZDATE");
    		iRemark       = header.get("I_REMARK");
    		iRfqCloseDate = header.get("I_RFQ_CLOSE_DATE");
    		iRfqCloseDate = SepoaString.getDateUnSlashFormat(iRfqCloseDate);
    		iRemark       = java.net.URLDecoder.decode(iRemark,"UTF-8");
    		header.put("I_REMARK",         iRemark);
    		header.put("I_RFQ_CLOSE_DATE", iRfqCloseDate);
    		signStatus    = this.setRfqCreateSignStatus(iRfgFlag);
    		iRfgFlag      = this.setRfqCreateIRfgFlag(iRfgFlag);
    		rfqNo         = this.setRfqCreateRfqNo(info);
    		rqhddata      = this.setRfqCreateRqhddata(info, header, rfqNo, iRfgFlag, signStatus);
    		prhddata      = this.setRfqCreatePrhddata(info, header, rfqNo);
    		svcParam      = this.getGridInfoParamList(info, data, rfqNo);
    		
    		if("".equals(iSzdate) == false){
				rqandata = this.setRfqCreateRqandata(info, rfqNo, iSzdate, header, rqandata);
			}
    		
    		
    		
    		//System.out.println(gdReq.getParam("I_PFLAG"));
    		
    		svcParam.put("pflag",       gdReq.getParam("I_PFLAG"));
    		svcParam.put("create_type", iCreateType);
    		svcParam.put("rfq_flag",    iRfgFlag);
    		svcParam.put("rfq_type",    header.get("I_RFQ_TYPE"));
    		svcParam.put("rfq_no",      rfqNo);
    		svcParam.put("prhddata",    prhddata);
    		svcParam.put("rqhddata",    rqhddata);
    		svcParam.put("rqandata",    rqandata);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1004", "TRANSACTION", "setRfqCreate", obj);
    		gdRes = this.setRfqCreateGdRes(value, message);
    	}
    	catch(Exception e){
    		gdRes = new GridData();//결과를 XML형태로 보내주기 위해 생성
    		gdRes.setSelectable(false);//true : 커넥션 / false : 트랜잭션
    		
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
    
    @SuppressWarnings("unchecked")
	private Map<String, Object> getGridInfoParamList(SepoaInfo info, Map<String, Object> data, String rfqNo) throws Exception{
    	Map<String, String>       header          = MapUtils.getMap(data, "headerData");
    	Map<String, String>       gridInfo        = null;
    	Map<String, Object>       servletParam    = null;
    	Map<String, Object>       result          = new HashMap<String, Object>();
    	String                    dtTbeNo         = null;
    	String                    techniqueGrade  = null;
    	String                    techniqueType   = null;
    	String                    techniqueFlag   = null;
    	String                    tbeFlag         = "";
    	String                    iPrType         = header.get("I_PR_TYPE");
    	String                    rfqSeq          = null;
    	String                    shipperType     = header.get("I_SHIPPER_TYPE");
    	String                    iCreateType     = header.get("I_CREATE_TYPE");
    	String                    iCtrlCode       = header.get("I_CTRL_CODE");
    	List<Map<String, String>> grid            = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	List<Map<String, String>> chkdata         = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> prcfmdata       = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> rqdtdata        = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> prdtdata        = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> rqopdata        = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> rqsedata        = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> rqepdata        = new ArrayList<Map<String, String>>();
    	int                       i               = 0;
    	int                       gridSize        = grid.size();
    	
    	for(i = 0; i < gridSize; i++){
			servletParam = new HashMap<String, Object>();
			
			gridInfo       = grid.get(i);
			dtTbeNo        = gridInfo.get("TBE_NO");
			dtTbeNo        = this.nvl(dtTbeNo);
			techniqueGrade = gridInfo.get("TECHNIQUE_GRADE");
			techniqueType  = gridInfo.get("TECHNIQUE_TYPE");
			techniqueFlag  = gridInfo.get("TECHNIQUE_FLAG");
			chkdata        = this.setRfqCreateChkdata(chkdata, gridInfo);
			prcfmdata      = this.setRfqCreatePrcfmdata(info, prcfmdata, gridInfo);
			
			if("".equals(dtTbeNo) == false){
				tbeFlag = "Y";
			}
			
			if("I".equals(iPrType)){
				techniqueGrade = "";
				techniqueType  = "";
				techniqueFlag  = "";
			}
			
			rfqSeq = String.valueOf(i + 1);
			
			servletParam.put("info",           info);
			servletParam.put("rfqSeq",         rfqSeq);
			servletParam.put("rfqNo",          rfqNo);
			servletParam.put("gridInfo",       gridInfo);
			servletParam.put("tbeFlag",        tbeFlag);
			servletParam.put("shipperType",    shipperType);
			servletParam.put("techniqueGrade", techniqueGrade);
			servletParam.put("techniqueType",  techniqueType);
			servletParam.put("techniqueFlag",  techniqueFlag);
			servletParam.put("rqdtdata",       rqdtdata);
			
			if("MA".equals(iCreateType) == false){
				rqdtdata = this.setRfqCreateRqdtdataICreateTypeNotMA(servletParam);
			}
			else{
				rqdtdata = this.setRfqCreateRqdtdataICreateTypeMA(servletParam);
			}
			
			prdtdata = this.setRfqCreatePrdtdata(prdtdata, gridInfo, info, iCtrlCode, rfqNo, rfqSeq);
			rqopdata = this.setRfqCreateRqopdata(info, rfqNo, rfqSeq, gridInfo, rqopdata);
			rqsedata = this.setRfqCreateRqsedata(info, gridInfo, rfqNo, rfqSeq, rqsedata);  
			rqepdata = this.setRfqCreateRqepdata(gridInfo, info, rfqNo, rfqSeq, rqepdata);    			
		}
    	
    	result.put("chkdata",   chkdata);
    	result.put("prcfmdata", prcfmdata);
    	result.put("rqdtdata",  rqdtdata);
    	result.put("prdtdata",  prdtdata);
    	result.put("rqopdata",  rqopdata);
    	result.put("rqsedata",  rqsedata);
    	result.put("rqepdata",  rqepdata);
    	
    	return result;
    }
    
    private List<Map<String, String>> setRfqCreateRqandata(SepoaInfo info, String rfqNo, String iSzdate, Map<String, String> header, List<Map<String, String>> rqandata) throws Exception{
    	Map<String, String> rqantemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		
		rqantemp.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		rqantemp.put("RFQ_NO",             rfqNo);
		rqantemp.put("RFQ_COUNT",          "1");
		rqantemp.put("STATUS",             "C");
		rqantemp.put("COMPANY_CODE",       info.getSession("COMPANY_CODE"));
		rqantemp.put("ANNOUNCE_DATE",      iSzdate);
		rqantemp.put("ANNOUNCE_TIME_FROM", header.get("I_START_TIME"));
		rqantemp.put("ANNOUNCE_TIME_TO",   header.get("I_END_TIME"));
		rqantemp.put("ANNOUNCE_HOST",      header.get("I_HOST"));
		rqantemp.put("ANNOUNCE_AREA",      header.get("I_AREA"));
		rqantemp.put("ANNOUNCE_PLACE",     header.get("I_PLACE"));
		rqantemp.put("ANNOUNCE_NOTIFIER",  header.get("I_NOTIFIER"));
		rqantemp.put("ANNOUNCE_RESP",      header.get("I_RESP"));
		rqantemp.put("DOC_FRW_DATE",       header.get("I_DOC_FRW_DATE"));
		rqantemp.put("ADD_USER_ID",        id);
		rqantemp.put("ADD_DATE",           shortDateString);
		rqantemp.put("ADD_TIME",           shortTimeString);
		rqantemp.put("CHANGE_USER_ID",     id);
		rqantemp.put("CHANGE_DATE",        shortDateString);
		rqantemp.put("CHANGE_TIME",        shortTimeString);
		rqantemp.put("ANNOUNCE_COMMENT",   header.get("I_COMMENT"));

		rqandata.add(rqantemp);
		
		return rqandata;
    }
    
    private List<Map<String, String>> setRfqCreateRqepdata(Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqSeq, List<Map<String, String>> rqepdata) throws Exception{
    	String              dtPriceDoc                = gridInfo.get("PRICE_DOC");
		String              dtVendorSelectedReason    = gridInfo.get("VENDOR_SELECTED_REASON");
		String              vendorDatasFirstTrim      = null;
		String              index05Value              = null;
		String              shortDateString           = SepoaDate.getShortDateString();
		String              shortTimeString           = SepoaDate.getShortTimeString();
		String              id                        = info.getSession("ID");
		String              houseCode                 = info.getSession("HOUSE_CODE");
		String              companyCode               = info.getSession("COMPANY_CODE");
		String[]            costDatas                 = CommonUtil.getTokenData(dtPriceDoc, "$");
		String[]            vendorSelectedDatas       = CommonUtil.getTokenData(dtVendorSelectedReason, "#");
		String[]            vendorDatas               = null;
		Map<String, String> tmpRqep                   = null;
		int                 vendorSelectedDatasLength = vendorSelectedDatas.length;
		int                 j                         = 0;
		int                 k                         = 0;
		int                 costDatasLength           = costDatas.length;

		for(j = 0; j < vendorSelectedDatasLength; j++) {
			vendorDatas = CommonUtil.getTokenData(vendorSelectedDatas[j], "@");

			for (k = 0; k < costDatasLength / 2; k++) {
				tmpRqep = new HashMap<String, String>();
				
				vendorDatasFirstTrim = vendorDatas[0].trim();
				index05Value         = String.valueOf(k + 1);
				
				tmpRqep.put("HOUSE_CODE",       houseCode);
				tmpRqep.put("VENDOR_CODE",      vendorDatasFirstTrim);
				tmpRqep.put("RFQ_NO",           rfqNo);
				tmpRqep.put("RFQ_COUNT",        "1");
				tmpRqep.put("RFQ_SEQ",          rfqSeq);
				tmpRqep.put("COST_SEQ",         index05Value);
				tmpRqep.put("STATUS",           "C");
				tmpRqep.put("COMPANY_CODE",     companyCode);
				tmpRqep.put("COST_PRICE_NAME",  costDatas[k * 2]);
				tmpRqep.put("COST_PRICE_VALUE", "");
				tmpRqep.put("ADD_DATE",         shortDateString);
				tmpRqep.put("ADD_TIME",         shortTimeString);
				tmpRqep.put("ADD_USER_ID",      id);
				tmpRqep.put("CHANGE_DATE",      shortDateString);
				tmpRqep.put("CHANGE_TIME",      shortTimeString);
				tmpRqep.put("CHANGE_USER_ID",   id);
				
				rqepdata.add(tmpRqep);
			}
		}
		
		return rqepdata;
    }
    
    private List<Map<String, String>> setRfqCreateRqsedata(SepoaInfo info, Map<String, String> gridInfo, String rfqNo, String rfqSeq, List<Map<String, String>> rqsedata) throws Exception{
    	String              dtVendorSelectedReason  = gridInfo.get("VENDOR_SELECTED_REASON");
    	String              vendorSelectedDatasInfo = null;
    	String              vendorDatasFirstTrim    = null;
    	String              shortDateString         = SepoaDate.getShortDateString();
		String              shortTimeString         = SepoaDate.getShortTimeString();
		String              id                      = info.getSession("ID");
		String              houseCode               = info.getSession("HOUSE_CODE");
		String              companyCode             = info.getSession("COMPANY_CODE");
		String[]            vendorSelectedDatas     = CommonUtil.getTokenData(dtVendorSelectedReason, "#");
		String[]            vendorDatas             = null;
		Map<String, String> tmpRqse                 = null;
		int      vendorSelectedDatasLength          = vendorSelectedDatas.length;
		int      j                                  = 0;
		
		for(j = 0; j < vendorSelectedDatasLength; j++){
			tmpRqse = new HashMap<String, String>();
			
			vendorSelectedDatasInfo = vendorSelectedDatas[j];
			vendorDatas             = CommonUtil.getTokenData(vendorSelectedDatasInfo, "@");
			vendorDatasFirstTrim    = vendorDatas[0].trim();
			
			tmpRqse.put("HOUSE_CODE",      houseCode);
			tmpRqse.put("VENDOR_CODE",     vendorDatasFirstTrim);
			tmpRqse.put("RFQ_NO",          rfqNo);
			tmpRqse.put("RFQ_COUNT",       "1");
			tmpRqse.put("RFQ_SEQ",         rfqSeq);
			tmpRqse.put("STATUS",          "C");
			tmpRqse.put("COMPANY_CODE",    companyCode);
			tmpRqse.put("CONFIRM_FLAG",    "S");
			tmpRqse.put("CONFIRM_DATE",    "");
			tmpRqse.put("CONFIRM_USER_ID", "");
			tmpRqse.put("BID_FLAG",        "");
			tmpRqse.put("ADD_DATE",        shortDateString);
			tmpRqse.put("ADD_USER_ID",     id);
			tmpRqse.put("ADD_TIME",        shortTimeString);
			tmpRqse.put("CHANGE_DATE",     shortDateString);
			tmpRqse.put("CHANGE_USER_ID",  id);
			tmpRqse.put("CHANGE_TIME",     shortTimeString);
			tmpRqse.put("CONFIRM_TIME",    "");
			
			rqsedata.add(tmpRqse);
		}
		
		return rqsedata;
    }
    
    private List<Map<String, String>> setRfqCreateRqopdata(SepoaInfo info, String rfqNo, String rfqSeq, Map<String, String> gridInfo, List<Map<String, String>> rqopdata) throws Exception{
    	String              dtVendorSelectedReason    = gridInfo.get("VENDOR_SELECTED_REASON");
    	String              vendorSelectedDatasInfo   = null;
    	String              vendorDatasFirstTrim      = null;
    	String              id                        = info.getSession("ID");
    	String              houseCode                 = info.getSession("HOUSE_CODE");
		String              shortDateString           = SepoaDate.getShortDateString();
		String              shortTimeString           = SepoaDate.getShortTimeString();
		String              dtPurchaseLocation        = gridInfo.get("PURCHASE_LOCATION");
		String[]            vendorSelectedDatas       = CommonUtil.getTokenData(dtVendorSelectedReason, "#");
		String[]            vendorDatas               = null;
		Map<String, String> tmpRqop                   = null;
		int                 vendorSelectedDatasLength = vendorSelectedDatas.length;
		int                 j                         = 0;
		
		dtPurchaseLocation = JSPUtil.nullToRef(dtPurchaseLocation, "01");
		
    	for(j = 0; j < vendorSelectedDatasLength; j++){
    		tmpRqop = new HashMap<String, String>();
    		
    		vendorSelectedDatasInfo = vendorSelectedDatas[j];
			vendorDatas             = CommonUtil.getTokenData(vendorSelectedDatasInfo, "@");
			vendorDatasFirstTrim    = vendorDatas[0].trim();
			
			tmpRqop.put("HOUSE_CODE",        houseCode);
			tmpRqop.put("RFQ_NO",            rfqNo);
			tmpRqop.put("RFQ_COUNT",         "1");
			tmpRqop.put("RFQ_SEQ",           rfqSeq);
			tmpRqop.put("PURCHASE_LOCATION", dtPurchaseLocation);
			tmpRqop.put("VENDOR_CODE",       vendorDatasFirstTrim);
			tmpRqop.put("STATUS",            "C");
			tmpRqop.put("ADD_USER_ID",       id);
			tmpRqop.put("ADD_DATE",          shortDateString);
			tmpRqop.put("ADD_TIME",          shortTimeString);
			tmpRqop.put("CHANGE_DATE",       shortDateString);
			tmpRqop.put("CHANGE_TIME",       shortTimeString);
			tmpRqop.put("CHANGE_USER_ID",    id);
			
			rqopdata.add(tmpRqop);
		}
    	
		return rqopdata;
    }
    
    private List<Map<String, String>> setRfqCreatePrdtdata(List<Map<String, String>> prdtdata, Map<String, String> gridInfo, SepoaInfo info, String iCtrlCode, String rfqNo, String rfqSeq) throws Exception{
    	Map<String, String> prdttemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		
		prdttemp.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		prdttemp.put("PR_NO",              rfqNo);
		prdttemp.put("PR_SEQ",             rfqSeq);
		prdttemp.put("STATUS",             "C");
		prdttemp.put("COMPANY_CODE",       info.getSession("COMPANY_CODE"));
		prdttemp.put("PLANT_CODE",         info.getSession("DEPARTMENT"));
		prdttemp.put("ITEM_NO",            gridInfo.get("ITEM_NO"));
		prdttemp.put("SHIPPER_TYPE",       "D");
		prdttemp.put("PR_PROCEEDING_FLAG", "P");
		prdttemp.put("PURCHASE_LOCATION",  "01");
		prdttemp.put("CTRL_CODE",          iCtrlCode);
		prdttemp.put("UNIT_MEASURE",       gridInfo.get("UNIT_MEASURE"));
		prdttemp.put("PR_QTY",             gridInfo.get("RFQ_QTY"));
		prdttemp.put("CONFIRM_QTY",        "");
		prdttemp.put("CUR",                gridInfo.get("CUR"));
		prdttemp.put("LIST_PRICE",         "");
		prdttemp.put("UNIT_PRICE",         gridInfo.get("RFQ_AMT"));
		prdttemp.put("PR_AMT",             gridInfo.get("RFQ_AMT"));
		prdttemp.put("RD_DATE",            gridInfo.get("RD_DATE"));
		prdttemp.put("PURCHASER_ID",       "");
		prdttemp.put("PURCHASER_NAME",     "");
		prdttemp.put("ATTACH_NO",          gridInfo.get("ATTACH_NO"));
		prdttemp.put("YEAR_QTY",           "");
		prdttemp.put("PURCHASE_DEPT",      "");
		prdttemp.put("PURCHASE_DEPT_NAME", "");
		prdttemp.put("ADD_DATE",           shortDateString);
		prdttemp.put("ADD_USER_ID",        id);
		prdttemp.put("ADD_TIME",           shortTimeString);
		prdttemp.put("CHANGE_DATE",        shortDateString);
		prdttemp.put("CHANGE_USER_ID",     id);
		prdttemp.put("CHANGE_TIME",        shortTimeString);
		prdttemp.put("DESCRIPTION_LOC",    gridInfo.get("DESCRIPTION_LOC"));
		prdttemp.put("SPECIFICATION",      gridInfo.get("SPECIFICATION"));
		prdttemp.put("MAKER_CODE",         gridInfo.get("MAKER_CODE"));
		prdttemp.put("MAKER_NAME",         gridInfo.get("MAKER_NAME"));
		prdttemp.put("DELY_TO_ADDRESS",    gridInfo.get("DELY_TO_ADDRESS"));
		
		prdtdata.add(prdttemp);
		
		return prdtdata;
    }
    
    @SuppressWarnings("unchecked")
	private List<Map<String, String>> setRfqCreateRqdtdataICreateTypeMA(Map<String, Object> param) throws Exception{
    	SepoaInfo                 info            = (SepoaInfo)param.get("info");
    	Map<String, String>       rqdttemp        = new HashMap<String, String>();
    	Map<String, String>       gridInfo        = (Map<String, String>)param.get("gridInfo");
    	String                    rfqSeq          = (String)param.get("rfqSeq");
    	String                    rfqNo           = (String)param.get("rfqNo");
    	String                    tbeFlag         = (String)param.get("tbeFlag");
    	String                    shipperType     = (String)param.get("shipperType");
    	String                    techniqueGrade  = (String)param.get("techniqueGrade");
    	String                    techniqueType   = (String)param.get("techniqueType");
    	String                    techniqueFlag   = (String)param.get("techniqueFlag");
		String                    shortDateString = SepoaDate.getShortDateString();
		String                    shortTimeString = SepoaDate.getShortTimeString();
		String                    id              = info.getSession("ID");
		String                    prSeq           = CommonUtil.lpad(rfqSeq, 5, "0");
		List<Map<String, String>> rqdtdata        = (List<Map<String, String>>)param.get("rqdtdata");
		
		rqdttemp.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		rqdttemp.put("RFQ_NO",              rfqNo);
		rqdttemp.put("RFQ_COUNT",           "1");
		rqdttemp.put("RFQ_SEQ",             rfqSeq);
		rqdttemp.put("STATUS",              "C");
		rqdttemp.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
		rqdttemp.put("PLANT_CODE",          gridInfo.get("PLANT_CODE"));
		rqdttemp.put("RFQ_PROCEEDING_FLAG", "N");
		rqdttemp.put("ADD_DATE",            shortDateString);
		rqdttemp.put("ADD_TIME",            shortTimeString);
		rqdttemp.put("ADD_USER_ID",         id);
		rqdttemp.put("CHANGE_DATE",         shortDateString);
		rqdttemp.put("CHANGE_TIME",         shortTimeString);
		rqdttemp.put("CHANGE_USER_ID",      id);
		rqdttemp.put("ITEM_NO",             gridInfo.get("ITEM_NO"));
		rqdttemp.put("UNIT_MEASURE",        gridInfo.get("UNIT_MEASURE"));
		rqdttemp.put("RD_DATE",             gridInfo.get("RD_DATE"));
		rqdttemp.put("VALID_FROM_DATE",     "");
		rqdttemp.put("VALID_TO_DATE",       "");
		rqdttemp.put("PURCHASE_PRE_PRICE",  gridInfo.get("PURCHASE_PRE_PRICE"));
		rqdttemp.put("RFQ_QTY",             gridInfo.get("RFQ_QTY"));
		rqdttemp.put("RFQ_AMT",             gridInfo.get("RFQ_AMT"));
		rqdttemp.put("BID_COUNT",           "0");
		rqdttemp.put("CUR",                 gridInfo.get("CUR"));
		rqdttemp.put("PR_NO",               rfqNo);
		rqdttemp.put("PR_SEQ",              prSeq);
		rqdttemp.put("SETTLE_FLAG",         "N");
		rqdttemp.put("SETTLE_QTY",          "0");
		rqdttemp.put("TBE_FLAG",            tbeFlag);
		rqdttemp.put("TBE_DEPT",            "");
		rqdttemp.put("PRICE_TYPE",          "");
		rqdttemp.put("TBE_PROCEEDING_FLAG", "");
		rqdttemp.put("SAMPLE_FLAG",         "");
		rqdttemp.put("DELY_TO_LOCATION",    gridInfo.get("DELY_TO_LOCATION"));
		rqdttemp.put("ATTACH_NO",           gridInfo.get("ATTACH_NO"));
		rqdttemp.put("SHIPPER_TYPE",        shipperType);
		rqdttemp.put("CONTRACT_FLAG",       "");
		rqdttemp.put("COST_COUNT",          gridInfo.get("COST_COUNT"));
		rqdttemp.put("YEAR_QTY",            gridInfo.get("YEAR_QTY"));
		rqdttemp.put("DELY_TO_ADDRESS",     gridInfo.get("DELY_TO_ADDRESS"));
		rqdttemp.put("MIN_PRICE",           "0");
		rqdttemp.put("MAX_PRICE",           "0");
		rqdttemp.put("STR_FLAG",            gridInfo.get("STR_FLAG"));
		rqdttemp.put("TBE_NO",              gridInfo.get("TBE_NO"));
		rqdttemp.put("Z_REMARK",            gridInfo.get("REMARK"));
		rqdttemp.put("TECHNIQUE_GRADE",     techniqueGrade);
		rqdttemp.put("TECHNIQUE_TYPE",      techniqueType);
		rqdttemp.put("INPUT_FROM_DATE",     gridInfo.get("INPUT_FROM_DATE"));
		rqdttemp.put("INPUT_TO_DATE",       gridInfo.get("INPUT_TO_DATE"));
		rqdttemp.put("TECHNIQUE_FLAG",      techniqueFlag);
		rqdttemp.put("SPECIFICATION",       gridInfo.get("SPECIFICATION"));
		rqdttemp.put("MAKER_NAME",          gridInfo.get("MAKER_NAME"));
		
		rqdtdata.add(rqdttemp);
		
		return rqdtdata;
    }
    
    @SuppressWarnings("unchecked")
	private List<Map<String, String>> setRfqCreateRqdtdataICreateTypeNotMA(Map<String, Object> param) throws Exception{
    	SepoaInfo                 info            = (SepoaInfo)param.get("info");
    	List<Map<String, String>> rqdtdata        = (List<Map<String, String>>)param.get("rqdtdata");
    	Map<String, String>       gridInfo        = (Map<String, String>)param.get("gridInfo");
    	HashMap<String, String>   rqdttemp        = new HashMap<String, String>();
		String                    shortDateString = SepoaDate.getShortDateString();
		String                    shortTimeString = SepoaDate.getShortTimeString();
		String                    id              = info.getSession("ID");
		String                    rfqSeq          = (String)param.get("rfqSeq");
    	String                    rfqNo           = (String)param.get("rfqNo");
    	String                    tbeFlag         = (String)param.get("tbeFlag");
    	String                    shipperType     = (String)param.get("shipperType");
    	String                    techniqueGrade  = (String)param.get("techniqueGrade");
    	String                    techniqueType   = (String)param.get("techniqueType");
    	String                    techniqueFlag   = (String)param.get("techniqueFlag");
		
		rqdttemp.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		rqdttemp.put("RFQ_NO",              rfqNo);
		rqdttemp.put("RFQ_COUNT",           "1");
		rqdttemp.put("RFQ_SEQ",             rfqSeq);
		rqdttemp.put("STATUS",              "C");
		rqdttemp.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
		rqdttemp.put("PLANT_CODE",          gridInfo.get("PLANT_CODE"));
		rqdttemp.put("RFQ_PROCEEDING_FLAG", "N");
		rqdttemp.put("ADD_DATE",            shortDateString);
		rqdttemp.put("ADD_TIME",            shortTimeString);
		rqdttemp.put("ADD_USER_ID",         id);
		rqdttemp.put("CHANGE_DATE",         shortDateString);
		rqdttemp.put("CHANGE_TIME",         shortTimeString);
		rqdttemp.put("CHANGE_USER_ID",      id);
		rqdttemp.put("ITEM_NO",             gridInfo.get("ITEM_NO"));
		rqdttemp.put("UNIT_MEASURE",        gridInfo.get("UNIT_MEASURE"));
		rqdttemp.put("RD_DATE",             gridInfo.get("RD_DATE"));
		rqdttemp.put("VALID_FROM_DATE",     "");
		rqdttemp.put("VALID_TO_DATE",       "");
		rqdttemp.put("PURCHASE_PRE_PRICE",  gridInfo.get("PURCHASE_PRE_PRICE"));
		rqdttemp.put("RFQ_QTY",             gridInfo.get("RFQ_QTY"));
		rqdttemp.put("RFQ_AMT",             gridInfo.get("RFQ_AMT"));
		rqdttemp.put("BID_COUNT",           "0");
		rqdttemp.put("CUR",                 gridInfo.get("CUR"));
		rqdttemp.put("PR_NO",               gridInfo.get("PR_NO"));
		rqdttemp.put("PR_SEQ",              gridInfo.get("PR_SEQ"));
		rqdttemp.put("SETTLE_FLAG",         "N");
		rqdttemp.put("SETTLE_QTY",          "0");
		rqdttemp.put("TBE_FLAG",            tbeFlag);
		rqdttemp.put("TBE_DEPT",            "");
		rqdttemp.put("PRICE_TYPE",          "");
		rqdttemp.put("TBE_PROCEEDING_FLAG", "");
		rqdttemp.put("SAMPLE_FLAG",         "");
		rqdttemp.put("DELY_TO_LOCATION",    gridInfo.get("DELY_TO_LOCATION"));
		rqdttemp.put("ATTACH_NO",           gridInfo.get("ATTACH_NO"));
		rqdttemp.put("SHIPPER_TYPE",        shipperType);
		rqdttemp.put("CONTRACT_FLAG",       "");
		rqdttemp.put("COST_COUNT",          gridInfo.get("COST_COUNT"));
		rqdttemp.put("YEAR_QTY",            gridInfo.get("YEAR_QTY"));
		rqdttemp.put("DELY_TO_ADDRESS",     gridInfo.get("DELY_TO_ADDRESS"));
		rqdttemp.put("MIN_PRICE",           "0");
		rqdttemp.put("MAX_PRICE",           "0");
		rqdttemp.put("STR_FLAG",            gridInfo.get("STR_FLAG"));
		rqdttemp.put("TBE_NO",              gridInfo.get("TBE_NO"));
		rqdttemp.put("Z_REMARK",            gridInfo.get("REMARK"));
		rqdttemp.put("TECHNIQUE_GRADE",     techniqueGrade);
		rqdttemp.put("TECHNIQUE_TYPE",      techniqueType);
		rqdttemp.put("INPUT_FROM_DATE",     gridInfo.get("INPUT_FROM_DATE"));
		rqdttemp.put("INPUT_TO_DATE",       gridInfo.get("INPUT_TO_DATE"));
		rqdttemp.put("TECHNIQUE_FLAG",      techniqueFlag);
		rqdttemp.put("SPECIFICATION",       gridInfo.get("SPECIFICATION"));
		rqdttemp.put("MAKER_NAME",          gridInfo.get("MAKER_NAME"));
		 

		rqdtdata.add(rqdttemp);
    	
    	return rqdtdata;
    }
    
    private List<Map<String, String>> setRfqCreatePrcfmdata(SepoaInfo info, List<Map<String, String>> prcfmdata, Map<String, String> gridInfo) throws Exception{
    	Map<String, String>       prcfmtemp       = new HashMap<String, String>();
    	
    	prcfmtemp.put("DT_RFQ_QTY", gridInfo.get("RFQ_QTY"));
		prcfmtemp.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		prcfmtemp.put("DT_PR_NO",   gridInfo.get("PR_NO"));
		prcfmtemp.put("DT_PR_SEQ",  gridInfo.get("PR_SEQ"));
		
		prcfmdata.add(prcfmtemp);
		
    	return prcfmdata;
    }
    
    private List<Map<String, String>> setRfqCreateChkdata(List<Map<String, String>> chkdata, Map<String, String> gridInfo) throws Exception{
    	Map<String, String> chktemp = new HashMap<String, String>();
    	
    	chktemp.put("DT_ITEM_NO", gridInfo.get("ITEM_NO"));
		
		chkdata.add(chktemp);
		
		return chkdata;
    }
    
    private List<Map<String, String>> setRfqCreatePrhddata(SepoaInfo info, Map<String, String> header, String rfqNo) throws Exception{
    	List<Map<String, String>> prhddata        = new ArrayList<Map<String, String>>();
    	Map<String, String>       prhdtemp        = new HashMap<String, String>();
    	String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
    	String                    id              = info.getSession("ID");
    	String                    nameLoc         = info.getSession("NAME_LOC");
    	String                    tel             = info.getSession("tel");
    	
    	prhdtemp.put("HOUSE_CODE",       info.getSession("HOUSE_CODE"));
		prhdtemp.put("PR_NO",            rfqNo);
		prhdtemp.put("STATUS",           "C");
		prhdtemp.put("COMPANY_CODE",     info.getSession("COMPANY_CODE"));
		prhdtemp.put("PLANT_CODE",       info.getSession("DEPARTMENT"));
		prhdtemp.put("PR_TYPE",          header.get("I_PR_TYPE"));
		prhdtemp.put("SIGN_STATUS",      "E");
		prhdtemp.put("SIGN_DATE",        shortDateString);
		prhdtemp.put("SIGN_PERSON_ID",   id);
		prhdtemp.put("SIGN_PERSON_NAME", nameLoc);
		prhdtemp.put("TEL_NO",           tel);
		prhdtemp.put("SUBJECT",          header.get("I_SUBJECT"));
		prhdtemp.put("REQ_TYPE",         "M");
		prhdtemp.put("ADD_DATE",         shortDateString);
		prhdtemp.put("ADD_TIME",         shortTimeString);
		prhdtemp.put("ADD_USER_ID",      id);
		prhdtemp.put("CHANGE_DATE",      shortDateString);
		prhdtemp.put("CHANGE_TIME",      shortTimeString);
		prhdtemp.put("CHANGE_USER_ID",   id);
		prhdtemp.put("DEMAND_DEPT_NAME", info.getSession("DEPARTMENT_NAME_LOC"));
		prhdtemp.put("DELY_TO_USER",     nameLoc);
		prhdtemp.put("DELY_TO_PHONE",    tel);
		
		prhddata.add(prhdtemp);
    	
    	return prhddata;
    }
    
    private List<Map<String, String>> setRfqCreateRqhddata(SepoaInfo info, Map<String, String> header, String rfqNo, String iRfgFlag, String signStatus) throws Exception{
    	List<Map<String, String>> rqhddata        = new ArrayList<Map<String, String>>();
    	Map<String, String>       rqhdtemp        = new HashMap<String, String>();
    	String                    id              = info.getSession("ID");
    	String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
    	
    	rqhdtemp.put("HOUSE_CODE",       info.getSession("HOUSE_CODE"));
		rqhdtemp.put("RFQ_NO",           rfqNo);
		rqhdtemp.put("RFQ_COUNT",        "1");
		rqhdtemp.put("STATUS",           "C");
		rqhdtemp.put("COMPANY_CODE",     info.getSession("COMPANY_CODE"));
		rqhdtemp.put("RFQ_DATE",         shortDateString);
		rqhdtemp.put("RFQ_CLOSE_DATE",   header.get("I_RFQ_CLOSE_DATE"));
		rqhdtemp.put("RFQ_CLOSE_TIME",   header.get("I_RFQ_CLOSE_TIME"));
		rqhdtemp.put("RFQ_TYPE",         header.get("I_RFQ_TYPE"));
		rqhdtemp.put("PC_REASON",        header.get("I_PC_REASON"));
		rqhdtemp.put("SETTLE_TYPE",      header.get("I_SETTLE_TYPE"));
		rqhdtemp.put("BID_TYPE",         "RQ");
		rqhdtemp.put("RFQ_FLAG",         iRfgFlag);
		rqhdtemp.put("TERM_CHANGE_FLAG", "");
		rqhdtemp.put("CREATE_TYPE",      header.get("I_CREATE_TYPE"));
		rqhdtemp.put("BID_COUNT",        "0");
		rqhdtemp.put("CTRL_CODE",        header.get("I_CTRL_CODE"));
		rqhdtemp.put("ADD_USER_ID",      id);
		rqhdtemp.put("ADD_DATE",         shortDateString);
		rqhdtemp.put("ADD_TIME",         shortTimeString);
		rqhdtemp.put("CHANGE_DATE",      shortDateString);
		rqhdtemp.put("CHANGE_TIME",      shortTimeString);
		rqhdtemp.put("CHANGE_USER_ID",   id);
		rqhdtemp.put("SUBJECT",          header.get("I_SUBJECT"));
		rqhdtemp.put("REMARK",           header.get("I_REMARK"));
		rqhdtemp.put("DOM_EXP_FLAG",     "");
		rqhdtemp.put("ARRIVAL_PORT",     "");
		rqhdtemp.put("USANCE_DAYS",      "");
		rqhdtemp.put("SHIPPING_METHOD",  "");
		rqhdtemp.put("PAY_TERMS",        header.get("I_PAY_TERMS"));
		// HOUSE_CODE
		rqhdtemp.put("ARRIVAL_PORT_NAME",  "");
		rqhdtemp.put("DELY_TERMS",         header.get("I_DELY_TERMS"));
		rqhdtemp.put("PRICE_TYPE",         "");
		rqhdtemp.put("SETTLE_COUNT",       "0");
		rqhdtemp.put("RESERVE_PRICE",      "0");
		rqhdtemp.put("CURRENT_PRICE",      "0");
		rqhdtemp.put("BID_DEC_AMT",        "0");
		rqhdtemp.put("TEL_NO",             "");
		rqhdtemp.put("EMAIL",              "");
		rqhdtemp.put("BD_TYPE",            "");
		rqhdtemp.put("CUR",                "");
		rqhdtemp.put("START_DATE",         "");
		rqhdtemp.put("START_TIME",         "");
		rqhdtemp.put("sms_yn",             "");
		rqhdtemp.put("z_result_open_flag", "");
		rqhdtemp.put("BID_REQ_TYPE",       header.get("I_PR_TYPE"));
		//CREATE_TYPE
		rqhdtemp.put("H_ATTACH_NO",        header.get("I_ATTACH_NO"));
		rqhdtemp.put("SIGN_STATUS",        signStatus);
		
		rqhddata.add(rqhdtemp);
    	
    	return rqhddata;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap setRfqCreateMessage(SepoaInfo info) throws Exception{
    	Vector  multilangId = new Vector();
    	HashMap message     = null;
    	
    	multilangId.addElement("MESSAGE");
    	   
    	message = MessageUtil.getMessage(info, multilangId);
    	
    	return message;
    }
    
    @SuppressWarnings("rawtypes")
	private GridData setRfqCreateGdRes(SepoaOut value, HashMap message) throws Exception{
    	GridData gdRes = new GridData();
    	
    	gdRes.addParam("mode", "doSave");
		gdRes.setSelectable(false);
		
    	if(value.flag) {
			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
			gdRes.setStatus("true");
		}
		else {
			gdRes.setMessage(value.message);
			gdRes.setStatus("false");
		}
    	
    	return gdRes;
    }
    
    private String setRfqCreateRfqNo(SepoaInfo info) throws Exception{
    	String   result = null;
    	SepoaOut wo2    = null;
    	
    	wo2    = DocumentUtil.getDocNumber(info, "RQ");
    	result = wo2.result[0];
    	
    	return result;
    }
    
    private String setRfqCreateIRfgFlag(String iRfgFlag) throws Exception{
    	String result = null;
    	
    	iRfgFlag = this.nvl(iRfgFlag);
    	
    	if ("T".equals(iRfgFlag)) { // 작성중
    		result   = "T"; // 작성중
		}
		else if ("P".equals(iRfgFlag)) { // 결재요청
			result   = "B"; // 결재중
		}
		else { // 업체전송
			result   = "C"; // 견적중
		}
    	
    	return result;
    }
    
    private String setRfqCreateSignStatus(String iRfgFlag) throws Exception{
    	String result = null;
    	
    	iRfgFlag = this.nvl(iRfgFlag);
    	
    	if ("T".equals(iRfgFlag)) { // 작성중
    		result = "T"; // 작성중
		}
		else if ("P".equals(iRfgFlag)) { // 결재요청
			result = "P"; // 결재중
		}
		else { // 업체전송
			result = "E"; // 결재완료
		}
    	
    	return result;
    }
    
	
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
	
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if("".equals(str)){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
	
	private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
	}
}