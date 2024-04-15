package contract;

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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

@SuppressWarnings("serial")
public class approval_user extends HttpServlet {

	private static SepoaInfo info;

	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		
		info = sepoa.fw.ses.SepoaSession.getAllValue(req);

		GridData gdReq = new GridData();
		GridData gdRes = new GridData();
		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
		String mode = "";
		PrintWriter out = res.getWriter();

		try {
			String rawData = req.getParameter("WISEGRID_DATA");
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));

			if ("query".equals(mode)) {
				gdRes = getApprovalUser(gdReq);
			} 

		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
			gdRes.setStatus("false");
//			e.printStackTrace();
		} finally {
			try {
				OperateGridData.write(req, res, gdRes, out);
			} catch (Exception e) {
//				e.printStackTrace();
				Logger.debug.println();
			}
		}
	}
	
	public GridData getApprovalUser(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");

		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			String user_id		= JSPUtil.paramCheck(gdReq.getParam("user_id")).trim();
			String user_name			= JSPUtil.paramCheck(gdReq.getParam("user_name")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");

			// EJB CALL
			Object[] obj = { user_id, user_name};
			SepoaOut value = ServiceConnector.doService(info, "CT_002", "CONNECTION", "getUser", obj);

			if (value.flag) {
				gdRes.setMessage("성공적으로 처리 하였습니다.");
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
				return gdRes;
			}

			wf = new SepoaFormater(value.result[0]);
			rowCount = wf.getRowCount();
			
			if (rowCount == 0) {
				gdRes.setMessage("조회된 데이터가 없습니다.");
				return gdRes;
			}

			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
				}
			}
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage("처리 중 오류가 발생하였습니다.");
			gdRes.setStatus("false");
		}

		return gdRes;
	}
	 
}
