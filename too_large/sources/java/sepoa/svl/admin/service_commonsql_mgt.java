/**
 * @파일명   : service_commonsql_mgt.java
 * @생성일자 : 2009. 03. 25
 * @작성자   : 전선경
 * @변경이력 :
 * @프로그램 설명 : 공통모듈내역
 */
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

public class service_commonsql_mgt extends HttpServlet
{
	private static final long serialVersionUID = 3295773626482754871L;

	public void init(ServletConfig config) throws ServletException
    {
        
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
            Logger.debug.println(info.getSession("ID"), this, "######### rawdata : " + rawData);
            
            gdReq = OperateGridData.parse(req, res);
            
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
            Logger.debug.println(info.getSession("ID"), this, "mode=="+mode);

            if ("query".equals(mode))
            {
                gdRes = selectCommonModuleList(gdReq, info);
            }
            else if ("delete".equals(mode))
            {
            	Logger.debug.println(info.getSession("ID"), this, "deleteMenuList");
                
                gdRes = deleteCode(gdReq, info);
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

    
    public GridData selectCommonModuleList(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaOut value = null;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        { 
        	
            String id = JSPUtil.CheckInjection(gdReq.getParam("id")).trim().toUpperCase();
            String title = JSPUtil.CheckInjection(gdReq.getParam("title")).trim().toUpperCase();
            String type = JSPUtil.CheckInjection(gdReq.getParam("type")).trim().toUpperCase();
            String sql = JSPUtil.CheckInjection(gdReq.getParam("sql")).trim().toUpperCase();
            String language = JSPUtil.CheckInjection(gdReq.getParam("language")).trim().toUpperCase();
            
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            // Client에서 셋팅한 헤더와 동일하게 GridData를 복사한다.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            String[] straData = {id, type, title,  sql, language};

            Object[] obj = {info, straData};
	    	value = ServiceConnector.doService(info, "AD_037", "CONNECTION", "selectCommonModuleList", obj);

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

            int rowNumber = rowCount;
            
            
            for (int i = 0; i < rowCount; i++)
            {
            	for(int k=0; k < grid_col_ary.length; k++)
                {
                	if(grid_col_ary[k] != null && grid_col_ary[k].equals("selected")) {
                		gdRes.addValue("selected", "0");
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
    
    
    
    public GridData insertMenuList(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	
        	gdRes.setSelectable(false);
        	int row_count = gdReq.getRowCount();
	        //int row_count = gdReq.getHeader("module_type").getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
	            {
	              
	            	gdReq.getValue("module_type",i),
	            	gdReq.getValue("screen_id", i),
	                gdReq.getValue("screen_name", i),
	                gdReq.getValue("use_flag", i),
	                gdReq.getValue("menu_link", i),
	                gdReq.getValue("autho_apply_flag", i),
	                gdReq.getValue("add_date", i)
	            };

	            bean_args[i] = loop_data1;
	        }

           
	        Object[] obj = {info, bean_args};
            SepoaOut value = ServiceConnector.doService(info, "AD_019", "TRANSACTION", "insertMenuList", obj);
            
            //성공이라면
            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "insert");
        return gdRes;
    }
   
    
    

    public GridData deleteCode(GridData gdReq, SepoaInfo info) throws Exception
    {
    	
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	gdRes.setSelectable(false);
        	int row_count = gdReq.getRowCount();
	        //int row_count = gdReq.getHeader("module_type").getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data2 =
	            {
	            	
	            	gdReq.getValue("id",i),
	            	gdReq.getValue("language", i),
	            };

	            bean_args[i] = loop_data2;
	        }

        
	        Object[] obj = {info, bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_037", "TRANSACTION", "deleteCode", obj);

	        
            //성공이라면
            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
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

 
}
