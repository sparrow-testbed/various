package sepoa.svl.contract;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
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


public class contract_make_form_list extends HttpServlet
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException
    {
        //System.out.println("Servlet call");
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
        

        try
        {
            String rawData = req.getParameter("WISEGRID_DATA");
            gdReq = OperateGridData.parse(req, res);
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            String kor_value = JSPUtil.CheckInjection(gdReq.getParam("kor_value"));
            
            //System.out.println("kor_value]"+kor_value);

            if (mode.equals("doQuery"))
            {
                gdRes = getContractList(gdReq);
            }
            if (mode.equals("doRegistQuery"))
            {
            	gdRes = getRegistQuery(gdReq);
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
/*            e.printStackTrace();*/
        }
        finally
        {
            try
            {
                OperateGridData.write(req, res, gdRes, out);
            }
            catch (Exception e)
            {
/*                e.printStackTrace();*/ mode = "";
            }
        }
    }

    public GridData getContractList(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
            String cont  = JSPUtil.CheckInjection(gdReq.getParam("cont")).trim().toUpperCase();
            
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            //EJB CALL
	        Object[] obj = {info, cont};
	    	SepoaOut value = ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractList", obj);

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
            		if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
            			gdRes.addValue("SELECTED", "0");
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")) {
						gdRes.addValue("ADD_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					}else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
                }
            }
        }
        catch (Exception e)
        {
        	//System.out.println("Exception : " + e.getMessage());
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
    
    public GridData getRegistQuery(GridData gdReq) throws Exception
    {
    	GridData gdRes = new GridData();
    	int rowCount = 0;
    	SepoaFormater wf = null;
    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
    	HashMap message = MessageUtil.getMessage(info,multilang_id);
    	
    	try
    	{
    		String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
    		String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
    		
    		String cont_form_no  = JSPUtil.CheckInjection(gdReq.getParam("cont_form_no")).trim().toUpperCase();

    		gdRes = OperateGridData.cloneResponseGridData(gdReq);
    		gdRes.addParam("mode", "query");
    		
    		//EJB CALL
    		Object[] obj = {info, cont_form_no};
    		SepoaOut value = ServiceConnector.doService(info, "CT_001", "CONNECTION","getRegistList", obj);
    		
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
    		
    		Config olConfxxxx = new Configuration();
    		String POASRM_CONTEXT_NAME = olConfxxxx.getString("sepoa.context.name");

    		for (int i = 0; i < rowCount; i++)
    		{
    			for(int k=0; k < grid_col_ary.length; k++)
    			{
    				if(grid_col_ary[k] != null && grid_col_ary[k].equals("POP_UP")) {
    					gdRes.addValue("POP_UP", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
                	} else {
                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
    			}
    		}
    	}
    	catch (Exception e)
    	{
    		//System.out.println("Exception : " + e.getMessage());
    		gdRes.setMessage(message.get("MESSAGE.1002").toString());
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
}
