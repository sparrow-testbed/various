package ev;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.rmi.PortableRemoteObject;
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
import sepoa.fw.util.SepoaString;
import sepoa.fw.util.SepoaFormater;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;


public class ev_sheet_insert2 extends HttpServlet
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException
    {
//        System.out.println("Servlet call");
    	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
	{
		doPost(req, res);
	}

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
    {
        info = sepoa.fw.ses.SepoaSession.getAllValue(req);

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
            String kor_value = JSPUtil.CheckInjection(gdReq.getParam("kor_value"));
            
//            System.out.println("kor_value]"+kor_value);

            if ("query".equals(mode))
            {
                gdRes = getSEVGL_detail(gdReq);
            }else if ("insert".equals(mode))
            {
                gdRes = setSheet_save(gdReq);
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
                OperateGridData.write(req, res, gdRes, out);
            }
            catch (Exception e)
            {
//                e.printStackTrace();
            	Logger.debug.println();
            }
        }
    }

   

   

    public GridData getSEVGL_detail(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String ev_no = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();
            String ev_year = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
            
            Map<String, String> params = new HashMap<String, String>();
            
            params.put("ev_no"	, ev_no);
            params.put("ev_year", ev_year);
    		
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");

            Object[] obj = {params};
	    	SepoaOut value = ServiceConnector.doService(info, "WO_001", "CONNECTION","getSEVGL_detail", obj);

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
            String key_info = "";
            String key_ev_m_item = "";
            String key_ev_d_item = "";
            Vector merge_vec_ev_m_item = new Vector();
            Vector merge_vec_ev_d_item = new Vector();
            Vector merge_vec_ev_remark = new Vector();
            Vector merge_vec_grade_item = new Vector();
            
            
            int cnt_ev_m_item= 0;
            int cnt_ev_d_item= 0;
            boolean stage_flag= false;
            
            for(int g=0; g<grid_col_ary.length; g++){
            }
            
            for (int i = 0; i < rowCount; i++)
            {
            	key_info = wf.getValue("EVAL_NO", i);
            	key_ev_m_item = wf.getValue("EV_M_ITEM", i);
            	key_ev_d_item = wf.getValue("EV_D_ITEM", i);
            	
            	for(int k=0; k < grid_col_ary.length; k++)
                {
            		
            		
            		if(grid_col_ary[k] != null && grid_col_ary[k].equals("selected")) {
                		gdRes.addValue("selected", "0");
                	}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("EV_M_ITEM")) {
            			cnt_ev_m_item = 0;
            			if(!merge_vec_ev_m_item.contains(key_ev_m_item)){
            				merge_vec_ev_m_item.addElement(key_ev_m_item);
							for(int z=i; z < rowCount; z++){
								
								if(wf.getValue(grid_col_ary[k], i).equals(wf.getValue(grid_col_ary[k], z))){
									cnt_ev_m_item++;
								}
							}
							
							gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_m_item);
 						}else{
 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
 						}
            			
						
            		}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("EV_D_ITEM")) {
            			cnt_ev_d_item = 0;
            			if(!merge_vec_ev_d_item.contains(key_ev_d_item)){
            				merge_vec_ev_d_item.addElement(key_ev_d_item);
							for(int z=i; z < rowCount; z++){
								
								if(wf.getValue(grid_col_ary[k], i).equals(wf.getValue(grid_col_ary[k], z))){
									cnt_ev_d_item++;
								}
							}
							
							gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_d_item);
 						}else{
 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
 						}
            			
						
            		}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("LEVEL")) {
            			if(!merge_vec_grade_item.contains(key_ev_d_item)){
            				merge_vec_grade_item.addElement(key_ev_d_item);
													
							gdRes.addRowSpanValue(grid_col_ary[k], cnt_ev_d_item+"",cnt_ev_d_item);
 						}else{
 							gdRes.addValue(grid_col_ary[k], cnt_ev_d_item+"");
 						}
            			
						
            		}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("EV_REMARK")) {
            			if(!merge_vec_ev_remark.contains(key_ev_d_item)){
            				merge_vec_ev_remark.addElement(key_ev_d_item);
													
							gdRes.addRowSpanValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i),cnt_ev_d_item);
 						}else{
 							gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
 						}
            			
						
            		}else {
                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
            }
        }
        catch (Exception e)
        {
//        	System.out.println("Exception : " + e.getMessage());
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
    
    
    
    public GridData setSheet_save(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	gdRes.setSelectable(false);
	        //int row_count = gdReq.getHeader("screen_id").getRowCount();
        	String ev_year = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
        	String ev_no = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();
        	
        	
        	
        	HashMap	header = new HashMap();		
          	header.clear();           	
          	header.put("ev_year", ev_year);
          	header.put("ev_no", ev_no);

	        Object[] obj = {header};
	    	SepoaOut value = ServiceConnector.doService(info, "WO_001", "TRANSACTION","setSheet_save", obj);

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
 
    
    
}
