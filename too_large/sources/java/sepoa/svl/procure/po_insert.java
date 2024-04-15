package sepoa.svl.procure;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
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



public class po_insert extends HttpServlet {
	private static final long serialVersionUID = 1L;
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    	    throws IOException, ServletException
    		{
    			doPost(req, res);
    		}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
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

       		if ("getPoInsert".equals(mode))
       		{	
       			gdRes = getPoInsert(gdReq, info);		//조회
       		}else if("setPoInsert".equals(mode)){
       			gdRes = setPoInsert(gdReq, info);
       		}else if("setPoInsertAll".equals(mode)){
       			gdRes = setPoInsertAll(gdReq, info);
   			}else if("setPoCancel".equals(mode)){
   				gdRes = setPoCancel(gdReq, info);
   			}else if ("charge_transfer".equals(mode)){
       			gdRes = charge_transfer(gdReq, info);		//조회
       		}else if("setExPoCancel".equals(mode)){
   				gdRes = setExPoCancel(gdReq, info);
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
    private GridData charge_transfer(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "PO_001", "TRANSACTION", "charge_transfer",       obj);
    		
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
    
	public GridData getPoInsert(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
			
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "getPoInsert");
			
			Object[] obj = {data};
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "PO_001", "CONNECTION", "getPoInsert", obj);
			
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
			    		gdRes.addValue("SEL", "1");
                	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_QTY")) {
			    		gdRes.addValue(grid_col_ary[k], wf.getValue("SETTLE_QTY", i));
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
            
	public GridData setPoInsert(GridData gdReq, SepoaInfo info) throws Exception {
	    GridData gdRes      = new GridData();
	    Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message     = MessageUtil.getMessage(info,multilang_id);
		
		try {
			gdRes.addParam("mode", "setPoInsert");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Object[] obj = {data};
			Map<String,String> header = MapUtils.getMap(data,"headerData");
			String po_no="";
			if("xp".equals(header.get("PO_NO"))){
	            SepoaOut so = DocumentUtil.getDocNumber(info,"POD");  // 발주번호 생성.
	            po_no = so.result[0];
	        } else {
	        	po_no = header.get("PO_NO");  // Menual 발주번호생성
	        }
			header.put("PO_NO", po_no);
			data.put("headerData", header);
			SepoaOut value = ServiceConnector.doService(info, "PO_001", "TRANSACTION","setPoInsert", obj);
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
	
	
	public GridData setPoInsertAll(GridData gdReq, SepoaInfo info) throws Exception {
		    GridData gdRes      = new GridData();
		    Vector multilang_id = new Vector();
			multilang_id.addElement("MESSAGE");
			HashMap message     = MessageUtil.getMessage(info,multilang_id);
			Map<String, String>       gridInfo        = null;
			
			try {
				gdRes.addParam("mode", "setPoInsert");
				gdRes.setSelectable(false);
				
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String,String> header = MapUtils.getMap(data,"headerData");
				String po_no="";
				
				List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
				//for start
	            for(int i = 0; i < grid.size(); i++){
	                gridInfo = grid.get(i);
	                String EXEC_NO = gridInfo.get("EXEC_NO");
	                        
	                SepoaOut so = DocumentUtil.getDocNumber(info,"POD");  // 발주번호 생성.
		            po_no = so.result[0];
//		            System.out.println("po_no==============="+po_no);
		         
		            //header.put("PO_NO", po_no);
					//data.put("headerData", header);
					
					Object[] obj = {po_no, gridInfo};
					SepoaOut value = ServiceConnector.doService(info, "PO_001", "TRANSACTION","setPoInsertAll", obj);
					if(value.flag) {
						gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
						gdRes.setStatus("true");
					}else {
						gdRes.setMessage(value.message);
						gdRes.setStatus("false");
						break;
					}
	            }			
				
			} catch (Exception e) {
				
				gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
			}
		    return gdRes;
		}
//  [R102204283448] [2022-05-06] (은행)전자구매 발주취소(연단가) 거래개선
//  위SR 개발로 인한 주석처리
//	public GridData setPoCancel(GridData gdReq, SepoaInfo info) throws Exception {
//	    GridData gdRes      = new GridData();
//	    Vector multilang_id = new Vector();
//		multilang_id.addElement("MESSAGE");
//		HashMap message     = MessageUtil.getMessage(info,multilang_id);
//		Map<String, String>       gridInfo        = null;
//		
//		try {
//			gdRes.addParam("mode", "setPoCancel");
//			gdRes.setSelectable(false);
//			
//			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
//			Map<String,String> header = MapUtils.getMap(data,"headerData");
//			
//			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
//			//for start
//			for(int i = 0; i < grid.size(); i++){
//                gridInfo = grid.get(i);
//                String EXEC_NO = gridInfo.get("EXEC_NO");
//                        
//                Logger.err.println("======PO_CANCEL_TEST======");
//				
//				Object[] obj = {gridInfo};
//				SepoaOut value = ServiceConnector.doService(info, "PO_001", "TRANSACTION","setPoCancel", obj);
//				if(value.flag) {
//					gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
//					gdRes.setStatus("true");
//				}else {
//					gdRes.setMessage(value.message);
//					gdRes.setStatus("false");
//					break;
//				}
//            }			
//			
//		} catch (Exception e) {
//			
//			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
//			gdRes.setStatus("false");
//		}
//	    return gdRes;
//	}

//  [R102204283448] [2022-05-06] (은행)전자구매 발주취소(연단가) 거래개선
	public GridData setPoCancel(GridData gdReq, SepoaInfo info) throws Exception {
	    GridData gdRes      = new GridData();
	    Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message     = MessageUtil.getMessage(info,multilang_id);
		Map<String, String>       gridInfo        = null;
		
		try {
			gdRes.addParam("mode", "setPoCancel");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Map<String,String> header = MapUtils.getMap(data,"headerData");
			data.put("headerData", header);
			Object[] obj = {data};
			
			SepoaOut value = ServiceConnector.doService(info, "PO_001", "TRANSACTION","setPoCancel", obj);
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
	
	public GridData setExPoCancel(GridData gdReq, SepoaInfo info) throws Exception {
	    GridData gdRes      = new GridData();
	    Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message     = MessageUtil.getMessage(info,multilang_id);
		Map<String, String>       gridInfo        = null;
		
		try {
			gdRes.addParam("mode", "setExPoCancel");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Map<String,String> header = MapUtils.getMap(data,"headerData");
			
			List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			//for start
			for(int i = 0; i < grid.size(); i++){
                gridInfo = grid.get(i);
                String EXEC_NO = gridInfo.get("EXEC_NO");
                        
                Logger.err.println("======PO_CANCEL_TEST======");
				
				Object[] obj = {gridInfo};
				SepoaOut value = ServiceConnector.doService(info, "PO_001", "TRANSACTION","setExPoCancel", obj);
				if(value.flag) {
					//gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
					gdRes.setMessage(value.message);
					gdRes.setStatus("true");
				}else {
					gdRes.setMessage(value.message);
					gdRes.setStatus("false");
					break;
				}
            }			
			
		} catch (Exception e) {
			
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
	    return gdRes;
	}
}
