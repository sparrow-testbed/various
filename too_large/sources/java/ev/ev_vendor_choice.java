package ev;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
//import sepoa.fw.util.MessageUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings("serial")
public class ev_vendor_choice extends HttpServlet
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
        //HashMap message     = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String sg_type1        = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("sg_type1") )).trim();
        	String sg_type2        = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("sg_type2") )).trim();
        	String sg_type3        = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("sg_type3") )).trim();
        	String seller_code     = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("seller_code") )).trim();
        	String ev_flag         = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("ev_flag") )).trim();
        	String ev_no           = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("ev_no") )).trim();
        	
            String grid_col_id     = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("grid_col_id") )).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { sg_type1, sg_type2, sg_type3, seller_code, ev_flag, ev_no };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_033", "CONNECTION", "ev_query", obj );

            if(value.flag){
                gdRes.setMessage("성공적으로 처리 하였습니다.");
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
                gdRes.setMessage("조회된 데이터가 없습니다.");
                return gdRes;
            }
           
            for( int i = 0; i < rowCount; i++ ){
            	for( int k=0; k < grid_col_ary.length; k++ ){
            		if( grid_col_ary[k] != null && grid_col_ary[k].equals("selected") ) {
                		gdRes.addValue("selected", "0");
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("st_date")){
                		gdRes.addValue( grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)) );
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("end_date")){
                		gdRes.addValue( grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)) );
                	}
            		
            		else{
                		gdRes.addValue( grid_col_ary[k], wf.getValue(grid_col_ary[k], i) );
                	}
                }
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage("처리 중 오류가 발생하였습니다");
            gdRes.setStatus("false");
        }
        
        return gdRes;    	
    }
    
    public GridData ev_insert(GridData gdReq) throws Exception {
    	GridData gdRes      = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        //HashMap message = MessageUtil.getMessage( info, multilang_id );

        try
        {
        	gdRes.setSelectable(false);
        	int row_count          = gdReq.getRowCount();
	        String[][] bean_args   = new String[row_count][];
        	String p_start_setting = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("p_start_setting") )).replaceAll("/", "").trim();
        	String p_ends_setting  = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("p_ends_setting") )).replaceAll("/", "").trim();
        	String APPROVAL_STR    = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("APPROVAL_STR") )).trim();
	        for ( int i = 0; i < row_count; i++ ) {
	            String[] loop_data2 = {
	            					   gdReq.getValue("vendor_code"     ,i)
	            					  ,gdReq.getValue("vendor_name_loc" ,i) 
		            	              ,gdReq.getValue("parent1"         ,i)
		            	              ,gdReq.getValue("parent2"         ,i)
		            	              ,gdReq.getValue("sg_refitem"      ,i)
		            	              ,gdReq.getValue("subject"         ,i)
		            	              ,gdReq.getValue("st_date"         ,i).replaceAll("/", "")
		            	              ,gdReq.getValue("end_date"        ,i).replaceAll("/", "")
		            	              ,gdReq.getValue("ev_no"           ,i)
		            	              ,gdReq.getValue("ev_year"         ,i)
		            	              ,gdReq.getValue("ev_flag"         ,i)
		            	              ,gdReq.getValue("in_refitem"      ,i)
		            	              ,gdReq.getValue("sg_refitem_num"  ,i)
	                                  };
	            bean_args[i] = loop_data2;
	        }
	        Object[] obj   = { bean_args, p_start_setting, p_ends_setting, APPROVAL_STR };
	        SepoaOut value = ServiceConnector.doService(info, "WO_033", "TRANSACTION", "ev_insert", obj);

	        if(value.flag){
                gdRes.setMessage("성공적으로 처리 하였습니다.");
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
        }
        catch (Exception e)
        {
            //gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "insert");
        return gdRes;
    }        
}
