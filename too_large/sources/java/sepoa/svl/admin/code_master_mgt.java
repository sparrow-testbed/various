package sepoa.svl.admin;
  
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class code_master_mgt extends HttpServlet
{
	private static final long serialVersionUID = -8117105879439451999L;

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
        
        try
        {
            String rawData = req.getParameter("WISEGRID_DATA");            
            gdReq = OperateGridData.parse(req, res);
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
            
            
            if ("query".equals(mode))
            {
                gdRes = queryCodeh(gdReq, info);
            }           
            else if ("delete".equals(mode))
            {
                gdRes = deleteCodeh(gdReq, info);
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
    }
    
    
    public GridData queryCodeh(GridData gdReq, SepoaInfo info) throws Exception
    {
    	GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaOut value = null;
        SepoaFormater wf = null;
        
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info, multilang_id);

        try
        { 
            String code = JSPUtil.CheckInjection(gdReq.getParam("code")).trim().toUpperCase();
            String searchword = JSPUtil.CheckInjection(gdReq.getParam("searchword")).trim().toUpperCase();            
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            // Client에서 셋팅한 헤더와 동일하게 GridData를 복사한다.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");          
            
            //EJB CALL
            Object[] obj = {info, code, searchword};
	    	value = ServiceConnector.doService(info, "AD_014", "CONNECTION", "getCodehQuery", obj);
            
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
            
            for (int i = 0; i < rowCount; i++)
            {            		
                for(int k=0; k < grid_col_ary.length; k++)
                {
                	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
                		gdRes.addValue("SELECTED", "0");
                	} else {
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
    
    public GridData deleteCodeh(GridData gdReq, SepoaInfo info) throws Exception
    {
    	GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        
        try
        {
        	gdRes.setSelectable(false);
	        //int row_count = gdReq.getHeader("SELECTED").getRowCount();
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data2 =
	            {
	            	gdReq.getValue("CODE", i).toUpperCase(),
	            	gdReq.getValue("TYPE", i).toUpperCase()	            	
	            };

	            bean_args[i] = loop_data2;
	        }

	        Object[] obj = {info, bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_014", "TRANSACTION", "getCodehDelete", obj);
         
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
            
        }
        catch (Exception e)
        {
        	
        	
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "delete");
        return gdRes;
    }
    
  
    /*
     * ############################## Logger 관련 ##############################
     */

    /*
     * Logger(String method, String message)
     * method명과 message를 받아서 print한다.
     */
    public void Logger(String method, String message)
    {
        
    }

    /*
     * getSystemTime()
     * 현재의 시간을 Return한다.
     */
    private String getSystemTime()
    {
        Date currentDate = new Date();

        currentDate.setTime(System.currentTimeMillis());

        return currentDate.toString();
    }
}