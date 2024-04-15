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
public class ev_sheet_runing extends HttpServlet
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
        	String ev_no           = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("ev_no") )).trim();
        	String subject         = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("subject") )).trim();
            String sg_kind         = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("sg_kind") )).trim();
            String seller_code     = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("seller_code") )).trim();
            String vn_status       = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("vn_status") )).trim();
            String grid_col_id     = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("grid_col_id") )).trim();
            String [] grid_col_ary = SepoaString.parser( grid_col_id, "," );
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            Object[] obj   = { p_year, ev_no, subject, sg_kind, seller_code, vn_status };
            
	    	SepoaOut value = ServiceConnector.doService( info, "WO_029", "CONNECTION", "ev_query", obj );

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
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("ev_date") ){
            			gdRes.addValue("ev_date", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
            		}
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("vn_score") ){
            			String fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_2.gif";
            			if(!"".equals(wf.getValue("vn_score", i))) {fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon.gif";}
					    gdRes.addValue(grid_col_ary[k], fileImg);
            		}             		
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("TOTAL_SCORE") ){
            			if(!"".equals(wf.getValue("vn_score", i))) {
            				gdRes.addValue(grid_col_ary[k], wf.getValue("vn_score", i));
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
}
