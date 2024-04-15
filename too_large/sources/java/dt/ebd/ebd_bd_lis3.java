package dt.ebd;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ebd_bd_lis3 extends HttpServlet{
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
    		
    		if("setBidDelete".equals(mode)){
    			gdRes = this.setBidDelete(gdReq, info);
    		}
    		else if("setPRCopy".equals(mode)){
    			gdRes = this.setPRCopy(gdReq, info);
    		}
    		else if("getReqBidList".equals(mode)){
    			gdRes = this.getReqBidList(gdReq, info);
    		}
    		else if("doReturnCart".equals(mode)){
    			gdRes = this.doReturnCart(gdReq, info);
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
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData getReqBidList(GridData gdReq, SepoaInfo info) throws Exception{
        GridData            gdRes        = new GridData();
        SepoaFormater       sf           = null;
        SepoaOut            value        = null;
        Vector              v            = new Vector();
        HashMap             message      = null;
        Map<String, Object> allData      = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header       = null;
        String              gridColId    = null;
        String              houseCode    = info.getSession("HOUSE_CODE");
		String              startAddDate = null;
		String              endAddDate   = null;
        String[]            gridColAry   = null;
        int                 rowCount     = 0;
        
        v.addElement("MESSAGE");
        
        message = MessageUtil.getMessage(info, v); // 메세지 조회?
        
        try{
        	allData    = SepoaDataMapper.getData(info, gdReq); // 파라미터로 넘어온 모든 값 조회
            header     = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
            gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim(); // 그리드 칼럼 정보 조회
            gridColAry = SepoaString.parser(gridColId, ","); // 그리드 칼럼 정보 배열
            gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
            
            gdRes.addParam("mode", "query");
            
            header.put("HOUSE_CODE ".trim(), houseCode);
			header.put("from_date  ".trim(), SepoaString.getDateUnSlashFormat( header.get("start_add_date ".trim() ) ) );
			header.put("to_date    ".trim(), SepoaString.getDateUnSlashFormat( header.get("end_add_date   ".trim() ) ) );

            Object[] obj = {header};
            
            value = ServiceConnector.doService(info ,"p1015", "CONNECTION","getReqBidList",obj);

            if(value.flag){ // 조회 성공
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
                gdRes.setMessage(value.message);
                gdRes.setStatus("false");
                return gdRes;
            }
            
            sf= new SepoaFormater(value.result[0]);
            
            rowCount = sf.getRowCount(); // 조회 건수

            if(rowCount == 0){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                
                return gdRes;
            }
            
            for (int i = 0; i < rowCount; i++){
                for(int k=0; k < gridColAry.length; k++){
                    if("SELECTED".equals(gridColAry[k])){
                        gdRes.addValue("SELECTED", "0");
                    }
                    else{
                        gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
                    }
                }
            }
            
        }
        catch (Exception e){
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }    
    
	
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setBidDelete(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes       = new GridData();
    	Vector                    multilangId = new Vector();
    	HashMap                   message     = null;
    	SepoaOut                  value       = null;
    	Map<String, Object>       data        = null;
    	Map<String, Object>       svcParam    = null;
    	List<Map<String, String>> grid        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data     = SepoaDataMapper.getData(info, gdReq);
    		grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    		svcParam = this.setBidDeleteSvcParam(info, grid);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1015", "TRANSACTION","setReqBidDelete", obj);
    		
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
    
    private Map<String, Object> setBidDeleteSvcParam(SepoaInfo info, List<Map<String, String>> grid) throws Exception{
    	Map<String, Object>       result              = new HashMap<String, Object>();
    	List<Map<String, String>> deleteParamList     = new ArrayList<Map<String, String>>();
    	Map<String, String>       deleteParamListInfo = null;
    	Map<String, String>       gridInfo            = null;
    	String                    prNo                = null;
    	String                    houseCode           = info.getSession("HOUSE_CODE");
    	int                       gridSize            = grid.size();
    	int                       i                   = 0;
    	
    	for(i = 0; i < gridSize; i++){
    		deleteParamListInfo = new HashMap<String, String>();
    		
    		gridInfo = grid.get(i);
    		prNo     = gridInfo.get("PR_NO");
    		
    		deleteParamListInfo.put("prNo",      prNo);
    		deleteParamListInfo.put("houseCode", houseCode);
    		
    		deleteParamList.add(deleteParamListInfo);
    	}
    	
    	result.put("deleteParamList", deleteParamList);
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setPRCopy(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes       = new GridData();
    	Vector                    multilangId = new Vector();
    	HashMap                   message     = null;
    	SepoaOut                  value       = null;
    	Map<String, Object>       data        = null;
    	Map<String, String>       gridInfo    = null;
    	String                    addPrNo     = "";
    	String                    houseCode   = info.getSession("HOUSE_CODE");
    	List<Map<String, String>> grid        = null;
    	int                       gridSize    = 0;
    	int                       i           = 0;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data     = SepoaDataMapper.getData(info, gdReq);
    		grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    		gridSize = grid.size();
    		
    		for(i = 0; i < gridSize; i++){
    			gridInfo = grid.get(i);
    			
    			gridInfo.put("HOUSE_CODE", houseCode);
    			
    			addPrNo = this.setPRCopyPrBrDisplay(gridInfo, info);
    			
    			gridInfo.put("addPrNo", addPrNo);
    			
    			Object[] obj = {gridInfo};
        		
        		value = ServiceConnector.doService(info, "p1003", "TRANSACTION", "setPRCopy", obj);
        		
        		if(value.flag == false) {
        			throw new Exception();
        		}
    		}
    		
    		gdRes.setMessage((value != null)?value.message:""); 
    		gdRes.setStatus("true");
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
    
    private String setPRCopyPrBrDisplay(Map<String, String> data, SepoaInfo info) throws Exception{
    	Object[]      obj          = {data};
    	SepoaOut      value        = null;
    	SepoaFormater sf           = null;
    	String        addPrNo      = null;
    	String        brNo         = null;
    	StringBuffer  stringBuffer = new StringBuffer();
    	int           rowCount     = 0;
		
		value = ServiceConnector.doService(info, "p1015", "CONNECTION",  "PrBrDisplay", obj);
		
		if(value.flag){// 조회 성공
    		sf= new SepoaFormater(value.result[0]);
    		
	    	rowCount = sf.getRowCount(); // 조회 row 수
	
	    	if(rowCount == 0){
	    		addPrNo = "";
	    	}
	    	else{
	    		for (int i = 0; i < rowCount; i++){
	    			brNo = sf.getValue("BR_NO", i);
	    			
	    			stringBuffer.append(brNo).append(":");
		    	}
	    		
	    		addPrNo = stringBuffer.toString();
	    	}
    	}
    	else{
    		throw new Exception();
    	}
		
		return addPrNo;
    }
    
    
    private GridData doReturnCart(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes = new GridData();
    	Vector multilangId = new Vector();
    	HashMap message = null;
    	SepoaOut value = null;
    	Map<String, Object> data = null;
    	Map<String, String> gridInfo = null;
    	String houseCode = info.getSession("HOUSE_CODE");
    	List<Map<String, String>> grid = null;
    	int gridSize = 0;
   
    	multilangId.addElement("MESSAGE");
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data     = SepoaDataMapper.getData(info, gdReq);
    		grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    		gridSize = grid.size();
    		
    		Object[] obj = {grid};
    		
    		value = ServiceConnector.doService(info, "p1003", "TRANSACTION", "doReturnCart", obj);
    		
    		
    		if(value.flag == false) {
    			throw new Exception();
    		}
//    		for(int i = 0; i < gridSize; i++){
//    			gridInfo = grid.get(i);
//    			
//    			gridInfo.put("HOUSE_CODE", houseCode);
//    			
//        		
//        		
//    		}
    		
    		gdRes.setMessage(value.message); 
    		gdRes.setStatus("true");
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
}