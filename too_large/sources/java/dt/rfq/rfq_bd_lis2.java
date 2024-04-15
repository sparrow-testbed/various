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

public class rfq_bd_lis2 extends HttpServlet{
	
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

			
			if ("getRfqResultList".equals(mode)){				// 견적결과 조회
				gdRes = getRfqResultList(gdReq,info);
			}else if("setReturnToSettle".equals(mode)){	// 선정 취소
				gdRes = setReturnToSettle(gdReq, info); 
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
     * 견적결과 조회 
     * 
     * @param getRfqResultList
     * @param info
     * @return GridData
     * @throws Exception
     */
	@SuppressWarnings("unchecked")
	private GridData getRfqResultList(GridData gdReq, SepoaInfo info) throws Exception{
	 	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> allData     = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header      = null;
        SepoaFormater       sf          = null;
    	String              grid_col_id = null;
        String[]            grid_col_ary= null;
       
    	multilangId.addElement("MESSAGE");
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		allData      = SepoaDataMapper.getData(info, gdReq);	// 파라미터로 넘어온 모든 값 조회
        	header       = MapUtils.getMap(allData, "headerData");
	    	grid_col_id  = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
   			grid_col_ary = SepoaString.parser(grid_col_id, ",");
   			
   			gdRes        = OperateGridData.cloneResponseGridData(gdReq);
   			gdRes.addParam("mode", "doQuery");
   			   			
   			header.put( "start_change_date".trim() , SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "start_change_date".trim(), "" ) ) );
   			header.put( "end_change_date".trim() , SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "end_change_date".trim(), "" ) ) );
   			
   			Object[] obj = {header};
    		value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqResultList", obj);

    		if(value.flag) {
    			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
    			gdRes.setStatus("true");
    		}
    		else {
    			gdRes.setMessage(value.message);
    			gdRes.setStatus("false");
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
   			    	}else {
   			        	gdRes.addValue(grid_col_ary[k], sf.getValue(grid_col_ary[k], i));
   			        }
   				}
   			}
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
	}
	
	/**
	 * 선정 취소 
	 * setReturnToSettle
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	@SuppressWarnings("unchecked")
	private GridData setReturnToSettle(GridData gdReq, SepoaInfo info) throws Exception {
		 GridData               gdRes                 = new GridData();
	    	Vector              multilangId           = new Vector();
	    	HashMap             message               = null;
	    	SepoaOut            value                 = null;
	    	Map<String, Object> data                  = null;
	   
	    	multilangId.addElement("MESSAGE");
	    	message = MessageUtil.getMessage(info, multilangId);

	    	Map<String, String>        gridInfo        = null;
	    	
	    	List<Map<String, String>> qtdtData        = null;
	    	List<Map<String, String>> rqdtData        = null;
	    	List<Map<String, String>> rqhdData        = null;
	    	List<Map<String, String>> prdtData        = null;
	        
	    	try {
	    		gdRes.addParam("mode", "doData");
	    		gdRes.setSelectable(false);
	    		data = SepoaDataMapper.getData(info, gdReq);
	    		

	    		List<Map<String, String>> grid    = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
	    		Map<String, Object> paramData     = new HashMap<String, Object>();
	    		
	    		String RFQ_NO     = "";
	    		String RFQ_COUNT  = "";
	    		String QTA_NO     = "";
	    		String PR_NO      = "";
	    		String PR_SEQ     = "";
	    		String ITEM_NO    = "";
	    		
	    		//for start
                for(int i = 0; i < grid.size(); i++){
                    
                    gridInfo                   = grid.get(i);
                    
                    RFQ_NO                     = gridInfo.get("RFQ_NO");
                    RFQ_COUNT                  = gridInfo.get("RFQ_COUNT");
                    QTA_NO                     = gridInfo.get("QTA_NO");
                    PR_NO                      = gridInfo.get("PR_NO");
                    PR_SEQ                     = gridInfo.get("PR_SEQ");
                    ITEM_NO                    = gridInfo.get("ITEM_NO");
                    
                    
                    qtdtData = this.setReturnToSettleQtdtData(RFQ_NO, RFQ_COUNT, QTA_NO); 						//견적서 상세정보
                    
                   
                    rqdtData = this.setReturnToSettleRqdtData(RFQ_NO, RFQ_COUNT, QTA_NO); 			//견적의뢰 상세정보
                    
                    rqhdData = this.setReturnToSettleRqhdData(RFQ_NO); 						//견적의뢰 일반정보
                    
                    prdtData = this.setReturnToSettlePrdtData(PR_NO, PR_SEQ); 				//구매요청 상세정보
                    
                    
                }// for end
                
                paramData.put("qtdtData", qtdtData);
                paramData.put("rqdtData", rqdtData);
                paramData.put("rqhdData", rqhdData);
                paramData.put("prdtData", prdtData);
                
	    		//Object[] obj = {data};
                Object[] obj   = {paramData};
	    		value = ServiceConnector.doService(info, "p1072", "TRANSACTION", "setReturnToSettle2", obj);

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
	    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
	    		gdRes.setStatus("false");
	    	}
	    	
	    	return gdRes;
		
        
	}

	/**
	 *  //구매요청 상세정보 선정 취소1 
	 * setReturnToSettlePrdtData
	 * @param PR_SEQ 
	 * @param PR_NO 
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	private List<Map<String, String>> setReturnToSettlePrdtData(String PR_NO, String PR_SEQ) {
		
		List<Map<String, String>> prdtData = new ArrayList<Map<String, String>>();
        Map<String, String> tmp_prdtData   = new HashMap<String, String>();
       
             tmp_prdtData.put("PR_NO"               , PR_NO);
             tmp_prdtData.put("PR_SEQ"              , PR_SEQ);
             prdtData.add(tmp_prdtData);
			
             return prdtData;
	}
	/**
	 * //견적의뢰 일반정보 선정 취소2 
	 * setReturnToSettleRqhdData
	 * @param RFQ_NO 
	 * @param  gdReq
	 * @param  info
	 * @return List<Map<String, String>>
	 * @throws Exception
	 * @since  2014-10-14
	 * @modify 2014-10-14
	 */
	private List<Map<String, String>> setReturnToSettleRqhdData(String RFQ_NO) {
		
		List<Map<String, String>> rqhdData = new ArrayList<Map<String, String>>();
        Map<String, String> tmp_rqhdData   = new HashMap<String, String>();
       
             tmp_rqhdData.put("RFQ_NO"               , RFQ_NO);
             rqhdData.add(tmp_rqhdData);
			
             return rqhdData;
	}
	/**
	 * //견적의뢰 상세정보 선정 취소3 
	 * setReturnToSettleRqdtData
	 * @param RFQ_COUNT 
	 * @param RFQ_NO 
	 * @param  gdReq
	 * @param  info
	 * @return List<Map<String, String>>
	 * @throws Exception
	 * @since  2014-10-14
	 * @modify 2014-10-14
	 */
	private List<Map<String, String>> setReturnToSettleRqdtData(String RFQ_NO, String RFQ_COUNT, String QTA_NO) {
		
		List<Map<String, String>> rqdtData = new ArrayList<Map<String, String>>();
        Map<String, String> tmp_rqdtData   = new HashMap<String, String>();
       
             tmp_rqdtData.put("RFQ_NO"               , RFQ_NO);
        	 tmp_rqdtData.put("RFQ_COUNT"            , RFQ_COUNT);
        	 tmp_rqdtData.put("QTA_NO"               , QTA_NO);
             rqdtData.add(tmp_rqdtData);
			
             return rqdtData;
	}
	/**
	 * //견적서 상세정보 선정 취소4 
	 * setReturnToSettleQtdtData
	 * @param QTA_NO 
	 * @param  gdReq
	 * @param  info
	 * @return List<Map<String, String>>
	 * @throws Exception
	 * @since  2014-10-14
	 * @modify 2014-10-14
	 */
	private List<Map<String, String>> setReturnToSettleQtdtData(String RFQ_NO, String RFQ_COUNT, String QTA_NO) {
		
		List<Map<String, String>> qtdtData = new ArrayList<Map<String, String>>();
        Map<String, String> tmp_qtdtData   = new HashMap<String, String>();
       
             tmp_qtdtData.put("RFQ_NO"               , RFQ_NO);
             tmp_qtdtData.put("RFQ_COUNT"            , RFQ_COUNT);
             tmp_qtdtData.put("QTA_NO"               , QTA_NO);
             qtdtData.add(tmp_qtdtData);
			
             return qtdtData;
	}
}