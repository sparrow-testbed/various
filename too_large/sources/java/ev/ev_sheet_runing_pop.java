package ev;

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

public class ev_sheet_runing_pop extends HttpServlet
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException {
//        System.out.println("evdetail_mst :: Servlet Start");
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		doPost(req, res);
	}
    
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        info           = sepoa.fw.ses.SepoaSession.getAllValue(req);
        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode     = "";
        PrintWriter out = res.getWriter();
        try 
        {
            gdReq = OperateGridData.parse(req, res);
            mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
   
            if( "query".equals(mode) ){
            	gdRes = ev_query(gdReq);
            }
            else if( "insert".equals(mode) ) {
                gdRes = ev_insert(gdReq);
            }
            else if( "delete".equals(mode) ){
            	gdRes = ev_delete(gdReq);
            }            
        }
        catch (Exception e)
        {
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
//            e.printStackTrace();
        }
        finally
        {
            try
            {
                OperateGridData.write( req, res, gdRes, out );
            }
            catch (Exception e)
            {
//                e.printStackTrace();
            	Logger.debug.println();
            }
        }
    }
    
    public GridData ev_query(GridData gdReq) throws Exception {
        GridData gdRes      = new GridData();
        int rowCount        = 0;
        SepoaFormater wf    = null;
        
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String ev_no           = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();
        	String ev_year         = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
        	String seller_code     = JSPUtil.CheckInjection(gdReq.getParam("seller_code")).trim();
        	String est_no          = JSPUtil.CheckInjection(gdReq.getParam("est_no")).trim();
        	String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("cols_ids")).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");

            Object[] obj   = { ev_no, ev_year, seller_code, est_no };
	    	SepoaOut value = ServiceConnector.doService( info, "WO_031", "CONNECTION", "ev_query", obj );

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }

            wf       = new SepoaFormater(value.result[0]);
            rowCount = wf.getRowCount();
            
            if (rowCount == 0){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }
            
            for( int i = 0; i < rowCount; i++ ){
            	for( int k=0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("sales_date") ){
            			gdRes.addValue("sales_date", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
            		}              		
            		else{
                		gdRes.addValue( grid_col_ary[k], wf.getValue(grid_col_ary[k], i) );
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
    
    public GridData ev_insert(GridData gdReq) throws Exception {
    	GridData gdRes      = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage( info, multilang_id );

        try
        {
        	gdRes.setSelectable(false);
        	int row_count        = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];
	        String ev_no         = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("ev_no"))).trim();
	        String ev_year       = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("ev_year"))).trim();
	        String seller_code   = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("seller_code"))).trim();
	        String est_no        = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("est_no"))).trim();
	        String sg_regitem    = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("sg_regitem"))).trim();
	        
	        for ( int i = 0; i < row_count; i++ ) {
	            String[] loop_data2 = {
	            					   gdReq.getValue("work_name"    ,i) 
	            					  ,gdReq.getValue("dept"         ,i)
		            	              ,gdReq.getValue("phone"        ,i)
		            	              ,gdReq.getValue("employee_seq" ,i)
		            	              ,gdReq.getValue("admin_part"   ,i)
		            	              ,gdReq.getValue("product_part" ,i)
		            	              ,gdReq.getValue("sales"        ,i)
		            	              ,gdReq.getValue("profit"       ,i)
		            	              ,gdReq.getValue("sales_date"   ,i)
		            	              ,gdReq.getValue("machine"      ,i)
		            	              ,gdReq.getValue("goods"        ,i)
		            	              ,gdReq.getValue("product"      ,i)
		            	              ,gdReq.getValue("est_no"       ,i)
		            	              ,gdReq.getValue("est_seq"      ,i)
	                                  };
	            bean_args[i] = loop_data2;
	        }

	        Object[] obj   = { bean_args, ev_no, ev_year, seller_code, est_no, sg_regitem };
	        SepoaOut value = ServiceConnector.doService(info, "WO_031", "TRANSACTION", "ev_insert", obj);

	        if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
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
    
    public GridData ev_delete(GridData gdReq) throws Exception {
    	GridData gdRes      = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage( info, multilang_id );
        try
        {
        	gdRes.setSelectable(false);
        	int row_count        = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];
	        String ev_no         = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("ev_no"))).trim();
	        String ev_year       = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("ev_year"))).trim();
	        String seller_code   = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("seller_code"))).trim();
	        String est_no        = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("est_no"))).trim();
	        String sg_regitem    = JSPUtil.CheckInjection(JSPUtil.convertStr(gdReq.getParam("sg_regitem"))).trim();
	        
	        for( int i = 0; i < row_count; i++ ) {
	            String[] loop_data2 = {
				 					   gdReq.getValue("work_name"    ,i) 
				 					  ,gdReq.getValue("dept"         ,i)
				     	              ,gdReq.getValue("phone"        ,i)
				     	              ,gdReq.getValue("employee_seq" ,i)
				     	              ,gdReq.getValue("admin_part"   ,i)
				     	              ,gdReq.getValue("product_part" ,i)
				     	              ,gdReq.getValue("sales"        ,i)
				     	              ,gdReq.getValue("profit"       ,i)
				     	              ,gdReq.getValue("sales_date"   ,i)
				     	              ,gdReq.getValue("machine"      ,i)
				     	              ,gdReq.getValue("goods"        ,i)
				     	              ,gdReq.getValue("product"      ,i)
				     	              ,gdReq.getValue("est_no"       ,i)
				     	              ,gdReq.getValue("est_seq"      ,i)
	                                  };
	            bean_args[i] = loop_data2;
	        }

	        Object[] obj   = { bean_args, ev_no, ev_year, seller_code, est_no, sg_regitem };
	        SepoaOut value = ServiceConnector.doService(info, "WO_031", "TRANSACTION", "ev_delete", obj);

	        if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else{
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
