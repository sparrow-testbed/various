package sepoa.svl.procure;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;



public class sg_vnlink_insert extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
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

       		if ("getSgVnLinkList".equals(mode))
       		{	
       			gdRes = getSgVnLinkList(gdReq, info);		//조회
       		}else if("setSgVnLinkInsert".equals(mode))
       		{	
       			gdRes = setSgVnLinkInsert(gdReq, info);		//생성
       		}else if("setSgVnLinkDelete".equals(mode))
       		{	
       			gdRes = setSgVnLinkDelete(gdReq, info);		//삭제
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
    public GridData getSgVnLinkList(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "getSgVnLinkList");
			
			Object[] obj = {data};
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "SR_005", "CONNECTION", "getSgVnLinkList", obj);
			
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
			    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SEL")) {
			    		gdRes.addValue("SEL", "0");
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("flag1")) {
			    		gdRes.addValue("flag1", "R");
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("type1_img")) {
			    		gdRes.addValue("type1_img", "/images/icon/icon_search.gif");
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("type2_img")) {
			    		gdRes.addValue("type2_img", "/images/icon/icon_search.gif");
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("type3_img")) {
			    		gdRes.addValue("type3_img", "/images/icon/icon_search.gif");
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
    
    public GridData setSgVnLinkInsert(GridData gdReq, SepoaInfo info) throws Exception {
	    GridData gdRes      = new GridData();
	    Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message     = MessageUtil.getMessage(info,multilang_id);
		
		try {
			gdRes.addParam("mode", "setSgVnLinkInsert");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Object[] obj = {data};
			SepoaOut value = ServiceConnector.doService(info, "SR_005", "TRANSACTION","setSgVnLinkInsert", obj);
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				gdRes.setStatus("true");
			}else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
	    return gdRes;
	}
    public GridData setSgVnLinkDelete(GridData gdReq, SepoaInfo info) throws Exception {
	    GridData gdRes      = new GridData();
	    Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message     = MessageUtil.getMessage(info,multilang_id);
		try {
			gdRes.addParam("mode", "setSgVnLinkDelete");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			
			Object[] obj = {data};
			SepoaOut value = ServiceConnector.doService(info, "SR_005", "TRANSACTION","setSgVnLinkDelete", obj);
			
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
