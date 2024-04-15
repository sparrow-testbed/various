package ict.sepoa.svl.co;

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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class I_CO_017_Servlet extends HttpServlet{
	private static SepoaInfo info;
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("selectBizList".equals(mode)){
    			gdRes = this.selectBizList(gdReq, info);
    		}else if ("bottomQuery".equals(mode)) {
				/*rfq_req_sellersel_bottom_ict.jsp*/
                gdRes = getBottomSupiList(gdReq);
            }
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
//    		e.printStackTrace();
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);    			
    		}
    		catch (Exception e) {
//    			e.printStackTrace();
    			mode  = "";
    		}
    	}
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
    	return result;
    }
    
    @SuppressWarnings("unchecked")
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
    
    private String[] getGridColArray(GridData gdReq) throws Exception{
    	String[] result    = null;
    	String   gridColId = gdReq.getParam("cols_ids");
    	
    	gridColId = JSPUtil.paramCheck(gridColId);
    	gridColId = gridColId.trim();
    	result    = SepoaString.parser(gridColId, ",");
    	
    	return result;
    }
    
    private Object[] selectBizListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result      = new Object[1];
    	Map<String, String> header      = this.getHeader(gdReq, info);
    	Map<String, String> resultInfo  = new HashMap<String, String>();
    	String              start_change_date = header.get("start_change_date").replaceAll("/","");
    	String              end_change_date   = header.get("end_change_date").replaceAll("/","");
    	String              biz_no            = header.get("biz_no");
    	String              biz_nm            = header.get("biz_nm");
    	
    	resultInfo.put("start_change_date",       start_change_date);
    	resultInfo.put("end_change_date", end_change_date);
    	resultInfo.put("biz_no",        biz_no);
    	resultInfo.put("biz_nm",        biz_nm);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    private GridData selectBizListGdRes(GridData gdReq, GridData gdRes, SepoaFormater sf) throws Exception{
    	String[]            gridColAry       = this.getGridColArray(gdReq);
    	String              colKey           = null;
	    String              colValue         = null;
    	int                 i                = 0;
	    int                 k                = 0;
	    int                 rowCount         = sf.getRowCount();
	    int                 gridColAryLength = gridColAry.length;
	    
    	for (i = 0; i < rowCount; i++){
    		for(k = 0; k < gridColAryLength; k++){
    			colKey   = gridColAry[k];
    			colValue = sf.getValue(colKey, i);
    			
    			if("SELECTED".equals(gridColAry[k])){
    				gdRes.addValue("SELECTED", "0");
    			}
    			else{
    				gdRes.addValue(colKey, colValue);
    			}
    		}
    	}
    	
    	return gdRes;
    }

	@SuppressWarnings({ "rawtypes" })
	private GridData selectBizList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	obj      = this.selectBizListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "I_CO_017", "CONNECTION", "selectBizList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		gdRes = this.selectBizListGdRes(gdReq, gdRes, sf);
		    	}
		    	
		    	gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch (Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}
	
	private GridData getBottomSupiList(GridData gdReq) throws Exception {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;

        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );

        try {
            String rfq_no       = JSPUtil.paramCheck(gdReq.getParam("rfq_no")).trim();
            String rfq_count    = JSPUtil.paramCheck(gdReq.getParam("rfq_count")).trim();
            
            String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
            String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");

            // EJB CALL
            Object[] obj = { rfq_no , rfq_count };
            SepoaOut value = ServiceConnector.doService(info, "I_CO_017", "CONNECTION", "getBottomSupiList", obj);

            if (value.flag) {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            } else {
                gdRes.setMessage(value.message);
                gdRes.setStatus("false");
                return gdRes;
            }

            wf = new SepoaFormater(value.result[0]);
            rowCount = wf.getRowCount();
            
            if (rowCount == 0) {
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }

            for (int i = 0; i < rowCount; i++) {
                for (int k = 0; k < grid_col_ary.length; k++) {
                    if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
                    	gdRes.addValue("SELECTED", "0");
                    } else {
                        gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                    }                    
                }
            }
            
        } catch (Exception e) {
            
            gdRes.setMessage(message.get("MESSAGE.1002").toString()); //처리 중 오류가 발생하였습니다
            gdRes.setStatus("false");
        }

        return gdRes;
    }
	
}