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
public class app_aproval_list3 extends HttpServlet {

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

			if ("query".endsWith(mode)) {
				gdRes = getBaseApprovalSignPath(gdReq);
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
	
	public GridData getBaseApprovalSignPath(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");

		try {
			String app_no = JSPUtil.CheckInjection(JSPUtil.nullChk(gdReq.getParam("app_no"))).trim().toUpperCase();
        	String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
 
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");
			
			String user_id = info.getSession("ID");
			// EJB CALL
			Object[] obj = { user_id, app_no};
			SepoaOut value = ServiceConnector.doService(info, "CT_002", "CONNECTION", "getBaseApprovalSignPath", obj);

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
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "0");
					}else{
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage("처리 중 오류가 발생하였습니다.");
			gdRes.setStatus("false");
		}

		return gdRes;
	}
	
	//보증증권번호등록
	public GridData getContractSave(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");

		try {
			gdRes.setSelectable(false);
	        //int row_count = gdReq.getHeader("screen_id").getRowCount();
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
	            {
	            		gdReq.getValue("CONT_INS_VN", i), //계약이행보증증권회사
		                gdReq.getValue("CONT_INS_NO", i), //계약이행보증증권번호
		                gdReq.getValue("FAULT_INS_NO", i), //하자이행보증증권번호
		                gdReq.getValue("CONT_NO", i), //계약번호
	            };

	            bean_args[i] = loop_data1;
	        }

			// EJB CALL
			Object[] obj = { bean_args };
			SepoaOut value = ServiceConnector.doService(info, "CT_030", "CONNECTION", "getContractSave", obj);


            if(value.flag)
            {
                gdRes.setMessage("성공적으로 처리 하였습니다.");
	            gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage("처리 중 오류가 발생하였습니다.");
			gdRes.setStatus("false");
		}

		return gdRes;
	}
}
