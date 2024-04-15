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
import sepoa.fw.util.SepoaCombo;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class rfq_pp_ins3 extends HttpServlet{
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
    		
    		if("re_getRfqDTDisplay".equals(mode)){						// 품목 그리드 조회
    			gdRes = this.re_getRfqDTDisplay(gdReq, info);
    		}else if("setRfqChange".equals(mode)){					// 업체 전송 수정 임시저장(rfq_flag:T) 업체전송(rfq_flag:E) 
    			//gdRes = this.setRfqChange(gdReq, info);
    		}else if("setRfqItemDelete".equals(mode)){				// 견적요청정보 삭제
    			//gdRes = this.setRfqItemDelete(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage(e.getMessage());
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
    
	/**
     * 견적요청 품목 정보 조회 
     * getRfqDTDisplay
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-09-03
     * @modify 2014-09-30
     */
 
    private GridData re_getRfqDTDisplay(GridData gdReq, SepoaInfo info) throws Exception {
    	GridData            gdRes        = new GridData();
	    SepoaFormater       sf           = null;
	    SepoaOut            value        = null;
	    Vector              v            = new Vector();
	    HashMap             message      = null;
	    Map<String, Object> allData      = null;
	    Map<String, String> header       = null;
	    String              gridColId    = null;
	    String              addDateStart = null;
	    String              addDateEnd   = null;
	    String[]            gridColAry   = null;
	    int                 rowCount     = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
        
        try{
        	allData      = SepoaDataMapper.getData(info, gdReq);
	    	header       = MapUtils.getMap(allData, "headerData");
	    	gridColId    = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry   = SepoaString.parser(gridColId, ",");
	    	gdRes        = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
   			
   			gdRes.addParam("mode", "doQuery");
   			
   			
            Object[] obj = {header};
            value        = ServiceConnector.doService(info, "p1004", "CONNECTION", "re_getRfqDTDisplay", obj);
//System.out.println("debug:header:"+header);            
//System.out.println("debug:value:"+value);            
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
	
    
    @SuppressWarnings("unchecked")
	private Map<String, Object> getGridInfoParamList(SepoaInfo info, Map<String, Object> data, String rfqNo, String rfqCount) throws Exception{
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
    	
		
		int i = 0;
		
    	for(i = 0; i < grid.size(); i++){
			servletParam = new HashMap<String, Object>();
			
			gridInfo       = grid.get(i);
			dtTbeNo        = gridInfo.get("TBE_NO");
			techniqueGrade = gridInfo.get("TECHNIQUE_GRADE");
			techniqueType  = gridInfo.get("TECHNIQUE_TYPE");
			techniqueFlag  = gridInfo.get("TECHNIQUE_FLAG");
			
			
			
			chkdata        = this.setRfqChangeChkdata(chkdata, gridInfo);
			prcfmdata      = this.setRfqChangePrcfmdata(info, prcfmdata, gridInfo);
			
			
			if("".equals(dtTbeNo)){
				tbeFlag = "Y";
			}
			
			if("I".equals(iPrType)){
				techniqueGrade = "";
				techniqueType  = "";
				techniqueFlag  = "";
			}
			
			
			rfqSeq = String.valueOf(i + 1);
			
			
			servletParam.put("info",           info);
			servletParam.put("rfqNo",          rfqNo);
			servletParam.put("rfqCount",       rfqCount);
			servletParam.put("rfqSeq",         rfqSeq);
			servletParam.put("gridInfo",       gridInfo);
			servletParam.put("tbeFlag",        tbeFlag);
			servletParam.put("shipperType",    shipperType);
			servletParam.put("techniqueGrade", techniqueGrade);
			servletParam.put("techniqueType",  techniqueType);
			servletParam.put("techniqueFlag",  techniqueFlag);
			servletParam.put("rqdtdata",       rqdtdata);
			
			
			
			if("MA".equals(iCreateType) == false){	//입력대행
				
				rqdtdata = this.setRfqChangeRqdtdataICreateTypeNotMA(servletParam);
			}
			else{	//지명,공개,수의
				
				
				rqdtdata = this.setRfqChangeRqdtdataICreateTypeMA(servletParam);
			}
			
			
			prdtdata = this.setRfqChangePrdtdata(prdtdata, gridInfo, info, iCtrlCode, rfqNo, rfqCount, rfqSeq);
			rqopdata = this.setRfqChangeRqopdata(info, rfqNo, rfqCount, rfqSeq, gridInfo, rqopdata);
			rqsedata = this.setRfqChangeRqsedata(info, gridInfo, rfqNo, rfqCount, rfqSeq, rqsedata);  
			
			
			rqepdata = this.setRfqChangeRqepdata(gridInfo, info, rfqNo, rfqCount, rfqSeq, rqepdata);
			
			
			
			
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
    
    private List<Map<String, String>> setRfqChangeRqandata(SepoaInfo info, String rfqNo, String rfqCount, String iSzdate, Map<String, String> header, List<Map<String, String>> rqandata) throws Exception{
    	Map<String, String> rqantemp        = new HashMap<String, String>();
		String              shortDateString = SepoaDate.getShortDateString();
		String              shortTimeString = SepoaDate.getShortTimeString();
		String              id              = info.getSession("ID");
		
		rqantemp.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		rqantemp.put("RFQ_NO",             rfqNo);
		rqantemp.put("RFQ_COUNT",          rfqCount);
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
    
    private List<Map<String, String>> setRfqChangeRqepdata(Map<String, String> gridInfo, SepoaInfo info, String rfqNo, String rfqCount, String rfqSeq, List<Map<String, String>> rqepdata) throws Exception{
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
				tmpRqep.put("RFQ_COUNT",        rfqCount);
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
    
    private List<Map<String, String>> setRfqChangeRqsedata(SepoaInfo info, Map<String, String> gridInfo, String rfqNo, String rfqCount, String rfqSeq, List<Map<String, String>> rqsedata) throws Exception{
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
			tmpRqse.put("RFQ_COUNT",       rfqCount);
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
    
    private List<Map<String, String>> setRfqChangeRqopdata(SepoaInfo info, String rfqNo, String rfqCount, String rfqSeq, Map<String, String> gridInfo, List<Map<String, String>> rqopdata) throws Exception{
		
    	String              dtVendorSelectedReason    = gridInfo.get("VENDOR_SELECTED_REASON");
		String              vendorDatasFirstTrim      = null;
    	String              id                        = info.getSession("ID");
    	String              houseCode                 = info.getSession("HOUSE_CODE");
		String              shortDateString           = SepoaDate.getShortDateString();
		String              shortTimeString           = SepoaDate.getShortTimeString();
		String              dtPurchaseLocation        = gridInfo.get("PURCHASE_LOCATION");
		
		
		String[] vendorSelectedDatas = CommonUtil.getTokenData(dtVendorSelectedReason, "#");
		
		String[]            vendorDatas               = null;
		Map<String, String> tmpRqop                   = null;
		//int                 vendorSelectedDatasLength = vendorSelectedDatas.length;
		int                 j                         = 0;
		
		dtPurchaseLocation = JSPUtil.nullToRef(dtPurchaseLocation, "01");
		
    	for(j = 0; j < vendorSelectedDatas.length; j++){
    		
    		tmpRqop = new HashMap<String, String>();
    		
    		//vendorSelectedDatasInfo = vendorSelectedDatas[j];
			vendorDatas             = CommonUtil.getTokenData(vendorSelectedDatas[j], "@");
			vendorDatasFirstTrim    = vendorDatas[0].trim();
			tmpRqop.put("HOUSE_CODE",        houseCode);
			tmpRqop.put("RFQ_NO",            rfqNo);
			tmpRqop.put("RFQ_COUNT",         rfqCount);
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
    
    private List<Map<String, String>> setRfqChangePrdtdata(List<Map<String, String>> prdtdata, Map<String, String> gridInfo, SepoaInfo info, String iCtrlCode, String rfqNo, String brfqCount, String rfqSeq) throws Exception{
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
	private List<Map<String, String>> setRfqChangeRqdtdataICreateTypeMA(Map<String, Object> param) throws Exception{
    	SepoaInfo                 info            = (SepoaInfo)param.get("info");
    	List<Map<String, String>> rqdtdata        = (List<Map<String, String>>)param.get("rqdtdata");
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
	private List<Map<String, String>> setRfqChangeRqdtdataICreateTypeNotMA(Map<String, Object> param) throws Exception{
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
    
    private List<Map<String, String>> setRfqChangePrcfmdata(SepoaInfo info, List<Map<String, String>> prcfmdata, Map<String, String> gridInfo) throws Exception{
    	Map<String, String>       prcfmtemp       = new HashMap<String, String>();
    	
    	prcfmtemp.put("DT_RFQ_QTY", gridInfo.get("RFQ_QTY"));
		prcfmtemp.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
		prcfmtemp.put("DT_PR_NO",   gridInfo.get("PR_NO"));
		prcfmtemp.put("DT_PR_SEQ",  gridInfo.get("PR_SEQ"));
		
		prcfmdata.add(prcfmtemp);
		
    	return prcfmdata;
    }
    
    private List<Map<String, String>> setRfqChangeChkdata(List<Map<String, String>> chkdata, Map<String, String> gridInfo) throws Exception{
    	Map<String, String> chktemp = new HashMap<String, String>();
    	
    	chktemp.put("DT_ITEM_NO", gridInfo.get("ITEM_NO"));
		
		chkdata.add(chktemp);
		
		return chkdata;
    }
    
    private List<Map<String, String>> setRfqChangePrhddata(SepoaInfo info, Map<String, String> header, String rfqNo, String rfqCount) throws Exception{
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
    
    private List<Map<String, String>> setRfqChangeRqhddata(SepoaInfo info, Map<String, String> header, String rfqNo, String rfqCount, String iRfgFlag, String signStatus) throws Exception{
    	List<Map<String, String>> rqhddata        = new ArrayList<Map<String, String>>();
    	Map<String, String>       rqhdtemp        = new HashMap<String, String>();
    	String                    id              = info.getSession("ID");
    	String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
    	
    	rqhdtemp.put("HOUSE_CODE",       info.getSession("HOUSE_CODE"));
		rqhdtemp.put("RFQ_NO",           rfqNo);
		rqhdtemp.put("RFQ_COUNT",        rfqCount);
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
		rqhdtemp.put("Z_RESULT_OPEN_FLAG", "");
		rqhdtemp.put("BID_REQ_TYPE",       header.get("I_PR_TYPE"));
		//CREATE_TYPE
		rqhdtemp.put("H_ATTACH_NO",        header.get("I_ATTACH_NO"));
		rqhdtemp.put("SIGN_STATUS",        signStatus);
		
		rqhddata.add(rqhdtemp);
    	
    	return rqhddata;
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