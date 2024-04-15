package admin.basic.material;

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
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class mty_g_upd1 extends HttpServlet{
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
    		
    		if("doData".equals(mode)){ // 저장 샘플
    			gdRes = this.doData(gdReq, info);
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
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    @SuppressWarnings("unchecked")
	private List<Map<String, String>> doDataGridData(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> grid       = null;
    	Map<String, Object>       data       = SepoaDataMapper.getData(info, gdReq);
    	Map<String, String>       gridInfo   = null;
    	Map<String, String>       resultInfo = null;
    	Map<String, String>       header     = null;
    	String                    HOUSE_CODE     = info.getSession("HOUSE_CODE");
    	String                    GROUP_CODE     = null;
    	String                    GROUP_UCODE   = null;
    	String                    GROUP_NAME     = null;
    	String                    id         = info.getSession("ID");
    	int                       gridSize   = 0;
    	int                       i          = 0;
    	
    	grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	gridSize = grid.size();
    	header   = MapUtils.getMap(data, "headerData");
    	GROUP_UCODE     = header.get("type");
    	
    	for(i = 0; i < gridSize; i++){
    		resultInfo = new HashMap<String, String>();
    		
    		gridInfo = grid.get(i);
    		
    		GROUP_CODE  = gridInfo.get("GROUP_CODE");
    		GROUP_NAME    = gridInfo.get("GROUP_NAME");
    		
    		resultInfo.put("HOUSE_CODE",       HOUSE_CODE);
    		resultInfo.put("CODE",       GROUP_CODE);
    		resultInfo.put("TYPE",     GROUP_UCODE);
    		resultInfo.put("GROUP_NAME",       GROUP_NAME);    		
    		resultInfo.put("USER_ID",    id);
    		
    		result.add(resultInfo);
    	}
    	
    	return result;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doData(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes       = new GridData();
    	Vector                    multilangId = new Vector();
    	HashMap                   message     = null;
    	SepoaOut                  value       = null;
    	Map<String, Object>       svcParam    = new HashMap<String, Object>();
    	List<Map<String, String>> gridData    = this.doDataGridData(gdReq, info);
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		svcParam.put("gridData", gridData);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p6025", "TRANSACTION", "mty_setUpdate", obj);
    		
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