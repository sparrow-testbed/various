package sepoa.svl.procure;

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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class po_update extends HttpServlet
{
public void init(ServletConfig config) throws ServletException {
	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	// �몄뀡 Object
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

       		if ("getPoDetail".equals(mode))
       		{	
       			gdRes = getPoDetail(gdReq, info);		//議고쉶
       		}
       		
       		else if ("setPoUpdate".equals(mode))
       		{	
       			gdRes = setPoUpdate(gdReq, info);		//��젣
       		}
       		/*
       		else if (mode.equals("doInsert")){
       			gdRes = doInsert(gdReq, info);
       		}
       		else if (mode.equals("doAddRow"))
       		{	
       			gdRes = doAddRow(gdReq, info);		//諛섎젮�ъ슜
       		}
       		else if (mode.equals("doQuery_DM"))
       		{	
       			gdRes = doQuery_DM(gdReq, info);		//諛섎젮�ъ슜
       		}*/
       		
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
    
    public GridData getPoDetail(GridData gdReq, SepoaInfo info) throws Exception {
   	    GridData gdRes   		= new GridData();
   	    Vector multilang_id 	= new Vector();
   	    multilang_id.addElement("MESSAGE");
   	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
   	
   		try {
   			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//洹몃━���곗씠��
   			
   		
   			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
   			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
   			
   			gdRes = OperateGridData.cloneResponseGridData(gdReq);
   			gdRes.addParam("mode", "getPoDetail");
   			
   			Object[] obj = {data};
   			// DB �곌껐諛⑸쾿 : CONNECTION, TRANSACTION, NONDBJOB
   			SepoaOut value = ServiceConnector.doService(info, "PO_002", "CONNECTION", "getPoDetailLine", obj);
   			
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
   			    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
   			    return gdRes;
   			}
   			
   			for (int i = 0; i < wf.getRowCount(); i++) {
   				for(int k=0; k < grid_col_ary.length; k++) {
   			    	 if(grid_col_ary[k] != null && grid_col_ary[k].equals("SEL")) {
   			    		gdRes.addValue("SEL", "1");
   			    	}
   			    	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
			    		gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
			    	}
   			    	 else if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_QTY")) {
   			    		gdRes.addValue(grid_col_ary[k], wf.getValue("ITEM_QTY", i));
   			    	}
   			    	 
   			    	
                   	else {
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
    
    
    public GridData setPoUpdate(GridData gdReq, SepoaInfo info) throws Exception {
   	    GridData gdRes   		= new GridData();
   	    Vector multilang_id 	= new Vector();
   	    multilang_id.addElement("MESSAGE");
   	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
   
   		try {
   			gdRes.setSelectable(false);
   			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//洹몃━���곗씠��
   			Map<String,String> header = MapUtils.getMap(data,"headerData");
   			String CHANGE_DATE = SepoaDate.getShortDateString();
   			String CHANGE_TIME = SepoaDate.getShortTimeString();
   			String CHANGE_USER_ID = info.getSession("ID");
   			String COMPANY_CODE = info.getSession("COMPANY_CODE");
   			String PURCHASER_ID = info.getSession("ID");
   			String PURCHASER_NAME = info.getSession("NAME_LOC");
   			String STATUS = "R";
   			String SPACE = "";
   			String STR_FLAG = "";
   			Number EXEC_AMT_KRW = MapUtils.getNumber(header,"EXEC_AMT_KRW");
   			String SIGN_FLAG = MapUtils.getString(header,"SIGN_FLAG","0");
   			String TAKE_USER_ID= MapUtils.getString(header,"TAKE_USER_ID","0");
   			String PO_NO= MapUtils.getString(header,"PO_NO","0");
   			data.put("PO_NO", PO_NO);
   			data.put("CHANGE_DATE", CHANGE_DATE);
   			data.put("STATUS", STATUS);
   			data.put("CHANGE_TIME", CHANGE_TIME);
   			data.put("CHANGE_USER_ID", CHANGE_USER_ID);
   			data.put("COMPANY_CODE", COMPANY_CODE);
   			data.put("SPACE", SPACE);
   			data.put("STR_FLAG", STR_FLAG);
   			data.put("PURCHASER_ID", PURCHASER_ID);
   			data.put("PURCHASER_NAME", PURCHASER_NAME);
   			data.put("ITEM_AMT_KRW", EXEC_AMT_KRW);
   			data.put("SIGN_STATUS",SIGN_FLAG);
   			data.put("PO_TTL_AMT",EXEC_AMT_KRW);
   			data.put("TAKE_USER_NAME",TAKE_USER_ID);
   			
   			/*String po_no="";
   			if(data.get("PO_NO").equals("xp")){
	            SepoaOut so = DocumentUtil.getDocNumber(info,"POD");  // 발주번호 생성.
	            po_no = so.result[0];
	        } else {
	        	po_no = (String) data.get("PO_NO");  // Menual 발주번호생성
	        }
   			data.put("PO_NO", po_no);*/
   			gdRes.addParam("mode", "update");
   			
   			Object[] obj = {data};
   			// DB �곌껐諛⑸쾿 : CONNECTION, TRANSACTION, NONDBJOB
   			SepoaOut value = ServiceConnector.doService(info, "PO_002", "TRANSACTION", "setPoUpdate", obj);
   			
   			if(value.flag) {
   			    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
   			    gdRes.setStatus("true");
   			 
   			} else {
   				gdRes.setMessage(value.message);
   				gdRes.setStatus("false");
   			}
   		} catch (Exception e) {
//   			e.printStackTrace();
   		    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
   			gdRes.setStatus("false");
   	    }
   		
   		return gdRes;
   	}

}
