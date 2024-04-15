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

@SuppressWarnings("serial")
public class pay_audit_list extends HttpServlet
{
public void init(ServletConfig config) throws ServletException {
	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	// 세션 Object
        SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = null;
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
        
        try {
       		gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
       		if ("getPayAuditList".equals(mode))
       		{	
       			gdRes = getPayAuditList(gdReq, info);		//조회
       		}
       		else if ("doAudit".equals(mode))
       		{	
       			gdRes = doAudit(gdReq, info);		//조회
       		}
       		else if ("getPayCostList".equals(mode))
       		{	
       			gdRes = getPayCostList(gdReq, info);		//조회
       		}
       		else if ("doCost".equals(mode))
       		{	
       			gdRes = doCost(gdReq, info);		//조회
       		}
       		else if ("getPayAuditListPop".equals(mode))
       		{	
       			gdRes = getPayAuditListPop(gdReq, info);		//조회-대금집행전 감사내역조회
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
    
	private GridData getPayAuditList(GridData gdReq, SepoaInfo info) throws Exception
	{
		GridData gdRes   		= new GridData();
		Vector multilang_id 	= new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		try{
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");
			
			Object[] obj = {header};
			
			SepoaOut value = ServiceConnector.doService(info, "TX_016", "CONNECTION","getPayAuditList",obj);
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			if (wf.getRowCount() == 0) {
			    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
			    return gdRes;
			}
			for (int i = 0; i < wf.getRowCount(); i++) {
				for(int k=0; k < grid_col_ary.length; k++) {
				    if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
	    	        	gdRes.addValue(grid_col_ary[k], "0");
	            	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("GW_INF_NO")) {
	            		gdRes.addValue(grid_col_ary[k], "<font color=blue>" + wf.getValue(grid_col_ary[k], i) + "</font>");
	            	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("GW_INF_NO2")) {
	            		gdRes.addValue(grid_col_ary[k], "<font color=blue>" + wf.getValue(grid_col_ary[k], i) + "</font>");
	            	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("SIGN_PATH_IMG")) {
						gdRes.addValue(grid_col_ary[k], "/images/icon/icon_data_a.gif");
	            	}else {
			        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
			        }
				}
			}
		 } catch (Exception e) {
			 gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			 gdRes.setStatus("false");
		 }
			
		 return gdRes;
	}
	
	private GridData getPayAuditListPop(GridData gdReq, SepoaInfo info) throws Exception
	{
		GridData gdRes   		= new GridData();
		Vector multilang_id 	= new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		try{
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");
			
			Object[] obj = {header};
			
			SepoaOut value = ServiceConnector.doService(info, "TX_016", "CONNECTION","getPayAuditListPop",obj);
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			if (wf.getRowCount() == 0) {
			    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
			    return gdRes;
			}
			for (int i = 0; i < wf.getRowCount(); i++) {
				for(int k=0; k < grid_col_ary.length; k++) {
				    if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
	    	        	gdRes.addValue(grid_col_ary[k], "0");
	            	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("GW_INF_NO")) {
	            		gdRes.addValue(grid_col_ary[k], "<font color=blue>" + wf.getValue(grid_col_ary[k], i) + "</font>");
	            	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("GW_INF_NO2")) {
	            		gdRes.addValue(grid_col_ary[k], "<font color=blue>" + wf.getValue(grid_col_ary[k], i) + "</font>");
	            	} else {
			        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
			        }
				}
			}
		 } catch (Exception e) {
			 gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			 gdRes.setStatus("false");
		 }
			
		 return gdRes;
	}
	
	private GridData getPayCostList(GridData gdReq, SepoaInfo info) throws Exception
	{
		GridData gdRes   		= new GridData();
		Vector multilang_id 	= new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		try{
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");
			
			Object[] obj = {header};
			
			SepoaOut value = ServiceConnector.doService(info, "TX_016", "CONNECTION","getPayCostList",obj);
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			if (wf.getRowCount() == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				return gdRes;
			}
			for (int i = 0; i < wf.getRowCount(); i++) {
				for(int k=0; k < grid_col_ary.length; k++) {
					if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue(grid_col_ary[k], "0");
					}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("GW_INF_NO")) {//컬럼 데이터 색 지정
	            		gdRes.addValue(grid_col_ary[k], "<font color=blue>" + wf.getValue(grid_col_ary[k], i) + "</font>");
	            	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("GW_INF_NO2")) {
	            		gdRes.addValue(grid_col_ary[k], "<font color=blue>" + wf.getValue(grid_col_ary[k], i) + "</font>");
	            	}else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
		} catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doAudit(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "TX_016", "TRANSACTION", "doAudit",       obj);
    		
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData doCost(GridData gdReq, SepoaInfo info) throws Exception{
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
			
			value = ServiceConnector.doService(info, "TX_016", "TRANSACTION", "doCost",       obj);
			
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
