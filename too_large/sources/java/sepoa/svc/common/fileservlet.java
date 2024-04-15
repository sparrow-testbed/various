package sepoa.svc.common;

import java.io.IOException;
import java.io.PrintWriter;
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

import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class FileServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	PrintWriter out = null;
    	
    	try {
    		req.setCharacterEncoding("UTF-8");
        	res.setContentType("text/html;charset=UTF-8");
        	
        	out   = res.getWriter();
    		gdReq = OperateGridData.parse(req, res);
    		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("delete".equals(mode)){
    			gdRes = this.delete(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
//    		e.printStackTrace();
    	}
    	finally {
    		if(out != null){ out.println((gdRes.getMessage() != null)?gdRes.getMessage():""); }
    	}
    }
    
    
    
    @SuppressWarnings({ "rawtypes", "unchecked", "unused" })
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
    	return result;
    }
    
    @SuppressWarnings({ "unchecked", "unused" })
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
    	return result;
    }
    
    @SuppressWarnings({ "unchecked", "unused" })
	private List<Map<String, String>> getGrid(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result  = null;
    	Map<String, Object>       allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	
    	return result;
    }
    
    @SuppressWarnings("unused")
	private String[] getGridColArray(GridData gdReq) throws Exception{
    	String[] result    = null;
    	String   gridColId = gdReq.getParam("cols_ids");
    	
    	gridColId = JSPUtil.paramCheck(gridColId);
    	gridColId = gridColId.trim();
    	result    = SepoaString.parser(gridColId, ",");
    	
    	return result;
    }
    
	private Object[] deleteObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]            result   = new Object[1];
		Map<String, String> header   = new HashMap<String, String>();
		String              doc      = gdReq.getParam("doc");
		String              docNo    = null;
		String              docSeq   = null;
		doc = doc.replaceAll("&&", ";");
		String[]            docArray = doc.split(";");
		
		docNo  = docArray[0];
		docSeq = docArray[1];
//		System.out.println("fileServlet--docNo="+docNo);
//		System.out.println("fileServlet--docSeq="+docSeq);
		header.put("DOC_NO",  docNo);
		header.put("DOC_SEQ", docSeq);
		
		result[0] = header;
		
		return result;
	}
	
	private String deleteJson(boolean isStatus){
		String       result       = null;
		String       isStatusCode = null;
		StringBuffer stringBuffer = new StringBuffer();
		
		if(isStatus){
			isStatusCode = "1";
		}
		else{
			isStatusCode = "0";
		}
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'").append(isStatusCode).append("'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
    private GridData delete(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	try {
    		String              doc      = gdReq.getParam("doc");
    		obj      = this.deleteObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "FileService", "CONNECTION", "deleteSfileInfo", obj);
    		isStatus = value.flag;
    	}
    	catch(Exception e){
	    	isStatus = false;
    	}
    	
    	gdResMessage = this.deleteJson(isStatus);
    	
    	gdRes.setSelectable(false);
		gdRes.addParam("mode", "doSave");
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
}