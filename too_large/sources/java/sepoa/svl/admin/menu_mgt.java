/**
 * @占쏙옙占싹몌옙   : menu_mgt.java
 * @占쏙옙占쏙옙占쏙옙 : 2009. 03. 25
 * @占쌜쇽옙占쏙옙   : 占쏙옙占?
 * @占쏙옙占쏙옙占싱뤄옙 :
 * @占쏙옙占싸그뤄옙 占쏙옙占쏙옙 : 占쌨댐옙占쏙옙
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

public class menu_mgt extends HttpServlet
{
	private static final long serialVersionUID = -588538889486205794L;

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
            //String rawData = req.getParameter("WISEGRID_DATA");            
            //Logger.debug.println(info.getSession("ID"), this, "######### rawdata : " + rawData);
            
            gdReq = OperateGridData.parse(req, res);
            
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
            Logger.debug.println(info.getSession("ID"), this, "mode=="+mode);

            if ("query".equals(mode))
            {
                gdRes = selectMenuMuhd(gdReq, info);
            }
            else if ("insert".equals(mode))
            {
            	//Logger.debug.println(info.getSession("ID"), this, "insertMenuList");
                
                gdRes = insertMenuMuhd(gdReq, info);
            }
            else if ("update".equals(mode))
            {
            	//Logger.debug.println(info.getSession("ID"), this, "updateMenuMuhd");
                
                gdRes = updateMenuMuhd(gdReq, info);
            }
            else if ("delete".equals(mode))
            {
            	//Logger.debug.println(info.getSession("ID"), this, "deleteMenuMu");
                
                gdRes = deleteMenuMu(gdReq, info);
            }
            else if ("copy".equals(mode))
            {
            	//Logger.debug.println(info.getSession("ID"), this, "deleteMenuMu");
                
                gdRes = copymenu(gdReq, info);
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

    
    public GridData selectMenuMuhd(GridData gdReq, SepoaInfo info) throws Exception
    {
    	
    	//Logger.debug.println(info.getSession("ID"), this, "xxxxxxxxxxxxxxxxx");
    	
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaOut value = null;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        { 

            String strMenuName = JSPUtil.CheckInjection(gdReq.getParam("st_menu_name")).trim();
            String strMuduleType = JSPUtil.CheckInjection(gdReq.getParam("st_module_type")).trim();
            String strObjectCode = JSPUtil.CheckInjection(gdReq.getParam("st_menu_object_code")).trim();
            
            //Logger.debug.println(info.getSession("ID"), this, "strMenuName=="+strMenuName);
        	
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            // Client占쏙옙占쏙옙 占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙占?占쏙옙占쏙옙占싹곤옙 GridData占쏙옙 占쏙옙占쏙옙占싼댐옙.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj = {strMenuName, strMuduleType, strObjectCode};
	    	value = ServiceConnector.doService(info, "AD_021", "CONNECTION", "selectMenuMuhd", obj);

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
                	} 
                	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("add_date")) {
                		gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                	} 
                	else {
                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
            }
/**
            for (int i = 0; i < rowCount; i++)
            {
            	 gdRes.addValue("selected"			, "0");
                 gdRes.addValue("module_type"		,wf.getValue("module_type", i));//占쌍메댐옙占쌘듸옙
                 gdRes.addValue("screen_id"			,wf.getValue("screen_id", i));//화占쏙옙ID
                 gdRes.addValue("screen_name"		,wf.getValue("screen_name", i));//화占쏙옙占?
                 gdRes.addValue("menu_link"			,wf.getValue("menu_link", i));//占쌨댐옙占쏙옙크
                 gdRes.addValue("use_flag"			,wf.getValue("use_flag", i));//占쏙옙肉⑼옙占?
                 gdRes.addValue("autho_apply_flag"	,wf.getValue("autho_apply_flag", i));//占쏙옙占쏙옙占쏙옙肉⑼옙占?
                 gdRes.addValue("add_user_name"		,wf.getValue("add_user_name", i));//占쏙옙占쏙옙占?
                 gdRes.addValue("add_date"			,wf.getValue("add_date", i));//占쏙옙占쏙옙占?

            }
           **/ 
           
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
    
       
	/**
	 * @占쌨소듸옙占?: insertMenuMuhd
	 * @占쏙옙占쏙옙占쏙옙 : 2009. 03. 26
	 * @占쌜쇽옙占쏙옙   : 占쏙옙占?
	 * @占쏙옙占쏙옙占싱뤄옙 :
	 * @占쌨소듸옙 占쏙옙占쏙옙 : 占쌨댐옙占쏙옙 > 占쏙옙占쏙옙
	 */
    public GridData insertMenuMuhd(GridData gdReq, SepoaInfo info) throws Exception
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
/*
 *              straData[i][0] = gd.getHeader("MENU_NAME").getValue(i);
				straData[i][1] = gd.getHeader("MODULE_TYPE").getValue(i);
				straData[i][2] = gd.getHeader("MENU_LINK").getValue(i);

				straData[i][3] = gd.getHeader("USE_FLAG").getValue(i).equals("1") ? "Y" : "N";
				straData[i][4] = gd.getHeader("INIT_SCREEN_ID").getValue(i);
 */
	            		
	            		gdReq.getValue("menu_name",i),
		            	gdReq.getValue("module_type",i),
		            	gdReq.getValue("menu_link",i),
		            	gdReq.getValue("use_flag", i),
		                gdReq.getValue("init_screen_id", i),
	            };

	            bean_args[i] = loop_data2;
	        }

        
	        Object[] obj = {bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_021", "TRANSACTION", "insertMenuMuhd", obj);

	        
            //占쏙옙占쏙옙占싱띰옙占?
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
    

    public GridData updateMenuMuhd(GridData gdReq, SepoaInfo info) throws Exception
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
     	
            		gdReq.getValue("menu_name",i),
	            	gdReq.getValue("module_type",i),
	            	gdReq.getValue("menu_link",i),
	            	"1".equals(gdReq.getValue("use_flag", i)) ? "Y" : "N",
	                gdReq.getValue("menu_object_code", i),
	                gdReq.getValue("init_screen_id", i),
	            };

	            bean_args[i] = loop_data2;
	        }

        
	        Object[] obj = {bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_021", "TRANSACTION", "updateMenuMuhd", obj);

	        
            //占쏙옙占쏙옙占싱띰옙占?
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
    
    public GridData deleteMenuMu(GridData gdReq, SepoaInfo info) throws Exception
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
	            	gdReq.getValue("menu_object_code", i),
	            };

	            bean_args[i] = loop_data2;
	        }

        
	        Object[] obj = {bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_021", "TRANSACTION", "deleteMenuMu", obj);

	        
            //占쏙옙占쏙옙占싱띰옙占?
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

    public GridData copymenu(GridData gdReq, SepoaInfo info) throws Exception
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
	            	gdReq.getValue("menu_object_code", i),
	            };

	            bean_args[i] = loop_data2;
	        }

        
	        Object[] obj = {bean_args[0][0]};
	        SepoaOut value = ServiceConnector.doService(info, "AD_021", "TRANSACTION", "copyMenu", obj);

	        
            //占쏙옙占쏙옙占싱띰옙占?
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

        gdRes.addParam("mode", "copy");
        return gdRes;
    }
}
