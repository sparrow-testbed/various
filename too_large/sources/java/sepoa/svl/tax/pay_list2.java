package sepoa.svl.tax;

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

@SuppressWarnings("serial")
public class pay_list2 extends HttpServlet{
	public void init(ServletConfig config) throws ServletException {}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
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
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
       		
       		if(mode.equals("getPayList")){	
       			gdRes = getPayList(gdReq, info);		//조회
       		}
       		else if(mode.equals("setManPayEnd")){
       			gdRes = setManPayEnd(gdReq, info);		//완료처리
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
    		catch (Exception e) { mode  = "";}
    	}
    }
    
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getPayList(GridData gdReq, SepoaInfo info) throws Exception{
		GridData gdRes        = new GridData();
		Vector   multilang_id = new Vector();
		HashMap  message      = null;
		
		multilang_id.addElement("MESSAGE");
		
		message = MessageUtil.getMessage(info, multilang_id);
		
		try{
			Map<String, Object> data         = SepoaDataMapper.getData(info, gdReq);
			Map<String, String> header       = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
			String              grid_col_id  = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String[]            grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			
			gdRes.addParam("mode", "doQuery");
			
			Object[]      obj   = {header};
			SepoaOut      value = ServiceConnector.doService(info, "TX_014", "CONNECTION","getPayList",obj);
			SepoaFormater wf    = new SepoaFormater(value.result[0]);
			
			if(wf.getRowCount() == 0){
			    gdRes.setMessage(message.get("MESSAGE.1001").toString());
			    
			    return gdRes;
			}
			
			for (int i = 0; i < wf.getRowCount(); i++) {
				for(int k=0; k < grid_col_ary.length; k++) {
				    if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
	    	        	gdRes.addValue(grid_col_ary[k], "0");
	            	}
				    else {
			        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
			        }
				}
			}
		 }
		catch (Exception e){
			 gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			 gdRes.setStatus("false");
		 }
			
		 return gdRes;
	}
	
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setManPayEnd(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		Object[] obj = {data};
    		
    		value = ServiceConnector.doService(info, "TX_014", "TRANSACTION", "setManPayEnd",       obj);
    		
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
}