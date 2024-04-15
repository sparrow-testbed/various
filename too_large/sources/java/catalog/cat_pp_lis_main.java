package catalog;

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

public class cat_pp_lis_main extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
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

			if("getCatalog".equals(mode)){ // 품목 마스터 조회
				gdRes = this.getCatalog(gdReq, info);
			}
			else if("getCatalog2".equals(mode)){ // ?
				gdRes = this.getCatalog2(gdReq, info);
			}
			else if("doData".equals(mode)){ // 나의 카탈로그 담기
				gdRes = this.doData(gdReq, info);
			}
			else if("getExcelCatalog".equals(mode)) {
				gdRes = this.getExcelCatalog(gdReq, info);
			}
			else if("getCatalogSo".equals(mode)){ // 품목 마스터 조회
				gdRes = this.getCatalogSo(gdReq, info);
			}
			else if("getCatalog5".equals(mode)){ // 품목 마스터 조회
				gdRes = this.getCatalog5(gdReq, info);
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
    
    
    /**
     * 품목 마스터 리스트를 조회한다.
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getExcelCatalog(GridData gdReq, SepoaInfo info) throws Exception{
        GridData            gdRes      = new GridData();
        SepoaFormater       sf         = null;
        SepoaOut            value      = null;
        Vector              v          = new Vector();
        HashMap             message    = null;
        Map<String, Object> allData    = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header     = null;
        String              gridColId  = null;
        String[]            gridColAry = null;
        String        		colValue   = null;
        String        		colKey     = null;
        int                 rowCount   = 0;
        
        v.addElement("MESSAGE");
        
        message = MessageUtil.getMessage(info, v); // 메세지 조회?
        
        try{
        	allData    = SepoaDataMapper.getData(info, gdReq); // 파라미터로 넘어온 모든 값 조회
            header     = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
            gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim(); // 그리드 칼럼 정보 조회
            gridColAry = SepoaString.parser(gridColId, ","); // 그리드 칼럼 정보 배열
            gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
            
            gdRes.addParam("mode", "query");

            Object[] obj = {header};
            
            value = ServiceConnector.doService(info, "p1003", "CONNECTION","getExcelCatalog", obj);

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
        		for(int k = 0; k < gridColAry.length; k++){
        			colKey   = gridColAry[k];
        			
                    if("SELECTED".equals(gridColAry[k])){
                        gdRes.addValue("SELECTED", "0");
                    }
        			else if("IMAGE_FILE_PATH".equals(colKey)){//이미지 경로 그리드컬럼
        				colValue = sf.getValue(colKey, i);
        			}
        			else if("IMAGE_FILE".equals(colKey)){//이미지 그리드컬럼
        				colValue = sf.getValue(colKey, i);
        				if(colValue == null || "".equals(colValue)){
        					colValue = "/images/000/icon/icon_close3.gif";//이미지 경로 세팅
        				} else {
        					colValue = "/images/ico_x1.gif";//이미지 경로 세팅
        				}
        			}
        			else{
        				colValue = sf.getValue(colKey, i);
        			}
        			
        			gdRes.addValue(colKey, colValue);
        		}            	
            }
        }
        catch (Exception e){
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
    
    
    /**
     * 품목 마스터 리스트를 조회한다.
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getCatalog(GridData gdReq, SepoaInfo info) throws Exception{
        GridData            gdRes      = new GridData();
        SepoaFormater       sf         = null;
        SepoaOut            value      = null;
        Vector              v          = new Vector();
        HashMap             message    = null;
        Map<String, Object> allData    = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header     = null;
        String              gridColId  = null;
        String[]            gridColAry = null;
        String        		colValue   = null;
        String        		colKey     = null;
        int                 rowCount   = 0;
        
        v.addElement("MESSAGE");
        
        message = MessageUtil.getMessage(info, v); // 메세지 조회?
        
        try{
        	allData    = SepoaDataMapper.getData(info, gdReq); // 파라미터로 넘어온 모든 값 조회
            header     = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
            gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim(); // 그리드 칼럼 정보 조회
            gridColAry = SepoaString.parser(gridColId, ","); // 그리드 칼럼 정보 배열
            gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
            
            gdRes.addParam("mode", "query");

            Object[] obj = {header};
            
            value = ServiceConnector.doService(info, "p1003", "CONNECTION","getCatalog", obj);

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
        		for(int k = 0; k < gridColAry.length; k++){
        			colKey   = gridColAry[k];
        			
                    if("SELECTED".equals(gridColAry[k])){
                        gdRes.addValue("SELECTED", "0");
                    }
        			else if("IMAGE_FILE_PATH".equals(colKey)){//이미지 경로 그리드컬럼
        				colValue = sf.getValue(colKey, i);
        			}
        			else if("IMAGE_FILE".equals(colKey)){//이미지 그리드컬럼
        				colValue = sf.getValue(colKey, i);
        				if(colValue == null || "".equals(colValue)){
        					colValue = "/images/000/icon/icon_close3.gif";//이미지 경로 세팅
        				} else {
        					colValue = "/images/ico_x1.gif";//이미지 경로 세팅
        				}
        			}
        			else{
        				colValue = sf.getValue(colKey, i);
        			}
        			
        			gdRes.addValue(colKey, colValue);
        		}            	
            }
        }
        catch (Exception e){
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }

    /**
     * 품목 마스터 리스트를 조회한다.
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getCatalogSo(GridData gdReq, SepoaInfo info) throws Exception{
        GridData            gdRes      = new GridData();
        SepoaFormater       sf         = null;
        SepoaOut            value      = null;
        Vector              v          = new Vector();
        HashMap             message    = null;
        Map<String, Object> allData    = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header     = null;
        String              gridColId  = null;
        String[]            gridColAry = null;
        String        		colValue   = null;
        String        		colKey     = null;
        int                 rowCount   = 0;
        
        v.addElement("MESSAGE");
        
        message = MessageUtil.getMessage(info, v); // 메세지 조회?
        
        try{
        	allData    = SepoaDataMapper.getData(info, gdReq); // 파라미터로 넘어온 모든 값 조회
            header     = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
            gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim(); // 그리드 칼럼 정보 조회
            gridColAry = SepoaString.parser(gridColId, ","); // 그리드 칼럼 정보 배열
            gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
            
            gdRes.addParam("mode", "query");

            Object[] obj = {header};
            
            value = ServiceConnector.doService(info, "p1003", "CONNECTION","getCatalogSo", obj);

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
        		for(int k = 0; k < gridColAry.length; k++){
        			colKey   = gridColAry[k];
        			
                    if("SELECTED".equals(gridColAry[k])){
                        gdRes.addValue("SELECTED", "0");
                    }
        			else if("IMAGE_FILE_PATH".equals(colKey)){//이미지 경로 그리드컬럼
        				colValue = sf.getValue(colKey, i);
        			}
        			else if("IMAGE_FILE".equals(colKey)){//이미지 그리드컬럼
        				colValue = sf.getValue(colKey, i);
        				if(colValue == null || "".equals(colValue)){
        					colValue = "/images/000/icon/icon_close3.gif";//이미지 경로 세팅
        				} else {
        					colValue = "/images/ico_x1.gif";//이미지 경로 세팅
        				}
        			}
        			else{
        				colValue = sf.getValue(colKey, i);
        			}
        			
        			gdRes.addValue(colKey, colValue);
        		}            	
            }
        }
        catch (Exception e){
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }

    
    /**
     * ???
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
	private GridData getCatalog2(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes      = new GridData();
        SepoaFormater       sf         = null;
        SepoaOut            value      = null;
        Vector              v          = new Vector();
        HashMap             message    = null;
        Map<String, Object> allData    = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header     = null;
        String              gridColId  = null;
        String[]            gridColAry = null;
        int                 rowCount   = 0;
        
        v.addElement("MESSAGE");
        
        message = MessageUtil.getMessage(info, v); // 메세지 조회?
        
        try{
        	allData    = SepoaDataMapper.getData(info, gdReq); // 파라미터로 넘어온 모든 값 조회
            header     = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
            gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim(); // 그리드 칼럼 정보 조회
            gridColAry = SepoaString.parser(gridColId, ","); // 그리드 칼럼 정보 배열
            gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
            
            gdRes.addParam("mode", "query");

            Object[] obj = {header};
            
            value = ServiceConnector.doService(info, "p1003", "CONNECTION","getCatalog2", obj);

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
    
    /**
     * 나의 카탈로그 담기를 처리하는 메소드
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData doData(GridData gdReq, SepoaInfo info) throws Exception{
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
			
			value = ServiceConnector.doService(info, "mycatalog", "TRANSACTION", "setDelete_myCatalog",       obj);
			value = ServiceConnector.doService(info, "mycatalog", "TRANSACTION", "getMyCatalogSelect_Insert", obj);
			
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
    
    /**
     * 품목 마스터 리스트를 조회한다.
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getCatalog5(GridData gdReq, SepoaInfo info) throws Exception{
        GridData            gdRes      = new GridData();
        SepoaFormater       sf         = null;
        SepoaOut            value      = null;
        Vector              v          = new Vector();
        HashMap             message    = null;
        Map<String, Object> allData    = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map<String, String> header     = null;
        String              gridColId  = null;
        String[]            gridColAry = null;
        String        		colValue   = null;
        String        		colKey     = null;
        int                 rowCount   = 0;
        
        v.addElement("MESSAGE");
        
        message = MessageUtil.getMessage(info, v); // 메세지 조회?
        
        try{
        	allData    = SepoaDataMapper.getData(info, gdReq); // 파라미터로 넘어온 모든 값 조회
            header     = MapUtils.getMap(allData, "headerData"); // 조회 조건 조회
            gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim(); // 그리드 칼럼 정보 조회
            gridColAry = SepoaString.parser(gridColId, ","); // 그리드 칼럼 정보 배열
            gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
            
            gdRes.addParam("mode", "query");

            Object[] obj = {header};
            
            value = ServiceConnector.doService(info, "p1003", "CONNECTION","getCatalog5", obj);

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
        		for(int k = 0; k < gridColAry.length; k++){
        			colKey   = gridColAry[k];
        			
                    if("SELECTED".equals(gridColAry[k])){
                        gdRes.addValue("SELECTED", "0");
                    }
        			else if("IMAGE_FILE_PATH".equals(colKey)){//이미지 경로 그리드컬럼
        				colValue = sf.getValue(colKey, i);
        			}
        			else if("IMAGE_FILE".equals(colKey)){//이미지 그리드컬럼
        				colValue = sf.getValue(colKey, i);
        				if(colValue == null || "".equals(colValue)){
        					colValue = "/images/000/icon/icon_close3.gif";//이미지 경로 세팅
        				} else {
        					colValue = "/images/ico_x1.gif";//이미지 경로 세팅
        				}
        			}
        			else{
        				colValue = sf.getValue(colKey, i);
        			}
        			
        			gdRes.addValue(colKey, colValue);
        		}            	
            }
        }
        catch (Exception e){
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
    
}