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

import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
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

public class qta_bd_lis3 extends HttpServlet 
{
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
    		
    		/*String start_rfq_date	= gdReq.getParam("start_rfq_date");
    		String end_rfq_date		= gdReq.getParam("end_rfq_date");
    		String rfq_no			= gdReq.getParam("rfq_no");
    		String settle_type		= gdReq.getParam("settle_type");
    		String subject			= gdReq.getParam("subject");
    		String ctrl_person_id   = gdReq.getParam("ctrl_person_id");
    		String bid_rfq_type   = gdReq.getParam("bid_rfq_type");*/
    		
    		if("getRfqHistory".equals(mode)){ // 조회 샘플
    			gdRes = this.getRfqHistory(gdReq, info);
    		}
    		/*else if("getCatalog2".equals(mode)){ // ?
    			gdRes = this.getCatalog2(gdReq, info);
    		}
    		else if("doData".equals(mode)){ // 저장 샘플
    			gdRes = this.doData(gdReq, info);
    		}*/
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
    
	@SuppressWarnings("unchecked")
	private GridData getRfqHistory(GridData gdReq, SepoaInfo info) throws Exception {
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
        	grid_col_id  = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
   			grid_col_ary = SepoaString.parser(grid_col_id, ",");
   			
   			gdRes        = OperateGridData.cloneResponseGridData(gdReq);
   			gdRes.addParam("mode", "getRfqHistory");
   			
   			header.put( "start_rfq_date ".trim(), SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "start_rfq_date ".trim(), "" ) ) );
   			header.put( "end_rfq_date   ".trim(), SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "end_rfq_date   ".trim(), "" ) ) );
   		
            Object[] obj = {header};
            
            // DB  : CONNECTION, TRANSACTION, NONDBJOB
            value        = ServiceConnector.doService(info, "p1071", "CONNECTION", "getRfqHistory", obj);
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
   			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CHANGE_DATE")) {
       	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(sf.getValue(grid_col_ary[k], i)));
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
}