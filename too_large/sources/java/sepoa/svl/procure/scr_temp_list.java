package sepoa.svl.procure;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletException;
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

public class scr_temp_list extends SepoaServlet 
{
	 public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
	    	doPost(req, res);
	    }

	    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
	    	// �몄뀡 Object
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

	       		if ("getTempList".equals(mode))
	       		{	
	       			gdRes = getTempList(gdReq, info);		//議고쉶
	       		}
	       		
	       		else if ("setTempDelete".equals(mode))
	       		{	
	       			gdRes = setTempDelete(gdReq, info);		//��젣
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
	
	
	    public GridData getTempList(GridData gdReq, SepoaInfo info) throws Exception {
	   	    GridData gdRes   		= new GridData();
	   	    Vector multilang_id 	= new Vector();
	   	    multilang_id.addElement("MESSAGE");
	   	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
	   	
	   		try {
	   			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//洹몃━���곗씠��
	   			
	   		
	   			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
	   			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
	   			
	   			gdRes = OperateGridData.cloneResponseGridData(gdReq);
	   			gdRes.addParam("mode", "getTempList");
	   			
	   			Object[] obj = {data};
	   			// DB �곌껐諛⑸쾿 : CONNECTION, TRANSACTION, NONDBJOB
	   			SepoaOut value = ServiceConnector.doService(info, "SR_009", "CONNECTION", "getTempList", obj);
	   			
	   			if(value.flag) {
	   			    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
	   			    gdRes.setStatus("true");
	   			} else {
	   				gdRes.setMessage(value.message);
	   				gdRes.setStatus("false");
	   			    return gdRes;
	   			}
	   			
	   			SepoaFormater wf = new SepoaFormater(value.result[0]);
	   			
	   			if (wf.getRowCount() == 0) {
	   			    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
	   			    return gdRes;
	   			}
	   			
	   			for (int i = 0; i < wf.getRowCount(); i++) {
	   				for(int k=0; k < grid_col_ary.length; k++) {
	   					int cnt=i+1;
	   			    	 if(grid_col_ary[k] != null && grid_col_ary[k].equals("SEL")) {
	   			    		gdRes.addValue("SEL", "1");
	   			    	}
	   			    	 else if(grid_col_ary[k] != null && grid_col_ary[k].equals("num")) {
	   			    		gdRes.addValue("num",String.valueOf(cnt) );
	   			    	}
	   			    	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("change_date")) {
	       	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
	       	            	
	   			    	} 
	   			    				    	
	                   	else {
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
	    
	    
	    public GridData setTempDelete(GridData gdReq, SepoaInfo info) throws Exception {
	   	    GridData gdRes      = new GridData();
	   	    Vector multilang_id = new Vector();
	   		multilang_id.addElement("MESSAGE");
	   		HashMap message     = MessageUtil.getMessage(info,multilang_id);
	   	
	   		try {
	   			gdRes.addParam("mode", "setTempDelete");
	   			gdRes.setSelectable(false);
	   			
	   			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
	   			
	   			Object[] obj = {data};
	   			SepoaOut value = ServiceConnector.doService(info, "SR_009", "TRANSACTION","setTempDelete", obj);
	   			
	   			
	   			
	   			if(value.flag) {
	   				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
	   				gdRes.setStatus("true");
	   			} else {
	   				gdRes.setMessage(value.message);
	   				gdRes.setStatus("false");
	   			}
	   		} catch (Exception e) {
	   			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
	   			gdRes.setStatus("false");
	   		}
	   		
	   	    return gdRes;
	   	}


}

