package sepoa.svl.admin;

import java.io.IOException;
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
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;


public class bulletin_view_count_list extends HttpServlet
{

	private static final long serialVersionUID = -2570726109514867212L;

public bulletin_view_count_list()
 {
	Logger.debug.println();
 }

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
     GridData gdRes;
     java.io.PrintWriter out;
     SepoaInfo info = SepoaSession.getAllValue(req);

     GridData gdReq = new GridData();
     gdRes = new GridData();
     req.setCharacterEncoding("UTF-8");
     res.setContentType("text/html;charset=UTF-8");

     String mode = "";
     out = res.getWriter();

     try
     {
         String rawData = req.getParameter("WISEGRID_DATA");
         //gdReq = OperateGridData.parse(rawData);
         gdReq = OperateGridData.parse(req, res);
         mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
         
         

         if ("query".equals(mode))
         {
             gdRes = getList(gdReq, info, req);
         } else if("dataStore_query".equals(mode)) {
        	 gdRes = getDataStoreList(gdReq, info, req);
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
             //OperateGridData.write(req, gdRes, out);
        	 OperateGridData.write(req, res, gdRes, out);
         }
         catch (Exception e)
         {
        	 Logger.debug.println();
         }
     }
 }

 
 /**
  * 자료실 목록 조회
  * @param gdReq
  * @param _info
  * @param req
  * @return
  * @throws Exception
  */
 public GridData getDataStoreList(GridData gdReq, SepoaInfo _info, HttpServletRequest req) throws Exception
 {
     GridData gdRes;
     int rowCount;
     SepoaFormater wf;
     String lang;
     gdRes = new GridData();
     rowCount = 0;
     wf = null;
     lang = "";

     HashMap message;
     SepoaOut value;
     String seq = JSPUtil.CheckInjection(gdReq.getParam("seq")).trim().toUpperCase();
     String user_name = JSPUtil.CheckInjection(gdReq.getParam("user_name")).trim().toUpperCase();
     String company_name = JSPUtil.CheckInjection(gdReq.getParam("company_name")).trim().toUpperCase();
     String user_gubun = JSPUtil.CheckInjection(gdReq.getParam("user_gubun")).trim().toUpperCase();
     String user_ip = JSPUtil.CheckInjection(gdReq.getParam("user_ip")).trim().toUpperCase();
//     String view_date_start = JSPUtil.CheckInjection(gdReq.getParam("view_date_start")).trim().toUpperCase();
//     String view_date_end = JSPUtil.CheckInjection(gdReq.getParam("view_date_end")).trim().toUpperCase();
     lang = JSPUtil.CheckInjection(gdReq.getParam("language")).trim().toUpperCase();
     
     String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
     String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");     
     
     gdRes = OperateGridData.cloneResponseGridData(gdReq);
     gdRes.addParam("mode", "query");


     Vector multilang_id = new Vector();
     multilang_id.addElement("MESSAGE");
     message = MessageUtil.getMessage(_info, multilang_id);

//     Object[] obj = { info, seq, user_name, company_name, user_gubun, view_date_start, view_date_end, lang };
     Object[] obj = { _info, seq, user_name, company_name, user_gubun, user_ip, lang };
     value = ServiceConnector.doService(_info, "MT_014", "CONNECTION", "getDataStoreViewCountList", obj);

     if (value.flag)
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

     try
     {
         int rowNumber = rowCount;

         for (int i = 0; i < rowCount; i++)
         {
//        	 gdRes.getHeader("no").addValue(wf.getValue("SEQ_SEQ", i), "");
//             gdRes.getHeader("user_name").addValue(wf.getValue("USER_NAME", i), "");
//             gdRes.getHeader("company_name").addValue(wf.getValue("COMPANY_NAME", i), "");
//             gdRes.getHeader("user_gubun").addValue(wf.getValue("USER_GUBUN", i), "");
//             gdRes.getHeader("view_date").addValue(wf.getValue("VIEW_DATE", i), "");
//             gdRes.getHeader("user_ip").addValue(wf.getValue("VIEW_IP_ADDRESS", i), "");
        	 
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
    	 
         gdRes.setMessage(message.get("MESSAGE.1002").toString());
         gdRes.setStatus("false");
     }

     return gdRes;
 }
 
 
 public GridData getList(GridData gdReq, SepoaInfo _info, HttpServletRequest req) throws Exception
 {
     GridData gdRes;
     int rowCount;
     SepoaFormater wf;
     String lang;
     gdRes = new GridData();
     rowCount = 0;
     wf = null;
     lang = "";

     HashMap message;
     SepoaOut value;
     String seq = JSPUtil.CheckInjection(gdReq.getParam("seq")).trim().toUpperCase();
     String user_name = JSPUtil.CheckInjection(gdReq.getParam("user_name")).trim().toUpperCase();
     String company_name = JSPUtil.CheckInjection(gdReq.getParam("company_name")).trim().toUpperCase();
     String user_gubun = JSPUtil.CheckInjection(gdReq.getParam("user_gubun")).trim().toUpperCase();
     String user_ip = JSPUtil.CheckInjection(gdReq.getParam("user_ip")).trim().toUpperCase();
//     String view_date_start = JSPUtil.CheckInjection(gdReq.getParam("view_date_start")).trim().toUpperCase();
//     String view_date_end = JSPUtil.CheckInjection(gdReq.getParam("view_date_end")).trim().toUpperCase();
     lang = JSPUtil.CheckInjection(gdReq.getParam("language")).trim().toUpperCase();
     
     String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
     String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");     
     
     gdRes = OperateGridData.cloneResponseGridData(gdReq);
     gdRes.addParam("mode", "query");


     Vector multilang_id = new Vector();
     multilang_id.addElement("MESSAGE");
     message = MessageUtil.getMessage(_info, multilang_id);

//     Object[] obj = { info, seq, user_name, company_name, user_gubun, view_date_start, view_date_end, lang };
     Object[] obj = { _info, seq, user_name, company_name, user_gubun, user_ip, lang };
     value = ServiceConnector.doService(_info, "MT_014", "CONNECTION", "getViewCountList", obj);

     if (value.flag)
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

     try
     {
         int rowNumber = rowCount;

         for (int i = 0; i < rowCount; i++)
         {
//        	 gdRes.getHeader("no").addValue(wf.getValue("SEQ_SEQ", i), "");
//             gdRes.getHeader("user_name").addValue(wf.getValue("USER_NAME", i), "");
//             gdRes.getHeader("company_name").addValue(wf.getValue("COMPANY_NAME", i), "");
//             gdRes.getHeader("user_gubun").addValue(wf.getValue("USER_GUBUN", i), "");
//             gdRes.getHeader("view_date").addValue(wf.getValue("VIEW_DATE", i), "");
//             gdRes.getHeader("user_ip").addValue(wf.getValue("VIEW_IP_ADDRESS", i), "");
        	 
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
    	 
         gdRes.setMessage(message.get("MESSAGE.1002").toString());
         gdRes.setStatus("false");
     }

     return gdRes;
 }
}