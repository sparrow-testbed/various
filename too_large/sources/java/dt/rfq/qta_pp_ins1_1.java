package dt.rfq;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
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
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaCombo;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class qta_pp_ins1_1  extends HttpServlet{
	
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

			if ("getDocBaseQtaCompareHD".equals(mode)){			// 총액별 견적비교 조회
				gdRes = getDocBaseQtaCompareHD(gdReq,info);
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
	 * 총액별 견적비교 조회
	 * getDocBaseQtaCompareHD
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-12
	 * @modify 2014-10-12
	 */
	private GridData getDocBaseQtaCompareHD(GridData gdReq, SepoaInfo info) throws Exception {
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
            value        = ServiceConnector.doService(info, "p1072", "CONNECTION", "getDocBaseQtaCompareHD", obj);
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

   	        		
   					if(grid_col_ary[k] != null && grid_col_ary[k].equals("SEL")) {
   			    		gdRes.addValue("SEL", "0");
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

        String mode = ws.getParam("mode");

        if(mode.equals("getDocBaseQtaCompareHD")) { //Doc Base 견적비교
        //get Parameter

            String rfq_no       = ws.getParam("rfq_no");
            String rfq_count    = ws.getParam("rfq_count");

            Object[] obj = {rfq_no, rfq_count};
            SepoaOut value = ServiceConnector.doService(info, "p1072", "CONNECTION", "getDocBaseQtaCompareHD", obj);
            
            SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
           
            for(int i=0; i<wf.getRowCount(); i++) { //데이타가 있는 경우
            
                String[] check 				= {"false", ""};
                String qta_no 				= wf.getValue("QTA_NO",    i);
                String[] qta_no_img 		= {"", qta_no, qta_no};
                
                String[] settle_remark_img 	= {"", "", wf.getValue("SETTLE_REMARK",      i)};
                if(!"".equals(wf.getValue("SETTLE_REMARK",      i))){
                	settle_remark_img[0] = "/kr/images/button/detail.gif";
                }
                String[] settle_attach_no_img 		= {"", "", wf.getValue("SETTLE_ATTACH_NO",      i)};
                if(!"".equals(wf.getValue("SETTLE_ATTACH_NO",      i))){
                	settle_attach_no_img[0] = "/kr/images/button/detail.gif";
                }

                ws.addValue("SEL"            , check, "");
                
                ws.addValue("ABANDON"        , wf.getValue("ABANDON",        i)	, "");
                ws.addValue("VENDOR_CODE"    , wf.getValue("VENDOR_CODE",    i)	, "");
                ws.addValue("VENDOR_NAME"    , wf.getValue("VENDOR_NAME",    i)	, "");
                ws.addValue("CUR"            , wf.getValue("CUR",            i)	, "");                
                ws.addValue("TTL_AMT"        , wf.getValue("TTL_AMT",        i)	, "");
                ws.addValue("QTA_NO"         , qta_no_img                      	, "");
                ws.addValue("DELY_TERMS_TEXT", wf.getValue("DELY_TERMS_TEXT",i)	, "");
                ws.addValue("PAY_TERMS_TEXT" , wf.getValue("PAY_TERMS_TEXT", i)	, "");
                ws.addValue("RFQ_COUNT"      , wf.getValue("RFQ_COUNT",      i)	, "");
                ws.addValue("BID_REQ_TYPE"   , wf.getValue("BID_REQ_TYPE",   i)	, "");
                ws.addValue("SETTLE_REMARK"  , settle_remark_img				, "");
                ws.addValue("SETTLE_ATTACH_NO", settle_attach_no_img			, "");
                ws.addValue("EVAL_SCORE"   , wf.getValue("EVAL_SCORE",   i)	, "");
                
            }
            
            ws.setMessage(value.message);
            ws.write();   
        }
    } // end of doQuery
*/
}