package sepoa.svl.admin;

import java.io.IOException;
import java.io.PrintWriter;
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


public class sap_interface_log_list extends HttpServlet
{
	private static final long serialVersionUID = -3873120917297616194L;

    public void init(ServletConfig config) throws ServletException
    {
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
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
                gdRes = getInterfaceLogList(gdReq, info);
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
            	OperateGridData.write(req, res,gdRes, out);
            }
            catch (Exception e)
            {
            	Logger.debug.println(); 
            }
        }
    }

    public GridData getInterfaceLogList(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String from_date	= SepoaString.getDateUnSlashFormat(JSPUtil.CheckInjection(gdReq.getParam("from_date")).trim());
            String to_date		= SepoaString.getDateUnSlashFormat(JSPUtil.CheckInjection(gdReq.getParam("to_date")).trim());
            String rfc_name		= JSPUtil.CheckInjection(gdReq.getParam("rfc_name")).trim().toUpperCase();
            String user_name	= JSPUtil.CheckInjection(gdReq.getParam("user_name")).trim().toUpperCase();
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");

            //EJB CALL
	        Object[] obj = {info, from_date, to_date, rfc_name, user_name};
	    	SepoaOut value = ServiceConnector.doService(info, "AD_137", "CONNECTION","getInterfaceLogList", obj);

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

            String if_time = "";

            for (int i = 0; i < rowCount; i++)
            {
                for(int k=0; k < grid_col_ary.length; k++)
                {
                    if(grid_col_ary[k] != null && grid_col_ary[k].equals("selected"))
                    {
                        gdRes.addValue("selected", "0");
                    }
                    else if(grid_col_ary[k] != null && grid_col_ary[k].equals("IF_DATE"))
                    {
                        gdRes.addValue("IF_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                    }
                    else if(grid_col_ary[k] != null && grid_col_ary[k].equals("IF_TIME"))
                    {
                        gdRes.addValue("IF_TIME", SepoaString.getTimeColonFormat(wf.getValue(grid_col_ary[k], i)));
                    }
                    else
                    {
                        gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                    }
                }
            }
        }
        catch (Exception e)
        {
        	Logger.debug.println(info.getSession("ID"), this, new Exception().getStackTrace()[0].getClassName()+"."+new Exception().getStackTrace()[0].getMethodName()+", Line Number : " + new Exception().getStackTrace()[0].getLineNumber() + ", ERROR : " + e.getMessage());
			
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
}
