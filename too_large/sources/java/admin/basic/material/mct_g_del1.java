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

public class mct_g_del1 extends HttpServlet{
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
	private Map<String, Object> doDataSvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, Object>       result       = new HashMap<String, Object>();
    	Map<String, Object>       allData      = SepoaDataMapper.getData(info, gdReq);
    	Map<String, String>       gridDataInfo = null;
    	Map<String, String>       gridInfo     = null;
    	Map<String, String>       header       = MapUtils.getMap(allData, "headerData");
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	String                    HOUSE_CODE     = info.getSession("HOUSE_CODE");
    	String                    GROUP_CODE     = null;
    	String                    GROUP_UCODE   = null;
    	String                    id         = info.getSession("ID");
    	int                       gridSize     = grid.size();
    	int                       i            = 0;
    	GROUP_UCODE     = header.get("type");
    	
    	for(i = 0; i < gridSize; i++){
    		gridDataInfo = new HashMap<String, String>();
    		
    		gridInfo = grid.get(i);
    		GROUP_CODE  = gridInfo.get("GROUP_CODE");
    		
    		gridDataInfo.put("HOUSE_CODE",       HOUSE_CODE);
    		gridDataInfo.put("CODE",       GROUP_CODE);
    		gridDataInfo.put("TYPE",     GROUP_UCODE);
    		gridDataInfo.put("USER_ID",    id);
    		
    		gridData.add(gridDataInfo);
    	}
    	
    	result.put("gridData", gridData);
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doData(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> svcParam    = this.doDataSvcParam(gdReq, info);
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p6025", "TRANSACTION", "mct_setDelete", obj);
    		
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