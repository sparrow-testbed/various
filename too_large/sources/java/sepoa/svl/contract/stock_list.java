package sepoa.svl.contract;

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
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings({"unchecked","rawtypes"})
public class stock_list extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4976782919109586666L;

	public void init(ServletConfig config) throws ServletException {
		//System.out.println("Servlet call");
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {

		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

		GridData gdReq = new GridData();
		GridData gdRes = new GridData();
		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
		String mode = "";
		PrintWriter out = res.getWriter();

		try {
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));

			if (mode.equals("query")) {
				gdRes = getContractList(info, gdReq);
			}

		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
			gdRes.setStatus("false");
/*			e.printStackTrace();*/
		} finally {
			try {
				OperateGridData.write(req, res, gdRes, out);
			} catch (Exception e) {
/*				e.printStackTrace();*/ mode = "";
			}
		}
	}
	
	public GridData getContractList(SepoaInfo info, GridData gdReq)
			throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		
		try {
			Map allData = SepoaDataMapper.getData(info, gdReq);

			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");
			

			// EJB CALL
			Object[] obj = {allData};
			SepoaOut value = ServiceConnector.doService(info, "CT_031", "CONNECTION", "getStockList", obj);

			if (value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
				return gdRes;
			}

			wf = new SepoaFormater(value.result[0]);
			rowCount = wf.getRowCount();

			if (rowCount == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString());
				return gdRes;
			}

			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "0");
					}  else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}

		} catch (Exception e) {
/*			System.out.println("Exception : " + e.getMessage());*/
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}

		return gdRes;
	}
}
