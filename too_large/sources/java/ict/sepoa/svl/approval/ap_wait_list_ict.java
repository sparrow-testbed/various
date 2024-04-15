package ict.sepoa.svl.approval;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

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

public class ap_wait_list_ict extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws IOException, ServletException {
		// 세션 Object
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

			if ("getWaitList".equals(mode)) {
				gdRes = getWaitList(gdReq, info); // 조회
			} else if ("setAppUpdate".equals(mode)) {
				gdRes = setAppUpdate(gdReq, info); // 승인/반려
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

	public GridData getWaitList(GridData gdReq, SepoaInfo info)
			throws Exception {
		GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq); // 그리드
																				// 데이터
			String grid_col_id = JSPUtil.CheckInjection(
					gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "getWaitList");

			Object[] obj = { data };
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "I_AP_001",	"CONNECTION", "getWaitList", obj);

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
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				return gdRes;
			}

			for (int i = 0; i < wf.getRowCount(); i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null
							&& grid_col_ary[k].equals("SEL")) {
						gdRes.addValue("SEL", "1");
					} else if (grid_col_ary[k] != null
							&& grid_col_ary[k].equals("ADD_DATE")) {
						gdRes.addValue(grid_col_ary[k], SepoaString
								.getDateDashFormat(wf.getValue(grid_col_ary[k],
										i)));
					} else if (grid_col_ary[k] != null
							&& grid_col_ary[k].equals("SIGN_DATE")) {
						gdRes.addValue(grid_col_ary[k], SepoaString
								.getDateDashFormat(wf.getValue(grid_col_ary[k],
										i)));
					} else if (grid_col_ary[k] != null
							&& grid_col_ary[k].equals("SIGN_REMARK_IMG")) {
						if (!("".equals(wf.getValue("SIGN_REMARK", i).trim()))
								&& wf.getValue(grid_col_ary[k], i) != null) {
							gdRes.addValue(grid_col_ary[k],
									"<img src='/images/icon/detail.gif' align='absmiddle' border='0' alt=''>");
						} else {
							gdRes.addValue(grid_col_ary[k], "");
						}
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("SIGN_PATH_IMG")) {
						gdRes.addValue(grid_col_ary[k],
								"/images/icon/icon_data_a.gif");
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ATTACH_NO_IMG")) {
						if (!("".equals(wf.getValue(grid_col_ary[k], i).trim())) && wf.getValue(grid_col_ary[k], i) != null) {
							gdRes.addValue(grid_col_ary[k],
									"/images/icon/icon_disk_b.gif");
						} else {
							gdRes.addValue(grid_col_ary[k],
									"/images/icon/icon_disk_a.gif");
						}
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

	/**
	 * 결재요청 승인
	 * @param gdReq
	 * @param info
	 * @return
	 * @throws Exception
	 */
	public GridData setAppUpdate(GridData gdReq, SepoaInfo info)
			throws Exception {
		GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

		try {
			gdRes.setSelectable(false);
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq); 
			Map<String, String> header = MapUtils.getMap(data, "headerData");

			Vector AppEnd = new Vector();
			Vector AppEnd2 = new Vector();
			Vector AppEnd3 = new Vector();

			Vector AppNext = new Vector();
			Vector AppNext2 = new Vector();
			Vector AppNext3 = new Vector();

			String app_type          = MapUtils.getString(header , "app_type", "");
			String doc_type          = MapUtils.getString(header , "doc_type", "");
			String doc_no            = MapUtils.getString(header , "doc_no", "");
			String next_sign_user_id = MapUtils.getString(header , "next_sign_user_id", "");
			String sign_remark       = MapUtils.getString(header , "remark", "");
			
			if (app_type.equals("E")) { // 승인일때 ( 차기결제자가 있을 경우와 마지막 최종 결제일때로 분리
										// )

				int end_cnt = 0;
				String dm_doc = "";
				String dm_type = "";
				String dm_doc_one = "";

				if (next_sign_user_id.length() == 0) { // 결재완료 로직을 탄다.

					List<Map<String, String>> end1_temp = (List<Map<String, String>>) MapUtils.getObject(data, "gridData");
					List<Map<String, String>> end2_temp = (List<Map<String, String>>) MapUtils.getObject(data, "gridData");
					List<Map<String, String>> end3_temp = (List<Map<String, String>>) MapUtils.getObject(data, "gridData");

					AppEnd.add(end1_temp);
					AppEnd2.add(end2_temp);
					AppEnd3.add(end3_temp);

					if ("RQ".equals(doc_type) || doc_type.equals("POD")) {
						if (end_cnt == 0) {
							dm_type = doc_type;
							dm_doc_one = doc_no;
						} else {
							dm_doc += " ,";
						}

						dm_doc += " '" + doc_no + "'";
						end_cnt++;
					}
				} else {
					List<Map<String, String>> next1_temp = (List<Map<String, String>>) MapUtils.getObject(data, "gridData");
					List<Map<String, String>> next2_temp = (List<Map<String, String>>) MapUtils.getObject(data, "gridData");
					List<Map<String, String>> next3_temp = (List<Map<String, String>>) MapUtils.getObject(data, "gridData");

					AppNext.add(next1_temp);
					AppNext2.add(next2_temp);
					AppNext3.add(next3_temp);
				}

				List<Vector> data_AppEnd[] = new List[AppEnd.size()];
				List<Vector> data_AppEnd2[] = new List[AppEnd2.size()];
				List<Vector> data_AppEnd3[] = new List[AppEnd3.size()];
				for (int i = 0; i < AppEnd.size(); i++) {
					data_AppEnd[i] = (List<Vector>) AppEnd.elementAt(i);
					data_AppEnd2[i] = (List<Vector>) AppEnd2.elementAt(i);
					data_AppEnd3[i] = (List<Vector>) AppEnd3.elementAt(i);
				}

				List<Vector> data_AppNext[] = new List[AppNext.size()];
				List<Vector> data_AppNext2[] = new List[AppNext2.size()];
				List<Vector> data_AppNext3[] = new List[AppNext3.size()];
				for (int i = 0; i < AppNext.size(); i++) {
					data_AppNext[i] = (List<Vector>) AppNext.elementAt(i);
					data_AppNext2[i] = (List<Vector>) AppNext2.elementAt(i);
					data_AppNext3[i] = (List<Vector>) AppNext3.elementAt(i);
				}

				if (AppNext.size() != 0) {	//차기결재자가 있을 경우

					Object[] obj = { data };
					SepoaOut value = ServiceConnector.doService(info, "I_AP_001","TRANSACTION", "setUpdate", obj);
					if (value.flag) {
						gdRes.setMessage(message.get("MESSAGE.0001").toString());
						gdRes.setStatus("true");

					} else {
						gdRes.setMessage(value.message);
						gdRes.setStatus("false");
					}
				}else if(AppEnd.size() != 0) {	//차기결재자가 없을 경우
					Object[] obj = { data };
					SepoaOut value = ServiceConnector.doService(info, "I_AP_001", "TRANSACTION", "setEndApp", obj);
					
					List<Map<String, String>> grid = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
					Map<String, String> gridIndexZero = grid.get(0);
					String docNo = gridIndexZero.get("DOC_NO");
					String docSeq = gridIndexZero.get("DOC_SEQ");
					
//					Map<String, String> smsObjInfo = new HashMap<String, String>();
//					
//					smsObjInfo.put("HOUSE_CODE", info.getSession("HOUSE_CODE"));
//					smsObjInfo.put("RFQ_NO",     docNo);
//					smsObjInfo.put("RFQ_COUNT",  docSeq);
//					
//					Object[] smsObj = {smsObjInfo};
//					ServiceConnector.doService(info, "SMS",  "TRANSACTION", "rqApplyE", smsObj);
					//ServiceConnector.doService(info, "mail", "TRANSACTION", "rqApplyE", smsObj);
					
					if (value.flag) {
						gdRes.setMessage(message.get("MESSAGE.0001").toString());
						gdRes.setStatus("true");

					} else {
						gdRes.setMessage(value.message);
						gdRes.setStatus("false");
					}
				}
				
			} else if (app_type.equals("R")) {// 반려일때

				List<Map<String, String>> re_end1_temp = (List<Map<String, String>>) MapUtils.getObject(data, "gridData");
				List<Map<String, String>> re_end2_temp = (List<Map<String, String>>) MapUtils.getObject(data, "gridData");
				List<Map<String, String>> re_end3_temp = (List<Map<String, String>>) MapUtils.getObject(data, "gridData");

				AppEnd.add(re_end1_temp);
				AppEnd2.add(re_end2_temp);
				AppEnd3.add(re_end3_temp);

				List<Vector> data_AppEnd[] = new List[AppEnd.size()];
				List<Vector> data_AppEnd2[] = new List[AppEnd2.size()];
				List<Vector> data_AppEnd3[] = new List[AppEnd3.size()];

				for (int i = 0; i < AppEnd.size(); i++) {

					data_AppEnd[i] = (List<Vector>) AppEnd.elementAt(i);
					data_AppEnd2[i] = (List<Vector>) AppEnd2.elementAt(i);
					data_AppEnd3[i] = (List<Vector>) AppEnd3.elementAt(i);
				}

				Object[] obj = { data };
				SepoaOut value = ServiceConnector.doService(info, "I_AP_001",	"TRANSACTION", "setRefund", obj);
				if (value.flag) {
					gdRes.setMessage(message.get("MESSAGE.0001").toString());
					gdRes.setStatus("true");

				} else {
					gdRes.setMessage(value.message);
					gdRes.setStatus("false");
				}
			}

			else if ("N".equals(app_type)) { // 차기결제 지정방식일때.

				List<Map<String, String>> next1_temp = (List<Map<String, String>>) MapUtils
						.getObject(data, "gridData");
				List<Map<String, String>> next2_temp = (List<Map<String, String>>) MapUtils
						.getObject(data, "gridData");
				List<Map<String, String>> next3_temp = (List<Map<String, String>>) MapUtils
						.getObject(data, "gridData");

				AppNext.add(next1_temp);
				AppNext2.add(next2_temp);
				AppNext3.add(next3_temp);

				List<Vector> data_AppEnd[] = new List[AppEnd.size()];
				List<Vector> data_AppEnd2[] = new List[AppEnd2.size()];
				List<Vector> data_AppEnd3[] = new List[AppEnd3.size()];

				for (int i = 0; i < AppEnd.size(); i++) {

					data_AppEnd[i] = (List<Vector>) AppEnd.elementAt(i);
					data_AppEnd2[i] = (List<Vector>) AppEnd2.elementAt(i);
					data_AppEnd3[i] = (List<Vector>) AppEnd3.elementAt(i);
				}
				List<Vector> data_AppNext[] = new List[AppNext.size()];
				List<Vector> data_AppNext2[] = new List[AppNext2.size()];
				List<Vector> data_AppNext3[] = new List[AppNext3.size()];
				for (int i = 0; i < AppNext.size(); i++) {
					data_AppNext[i] = (List<Vector>) AppNext.elementAt(i);
					data_AppNext2[i] = (List<Vector>) AppNext2.elementAt(i);
					data_AppNext3[i] = (List<Vector>) AppNext3.elementAt(i);
				}

				if (AppNext.size() != 0) {
					Object[] obj = { data };
					SepoaOut value = ServiceConnector.doService(info, "I_AP_001", "TRANSACTION", "setInsert", obj);
					if (value.flag) {
						gdRes.setMessage(message.get("MESSAGE.0001").toString());
						gdRes.setStatus("true");

					} else {
						gdRes.setMessage(value.message);
						gdRes.setStatus("false");
					}
				}

			}

			gdRes.addParam("mode", "setAppUpdate");

		} catch (Exception e) {

			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}

		return gdRes;
	}
	/*
	 * try{ String value_status = String.valueOf(value.status);
	 * 
	 * String value_message = value.message; String[] uObj = {value_status ,
	 * value_message }; ws.setUserObject(uObj);
	 * ws.setCode(String.valueOf(value.status)); ws.setMessage(value.message);
	 * ws.write();
	 * 
	 * // 결재반려시 상신자부터 반려한 현재 결재자 이전결재자까지 반려사유를 포함한 메일전송 if
	 * (app_type.equals("R")) { // SMS 전송, MAIL 전송 if(value.status == 1){ try {
	 * String[][] args = new String[iRowCount][4]; for(int i=0; i<iRowCount;
	 * i++){ String[] temp_args = { DOC_TYPE [i] ,DOC_NO [i] ,DOC_SEQ [i]
	 * ,APP_STAGE [i] // 현재결재자순서 = SIGN_PATH_SEQ와 같다. };
	 * 
	 * args[i] = temp_args; }
	 * 
	 * 
	 * Object[] sms_args = {args}; String sms_type = ""; String mail_type = "";
	 * 
	 * sms_type = "S00005"; mail_type = "M00010";
	 * 
	 * if(!"".equals(sms_type)){ ServiceConnector.doService(info, "SMS",
	 * "TRANSACTION", sms_type, sms_args); } if(!"".equals(mail_type)){
	 * ServiceConnector.doService(info, "mail", "CONNECTION", mail_type,
	 * sms_args); }
	 * 
	 * } catch (Exception e) { Logger.debug.println("mail error = " +
	 * e.getMessage()); e.printStackTrace(); } } } }catch(NullPointerException
	 * ne){ ne.printStackTrace(); }
	 */
}
