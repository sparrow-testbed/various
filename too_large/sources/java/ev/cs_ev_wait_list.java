package ev;

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
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class cs_ev_wait_list extends HttpServlet
{
public void init(ServletConfig config) throws ServletException {
	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	// 세션 Object
        SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = null;
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
        
        try {
       		gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
       		if ("getCsEvWaitList".equals(mode))
       		{	
       			gdRes = getCsEvWaitList(gdReq, info);		//공사 평가대상 조회
       		}else if("getCsEvList".equals(mode)){
       			gdRes = getCsEvList(gdReq, info);		//공사 평가 조회
    		}else if("setEcSave".equals(mode)){
    			gdRes = this.setEcSave(gdReq, info);
    		}else if ("setEcDelete".equals(mode)) {
				gdRes = setEcDelete(gdReq, info);
			}else if ("doEvalChg".equals(mode)){
       			gdRes = doEvalChg(gdReq, info);		//조회
       		}else if("getCsEvList2".equals(mode)){
       			gdRes = getCsEvList2(gdReq, info);		//공사 평가 통계
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
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doEvalChg(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "EV_001", "TRANSACTION", "doEvalChg",       obj);
    		
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
    
    public GridData setEcDelete(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

		try {
			gdRes.addParam("mode", "doDelete");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Object[] obj = {data};
			Map<String,String> header = MapUtils.getMap(data,"headerData");
			SepoaOut value = ServiceConnector.doService(info, "EV_001", "TRANSACTION","setEcDelete", obj);
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

        gdRes.addParam("mode", "delete");
        return gdRes;
    }
  	
	private GridData getCsEvWaitList(GridData gdReq, SepoaInfo info) throws Exception
	{
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 try{
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				
//				SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getCsEvWaitList",obj);
				SepoaOut value = ServiceConnector.doService(info, "EV_001", "CONNECTION","getCsEvWaitList",obj);
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				for (int i = 0; i < wf.getRowCount(); i++) {
					for(int k=0; k < grid_col_ary.length; k++) {
					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
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
	
	private GridData getCsEvList(GridData gdReq, SepoaInfo info) throws Exception
	{
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 try{
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				
//				SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getCsEvWaitList",obj);
				SepoaOut value = ServiceConnector.doService(info, "EV_001", "CONNECTION","getCsEvList",obj);
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				for (int i = 0; i < wf.getRowCount(); i++) {
					for(int k=0; k < grid_col_ary.length; k++) {
					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
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
	
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setEcSave(GridData gdReq, SepoaInfo info) throws Exception{
		GridData                  gdRes            = new GridData();
	    Vector                    multilangId      = new Vector();
	    HashMap                   message          = null;
	    SepoaOut                  value            = null;
	    Map<String, Object>       data             = null;
	    Map<String, String>       header           = null;
	    List<Map<String, String>> grid             = null;
	    
	    multilangId.addElement("MESSAGE");
	    
		message = MessageUtil.getMessage(info, multilangId);
		
		String     ecNo             = null;
		
		try {
			gdRes.addParam("mode", "doSave");
			gdRes.setSelectable(false);
			
			ecNo = this.getECNo(info);		
			
			data   = SepoaDataMapper.getData(info, gdReq);
			header = MapUtils.getMap(data, "headerData"); // 조회 조건 조회
			header = this.getHeader(info, header, ecNo); // 조회 조건 조작
			grid   = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			grid   = this.getGrid(header, grid, ecNo); // 그리드 정보 조작
			
			Object[] obj = {data};
			
			value = ServiceConnector.doService(info, "EV_001", "TRANSACTION", "setEcSave", obj);
			
			if(value.flag) {
				gdRes.setMessage(value.message); 
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
	
	private String getECNo(SepoaInfo info) throws Exception{
    	String   result = null;
    	SepoaOut wo2    = null;
    	
    	wo2    = DocumentUtil.getDocNumber(info, "EC");
    	result = wo2.result[0];
    	
    	return result;
    }
	
	/**
	 * 서비스에서 사용할 헤더의 정보를 조작하는 메소드
	 * 
	 * @param info
	 * @param header
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> getHeader(SepoaInfo info, Map<String, String> header, String ecNo) throws Exception{
		header.put("EC_NO",             ecNo);
		return header;
	}
	
	/**
	 * 서비스에서 사용할 그리드 정보를 조작하는 메소드
	 * 
	 * @param grid
	 * @return List
	 * @throws Exception
	 */
	private List<Map<String, String>> getGrid(Map<String, String> header, List<Map<String, String>> grid, String ecNo) throws Exception{
		Map<String, String> gridInfo         = null;
		String              ecSeq            = null;
		int                 i                = 0;
		int                 gridSize         = grid.size();
		
		for(i = 0; i < gridSize; i++){
			gridInfo         = grid.get(i);
			ecSeq            = String.valueOf(i + 1);
			
			gridInfo.put("EC_NO",              ecNo);
			gridInfo.put("EC_SEQ",             ecSeq);
		}
		
		return grid;
	}
	
	private GridData getCsEvList2(GridData gdReq, SepoaInfo info) throws Exception
	{
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 try{
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				
//				SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getCsEvWaitList",obj);
				SepoaOut value = ServiceConnector.doService(info, "EV_001", "CONNECTION","getCsEvList2",obj);
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				for (int i = 0; i < wf.getRowCount(); i++) {
					for(int k=0; k < grid_col_ary.length; k++) {
					   gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));				    
					}
				}
				
		 } catch (Exception e) {
			    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
		    }
			
			return gdRes;
		
	}
}
