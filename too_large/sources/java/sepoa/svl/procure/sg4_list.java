package sepoa.svl.procure;

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
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;





public class sg4_list extends HttpServlet {

    public void init(ServletConfig config) throws ServletException {
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res)
    	    throws IOException, ServletException
    		{
    			doPost(req, res);
    		}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
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

       		if ("getSgList".equals(mode))
       		{	
       			gdRes = getSgList(gdReq, info);		//조회
       		}else if("setSgDelete".equals(mode)){
       			gdRes = setSgDelete(gdReq, info);
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
    
    public GridData getSgList(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
			
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "getSgList");
			
			Object[] obj = {data};
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "SR_002", "CONNECTION", "getSgList", obj);
			
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
			    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
			    return gdRes;
			}
			
			for (int i = 0; i < wf.getRowCount(); i++) {
				for(int k=0; k < grid_col_ary.length; k++) {
			    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("T_SEQ")) {
			    		gdRes.addValue("T_SEQ", "0");
			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("T_ADD_DATE")) {
    	            	gdRes.addValue(grid_col_ary[k], wf.getValue("CHANGE_DATE", i));
                	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("T_NAME")) {
			    		gdRes.addValue(grid_col_ary[k], wf.getValue("TEXT2", i));
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("T_ID")) {
			    		gdRes.addValue(grid_col_ary[k], wf.getValue("SG_PTY_REFITEM", i));
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
    
    public GridData setSgDelete(GridData gdReq, SepoaInfo info) throws Exception {
	    GridData gdRes      = new GridData();
	    Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message     = MessageUtil.getMessage(info,multilang_id);
		try {
			gdRes.addParam("mode", "setSgVnLinkDelete");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Object[] obj = {data};
			SepoaOut value = ServiceConnector.doService(info, "SR_002", "TRANSACTION","setSgDelete", obj);
			
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
