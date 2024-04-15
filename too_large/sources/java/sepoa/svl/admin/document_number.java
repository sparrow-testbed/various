/**
 * @파일명   : document_number.java
 * @생성일자 : 2009. 03. 25
 * @작성자   : 전선경
 * @변경이력 :
 * @프로그램 설명 : 문서채번 관리
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

public class document_number extends HttpServlet
{

	private static final long serialVersionUID = 2001737298675682423L;

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
                gdRes = FindDNMT(gdReq, info);
            }
            else if ("insert".equals(mode))
            {
            	//Logger.debug.println(info.getSession("ID"), this, "insertMenuList");
                
                gdRes = CreateDNMT(gdReq, info);
            }
            else if ("delete".equals(mode))
            {
            	//Logger.debug.println(info.getSession("ID"), this, "deleteMenuMu");
                
                gdRes = RemoveDNMT(gdReq, info);
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

    
    public GridData FindDNMT(GridData gdReq, SepoaInfo info) throws Exception
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


            String i_change_user_id = JSPUtil.CheckInjection(gdReq.getParam("i_change_user_id")).trim();
            
        	
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            // Client에서 셋팅한 헤더와 동일하게 GridData를 복사한다.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj = {i_change_user_id};
	    	value = ServiceConnector.doService(info, "AD_100", "CONNECTION", "FindDNMT", obj);

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
                	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("change_date")) {
                		gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                	} else{
                    		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
            }
/**
            for (int i = 0; i < rowCount; i++)
            {
            	 gdRes.addValue("selected"			, "0");
                 gdRes.addValue("module_type"		,wf.getValue("module_type", i));//주메뉴코드
                 gdRes.addValue("screen_id"			,wf.getValue("screen_id", i));//화면ID
                 gdRes.addValue("screen_name"		,wf.getValue("screen_name", i));//화면명
                 gdRes.addValue("menu_link"			,wf.getValue("menu_link", i));//메뉴링크
                 gdRes.addValue("use_flag"			,wf.getValue("use_flag", i));//사용여부
                 gdRes.addValue("autho_apply_flag"	,wf.getValue("autho_apply_flag", i));//권한적용여부
                 gdRes.addValue("add_user_name"		,wf.getValue("add_user_name", i));//등록자
                 gdRes.addValue("add_date"			,wf.getValue("add_date", i));//등록일

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
	 * @메소드명 : CreateDNMT
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 문서채번 > 저장
	 */
    public GridData CreateDNMT(GridData gdReq, SepoaInfo info) throws Exception
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

	            	gdReq.getValue("doc_type",i),
	                gdReq.getValue("description",i)
		        };

	            bean_args[i] = loop_data2;
	        }

	        
	        Object[] obj = {bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_100", "TRANSACTION", "CreateDNMT", obj);

	        
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
    
    public GridData RemoveDNMT(GridData gdReq, SepoaInfo info) throws Exception
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
	            	gdReq.getValue("doc_type", i),
	            };

	            bean_args[i] = loop_data2;
	        }

        
	        Object[] obj = {bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_100", "TRANSACTION", "RemoveDNMT", obj);

	        
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

        gdRes.addParam("mode", "copy");
        return gdRes;
    }
}
