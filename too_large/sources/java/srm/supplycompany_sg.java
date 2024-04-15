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
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings("serial")
public class supplycompany_sg extends HttpServlet
{
  private static SepoaInfo info;

  public void init(ServletConfig config)
    throws ServletException
  {
//    System.out.println("Servlet call");
	  Logger.debug.println();
  }

  public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
  {
    doPost(req, res); } 
  // ERROR //
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
				gdRes = supplycompany_insert(gdReq);
			}else if ("delete".equals(mode)) {
				gdRes = supplycompany_delete(gdReq);
			}else if ("query".equals(mode)) {
				gdRes = supplycompany_list(gdReq);
			}

		} catch (Exception e) {
//			e.printStackTrace();
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
  public GridData supplycompany_insert(GridData gdReq) throws Exception { GridData gdRes = new GridData();
    
    try
    {
      String company_code = JSPUtil.CheckInjection(gdReq.getParam("company_code")).trim().toUpperCase();
      gdRes.setSelectable(false);

      int row_count = gdReq.getRowCount();
      String[][] bean_args = new String[row_count][];

      for (int i = 0; i < row_count; i++)
      {
        String[] loop_data1 = 
          { 
          gdReq.getValue("sg_type1", i), 
          gdReq.getValue("sg_type2", i), 
          gdReq.getValue("sg_type3", i), 
          gdReq.getValue("apply_flag", i), 
          gdReq.getValue("seller_sg_refitem", i) };

        bean_args[i] = loop_data1;
      }

      Object[] obj = { bean_args, company_code };
      SepoaOut value = ServiceConnector.doService(info, "SR_001", "TRANSACTION", "supplycompany_insert", obj);

      if (value.flag)
      {
        gdRes.setMessage("성공적으로 처리 하였습니다.");
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
    return gdRes; }

  public GridData supplycompany_delete(GridData gdReq)
    throws Exception
  {
    GridData gdRes = new GridData();
    try
    {
      gdRes.setSelectable(false);

      int row_count = gdReq.getRowCount();
      String[][] bean_args = new String[row_count][];

      for (int i = 0; i < row_count; i++)
      {
        String[] loop_data2 = 
          { 
          gdReq.getValue("sg_type1", i), 
          gdReq.getValue("sg_type2", i), 
          gdReq.getValue("sg_type3", i), 
          gdReq.getValue("apply_flag", i), 
          gdReq.getValue("seller_sg_refitem", i) };

        bean_args[i] = loop_data2;
      }

      Object[] obj = { bean_args };
      SepoaOut value = ServiceConnector.doService(info, "SR_001", "TRANSACTION", "supplycompany_delete", obj);

      if (value.flag)
      {
        gdRes.setMessage("성공적으로 처리 하였습니다.");
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
      gdRes.setMessage("처리중 오류가 발생하였습니다.");
      gdRes.setStatus("false");
    }

    gdRes.addParam("mode", "delete");
    return gdRes;
  }

  public GridData supplycompany_list(GridData gdReq) throws Exception
  {
    SepoaFormater wf = null;
	GridData            gdRes      = new GridData();
    SepoaFormater       sf         = null;
    SepoaOut            value      = null;
    HashMap             message    = null;
    Map<String, Object> allData    = null;
    Map<String, String> header     = null;
    String              gridColId  = null;
    String[]            gridColAry = null;
    int                 rowCount   = 0;    
    
    try
    {
      String company_code = JSPUtil.CheckInjection(gdReq.getParam("company_code")).trim().toUpperCase();
      String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
      String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

      gdRes = OperateGridData.cloneResponseGridData(gdReq);
      gdRes.addParam("mode", "query");

      Object[] obj = { company_code };
      value = ServiceConnector.doService(info, "SR_001", "CONNECTION", "supplycompany_list", obj);

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
        gdRes.setMessage("조회된 데이터가 없습니다.");
        return gdRes;
      }

      for (int i = 0; i < rowCount; i++)
      {
        for (int k = 0; k < grid_col_ary.length; k++)
        {
          if ((grid_col_ary[k] != null) && (grid_col_ary[k].equals("selected"))) {
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
//      System.out.println("Exception : " + e.getMessage());
      gdRes.setMessage("처리 중 오류가 발생하였습니다.");
      gdRes.setStatus("false");
    }

    return gdRes;
  }
}