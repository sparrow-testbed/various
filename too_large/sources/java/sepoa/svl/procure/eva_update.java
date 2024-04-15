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

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class eva_update extends HttpServlet {
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
			} else if ("getEvaInsert".equals(mode)) {
				gdRes = getEvaInsert(gdReq, info);
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
	// Logger.debug.println(info.getSession("ID"), this,
	// ">>>>>>>>>>>>> Servlet");
	// boolean isOk = true;
	// String message = "";
	// String msg_value = "";
	//
	// String eval_refitem = ws.getParam("eval_refitem");
	//
	// SepoaOut value = getQuery(eval_refitem, info);
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
	// String[] check = {"false", ""};
	// String[] imagetext1 = {"/kr/images/button/query.gif", wf.getValue("cnt" ,
	// i), "Y"};
	// String value_id = "";
	//
//	 if(!wf.getValue("cnt" , i).equals("0"))
//	 {
//	 SepoaOut wvalue_id = getQuery_id(wf.getValue("eval_item_refitem" , i),
//	 info);
//	
//	 SepoaFormater wf1 = ws.getSepoaFormater(wvalue_id.result[0]);
//	 int row_cnt1 = wf1.getRowCount();
//	
//	 if(row_cnt1 > 0)
//	 {
//	 String code = "";
//	 String name = "";
//	 String name1 = "";
//	 String code1 = "";
//	
//	 for(int ii=0; ii<row_cnt1; ii++)
//	 {
//	 code = wf1.getValue("DEPT" , ii);
//	 name = wf1.getValue("DEPT_NAME" , ii);
//	 name1 = wf1.getValue("USER_NAME" , ii);
//	 code1 = wf1.getValue("EVAL_VALUER_ID" , ii);
//	
//	 value_id = value_id.concat(code).concat("@");
//	 value_id = value_id.concat(name).concat("@");
//	 value_id = value_id.concat(name1).concat("@");
//	 value_id = value_id.concat(code1).concat("@");
//	 value_id = value_id.concat("#");
	// }
	// }
	// }
	//
	// ws.addValue("sel", check, "");
	// ws.addValue("vendor_code" , wf.getValue("vendor_code" , i), "");
	// ws.addValue("vendor_name" , wf.getValue("name_loc" , i), "");
	// ws.addValue("sg_name" , wf.getValue("sg_name" , i), "");
	// ws.addValue("valuer", imagetext1, "");
	//
	// ws.addValue("qty_yn", wf.getValue("qty_yn" , i), "");
	// ws.addValue("value_id", value_id, "");
	// ws.addValue("sg_refitem", wf.getValue("sg_refitem" , i), "");
	// ws.addValue("eval_item_refitem",wf.getValue("eval_item_refitem" , i),
	// "");
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

		SepoaOut value = null;
		SepoaRemote wr = null;

		/*
		 * String nickName = "p0080"; String MethodName = "getEvabdupd1"; String
		 * conType = "CONNECTION";
		 */

		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq); // 그리드

			String grid_col_id = JSPUtil.CheckInjection(
					gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");

			Object[] obj = { data };
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			value = ServiceConnector.doService(info, "SR_022", "CONNECTION",
					"getEvaList", obj);

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
				String value_id = "";
				if(!"0".equals(wf.getValue("CNT" , i)))
				 {
					 SepoaOut wvalue_id = getQuery_id(wf.getValue("EVAL_ITEM_REFITEM" , i), info);
					
					 SepoaFormater wf1 = new SepoaFormater(wvalue_id.result[0]);
					 int row_cnt1 = wf1.getRowCount();
					
					 if(row_cnt1 > 0){
						 String code = "";
						 String name = "";
						 String name1 = "";
						 String code1 = "";
				
						 for(int ii=0; ii<row_cnt1; ii++)
						 {
							 code = wf1.getValue("DEPT" , ii);
							 name = wf1.getValue("DEPT_NAME" , ii);
							 name1 = wf1.getValue("USER_NAME" , ii);
							 code1 = wf1.getValue("EVAL_VALUER_ID" , ii);
							
							 value_id = value_id.concat(code).concat("@");
							 value_id = value_id.concat(name).concat("@");
							 value_id = value_id.concat(name1).concat("@");
							 value_id = value_id.concat(code1).concat("@");
							 value_id = value_id.concat("#");
						 }
					 }
				 }

				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null
							&& grid_col_ary[k].equals("valuer")) {
						gdRes.addValue(grid_col_ary[k], wf.getValue("CNT", i));
					} else if (grid_col_ary[k] != null
							&& grid_col_ary[k].equals("vendor_name")) {
						gdRes.addValue(grid_col_ary[k],
								wf.getValue("NAME_LOC", i));
					}else if (grid_col_ary[k] != null
							&& grid_col_ary[k].equals("valuer_id")) {
						gdRes.addValue(grid_col_ary[k],
								value_id);
					} else {
						gdRes.addValue(grid_col_ary[k],
								wf.getValue(grid_col_ary[k], i));
					}
				}
			}
				 
		} catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		return gdRes;
	}

	public SepoaOut getQuery_id(String eval_item_refitem, SepoaInfo info) {
		Object[] args = { eval_item_refitem };

		SepoaOut value = null;
		SepoaRemote wr = null;

		String nickName = "SR_022";
		String MethodName = "getEvabdupd2";
		String conType = "CONNECTION";

		try {
			wr = new SepoaRemote(nickName, conType, info);
			value = wr.lookup(MethodName, args);
		} catch (Exception e) {
			Logger.err.println(info.getSession("ID"), this,
					"e = " + e.getMessage());
			Logger.dev.println(e.getMessage());
		} finally {
			try {
				if(wr != null){ wr.Release(); }
			} catch (Exception e) {
				Logger.debug.println();
			}
		}
		return value;
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

	// public void doData( SepoaStream ws ) throws Exception
	// {
	// String screenId = "eva_bd_upd1";
	// String processId = "p40";
	//
	// SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
	// String language = info.getSession("LANGUAGE");
	// Message msg = new Message(language, processId);
	// SepoaFormater wf = ws.getSepoaFormater();
	//
	// boolean isOk = true;
	// String message = "";
	// String msg_value = "";
	//
	// String eval_refitem = ws.getParam( "eval_refitem" );
	// String fromdate = ws.getParam( "fromdate" );
	// String todate = ws.getParam( "todate" );
	// String flag = ws.getParam( "flag" );
	//
	// String[] vendor_code = wf.getValue("vendor_code");
	// String[] qty_yn = wf.getValue("qty_yn");
	// String[] sg_refitem = wf.getValue("sg_refitem");
	// String[] value_id = wf.getValue("value_id");
	// String[] eval_item_refitem = wf.getValue("eval_item_refitem");
	//
	// String setData[][] = new String[wf.getRowCount()][];
	//
	// for (int i = 0; i<wf.getRowCount(); i++)
	// {
	// String Data[] = { vendor_code[i], qty_yn[i], sg_refitem[i], value_id[i],
	// eval_item_refitem[i]};
	// setData[i] = Data;
	// }
	//
	// // 해당클래스, 메소드, nickName, ConType을 Mapping한다.
	// SepoaOut value = setSave(info, setData, eval_refitem, fromdate, todate,
	// flag);
	//
	// if ( value.status != 1 )
	// {
	// isOk = false;
	// }else{
	// isOk = true;
	// }
	//
	// //등록중 오류가 발생하였다면...
	// if ( ! isOk ){
	// msg.setArg( "SCREEN_ID", screenId );
	// msg_value = msg.getMessage( "0004" );
	// ws.setMessage( msg_value );
	// String [] userObject = {msg_value, "F" };
	// ws.setUserObject( userObject );
	// }
	// else
	// {
	// //msg.setArg( "SCREEN_ID", screenId );
	// //msg_value = msg.getMessage( "0013" );
	// //ws.setMessage( msg_value );
	// ws.setMessage("등록을 완료하였습니다.");
	//
	// String [] userObject = {msg_value, "S" };
	// ws.setUserObject( userObject );
	// }
	//
	// ws.write();
	// return;
	// }

	public GridData getEvaInsert(GridData gdReq, SepoaInfo info)
			throws Exception {
		// String serviceId = "p0080";
		// String conType = "TRANSACTION";
		// String MethodName = "setEvabdupd1";

		GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

		try {
			gdRes.addParam("mode", "doSave");
			gdRes.setSelectable(false);

			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			header.put("flag", JSPUtil.CheckInjection(gdReq.getParam("flag"))
					.trim());
			Object[] obj = { data };
			SepoaOut value = ServiceConnector.doService(info, "SR_022",	"TRANSACTION", "getEvaInsert", obj);

			if (value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
		} catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}

		return gdRes;
	}

}
