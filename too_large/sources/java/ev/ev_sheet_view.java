package ev;

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

public class ev_sheet_view  extends HttpServlet
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException
    {
//        System.out.println("Servlet call");
    	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
	{
		doPost(req, res);
	}

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
    {
        info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        String mode = "";
        PrintWriter out = res.getWriter();
        
        try {
    		
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("query".equals(mode)){ 						//조회
    			gdRes = this.getSEVGL_detail(gdReq, info);
    		}else if("insert".equals(mode)){				//저장
    			//gdRes = this.setSheet_save(gdReq, info);
    			Logger.debug.println();
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
     * 심사표상세조회 
     * getSEVGL_detail
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-11-24
     * @modify 2014-11-24
     */
	private GridData getSEVGL_detail(GridData gdReq, SepoaInfo info2) throws Exception{
  
		
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
//	    	System.out.println(header);
	    	value = ServiceConnector.doService(info, "WO_001", "CONNECTION","getSEVGL_detail", obj);
	
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
}
