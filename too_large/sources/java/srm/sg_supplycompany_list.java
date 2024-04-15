package srm;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
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
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings("serial")
public class sg_supplycompany_list extends HttpServlet
{
  private static SepoaInfo info;

  public void init(ServletConfig config)
    throws ServletException
  {
//    System.out.println("Servlet call");
	  Logger.debug.println();
  }

  public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
  {
	  doPost(req, res); 
  } 
  
  public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		// 세션 Object
	  SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

	  GridData gdReq = null;
	  GridData gdRes = new GridData();
	  req.setCharacterEncoding("UTF-8");
	  res.setContentType("text/html;charset=UTF-8");

	  String mode = "";
	  PrintWriter out = res.getWriter();

	  try {
		  gdReq = OperateGridData.parse(req, res);
		  mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
		  if ("insert".equals(mode)) {
			  gdRes = sg_supplycompany_insert(gdReq);
		  }else if ("delete".equals(mode)) {
			  gdRes = sg_supplycompany_delete(gdReq);
		  }else if ("query".equals(mode)) {
			  gdRes = sg_supplycompany_lis1(gdReq);
		  }

	  } catch (Exception e) {
//		  e.printStackTrace();
		  gdRes.setMessage("Error: " + e.getMessage());
		  gdRes.setStatus("false");
			
	  } finally {
		  try {
			  OperateGridData.write(req, res, gdRes, out);
		  } catch (Exception e) {
			  Logger.debug.println();
				
		  }
	  }
  } 
  public GridData sg_supplycompany_lis1(GridData gdReq) throws Exception { 
	  GridData gdRes = new GridData();
	  int rowCount = 0;
	  SepoaFormater wf = null;

	  String POASRM_CONTEXT_NAME = CommonUtil.getConfig("sepoa.context.name");
	  try
	  {
	    String company_code = JSPUtil.CheckInjection(gdReq.getParam("company_code")).trim().toUpperCase();
	    String sg_type1 = JSPUtil.CheckInjection(gdReq.getParam("sg_type1")).trim().toUpperCase();
	    String sg_type2 = JSPUtil.CheckInjection(gdReq.getParam("sg_type2")).trim().toUpperCase();
	    String sg_type3 = JSPUtil.CheckInjection(gdReq.getParam("sg_type3")).trim().toUpperCase();
	    String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
	    String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
	
	    gdRes = OperateGridData.cloneResponseGridData(gdReq);
	    gdRes.addParam("mode", "query");
	
	    Object[] obj = { company_code, sg_type1, sg_type2, sg_type3 };
	    SepoaOut value = ServiceConnector.doService(info, "SR_001", "CONNECTION", "sg_supplycompany_list_search", obj);
	
	    if (value.flag)
	    {
	      gdRes.setMessage("성공적으로 처리 하였습니다.");
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
	      gdRes.setMessage("조회된 데이터가 업습니다.");
	      return gdRes;
	    }
	
	    for (int i = 0; i < rowCount; i++)
	    {
	      for (int k = 0; k < grid_col_ary.length; k++)
	      {
	        if ((grid_col_ary[k] != null) && (grid_col_ary[k].equals("selected"))){
	          gdRes.addValue("selected", "0");
	        }
	        else {
	          gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
	        }
	      }
	    }
	  }
	  catch (Exception e)
	  {
//	    System.out.println("Exception : " + e.getMessage());
	    gdRes.setMessage("처리 중 오류가 발생하였습니다.");
	    gdRes.setStatus("false");
	  }
	
	  return gdRes; }
	
	public GridData sg_supplycompany_insert(GridData gdReq)
	  throws Exception
	{
	  GridData gdRes = new GridData();
	  try
	  {
	    gdRes.setSelectable(false);
	    int row_count = gdReq.getRowCount();
	    String[][] bean_args = new String[row_count][];
	    Logger.sys.println("@@@@@@@@@ row_count = " + row_count);
	
	    for (int i = 0; i < row_count; i++) {
	      String[] loop_data1 = 
	        { 
	        gdReq.getValue("sg_type1", i), 
	        gdReq.getValue("sg_type2", i), 
	        gdReq.getValue("sg_type3", i), 
	        gdReq.getValue("vendor_code", i), 
	        gdReq.getValue("vendor_name_loc", i), 
	        gdReq.getValue("apply_flag", i), 
	        gdReq.getValue("seller_sg_refitem", i) };
	
	      bean_args[i] = loop_data1;
	    }
	
	    Object[] obj = { bean_args };
	    SepoaOut value = ServiceConnector.doService(info, "SR_001", "TRANSACTION", "sg_list_supplycompany_insert", obj);
	
	    if (value.flag)
	    {
	      gdRes.setMessage("성공적으로 처리 되었습니다.");
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
	    gdRes.setMessage("처리 중 오류가 발생하였습니다.");
	    gdRes.setStatus("false");
	  }
	
	  gdRes.addParam("mode", "insert");
	  return gdRes;
	}
	
	public GridData sg_supplycompany_delete(GridData gdReq) throws Exception
	{
	  GridData gdRes = new GridData();
	  try
	  {
	    gdRes.setSelectable(false);
	    int row_count = gdReq.getRowCount();
	    String[][] bean_args = new String[row_count][];
	
	    for (int i = 0; i < row_count; i++) {
	      String[] loop_data2 = 
	        { 
	        gdReq.getValue("sg_type1", i), 
	        gdReq.getValue("sg_type2", i), 
	        gdReq.getValue("sg_type3", i), 
	        gdReq.getValue("vendor_code", i), 
	        gdReq.getValue("vendor_name_loc", i), 
	        gdReq.getValue("apply_flag", i), 
	        gdReq.getValue("seller_sg_refitem", i) };
	
	      bean_args[i] = loop_data2;
	    }
	
	    Object[] obj = { bean_args };
	    SepoaOut value = ServiceConnector.doService(info, "SR_001", "TRANSACTION", "sg_list_supplycompany_delete", obj);
	
	    if (value.flag)
	    {
	      gdRes.setMessage("성공적으로 처리 되었습니다.");
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
	    gdRes.setMessage("처리 중 오류가 발생하였습니다.");
	    gdRes.setStatus("false");
	  }
	
	  gdRes.addParam("mode", "delete");
	  return gdRes;
	}
}