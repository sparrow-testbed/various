package sepoa.svl.approval;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

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


public class ap_report_list extends HttpServlet {
	private static final long serialVersionUID = 1L;
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    	    throws IOException, ServletException
    		{
    			doPost(req, res);
    		}
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	// 세션 Object
        SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
        
        try {
       		gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));

       		if ("getReportList".equals(mode))
       		{	
       			gdRes = getReportList(gdReq, info);		//조회
       		}else if("setReportCancel".equals(mode)){
       			gdRes = setReportCancel(gdReq, info);
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
    public GridData getReportList(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "getProgressList");
			
			Object[] obj = {data};
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "AP_008", "CONNECTION", "getReportList", obj);
			
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
			    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
			    		gdRes.addValue("SELECTED", "0");
			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")) {
    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("SIGN_DATE")) {
    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("SCTM_SIGN_REMARK_IMG")) {
						if(!("".equals(wf.getValue("SCTM_SIGN_REMARK", i).trim())) && wf.getValue(grid_col_ary[k], i)!=null){
							gdRes.addValue(grid_col_ary[k], "/images/icon/icon_data_a.gif");
						}else{
							gdRes.addValue(grid_col_ary[k], "");
						}
					} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("SCTP_SIGN_REMARK_IMG")) {
						if(Integer.parseInt(wf.getValue("SCTP_SIGN_REMARK", i).trim())>0){
							gdRes.addValue(grid_col_ary[k], "/images/icon/icon_data_a.gif");
						}else{
							gdRes.addValue(grid_col_ary[k], "");
						}
					} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("SIGN_PATH_IMG")) {
						gdRes.addValue(grid_col_ary[k], "/images/icon/icon_data_a.gif");
					} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ATTACH_NO_IMG")) {
						if(!("".equals(wf.getValue(grid_col_ary[k], i).trim())) && wf.getValue(grid_col_ary[k], i)!=null){
							gdRes.addValue(grid_col_ary[k], "/images/icon/icon_disk_b.gif");
						}else{
							gdRes.addValue(grid_col_ary[k], "/images/icon/icon_disk_a.gif");
						}
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
    public GridData setReportCancel(GridData gdReq, SepoaInfo info) throws Exception {
	    GridData gdRes      = new GridData();
	    Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message     = MessageUtil.getMessage(info,multilang_id);
		try {
			gdRes.addParam("mode", "setReportCancel");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			
			Object[] obj = {data};
			SepoaOut value = ServiceConnector.doService(info, "AP_008", "TRANSACTION","setReportCancel", obj);
			
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
