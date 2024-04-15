package dt.rat;

import java.util.*;
import java.io.*;

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



/***********************
 *DT>역경매관리>역경매
 *Kim.D.H
 ***********************/
public class rat_bd_lis1 extends HttpServlet {
	
	
	private static final long serialVersionUID = 1L;

	public void init(javax.servlet.ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	SepoaFormater  sf	= null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getratbdlis1_1".equals(mode)){ // 역경매공고 조회
    			gdRes = this.getratbdlis1_1(gdReq, info);
    		}
    		else if("getratbdlis1_3".equals(mode)){ // 역경매공고 삭제
    			gdRes = this.getratbdlis1_3(gdReq, info);
    		}
    		else if("setRaDelete".equals(mode)){ // 역경매공고 삭제
    			gdRes = this.setRaDelete(gdReq, info);
    		}
    		else if("doData".equals(mode)){ // 저장 샘플
    		//	gdRes = this.doData(gdReq, info);
    			Logger.debug.println();
    		}
    		else if("getServerTime".equals(mode)){//서버시간 조회
    			sf = this.getServerTime(info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			if("getServerTime".equals(mode)){
    				out.print((sf != null)?sf.getValue("SERVER_TIME", 0):"");
    			}else{
    				OperateGridData.write(req, res, gdRes, out);
    			}
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private SepoaFormater getServerTime(SepoaInfo info) throws Exception{
		
		GridData            gdRes      = new GridData();
		SepoaFormater       sf         = null;
		SepoaOut            value      = null;
		Vector              v          = new Vector();
		HashMap             message    = null;
		Map<String, Object> allData    = null;
		Map<String, String> header     = null;
		String              gridColId  = null;
		String[]            gridColAry = null;
		int                 rowCount   = 0;
		
		v.addElement("MESSAGE");
		
		message = MessageUtil.getMessage(info, v);
		
		try{
			
			gdRes.addParam("mode", "query");
			
			Object[] obj = {};
			
			value = ServiceConnector.doService(info, "p1008", "CONNECTION","getDBTime", obj);
			
			if(value.flag){// 조회 성공
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
				
				sf= new SepoaFormater(value.result[0]);
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
		
		return sf;
	}       

    /**
     * 역경매 조회
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getratbdlis1_1(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	    int                 rowCount   = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "p1008", "CONNECTION","getratbdlis1_2", obj);
	
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
	 * 역경매 조회
	 * 
	 * @param gdReq
	 * @param info
	 * @return GridData
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getratbdlis1_3(GridData gdReq, SepoaInfo info) throws Exception{
		GridData            gdRes      = new GridData();
		SepoaFormater       sf         = null;
		SepoaOut            value      = null;
		Vector              v          = new Vector();
		HashMap             message    = null;
		Map<String, Object> allData    = null;
		Map<String, String> header     = null;
		String              gridColId  = null;
		String[]            gridColAry = null;
		int                 rowCount   = 0;
		
		v.addElement("MESSAGE");
		
		message = MessageUtil.getMessage(info, v);
		
		try{
			allData    = SepoaDataMapper.getData(info, gdReq);
			header     = MapUtils.getMap(allData, "headerData");
			gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
			gridColAry = SepoaString.parser(gridColId, ",");
			gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
			
			gdRes.addParam("mode", "query");
			
			
			Object[] obj = {header};
			
			value = ServiceConnector.doService(info, "p1008", "CONNECTION","getratbdlis1_1", obj);
			
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
	
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setRaDelete(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		Object[] obj = {data};
    		
    		value = ServiceConnector.doService(info, "p1008", "TRANSACTION", "setRaDelete",       obj);
    		
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
/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
	public String checkNull(String value) {
        if(value == null || "".equals(value.trim()))
        {	value = null;}
        
		return value;
	}
}
/*******************************************************************************************************************************
                                                       END OF File
*********************************************************************************************************************************/
