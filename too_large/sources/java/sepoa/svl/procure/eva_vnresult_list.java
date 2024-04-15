package sepoa.svl.procure;

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

public class eva_vnresult_list extends HttpServlet {
	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {
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
			if ("getEvaList".equals(mode)) {
				gdRes = getEvaList(gdReq, info); // 조회
			}

		} catch (Exception e) { 
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

	// =========================================================================================================
	// public void doQuery(SepoaStream ws) throws Exception
	// {
	// String processId = "p40";
	//
	// SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
	// String language = info.getSession("LANGUAGE");
	// Message msg = new Message(language, processId);
	//
	// boolean isOk = true;
	// String message = "";
	// String msg_value = "";
	//
	// String vendor_code = ws.getParam("vendor_code");
	// String eval_name = ws.getParam("eval_name");
	//
	// SepoaOut value = getQuery(vendor_code, eval_name, info);
	//
	// if( value.status == 0 ){
	// isOk = false;
	// message = value.message;
	// }else{
	// isOk = true;
	// message = "";
	// }
	//
	// if(!isOk ){
	// msg.setArg( "SCREEN_ID", processId );
	// msg_value = msg.getMessage( "0002" );
	// ws.setMessage( msg_value );
	// String [] userObject = { message };
	// ws.setUserObject( userObject );
	// ws.write();
	// return;
	// }
	//
	// SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
	// int row_cnt = wf.getRowCount();
	//
	// try
	// {
	// if(row_cnt > 0)
	// {
	// for(int i=0; i<row_cnt; i++)
	// {
	// String[] imagetext1 = {"", wf.getValue("eval_name" , i),
	// wf.getValue("eval_name" , i)};
	// String[] imagetext2 = {"", wf.getValue("eval_temp" , i),
	// wf.getValue("eval_temp" , i)};
	// String[] imagetext3 = {"", wf.getValue("eval_score" , i),
	// wf.getValue("eval_score" , i)};
	//
	// ws.addValue("eval_name" , imagetext1, "");
	// ws.addValue("eval_temp" , imagetext2, "");
	// ws.addValue("interval" , wf.getValue("interval" , i), "");
	// ws.addValue("sg_name" , wf.getValue("sg_name" , i), "");
	// ws.addValue("vendor_name" , wf.getValue("vendor_name" , i), "");
	//
	// ws.addValue("score", imagetext3, "");
	// ws.addValue("eval_refitem", wf.getValue("eval_refitem" , i), "");
	// ws.addValue("e_template_refitem",wf.getValue("e_template_refitem" , i),
	// "");
	// ws.addValue("eval_item_refitem",wf.getValue("eval_item_refitem" , i),
	// "");
	// ws.addValue("template_type", wf.getValue("template_type" , i), "");
	// ws.addValue("HUMAN_NO", wf.getValue("HUMAN_NO" , i), "");
	// ws.addValue("HUMAN_NAME", wf.getValue("HUMAN_NAME" , i), "");
	// ws.addValue("QNT_Y_SCORE", wf.getValue("QNT_Y_SCORE" , i), "");
	// ws.addValue("QNT_N_SCORE", wf.getValue("QNT_N_SCORE" , i), "");
	// }
	// }else{
	//
	// msg.setArg("SCREEN_ID", processId);
	// msg_value = msg.getMessage("0006");
	// ws.setMessage(msg_value);
	// ws.write();
	// return;
	// }
	//
	// }catch(Exception ex){
	// Logger.debug.println(info.getSession("ID"),this,"A###"+ ex);
	// }
	//
	// msg.setArg("SCREEN_ID", processId);
	// msg_value = msg.getMessage("0001");
	// ws.setMessage(msg_value);
	// ws.write();
	// }

	// =========================================================================================================
	public GridData getEvaList(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

//		String nickName = "p0080";
//		String MethodName = "getEvabdlis6";
//		String conType = "CONNECTION";

		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq); // 그리드

			String grid_col_id = JSPUtil.CheckInjection(
					gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");

			Object[] obj = { data };
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "SR_026", "CONNECTION", "getEvaList", obj);

			if (value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
				return gdRes;
			}

			SepoaFormater wf = new SepoaFormater(value.result[0]);

			if (wf.getRowCount() == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString());
				return gdRes;
			}

			for (int i = 0; i < wf.getRowCount(); i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if(grid_col_ary[k] != null && grid_col_ary[k].equals("score")){
						gdRes.addValue(grid_col_ary[k],	wf.getValue("EVAL_SCORE", i));
					}else{
						gdRes.addValue(grid_col_ary[k],	wf.getValue(grid_col_ary[k], i));
					}
				}
			}

		} catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		return gdRes;
	}

	// =========================================================================================================
	private String chkNull(String value) {
		if ("".equals(value)) {
			value = "0";
		}
		return value;
	}

	private String setZero(String value) {
		if (value.indexOf(".") != -1) {
			int decimal = Integer.parseInt(value.substring(
					value.indexOf(".") + 1, value.length()));
			if (decimal == 0) {
				value = value.substring(0, value.indexOf("."));
			}
		}
		return value;
	}
}
