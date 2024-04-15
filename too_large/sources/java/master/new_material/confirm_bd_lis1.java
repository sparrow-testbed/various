package master.new_material;

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

public class confirm_bd_lis1 extends HttpServlet{
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
    		
    		if("getQuery".equals(mode)){
    			gdRes = this.getQuery(gdReq, info);
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
	private Map<String, String> getQuerySvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result            = new HashMap<String, String>();
    	Map<String, Object> allData           = SepoaDataMapper.getData(info, gdReq);
	    Map<String, String> header            = MapUtils.getMap(allData, "headerData");
	    String              createDateFrom    = header.get("create_date_from");
	    String              createDateTo      = header.get("create_date_to");
	    String              reqUserId         = header.get("req_user_id");
	    String              description       = header.get("description");
	    String              selProceedingFlag = header.get("sel_proceeding_type");
	    String              houseCode         = info.getSession("HOUSE_CODE");
	    
	    createDateFrom = SepoaString.getDateUnSlashFormat(createDateFrom);
	    createDateTo   = SepoaString.getDateUnSlashFormat(createDateTo);
	    
	    result.put("HOUSE_CODE",          houseCode);
	    result.put("create_date_from",    createDateFrom);
	    result.put("create_date_to",      createDateTo);
	    result.put("REQ_USER_ID",         reqUserId);
	    result.put("description",         description);
	    result.put("sel_proceeding_flag", selProceedingFlag);
	      	
    	return result;
    }

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getQuery(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, String> svcParam   = this.getQuerySvcParam(gdReq, info);
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	    int                 rowCount   = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {svcParam};
	
	    	value = ServiceConnector.doService(info, "t0033", "CONNECTION","confirm_bd_lis1_getQuery", obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		for (int i = 0; i < rowCount; i++){
			    		for(int k=0; k < gridColAry.length; k++){
			    			if("SELECTED".equals(gridColAry[k])){
			    				gdRes.addValue("SELECTED", "0");
			    			}
			    			else if("REJECT_REMARK".equals(gridColAry[k])){
			    				if( !"".equals(this.nvl(sf.getValue(gridColAry[k], i))) ){
			    					gdRes.addValue(gridColAry[k], "<img src='/images/icon/detail.gif' align='absmiddle' border='0' alt=''> ");
			    				}else{
			    					gdRes.addValue(gridColAry[k], "");
			    				}
			    			}
			    			else{
			    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
			    			}
			    		}
			    	}
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
	
    /**
     * String이 널일경우 "", 아닐경우 자기 자신 반환
     * @param string
     * @return
     * @throws Exception
     */
    private String nvl(String string) throws Exception{
    	String result = null;
    	
    	if(string == null){
    		result = "";
    	}
    	else{
    		result = string;
    	}
    	
    	return result;
    }
}