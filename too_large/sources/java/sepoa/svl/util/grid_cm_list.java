package sepoa.svl.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class grid_cm_list extends HttpServlet
{
    public void init(ServletConfig config) throws ServletException
    {
    	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
	{
		doPost(req, res);
	}

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
    {
    	SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        String mode = "";
        PrintWriter out = res.getWriter();
        String insertResult = "";
        
        try
        {
            gdReq = OperateGridData.parse(req, res);
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
           
            if ("query".equals(mode)){			//조회
                gdRes = getPopupList(info,gdReq);
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
            
        }
        finally
        {
            try
            {
            	OperateGridData.write(req, res, gdRes, out);
            }
            catch (Exception e)
            {
            	Logger.debug.println(); 
            }
        }
        
        if("insert".equals(mode)){
    		PrintWriter pw = res.getWriter();
    		pw.println(insertResult); //Write the response back to the browser
    		pw.close(); //Close the writer
        }
    }

    //조회
    public GridData getPopupList(SepoaInfo info,GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        String POASRM_CONTEXT_NAME = new Configuration().getString("sepoa.context.name");
        
        try
        {
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            String house_code 	= JSPUtil.CheckInjection(gdReq.getParam("house_code")).trim();
            String company_code = JSPUtil.CheckInjection(gdReq.getParam("company_code")).trim();
            String type 		= JSPUtil.CheckInjection(gdReq.getParam("type")).trim();
            String pCode 		= JSPUtil.CheckInjection(gdReq.getParam("pCode")).trim();
            String pDescription = JSPUtil.CheckInjection(gdReq.getParam("pDescription")).trim();
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            //EJB CALL
	        Object[] obj = {house_code, company_code, type, pCode, pDescription};
	    	SepoaOut value = ServiceConnector.doService(info, "CO_012", "CONNECTION","getEPCodeSearch", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            wf = new SepoaFormater(value.result[0]);
            rowCount = wf.getRowCount();
            
            if (rowCount == 0)
            {
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }
            
			String key_info1 = "";
            for (int i = 0; i < rowCount; i++)
            {
            	key_info1 = wf.getValue("MATERIAL_NUMBER", i);
            	for(int k=0; k < grid_col_ary.length; k++)
                {
            		if(grid_col_ary[k] != null && grid_col_ary[k].equals("selected")) {
                		gdRes.addValue("selected", "0");
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")) {
            			gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CHANGE_DATE")) {
            			gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					}else {
                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
            }
        }
        catch (Exception e)
        {
        	
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        return gdRes;
    }
}
   