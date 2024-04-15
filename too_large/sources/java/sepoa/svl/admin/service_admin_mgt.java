/**
 * @파일명   : service_admin_mgt.java
 * @생성일자 : 2009. 03. 23
 * @작성자   : 전선경
 * @변경이력 :
 * @프로그램 설명 : 서비스관리
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

public class service_admin_mgt extends HttpServlet
{
	private static final long serialVersionUID = -7129801162806254839L;

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
            Logger.debug.println(info.getSession("ID"), this, "######### rawdata : " + rawData);
            
            gdReq = OperateGridData.parse(req, res);
            
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
            Logger.debug.println(info.getSession("ID"), this, "mode=="+mode);

            if ("query".equals(mode))
            {
                gdRes = selectFwrs(gdReq, info);
            }
            else if ("insert".equals(mode))
            {
                gdRes = insertFwrs(gdReq, info);
            }
            else if ("update".equals(mode))
            {
                gdRes = deleteInsertFwrs(gdReq, info);
            }
            else if ("delete".equals(mode))
            {
            	Logger.debug.println(info.getSession("ID"), this, "deleteMenuList");
                
                gdRes = deleteFwrs(gdReq, info);
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
                OperateGridData.write(req, res, gdRes, out);	//res 추가하지 않으면 그리드 조회 오류
            }
            catch (Exception e)
            {
            	Logger.debug.println(); 
            }
        }
    }

    
    public GridData selectFwrs(GridData gdReq, SepoaInfo info) throws Exception
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

        	
    		String strProcess = JSPUtil.CheckInjection(gdReq.getParam("process")).trim().toUpperCase();
            String strPrc_value = JSPUtil.CheckInjection(gdReq.getParam("prc_value")).trim().toUpperCase();
            String house_code = JSPUtil.CheckInjection(gdReq.getParam("house_code")).trim().toUpperCase();
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            // Client에서 셋팅한 헤더와 동일하게 GridData를 복사한다.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");

            Object[] obj = {info, strProcess, strPrc_value, house_code };
	    	value = ServiceConnector.doService(info, "AD_036", "CONNECTION", "selectFwrs", obj);

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
                	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("use_flag"))
    	            {
    	            	if("Y".equals(wf.getValue("use_flag", i))) {
    	            		gdRes.addValue("use_flag", "1");
    	            	}
    	            	else {
    	            		gdRes.addValue("use_flag", "0");
    	            	}
    	            }
                	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("autho_apply_flag"))
                	{
                		if("Y".equals(wf.getValue("autho_apply_flag", i))) {
                			gdRes.addValue("autho_apply_flag", "1");
                		}
                		else {
                			gdRes.addValue("autho_apply_flag", "0");
                		}
                	}
                	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("start_date")){
                		 gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                	}
                	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("end_date")){
                    	 gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                    }
                	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("add_date")){
                		gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                	}
                	else {
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
    
    
    
    public GridData insertFwrs(GridData gdReq, SepoaInfo info) throws Exception
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
	        	
	        	String start_date = SepoaString.getDateUnSlashFormat( gdReq.getValue("start_date", i) );
            	String end_date   = SepoaString.getDateUnSlashFormat(gdReq.getValue("end_date", i));
            	
	            String[] loop_data1 =
	            {
         
	            	
	            	gdReq.getValue("house_code",i),
	            	gdReq.getValue("process_id",i),
	            	gdReq.getValue("method", i),
	                gdReq.getValue("url", i),
	                gdReq.getValue("service_class", i),
	                "1".equals(gdReq.getValue("use_flag", i)) ? "Y" : "N",
	                gdReq.getValue("description", i),
	                "1".equals(gdReq.getValue("autho_apply_flag", i)) ? "Y" : "N",
	                gdReq.getValue("autho_object_code", i),
	                start_date,
	                end_date,
	                gdReq.getValue("end_date", i),
	                gdReq.getValue("add_user_name", i),
	                gdReq.getValue("add_date", i)
	                
	                
	            };
	            bean_args[i] = loop_data1;
	        }

           
	        Object[] obj = {bean_args};
            SepoaOut value = ServiceConnector.doService(info, "AD_036", "TRANSACTION", "insertFwrs", obj);
            
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
   
    
    public GridData deleteInsertFwrs(GridData gdReq, SepoaInfo info) throws Exception
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
	        	
	        	String start_date = SepoaString.getDateUnSlashFormat( gdReq.getValue("start_date", i) );
            	String end_date   = SepoaString.getDateUnSlashFormat(gdReq.getValue("end_date", i));
            	
	            String[] loop_data2 =
	            {
	            	
		            	gdReq.getValue("house_code",i),
		            	gdReq.getValue("process_id",i),
		            	gdReq.getValue("method", i),
		                gdReq.getValue("url", i),
		                gdReq.getValue("service_class", i),
		                "1".equals(gdReq.getValue("use_flag", i)) ? "Y" : "N",
		                gdReq.getValue("description", i),
		                "1".equals(gdReq.getValue("autho_apply_flag", i)) ? "Y" : "N",
		                gdReq.getValue("autho_object_code", i),
		                start_date,
		                end_date,
		                gdReq.getValue("add_user_name", i),
		                gdReq.getValue("add_date", i)
	            };
	            bean_args[i] = loop_data2;
	        }

        
	        Object[] obj = {info, bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_036", "TRANSACTION", "deleteInsertFwrs", obj);

	        
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

        gdRes.addParam("mode", "update");
        return gdRes;
    }    

    public GridData deleteFwrs(GridData gdReq, SepoaInfo info) throws Exception
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
	            	
		            	gdReq.getValue("house_code",i),
		            	gdReq.getValue("process_id",i),
		            	gdReq.getValue("method", i),
		                gdReq.getValue("url", i),
		                gdReq.getValue("service_class", i),
		                gdReq.getValue("use_flag", i),
		                gdReq.getValue("description", i),
		                gdReq.getValue("autho_apply_flag", i),
		                gdReq.getValue("autho_object_code", i),
		                gdReq.getValue("start_date", i),
		                gdReq.getValue("end_date", i),
		                gdReq.getValue("add_user_name", i),
		                gdReq.getValue("add_date", i)
	            };

	            bean_args[i] = loop_data2;
	        }

        
	        Object[] obj = {info, bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_036", "TRANSACTION", "deleteFwrs", obj);

	        
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
