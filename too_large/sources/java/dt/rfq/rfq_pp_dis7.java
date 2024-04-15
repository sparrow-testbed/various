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

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class rfq_pp_dis7 extends HttpServlet{
	
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

			
			if ("getVendorDisplay".equals(mode)){ //견적요청 상세조회 - 업체선정 조회
				gdRes = getVendorDisplay(gdReq,info);
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
	 * 업체선정을 위한 업체조회 
	 * getVendorDisplay
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-06
	 * @modify 2014-10-06
	 */
	@SuppressWarnings("unchecked")
	private GridData getVendorDisplay(GridData gdReq, SepoaInfo info) throws Exception {
		GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
    	SepoaFormater       sf          = null;
    	String              grid_col_id = null;
        String[]            grid_col_ary= null;
        
    	multilangId.addElement("MESSAGE");
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doQuery");
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    	
			grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			
    		Object[] obj = {data};
    		value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getVendorDisplay2", obj);

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
	 


	/*public void doQuery(SepoaStream ws) throws Exception {
		//get session
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		String mode = ws.getParam("mode");
		
		if(mode.equals("getVendorDisplay")) { //견적요청 상세조회 - 업체선정 조회

		    String rfq_no =	ws.getParam("rfq_no");
		    String rfq_count = ws.getParam("rfq_count");
		    String rfq_seq = ws.getParam("rfq_seq");

		    Object[] obj = {rfq_no, rfq_count, rfq_seq};
		    SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getVendorDisplay", obj);

		    SepoaFormater wf =	ws.getSepoaFormater(value.result[0]);

			for(int i=0; i<wf.getRowCount(); i++)	{ //데이타가 있는 경우
		        ws.addValue("VENDOR_CODE", wf.getValue("VENDOR_CODE", i),	"");
		        ws.addValue("VENDOR_NAME", wf.getValue("VENDOR_NAME", i),	"");
		        ws.addValue("BID_FLAG"   , wf.getValue("BID_FLAG"   , i),	"");
			}

		    ws.setMessage(value.message);
		    ws.write();
		}
	}*/
}
