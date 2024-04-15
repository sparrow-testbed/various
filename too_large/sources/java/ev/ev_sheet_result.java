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

@SuppressWarnings("serial")
public class ev_sheet_result extends HttpServlet
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
        
        String POASRM_CONTEXT_NAME = new Configuration().getString("sepoa.context.name");
        try
        {
        	String p_year          = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("p_year") )).trim();
        	String p_ev_no         = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("p_ev_no") )).trim();
        	String p_conf_status   = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("p_conf_status") )).trim();
            String grid_col_id     = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("grid_col_id") )).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { p_year, p_ev_no, p_conf_status };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_032", "CONNECTION", "ev_query", obj );

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
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("conf_date") ){
            			String formatData = "";
            			String format     = "";
            			String data[] = wf.getValue(grid_col_ary[k], i).split(" ~ ");
            			
            			for( int j = 0; j < data.length; j++ ){
            				if( j != 0 ) {format = " ~ ";}
            				formatData += format + SepoaString.getDateSlashFormat(data[j]);
            			}
            			gdRes.addValue("conf_date", formatData);
            		}             		
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("lifnr_conf_date") ){
            			String formatData = "";
            			String format     = "";
            			String data[] = wf.getValue(grid_col_ary[k], i).split(" ~ ");
            			
            			for( int j = 0; j < data.length; j++ ){
            				if( j != 0 ) {format = " ~ ";}
            				formatData += format + SepoaString.getDateSlashFormat(data[j]);
            			}
            			gdRes.addValue("lifnr_conf_date", formatData);
            		}
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("score") ){
            			String fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif";
            			if(!"".equals(wf.getValue("score", i))){ fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon.gif";}
					    gdRes.addValue(grid_col_ary[k], fileImg);
            		} 
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("TOTAL_SCORE") ){
            			if(!"".equals(wf.getValue("score", i))) {
            				gdRes.addValue(grid_col_ary[k], wf.getValue("score", i));
            			}else{
            				gdRes.addValue(grid_col_ary[k], "");
            			}
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
        	int row_count          = gdReq.getRowCount();
	        String[][] bean_args   = new String[row_count][];
        	
	        for ( int i = 0; i < row_count; i++ ) {
	            String[] loop_data2 = {
	            					   gdReq.getValue("seller_name"     ,i)
	            					  ,gdReq.getValue("ev_no"           ,i) 
		            	              ,gdReq.getValue("subject"         ,i)
		            	              ,gdReq.getValue("conf_date"       ,i)
		            	              ,gdReq.getValue("lifnr_conf_date" ,i)
		            	              ,gdReq.getValue("score"           ,i)
		            	              ,gdReq.getValue("accept_value"    ,i)
		            	              ,gdReq.getValue("ev_date_flag"    ,i)
		            	              ,gdReq.getValue("offline_flag"    ,i)
		            	              ,gdReq.getValue("confirm_flag"    ,i)
		            	              ,gdReq.getValue("ev_year"         ,i)
		            	              ,gdReq.getValue("sg_regitem"      ,i)
		            	              ,gdReq.getValue("seller_code"     ,i)
	                                  };
	            bean_args[i] = loop_data2;
	        }

	        Object[] obj   = { bean_args };
	        SepoaOut value = ServiceConnector.doService(info, "WO_032", "TRANSACTION", "ev_insert", obj);

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
}
