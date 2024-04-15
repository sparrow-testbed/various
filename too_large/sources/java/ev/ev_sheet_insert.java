package ev;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
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


public class ev_sheet_insert extends HttpServlet
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException
    {
        //System.out.println("Servlet call");
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
                gdRes = getsevln_list(gdReq);
            }else if ("insert".equals(mode))
            {
                gdRes = getsevln_insert(gdReq);
            }else if ("delete".equals(mode))
            {
                gdRes = getsevln_delete(gdReq);
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

    public GridData getsevln_list(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        Hashtable ht = null;

        try
        {
        	String ev_no = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();
        	String ev_year = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
        	String ev_m_item = JSPUtil.CheckInjection(gdReq.getParam("ev_m_item")).trim();
        	String ev_d_item = JSPUtil.CheckInjection(gdReq.getParam("ev_d_item")).trim();

            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            //EJB CALL
	        Object[] obj = { ev_no,  ev_year, ev_m_item, ev_d_item};
	    	SepoaOut value = ServiceConnector.doService(info, "WO_001", "CONNECTION","getsevln_list", obj);

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
            
            ArrayList arr_list =  value.array;	//value값을 arraylist로 받아서
            for (int i = 0; i < arr_list.size(); i++)
            {
            	ht = (Hashtable) arr_list.get(i);	//hashtable형태로
            	
            	 gdRes.addParam("EV_SEQ", (String)ht.get("EV_SEQ"));
            	 gdRes.addParam("EV_YEAR", (String)ht.get("EV_YEAR"));
            	 gdRes.addParam("EV_M_ITEM", (String)ht.get("EV_M_ITEM"));
            	 gdRes.addParam("EV_D_ITEM", (String)ht.get("EV_D_ITEM"));
            	 gdRes.addParam("EV_TYPE", (String)ht.get("EV_TYPE"));
            	 gdRes.addParam("EV_UNIT", (String)ht.get("EV_UNIT"));
            	 gdRes.addParam("EV_SCOPE", (String)ht.get("EV_SCOPE"));
            	 gdRes.addParam("EV_WEIGHT", (String)ht.get("EV_WEIGHT"));
            	 gdRes.addParam("EV_WEIGHT_POINT", (String)ht.get("EV_WEIGHT_POINT"));
            	 gdRes.addParam("EV_BASIC_POINT", (String)ht.get("EV_BASIC_POINT"));
            	 gdRes.addParam("EV_REMARK", (String)ht.get("EV_REMARK"));
            	 gdRes.addParam("ATTACH_REMARK", (String)ht.get("ATTACH_REMARK"));
            	 gdRes.addParam("VN_DISPLAY", (String)ht.get("VN_DISPLAY"));
            	 gdRes.addParam("MONEY_USE", (String)ht.get("MONEY_USE"));
            	 gdRes.addParam("EV_ITEM", (String)ht.get("EV_ITEM"));
            	 gdRes.addParam("ITEM_NAME1", (String)ht.get("ITEM_NAME1"));
            	 gdRes.addParam("ITEM_NAME2", (String)ht.get("ITEM_NAME2"));
            	 gdRes.addParam("ITEM_NAME3", (String)ht.get("ITEM_NAME3"));
            	 gdRes.addParam("CAL_DESC", (String)ht.get("CAL_DESC"));
            	 gdRes.addParam("EV_REQ_DESC", (String)ht.get("EV_REQ_DESC"));
            	 gdRes.addParam("EV_REQSEQ", (String)ht.get("EV_REQSEQ"));
            	 
            	 gdRes.addParam("AVG_EV_NO", (String)ht.get("AVG_EV_NO"));
            	 gdRes.addParam("SUM_EV_NO", (String)ht.get("SUM_EV_NO"));
            	 gdRes.addParam("CAL_TYPE", (String)ht.get("CAL_TYPE"));
            	 gdRes.addParam("AVG_VALUE", (String)ht.get("AVG_VALUE"));
            	 gdRes.addParam("AUTO_CAL", (String)ht.get("AUTO_CAL"));
            	 
            }

            
            wf = new SepoaFormater(value.result[0]);
            rowCount = wf.getRowCount();
            
            if (rowCount == 0)
            {
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }
            
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
//        	System.out.println("Exception : " + e.getMessage());
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }

    public GridData getsevln_insert(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	gdRes.setSelectable(false);
//        	System.out.println("1");
	        //int row_count = gdReq.getHeader("screen_id").getRowCount();
        	String ev_seq = JSPUtil.CheckInjection(gdReq.getParam("ev_seq")).trim();
        	String ev_year = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
        	String ev_no = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();
        	String ev_m_item = JSPUtil.CheckInjection(gdReq.getParam("ev_m_item")).trim();
        	String ev_d_item = JSPUtil.CheckInjection(gdReq.getParam("ev_d_item")).trim();
        	String grade_item = JSPUtil.CheckInjection(gdReq.getParam("grade_item")).trim();
        	String ev_type = JSPUtil.CheckInjection(gdReq.getParam("ev_type")).trim();
        	String ev_unit = JSPUtil.CheckInjection(gdReq.getParam("ev_unit")).trim();
        	String ev_scope = JSPUtil.CheckInjection(gdReq.getParam("ev_scope")).trim();
        	String ev_weight = JSPUtil.CheckInjection(gdReq.getParam("ev_weight")).trim();
        	String ev_weight_point = JSPUtil.CheckInjection(gdReq.getParam("ev_weight_point")).trim();
        	String ev_basic_point = JSPUtil.CheckInjection(gdReq.getParam("ev_basic_point")).trim();
        	String ev_remark = JSPUtil.CheckInjection(gdReq.getParam("ev_remark")).trim();
        	String attach_remark = JSPUtil.CheckInjection(gdReq.getParam("attach_remark")).trim();
        	String vn_display = JSPUtil.CheckInjection(gdReq.getParam("vn_display")).trim();
        	String money_use = JSPUtil.CheckInjection(gdReq.getParam("money_use")).trim();
        	String ev_item = JSPUtil.CheckInjection(gdReq.getParam("ev_item")).trim();
        	String item_name1 = JSPUtil.CheckInjection(gdReq.getParam("item_name1")).trim();
        	String item_name2 = JSPUtil.CheckInjection(gdReq.getParam("item_name2")).trim();
        	String item_name3 = JSPUtil.CheckInjection(gdReq.getParam("item_name3")).trim();
        	String cal_desc = JSPUtil.CheckInjection(gdReq.getParam("cal_desc")).trim();
        	String ev_req_desc = JSPUtil.CheckInjection(gdReq.getParam("ev_req_desc")).trim();
        	String ev_reqseq = JSPUtil.CheckInjection(gdReq.getParam("ev_reqseq")).trim();
        	String auto_cal =JSPUtil.CheckInjection(gdReq.getParam("auto_cal")).trim();
        	String avg_ev_no = JSPUtil.CheckInjection(gdReq.getParam("avg_ev_no")).trim();
        	String sum_ev_no = JSPUtil.CheckInjection(gdReq.getParam("sum_ev_no")).trim();
        	String cal_type = JSPUtil.CheckInjection(gdReq.getParam("cal_type")).trim();
        	String avg_value = JSPUtil.CheckInjection(gdReq.getParam("avg_value")).trim();
        	
        	HashMap	header = new HashMap();		
          	header.clear();           	
          	header.put("ev_seq", ev_seq);
          	header.put("ev_year", ev_year);
          	header.put("ev_no", ev_no);
          	header.put("ev_m_item", ev_m_item);
          	header.put("ev_d_item", ev_d_item);
          	header.put("grade_item", grade_item);
          	header.put("ev_type", ev_type);
          	header.put("ev_unit", ev_unit);
          	header.put("ev_scope", ev_scope);
          	header.put("ev_weight", ev_weight);
          	header.put("ev_weight_point", ev_weight_point);
          	header.put("ev_basic_point", ev_basic_point);
          	header.put("ev_remark", ev_remark);
          	header.put("attach_remark", attach_remark);
          	header.put("vn_display", vn_display);
          	header.put("money_use", money_use);
          	header.put("ev_item", ev_item);
          	header.put("item_name1", item_name1);
          	header.put("item_name2", item_name2);
          	header.put("item_name3", item_name3);
          	header.put("cal_desc", cal_desc);
          	header.put("ev_req_desc", ev_req_desc);
          	header.put("ev_reqseq", ev_reqseq);
          	header.put("auto_cal", auto_cal);
          	header.put("avg_ev_no", avg_ev_no);
          	header.put("sum_ev_no", sum_ev_no);
          	header.put("cal_type", cal_type);
          	header.put("avg_value", avg_value);
          	
          	
          	
          	
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];
	        
	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
	            {
	            		gdReq.getValue("EV_ITEM_DESC", i), //일련번호
		                gdReq.getValue("EV_MAX", i),
		                gdReq.getValue("EV_MIN", i),
		                gdReq.getValue("EV_POINT", i)

	            };

	            bean_args[i] = loop_data1;
	        }

	        Object[] obj = {bean_args,header};
	    	SepoaOut value = ServiceConnector.doService(info, "WO_001", "TRANSACTION","getsevln_insert", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            gdRes.setStatus("true");
//	            System.out.println(value.result[0]+"=value");
	            gdRes.addParam("ev_seq", value.result[0]);
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
    
    public GridData getsevln_delete(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	gdRes.setSelectable(false);
	        //int row_count = gdReq.getHeader("screen_id").getRowCount();
        	String ev_seq = JSPUtil.CheckInjection(gdReq.getParam("ev_seq")).trim();
        	String ev_year = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
        	String ev_no = JSPUtil.CheckInjection(gdReq.getParam("ev_no")).trim();
        	
        	
        	
        	HashMap	header = new HashMap();		
          	header.clear();           	
          	header.put("ev_seq", ev_seq);
          	header.put("ev_year", ev_year);
          	header.put("ev_no",ev_no);

	        Object[] obj = {header};
	    	SepoaOut value = ServiceConnector.doService(info, "WO_001", "TRANSACTION","getsevln_delete", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            gdRes.setStatus("true");
	            gdRes.addParam("ev_seq", "");
	            gdRes.addParam("reset", "Y");
	            gdRes.addParam("del_flag", "Y");
	            
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
