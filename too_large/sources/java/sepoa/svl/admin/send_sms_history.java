/**
 * @파일명   : send_sms_history.java
 * @생성일자 : 2009. 03. 23
 * @작성자   : 전선경
 * @변경이력 :
 * @프로그램 설명 : SMS 전송내역
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

public class send_sms_history extends HttpServlet
{
	private static final long serialVersionUID = 3199063672285618371L;

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

            gdReq = OperateGridData.parse(req, res);
            
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
            Logger.debug.println(info.getSession("ID"), this, "mode=="+mode);

            if ("query".equals(mode))
            {
                gdRes = searchSendSmsHistory(gdReq, info);
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

    
    public GridData searchSendSmsHistory(GridData gdReq, SepoaInfo info) throws Exception
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

            String from_date 	= SepoaString.getDateUnSlashFormat(JSPUtil.paramCheck(gdReq.getParam("from_date")).trim());
            String to_date 		= SepoaString.getDateUnSlashFormat(JSPUtil.paramCheck(gdReq.getParam("to_date")).trim());
            String seller_code 	= JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim();
            String send_recv 	= JSPUtil.paramCheck(gdReq.getParam("send_recv")).trim();
            String sms_send 	= JSPUtil.paramCheck(gdReq.getParam("sms_send")).trim();
            String message_recv = JSPUtil.paramCheck(gdReq.getParam("content")).trim();
            
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            // Client에서 셋팅한 헤더와 동일하게 GridData를 복사한다.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");

            Object[] obj = {from_date, to_date,seller_code,send_recv,sms_send,message_recv};
	    	value = ServiceConnector.doService(info, "AD_052", "CONNECTION", "searchSendSmsHistory", obj);

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
            		Logger.debug.println();
            		
            		
                	if(grid_col_ary[k] != null && grid_col_ary[k].equals("send_date_time")) {
                		gdRes.addValue(grid_col_ary[k], wf.getValue("send_date", i) +" "+wf.getValue("send_time", i)  );
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
	            String[] loop_data1 =
	            {
            
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

	            bean_args[i] = loop_data1;
	        }

           
	        Object[] obj = {info, bean_args};
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
	            String[] loop_data2 =
	            {
	            	
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
