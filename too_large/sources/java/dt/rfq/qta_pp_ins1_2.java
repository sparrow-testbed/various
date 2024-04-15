package dt.rfq;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

import com.icompia.util.CommonUtil;

public class qta_pp_ins1_2 extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException{Logger.debug.println();}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException{
		doPost(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		
		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = null;
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
        
		
		try{
			
			gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));

			if ("getDocBaseQtaCompareDT".equals(mode)){					// 총액별 견적비교 품목 정보 조회
				gdRes = getDocBaseQtaCompareDT(gdReq,info);
			}else if ("setDocTotalSave".equals(mode)){					// 총액별 견적비교 업체 선정
				gdRes = setDocTotalSave(gdReq,info);
			}else if ("setReturnToPR_DOC_ALL".equals(mode)){			// 총액별 견적비교 구매복구(청구복구) 선정
				gdRes = setReturnToPR_DOC_ALL(gdReq,info);
			}
			
			
			
			
			
			
	       		
		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
        	gdRes.setStatus("false"); 
        	
        } finally {
        	try {
        		OperateGridData.write(req, res, gdRes, out);
        	} catch (Exception e) {
        		Logger.debug.println();
        	}
        }
	}
	
	
	/**
	 * 총액별 견적비교 구매복구
	 * setReturnToPR_DOC_ALL
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private GridData setReturnToPR_DOC_ALL(GridData gdReq, SepoaInfo info) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 총액별 견적비교 업체선정
	 * setDocTotalSave
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private GridData setDocTotalSave(GridData gdReq, SepoaInfo info) throws Exception{
		GridData                  gdRes           = new GridData();
        HashMap                   message         = null;
        SepoaOut                  value           = null;
        Map<String, Object>       data            = null;
        Map<String, String>       header          = null;
        Map<String, String>       gridInfo        = null;
        
        
        List<Map<String, String>> rqdtData        = new ArrayList<Map<String, String>>();
		List<Map<String, String>> rqdtResData     = new ArrayList<Map<String, String>>();
		List<Map<String, String>> delRqopData     = new ArrayList<Map<String, String>>();
		List<Map<String, String>> rqopData        = new ArrayList<Map<String, String>>();
		List<Map<String, String>> qtdtData        = new ArrayList<Map<String, String>>();
		List<Map<String, String>> prData          = new ArrayList<Map<String, String>>();
        
		Map<String, Object> paramData             = new HashMap<String, Object>();
	       
        Vector                    multilangId     = new Vector();
        multilangId.addElement("MESSAGE");
        message = MessageUtil.getMessage(info, multilangId);
        
        
        
        try {
        	gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);

    		data                              = SepoaDataMapper.getData(info, gdReq);
    		header                            = MapUtils.getMap(data, "headerData"); // 헤더 정보 조회
    		List<Map<String, String>> grid    = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
            
			String rfq_no       	= header.get("rfq_no");
	        String rfq_count    	= header.get("rfq_count");
	        String vendor_code  	= header.get("vendor_code");
	        String remark  			= header.get("remark");
	        String settle_attach_no = header.get("settle_attach_no");	
	        
	        Map<String, Object>       param   = null;
            
            int tmpRqopCnt = 0;
			int ins_count = 0;

			//String dt_auto_po_flag   = "";
			//String dt_contract_flag  = "";
			String rfq_seq           = "";
			String prNo              = "";
			String prSeq             = "";
			//String purchaseLocation  = "";
			
            //for start
            for(int i = 0; i < grid.size(); i++){
                //servletParam = new HashMap<String, Object>();
                gridInfo                   = grid.get(i);
                
                //String[] PURCHASE_LOCATION = CommonUtil.getTokenData(gridInfo.get("PURCHASE_LOCATION"), ":");
            	//tmpRqopCnt += ( PURCHASE_LOCATION.length);
                //dt_auto_po_flag   = CommonUtil.RepToStr(gridInfo.get("DT_AUTO_PO_FLAG"), "Y", "N");
				//dt_contract_flag  = CommonUtil.RepToStr(gridInfo.get("DT_CONTRACT_FLAG"), "Y", "N");
//				  rfq_seq           = gridInfo.get("RFQ_SEQ");
//                prNo              = gridInfo.get("PR_NO");            
//                prSeq             = gridInfo.get("PR_SEQ");           				
//                purchaseLocation  = gridInfo.get("PURCHASE_LOCATION");				
            }
            
            rqdtData        = this.setDocTotalSaveRqdtData   (rqdtData, info, grid, rfq_no, rfq_count);                                         //견적의뢰 상세정보 ICOYRQDT
            rqdtResData     = this.setDOcTotalSaveRqdtResData(rqdtResData, info, grid, rfq_no, rfq_count, vendor_code);
            delRqopData     = this.setDOcTotalSaveDelRqopData(delRqopData, info, grid, rfq_no, rfq_count, vendor_code);															   //견적의뢰 단가 구매지역 정보 삭제 (ICOYRQOP)
            rqopData        = this.setDOcTotalSaveRqopData   (rqopData, info, grid, rfq_no, rfq_count, vendor_code); 			               //견적의뢰 단가 구매지역 정보 입력 (ICOYRQOP)
            qtdtData        = this.setDOcTotalSaveQtdtData   (qtdtData, info, grid, rfq_no, rfq_count, vendor_code, remark, settle_attach_no);              
            prData          = this.setDOcTotalSavePrData     (prData, info, grid);
            
            paramData.put("RFQ_NO"          , rfq_no);
            paramData.put("RFQ_COUNT"       , rfq_count);
            paramData.put("rqdtData"        , rqdtData);
            paramData.put("rqdtResData"     , rqdtResData);
            paramData.put("delRqopData"     , delRqopData);
            paramData.put("rqopData"        , rqopData);
            paramData.put("qtdtData"        , qtdtData);
            paramData.put("prData"          , prData);

            Object[] obj = {paramData};
            
            value = ServiceConnector.doService(info, "p1072", "TRANSACTION", "setDocTotalSave", obj);
    
            if(value.flag) {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else {
                gdRes.setMessage(value.message);
                gdRes.setStatus("false");
            }
            
        }
        catch(Exception e){
            
        	gdRes = new GridData();
            
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        
        return gdRes;
	}

	
	/**
	 * 
	 * setDOcTotalSavePrData
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private List<Map<String, String>> setDOcTotalSavePrData(List<Map<String, String>> prData, SepoaInfo info, List<Map<String, String>> grid) {

        Map<String, String>       tmp_prData     = null;
        Map<String, String>       gridInfo       = new HashMap<String, String>();
		
		
		for(int i=0;i<grid.size();i++){
			tmp_prData     = new HashMap<String, String>();
			gridInfo = grid.get(i);
			
			tmp_prData.put("PR_NO"                        , gridInfo.get("PR_NO"));    
			tmp_prData.put("PR_SEQ"                       , gridInfo.get("PR_SEQ"));
			
			prData.add(tmp_prData);
		}

       return prData;
		
	}

	/**
	 * 
	 * setDOcTotalSaveQtdtData
	 * @param settle_attach_no 
	 * @param remark 
	 * @param string 
	 * @param vendor_code 
	 * @param dt_rfq_seq 
	 * @param rfq_count 
	 * @param rfq_no 
	 * @param gridInfo 
	 * @param info 
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private List<Map<String, String>> setDOcTotalSaveQtdtData(List<Map<String, String>> qtdtData, SepoaInfo info, List<Map<String, String>> grid, String rfq_no, String rfq_count, String vendor_code, String remark, String settle_attach_no) {
		
        Map<String, String>       tmp_qtdtData     = null;
        Map<String, String>       gridInfo         = new HashMap<String, String>();
        
        
	    for(int i=0;i<grid.size();i++){    
	    	tmp_qtdtData     = new HashMap<String, String>();
	    	gridInfo = grid.get(i);
	    	
	        tmp_qtdtData.put("RFQ_NO"                          , rfq_no);    
	        tmp_qtdtData.put("RFQ_COUNT"                       , rfq_count);    
	        tmp_qtdtData.put("RFQ_SEQ"                         , gridInfo.get("RFQ_SEQ"));    
	        tmp_qtdtData.put("VENDOR_CODE"                     , vendor_code);    
	        tmp_qtdtData.put("QUOTA_PERCENT"                   , "");    
	        tmp_qtdtData.put("ITEM_QTY"                        , gridInfo.get("ITEM_QTY"));    
	        tmp_qtdtData.put("MOLDING_TYPE"                    , gridInfo.get("MOLDING_TYPE"));    
	        tmp_qtdtData.put("SETTLE_REMARK"                   , remark);    
	        tmp_qtdtData.put("SETTLE_ATTACH_NO"                , settle_attach_no);    
	
	        qtdtData.add(tmp_qtdtData);    
	    }
       return qtdtData;
		
		
	}
	
	/**
	 * 
	 * setDOcTotalSaveRqopData
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private List<Map<String, String>> setDOcTotalSaveRqopData(List<Map<String, String>> rqopData, SepoaInfo info, List<Map<String, String>> grid, String rfq_no, String rfq_count, String vendor_code) {
		
        Map<String, String>       tmp_rqopData     = null;
        Map<String, String>       gridInfo         = new HashMap<String, String>();
        
        // rqop insert data
		
		for(int i=0;i<grid.size();i++){
			tmp_rqopData     = new HashMap<String, String>();
			gridInfo = grid.get(i);
			String[] PURCHASE_LOCATION = CommonUtil.getTokenData(gridInfo.get("PURCHASE_LOCATION"), ":");
		    
	        for(int j=0; j < PURCHASE_LOCATION.length; j++) {
	        	
		        tmp_rqopData.put("RFQ_NO"                          , rfq_no);    
		        tmp_rqopData.put("RFQ_COUNT"                       , rfq_count);    
		        tmp_rqopData.put("RFQ_SEQ"                         , gridInfo.get("RFQ_SEQ"));    
		        tmp_rqopData.put("VENDOR_CODE"                     , vendor_code);    
		        tmp_rqopData.put("PURCHASE_LOCATION"               , PURCHASE_LOCATION[j]);    
		        tmp_rqopData.put("ADD_USER_ID"                     , info.getSession("ID"));    
		        //tmp_rqopData.put("ADD_DATE"                        , SepoaDate.getShortDateString());    
		        //tmp_rqopData.put("ADD_TIME"                        , SepoaDate.getShortTimeString());    
		        tmp_rqopData.put("VENDOR_CODE"                     , vendor_code);    
		        tmp_rqopData.put("STATUS"                          , "C");    
		
		        rqopData.add(tmp_rqopData);    
		     
	        }
		}
       
       return rqopData;
		
	}

	/**
	 * 
	 * setDOcTotalSaveDelRqopData
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private List<Map<String, String>> setDOcTotalSaveDelRqopData(List<Map<String, String>> delRqopData, SepoaInfo info, List<Map<String, String>> grid, String rfq_no,
			String rfq_count, String vendor_code) {
		
        Map<String, String>       tmp_delRqopData     = null;
        Map<String, String>       gridInfo            = new HashMap<String, String>();
        
        for(int i=0;i<grid.size();i++){
        	tmp_delRqopData     = new HashMap<String, String>();
        	gridInfo = grid.get(i);
        	
	        tmp_delRqopData.put("RFQ_NO"                          , rfq_no);    
	        tmp_delRqopData.put("RFQ_COUNT"                       , rfq_count);    
	        tmp_delRqopData.put("RFQ_SEQ"                         , gridInfo.get("RFQ_SEQ"));    
	        tmp_delRqopData.put("VENDOR_CODE"                     , vendor_code);    
	
	        delRqopData.add(tmp_delRqopData);    
        }
       return delRqopData;
		
	}

	/**
	 * 
	 * setDOcTotalSaveRqdtResData
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private List<Map<String, String>> setDOcTotalSaveRqdtResData(List<Map<String, String>> rqdtResData, SepoaInfo info, List<Map<String, String>> grid, String rfq_no,
			String rfq_count, String vendor_code) {
        Map<String, String>       tmp_rqdtResData     = null;
        Map<String, String>       gridInfo            = new HashMap<String, String>();
        
        for(int i=0;i<grid.size();i++){
        	tmp_rqdtResData     = new HashMap<String, String>();
        	gridInfo = grid.get(i);
        	
	        tmp_rqdtResData.put("RFQ_NO"           , rfq_no);    
	        tmp_rqdtResData.put("RFQ_COUNT"        , rfq_count);    
	        tmp_rqdtResData.put("RFQ_SEQ"          , gridInfo.get("RFQ_SEQ"));    
	        tmp_rqdtResData.put("VENDOR_CODE"      , vendor_code);    

			rqdtResData.add(tmp_rqdtResData);
	        
        }
       return rqdtResData;
	}

	/**
	 * 
	 * setDocTotalSaveRqdtData
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private List<Map<String, String>> setDocTotalSaveRqdtData(List<Map<String, String>> rqdtData, SepoaInfo info,
			List<Map<String, String>> grid, String rfq_no, String rfq_count) throws Exception {
		Map<String, String>       tmp_rqdtData    = null;
        Map<String, String>       gridInfo        = new HashMap<String, String>();
       
       for(int i=0;i<grid.size();i++){ 
    	   tmp_rqdtData    = new HashMap<String, String>();
    	   gridInfo = grid.get(i);

    	   tmp_rqdtData.put("AUTO_PO_FLAG"                 , this.RepToStr2(gridInfo.get("AUTO_PO_FLAG"), "Y", "N"));    
    	   tmp_rqdtData.put("CONTRACT_FLAG"                , this.RepToStr2(gridInfo.get("CONTRACT_FLAG"), "Y", "N"));    
    	   tmp_rqdtData.put("RFQ_NO"                          , rfq_no);    
    	   tmp_rqdtData.put("RFQ_COUNT"                       , rfq_count);    
    	   tmp_rqdtData.put("RFQ_SEQ"                         , gridInfo.get("RFQ_SEQ"));    
	       rqdtData.add(tmp_rqdtData);    
       }
       
       return rqdtData;
		
	}

	
	/**
	 * 총액별 견적비교 품목 정보 조회
	 * getDocBaseQtaCompareDT
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private GridData getDocBaseQtaCompareDT(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
   	    Vector multilang_id 	= new Vector();
   	    multilang_id.addElement("MESSAGE");
   	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
   	
		SepoaFormater       sf              = null;
        Map<String, Object> allData         = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header          = null;
        SepoaOut            value           = null;
        String              grid_col_id     = null;
        String[]            grid_col_ary    = null;
        
        try{
        	allData         = SepoaDataMapper.getData(info, gdReq);	// 파라미터로 넘어온 모든 값 조회
        	header       = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
        	grid_col_id  = JSPUtil.CheckInjection(gdReq.getParam("cols_ids")).trim();
   			grid_col_ary = SepoaString.parser(grid_col_id, ",");
   			
   			gdRes        = OperateGridData.cloneResponseGridData(gdReq);
   			gdRes.addParam("mode", "doQuery");
   			
   			
   			
            Object[] obj = {header};
            // DB  : CONNECTION, TRANSACTION, NONDBJOB
            value        = ServiceConnector.doService(info, "p1072", "CONNECTION", "getDocBaseQtaCompareDT", obj);
   			if(value.flag) {
   			    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
   			    gdRes.setStatus("true");
   			} else {
   				gdRes.setMessage(value.message);
   				gdRes.setStatus("false");
   			    return gdRes;
   			}
   			
   			sf = new SepoaFormater(value.result[0]);
   			
   			if (sf.getRowCount() == 0) {
   			    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
   			    return gdRes;
   			}
   			
   			
   			for (int i = 0; i < sf.getRowCount(); i++) {
   				for(int k=0; k < grid_col_ary.length; k++) {

   	        		
   					if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
   			    		gdRes.addValue("SELECTED", "0");
   			    	//} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")) {
       	            //	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
   	   			    		
   			    	}else {
   			        	gdRes.addValue(grid_col_ary[k], sf.getValue(grid_col_ary[k], i));
   			        }
   			    	
   				}
   			}
   		    
   		} catch (Exception e) {
   		    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
   			gdRes.setStatus("false");
   	    }
   		
   		return gdRes;
	}
		
	
	
	
	
	
	
	
	
	
	
	
    /*public void doQuery(SepoaStream ws) throws Exception {
        //get session
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());

    	String HOUSE_CODE = info.getSession("HOUSE_CODE");
        String rfq_no       = ws.getParam("rfq_no");
        String rfq_count    = ws.getParam("rfq_count");
        String vendor_code  = ws.getParam("vendor_code");
        
        
        Object[] obj = {rfq_no, rfq_count, vendor_code};
        SepoaOut value = ServiceConnector.doService(info, "p1072", "CONNECTION", "getDocBaseQtaCompareDT", obj);
        
        SepoaFormater wf = ws.getSepoaFormater(value.result[0]);        
        
        sepoaservlet.SepoaCombo sepoacombo = new sepoaservlet.SepoaCombo(); 
        String cbo_flag[][] = sepoacombo.getCombo(ws.getRequest(), "SL0022", HOUSE_CODE+"#M181", "");
        String cbo_type[][] = sepoacombo.getCombo(ws.getRequest(), "SL0022", HOUSE_CODE+"#M170", "");
        String cbo_grade[][] = sepoacombo.getCombo(ws.getRequest(), "SL0022", HOUSE_CODE+"#M172", "");
        for(int i=0; i<wf.getRowCount(); i++) 
        {   
        	String[] sel_check   = {"true", ""};
        	String[] check       = {"false", ""};
            String[] img_item_no = {"", wf.getValue("ITEM_NO", i), wf.getValue("ITEM_NO", i)};
            
            String img_name = "";
            String tmp1 = wf.getValue("COST_COUNT", i);
            if(!tmp1.equals("0")) {
                img_name = "/kr/images/button/detail.gif";
            }
            String[] img_cost_count = {img_name,"",tmp1};
            
            String img_name2 = "";
            String tmp2 = wf.getValue("ATTACH_NO", i);
            if(!tmp2.equals("N") && tmp2.length() > 0) {
                img_name2 = "/kr/images/button/detail.gif";
            }
            String[] img_attach_no = {img_name2,wf.getValue("QTA_ATTACH_CNT", i),tmp2};
            
            img_name = "/kr/images/button/detail.gif";
            String[] img_purchase_location = {img_name,"Y",wf.getValue("PURCHASE_LOCATION", i)};

        	int iFlagIndex = CommonUtil.getComboIndex(cbo_flag, wf.getValue("TECHNIQUE_FLAG",i));
        	int iTypeIndex = CommonUtil.getComboIndex(cbo_type, wf.getValue("TECHNIQUE_TYPE",i));
        	int iGradeIndex = CommonUtil.getComboIndex(cbo_grade, wf.getValue("TECHNIQUE_GRADE",i));
        	
            ws.addValue("SELECTED",          sel_check,                          "");
            ws.addValue("ITEM_NO",           img_item_no,                        "");
            ws.addValue("DESCRIPTION_LOC",   wf.getValue("DESCRIPTION_LOC",  i), "");
            ws.addValue("SPECIFICATION",     wf.getValue("SPECIFICATION",    i), "");
            ws.addValue("MAKER_CODE",        wf.getValue("MAKER_CODE",       i), "");
            ws.addValue("MAKER_NAME",        wf.getValue("MAKER_NAME",       i), "");
            ws.addValue("ITEM_QTY",          wf.getValue("ITEM_QTY",         i), "");
            ws.addValue("UNIT_MEASURE",      wf.getValue("UNIT_MEASURE",     i), "");
            ws.addValue("F_UNIT_PRICE",      wf.getValue("F_UNIT_PRICE",     i), "");
            ws.addValue("CUSTOMER_PRICE",    wf.getValue("CUSTOMER_PRICE",   i), "");
            ws.addValue("CUSTOMER_AMT",      "0",                                "");
            ws.addValue("SUPPLY_PRICE",      wf.getValue("UNIT_PRICE",       i), "");
            ws.addValue("SUPPLY_AMT",        wf.getValue("ITEM_AMT",         i), "");
            ws.addValue("DISCOUNT",          wf.getValue("DISCOUNT",         i), "");
            ws.addValue("ITEM_AMT",          wf.getValue("ITEM_AMT",         i), "");
            ws.addValue("F_MOLDING_CHARGE",  wf.getValue("F_MOLDING_CHARGE", i), "");
            ws.addValue("MOLDING_CHARGE",    wf.getValue("MOLDING_CHARGE",   i), "");
            ws.addValue("L_MOLDING_CHARGE",  wf.getValue("L_MOLDING_CHARGE", i), "");
            ws.addValue("COST_COUNT",        img_cost_count,                     "");
            ws.addValue("ATTACH_NO",         img_attach_no,                      "");
            ws.addValue("PR_NO",             wf.getValue("PR_NO",            i), "");
            ws.addValue("RD_DATE",           wf.getValue("RD_DATE",          i), "");
            ws.addValue("PURCHASE_LOCATION", img_purchase_location,              "");
            ws.addValue("AUTO_PO_FLAG",      check,                              "");
            ws.addValue("CONTRACT_FLAG",     check,                              "");
            ws.addValue("DELIVERY_LT",       wf.getValue("DELIVERY_LT",      i), "");
            ws.addValue("PR_SEQ",            wf.getValue("PR_SEQ",           i), "");
            ws.addValue("RFQ_SEQ",           wf.getValue("RFQ_SEQ",          i), "");
            ws.addValue("SHIPPER_TYPE",      wf.getValue("SHIPPER_TYPE",     i), "");
            ws.addValue("QTA_NO",            wf.getValue("QTA_NO",           i), "");
            ws.addValue("QTA_SEQ",           wf.getValue("QTA_SEQ",          i), "");
            ws.addValue("VENDOR_CODE",       wf.getValue("VENDOR_CODE",      i), "");
            String cbo_z_sales_flag[][]    = {{"전체",""},{"일괄","01"},{"분할","02"}};
            ws.addValue("MOLDING_TYPE",     cbo_z_sales_flag,                    "", 0);
            ws.addValue("TECHNIQUE_GRADE",  cbo_grade,                           "", iGradeIndex);
            ws.addValue("TECHNIQUE_FLAG",   cbo_flag,                            "", iFlagIndex);
            ws.addValue("TECHNIQUE_TYPE",   cbo_type,                            "", iTypeIndex);
            ws.addValue("HUMAN_NAME_LOC",   wf.getValue("HUMAN_NAME_LOC",    i), "");
            ws.addValue("CUR",              wf.getValue("CUR",               i), "");
            ws.addValue("RATE"    	, wf.getValue("RATE"			,i), "");  
			ws.addValue("SEC_VENDOR_CODE"    	, wf.getValue("SEC_VENDOR_CODE"			,i), "");  
			ws.addValue("SEC_VENDOR_CODE_TEXT"  , wf.getValue("SEC_VENDOR_CODE_TEXT"	,i), "");
        }

        ws.setMessage(value.message);
        ws.write();   
    } // end of doQuery


    public void doData(SepoaStream ws) throws Exception {
    //get session
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());

          //get Parameter
        String mode = ws.getParam("mode");
        SepoaFormater wf = ws.getSepoaFormater();

        if(mode.equals("setDocTotalSave")) {

            String rfq_no       	= ws.getParam("rfq_no");
            String rfq_count    	= ws.getParam("rfq_count");
            String vendor_code  	= ws.getParam("vendor_code");
            String remark  			= ws.getParam("remark");
            String settle_attach_no = ws.getParam("settle_attach_no");
            
            String[] DT_ITEM_QTY          	= wf.getValue("ITEM_QTY") ;

            String[] DT_PURCHASE_LOCATION 	= wf.getValue("PURCHASE_LOCATION") ;
            String[] DT_AUTO_PO_FLAG      	= wf.getValue("AUTO_PO_FLAG") ;
            String[] DT_CONTRACT_FLAG     	= wf.getValue("CONTRACT_FLAG") ;
            String[] DT_RFQ_SEQ           	= wf.getValue("RFQ_SEQ") ;
			String[] MOLDING_TYPE           = wf.getValue("MOLDING_TYPE");   
			String[] PR_NO           		= wf.getValue("PR_NO");   
			String[] PR_SEQ           		= wf.getValue("PR_SEQ");   

            String[][] rqdtdata    = new String[wf.getRowCount()][]; 
			String[][] rqdtresdata = new String[wf.getRowCount()][];		
			String[][] delrqopdata = new String[wf.getRowCount()][];
			String[][] qtdtdata    = new String[wf.getRowCount()][];
			String[][] prdata    = new String[wf.getRowCount()][];

            int tmpRqopCnt = 0;
            for(int	i =	0 ;	i <	wf.getRowCount();	i++	) {
            	
                String[] PURCHASE_LOCATION = CommonUtil.getTokenData(DT_PURCHASE_LOCATION[i], ":");
            	tmpRqopCnt += ( PURCHASE_LOCATION.length);
            }
            
			String[][] rqopdata = new String[tmpRqopCnt][];
			int ins_count = 0;
			
            for (int i = 0; i< wf.getRowCount(); i++) 
            {
				String[] tmp_rqdtdata = 
				{
				    CommonUtil.RepToStr(DT_AUTO_PO_FLAG[i], "Y", "N")
				,	CommonUtil.RepToStr(DT_CONTRACT_FLAG[i], "Y", "N")
				,	info.getSession("HOUSE_CODE")
				,	rfq_no
				,	rfq_count
				,	DT_RFQ_SEQ[i]
						           
				};
				
				rqdtdata[i] = tmp_rqdtdata;
				
				String[] tmp_rqdtresdata = 
				{
				 	info.getSession("HOUSE_CODE")
				,	rfq_no
				,	rfq_count
				,	DT_RFQ_SEQ[i]
						           
				};
				
				rqdtresdata[i] = tmp_rqdtresdata;	
				
				String[] tmp_delrqopdata = 
				{
				 	info.getSession("HOUSE_CODE")
				,	rfq_no
				,	rfq_count
				,	DT_RFQ_SEQ[i]
				,   vendor_code		           
				};
				
				delrqopdata[i] = tmp_delrqopdata;		
				
				// rqop insert data
				String[] PURCHASE_LOCATION = CommonUtil.getTokenData(DT_PURCHASE_LOCATION[i], ":");

				for(int j=0; j < PURCHASE_LOCATION.length; j++) {

					String[] tmp_rqopdata = 
					{
					 	info.getSession("HOUSE_CODE")
					,	rfq_no
					,	rfq_count
					,	DT_RFQ_SEQ[i]
					,	PURCHASE_LOCATION[j]
					,   PURCHASE_LOCATION[j]
					,   vendor_code	
					,   "C"
                    ,	info.getSession("ID")
                    ,	SepoaDate.getShortDateString()
                    ,	SepoaDate.getShortTimeString()
                    
                    ,	SepoaDate.getShortDateString()
                    ,	SepoaDate.getShortTimeString()
                    ,	info.getSession("ID")
					};
					
					rqopdata[ins_count] = tmp_rqopdata;
					ins_count++;
				}
				
				String[] tmp_qtdtdata = 
				{
					"100"
			    ,	"100"
			    ,	SepoaDate.getShortDateString() 	                 
				,   MOLDING_TYPE[i]
				,	remark
				,	settle_attach_no
			    ,	info.getSession("HOUSE_CODE")
				,	rfq_no
				,	rfq_count
				,	DT_RFQ_SEQ[i]
				,   vendor_code		           
				};
				
				qtdtdata[i] = tmp_qtdtdata;	
				
				String[] tmp_prdata = 
				{
					 	info.getSession("HOUSE_CODE")
				 	, PR_NO[i]
					, PR_SEQ[i] 
						           
				};
				
				prdata[i] = tmp_prdata;	
				
            }

			Object[] obj = {rqdtdata, rqdtresdata, delrqopdata, rqopdata, qtdtdata, prdata
							, rfq_no, rfq_count}; 

            SepoaOut value = ServiceConnector.doService(info, "p1072", "TRANSACTION", "setDocTotalSave", obj);

            String[] exValue = new String[1];
            exValue[0] = value.message;
          
            ws.setUserObject(exValue);
            ws.setCode(String.valueOf(value.status));
            ws.setMessage(value.message);
            ws.write();
            
            try{
	            // SMS 전송         
				String[][] args = new String[1][2];
				args[0][0] = rfq_no;
				args[0][1] = String.valueOf(rfq_count);
	
				Object[] sms_args = {args};
	            ServiceConnector.doService(info, "SMS", "TRANSACTION", "S00006_1", sms_args);
			} catch (Exception e) {
				Logger.debug.println("mail error = " + e.getMessage());
				e.printStackTrace();
			}

        } else if(mode.equals("setReturnToPR_DOC_ALL")) { //DOC 청구복구

            String rfq_no       = ws.getParam("rfq_no");
            String rfq_count    = ws.getParam("rfq_count");
            
            String sr_reason    = ws.getParam("sr_reason");
            String sr_attach_no = ws.getParam("sr_attach_no");
            

            String[] PR_NO        = wf.getValue("PR_NO");
            String[] PR_SEQ       = wf.getValue("PR_SEQ");

            String prdt_data[][] = new String[wf.getRowCount()][];

            for (int i = 0; i<wf.getRowCount(); i++) 
            {
                String sPrdtData[] = {
										info.getSession("HOUSE_CODE"),
                                        PR_NO[i],
                                        PR_SEQ[i]
                                     };

                prdt_data[i] = sPrdtData;       
            }
            
            String[][] rqdtData = {{
            						info.getSession("HOUSE_CODE")
            					,	rfq_no
            					,	rfq_count
            						}};

            String[][] rqhdData = {{
            						sr_reason
            					,	sr_attach_no
								,	info.getSession("HOUSE_CODE")
								,	rfq_no
								,	rfq_count
									}};
            
			Object[] obj = {rqdtData, rqhdData, prdt_data}; 
		    SepoaOut value = ServiceConnector.doService(info, "p1072", "TRANSACTION", "setReturnToPR_DOC_ALL", obj);
		
		    String[] exValue = new String[1];
		    exValue[0] = value.message;
		  
		    ws.setUserObject(exValue);
		    ws.setCode(String.valueOf(value.status));
		    ws.setMessage(value.message);
		    ws.write();
        }
    }*/
	private String RepToStr2(String foo, String pos, String neg)
			throws Exception {
		if ((foo == null) || (foo.equals("null")) || (foo.equals(""))) {
			foo = "";
		} else if (foo.equals(true))
			foo = pos;
		else if (foo.equals(false))
			foo = neg;

		return foo;
	}

}