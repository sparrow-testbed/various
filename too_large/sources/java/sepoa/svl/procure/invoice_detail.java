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
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

import com.icompia.util.CommonUtil;

public class invoice_detail extends HttpServlet {
	
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
			if ("grid_top".equals(mode)) {
				gdRes = GridTop(gdReq, info); 
			}else if("grid_bottom".equals(mode)){
				gdRes = GridBottom(gdReq, info);
			}else if("inv_item_info".equals(mode)){
				gdRes = inv_item_info(gdReq, info);
			}else if("setInvItemInfo".equals(mode)){
				gdRes = setInvItemInfo(gdReq, info);
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

	/*public void doQuery(SepoaStream ws) throws Exception {
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		String inv_no = ws.getParam("inv_no");
		String po_no = ws.getParam("po_no");
		if (ws.getParam("grid_type") == null) {
			GetQuery(ws, info, inv_no);
		} else if (ws.getParam("grid_type").equals("grid_top")) {
			GridTop(ws, info, inv_no, po_no);
		} else if (ws.getParam("grid_type").equals("grid_bottom")) {
			GridBottom(ws, info, inv_no, po_no);
		}

	}*/

//	private void GetQuery(SepoaStream ws, SepoaInfo info, String doc_no)
//			throws Exception {
//		Object[] obj = { doc_no };
//		SepoaOut value = ServiceConnector.doService(info, "p2050", "CONNECTION", "getItemList", obj);
//		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
//
//		int iRowCount = wf.getRowCount();
//		for (int i = 0; i < iRowCount; i++) {
//			String[] check = { "true", "" };
//			String[] img_description_loc = { "", wf.getValue("DESCRIPTION_LOC", i), wf.getValue("DESCRIPTION_LOC", i) };
//			
//			ws.addValue("SEL", check, "");
//			ws.addValue("ITEM_NO", wf.getValue("ITEM_NO", i), "");
//			ws.addValue("DESCRIPTION_LOC", img_description_loc, "");
//			ws.addValue("SPECIFICATION", wf.getValue("SPECIFICATION", i), "");
//			ws.addValue("TECHNIQUE_GRADE", wf.getValue("TECHNIQUE_GRADE", i), "");
//			ws.addValue("INPUT_FROM_DATE", wf.getValue("INPUT_FROM_DATE", i), "");
//			ws.addValue("INPUT_TO_DATE", wf.getValue("INPUT_TO_DATE", i), "");
//			ws.addValue("RD_DATE", wf.getValue("RD_DATE", i), "");
//			ws.addValue("UNIT_MEASURE", wf.getValue("UNIT_MEASURE", i), "");
//			ws.addValue("ITEM_QTY", wf.getValue("ITEM_QTY", i), "");
//			ws.addValue("UNIT_PRICE", wf.getValue("UNIT_PRICE", i), "");
//			ws.addValue("GR_QTY", wf.getValue("GR_QTY", i), "");
//			ws.addValue("INV_QTY", wf.getValue("INV_QTY", i), "");
//			ws.addValue("ITEM_AMT", wf.getValue("ITEM_AMT", i), "");
//			ws.addValue("INV_AMT", wf.getValue("INV_AMT", i), "");
//			ws.addValue("GR_AMT", wf.getValue("GR_AMT", i), "");
//			ws.addValue("PO_SEQ", "", "");
//
//		}
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//		ws.write();
//
//	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setInvItemInfo(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		Object[] obj = {data};
    		
    		value = ServiceConnector.doService(info, "IV_001", "TRANSACTION", "setInvItemInfo", obj);
    		
    		if(value.flag) {
    			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
    			gdRes.setStatus("true");
    		}
    		else {
    			gdRes.setMessage(value.message);
    			gdRes.setStatus("false");
    		}
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }		

	public void doData(SepoaStream ws) throws Exception {
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		// SepoaTable로부터 upload된 data을 formatting하여 얻는다.
		SepoaFormater wf = ws.getSepoaFormater();
		String mode = ws.getParam("mode");

		/*검수요청 결재 추가*/
		if("inv_app".equals(mode)){
			Object[] obj = { ws };
			SepoaOut value = ServiceConnector.doService(info, "s2050", "TRANSACTION", "setAppInv", obj);

			String[] uObj = { mode, String.valueOf(value.status) };
			ws.setUserObject(uObj);
			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
		}
		else{
			String house_code = info.getSession("HOUSE_CODE");
			String id = info.getSession("ID");
			String dept = info.getSession("DEPARTMENT");
			String company_code = info.getSession("COMPANY_CODE");
			String po_no = ws.getParam("po_no");
			String iv_no = ws.getParam("iv_no");
			String SUBJECT = ws.getParam("SUBJECT");
			String DP_TYPE = ws.getParam("DP_TYPE");
			String DP_PAY_TERMS = ws.getParam("DP_PAY_TERMS");
			String IV_SEQ = ws.getParam("IV_SEQ");
			String DP_AMT = ws.getParam("DP_AMT");
			String PO_TTL_AMT = ws.getParam("PO_TTL_AMT");
			String ADD_USER_ID = ws.getParam("ADD_USER_ID");
			String INV_DATE = ws.getParam("INV_DATE");
			String REMARK = ws.getParam("REMARK");
			String DP_PAY_TERMS_TEXT = ws.getParam("DP_PAY_TERMS_TEXT");
			String PO_CREATE_DATE = ws.getParam("PO_CREATE_DATE");
			String DP_PERCENT = ws.getParam("DP_PERCENT");
			String DP_TEXT = ws.getParam("DP_TEXT");
			String setivdtData[][] = new String[wf.getRowCount()][];

			String[] ITEM_NO = wf.getValue("ITEM_NO");
			String[] DESCRIPTION_LOC = wf.getValue("DESCRIPTION_LOC");
			String[] RD_DATE = wf.getValue("RD_DATE");
			String[] UNIT_MEASURE = wf.getValue("UNIT_MEASURE");
			String[] ITEM_QTY = wf.getValue("ITEM_QTY");
			String[] UNIT_PRICE = wf.getValue("UNIT_PRICE");
			String[] ITEM_AMT = wf.getValue("ITEM_AMT");
			String[] GR_QTY = wf.getValue("GR_QTY");
			String[] INV_QTY = wf.getValue("INV_QTY");
			String[] PO_SEQ = wf.getValue("PO_SEQ");

			SepoaOut wo = DocumentUtil.getDocNumber(info, "INV"); // 매입계산서번호 생성.
			String inv_no = wo.result[0];
			String setivhdData[][] = { { house_code // HOUSE_CODE
					, inv_no // INV_NO
					, SUBJECT // SUBJECT
					, SepoaDate.getShortDateString() // ADD_DATE
					, SepoaDate.getShortTimeString() // ADD_TIME
					, id // ADD_USER_ID
					, dept // ADD_USER_DEPT
					, company_code // VENDOR_CODE
					, DP_TYPE // DP_TYPE
					, DP_AMT // DP_AMT
					, DP_PAY_TERMS // DP_PAY_TERMS
					, DP_PAY_TERMS_TEXT // DP_PAY_TERMS_TEXT
					, PO_TTL_AMT // PO_TTL_AMT
					, PO_CREATE_DATE // PO_CREATE_DATE
					, "0" // INV_AMT
					, ADD_USER_ID // INV_PERSON_ID
					, INV_DATE // INV_DATE
					, REMARK // REMARK
					, ADD_USER_ID // PURCHARSE_ID
					, IV_SEQ, DP_PERCENT, DP_TEXT } };
			for (int i = 0; i < wf.getRowCount(); i++) {
				String ivdtData[] = { house_code, inv_no,
						CommonUtil.lpad(String.valueOf(i), 6, "0"), iv_no, po_no,
						PO_SEQ[i], SepoaDate.getShortDateString(),
						SepoaDate.getShortTimeString(), id, dept, ITEM_NO[i],
						UNIT_MEASURE[i], ITEM_QTY[i], UNIT_PRICE[i], ITEM_AMT[i],
						RD_DATE[i], GR_QTY[i], INV_QTY[i], DESCRIPTION_LOC[i] };
				setivdtData[i] = ivdtData;
			}

			Object[] obj = { setivhdData, setivdtData };
			SepoaOut value = ServiceConnector.doService(info, "s2050",
					"TRANSACTION", "setInv", obj);

			String[] res = new String[1];
			res[0] = value.message;

			ws.setUserObject(res);
			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
		}
		ws.write();
	}

	/**
	 * 상단그리드
	 *
	 * @param obj
	 * @throws Exception
	 */
	public GridData GridTop(GridData gdReq, SepoaInfo info) throws Exception
	{
		GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		

		try {
			String inv_no = JSPUtil.CheckInjection(gdReq.getParam("inv_no")); 
			String po_no = JSPUtil.CheckInjection(gdReq.getParam("po_no")); 
			Map<String, String> data = new HashMap<String,String>();
			data.put("inv_no", inv_no);
			data.put("po_no",po_no);
			data.put("gridFlag", "TOP");
			
			String grid_col_id = JSPUtil.CheckInjection(
					gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "grid_top");

			Object[] obj = {data};
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "IV_001", "CONNECTION", "getIvDetail", obj);

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
					
					if("INV_INFO".equals(grid_col_ary[k])){
						gdRes.addValue(grid_col_ary[k],	"/images/icon/icon.gif");
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

	/**
	 * 하단 그리드
	 *
	 * @param obj
	 * @throws Exception
	 */
	private GridData GridBottom(GridData gdReq, SepoaInfo info) throws Exception
	{
		GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

		try {
			String inv_no = JSPUtil.CheckInjection(gdReq.getParam("inv_no")); 
			String po_no = JSPUtil.CheckInjection(gdReq.getParam("po_no")); 
			Map<String, String> data = new HashMap<String,String>();
			data.put("inv_no", inv_no);
			data.put("po_no",po_no);
			data.put("gridFlag", "BOTTOM");
			
			String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "grid_bottom");

			Object[] obj = {data};
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "IV_001", "CONNECTION", "getIvDetail", obj);

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
					gdRes.addValue(grid_col_ary[k],	wf.getValue(grid_col_ary[k], i));
				}
			}

		} catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		return gdRes;

	}
	
	private GridData inv_item_info(GridData gdReq, SepoaInfo info) throws Exception
	{
		GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		
		try {
			String inv_no = JSPUtil.CheckInjection(gdReq.getParam("inv_no")); 
			String inv_seq = JSPUtil.CheckInjection(gdReq.getParam("inv_seq")); 
			String item_no = JSPUtil.CheckInjection(gdReq.getParam("item_no")); 
			Map<String, String> data = new HashMap<String,String>();
			data.put("inv_no", inv_no);
			data.put("inv_seq",inv_seq);
			data.put("item_no",item_no);
			
			String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");
			
			Object[] obj = {data};
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "IV_001", "CONNECTION", "inv_item_info", obj);
			
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
					gdRes.addValue(grid_col_ary[k],	wf.getValue(grid_col_ary[k], i));
				}
			}
			
		} catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		return gdRes;
		
	}
}


