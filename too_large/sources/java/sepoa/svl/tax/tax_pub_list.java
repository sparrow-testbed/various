package sepoa.svl.tax;

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
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class tax_pub_list extends HttpServlet
{
public void init(ServletConfig config) throws ServletException {
	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
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
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
       		if ("getTrList".equals(mode))
       		{	
       			gdRes = getTrList(gdReq, info);		//조회
       		}
       		else if ("getTxList".equals(mode))
       		{	
       			gdRes = getTxList(gdReq, info);
       		}
       		else if("setTxData".equals(mode))
       		{
       			gdRes = setTxData(gdReq, info);
       		}
       		else if ("tax_tgt".equals(mode))
       		{	
       			gdRes = tax_tgt(gdReq, info);		//조회
       		}
//       		else if(mode.equals("setIvInsert"))
//       		{
//       			gdRes = setIvInsert(gdReq, info);
//       		}
  
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
     
//	public void doQuery(SepoaStream ws) throws Exception
//	{
//		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
//		String mode 	= ws.getParam("mode");
//		
//		if (mode.equals("getTrList")) {				// (공급사) 세금계산서 발행 대상 조회
//			getTrList(ws, info);
//		} else if (mode.equals("getTxList")) {		// (공급사) 세금계산서 상세 내역 조회
//			getTxList(ws, info);
//		} else if (mode.equals("getTxList2")){		// (공급사) 세금계산서 현황 조회
//			getTxList2(ws, info);
//		} else if(mode.equals("getTaxList")){		//  세금계산서 현황 조회
//			getTaxList(ws, info);
//		} else if(mode.equals("getSignTaxList")){	// 해당 결제건의 세금계산서 조회
//			getSignTaxList(ws, info);
//		} else {
//			getTrList(ws, info);
//		}
//
//	}
	
	public void doData(SepoaStream ws) throws Exception {
		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
    	SepoaFormater wf = ws.getSepoaFormater();
		String mode 	= ws.getParam("mode");
		
		if ("setTaxAppNo".equals(mode)){
			setTaxAppNo(ws);
		}else if ("setTaxCheck".equals(mode)){
			setTaxCheck(ws);
		}else if ("setApproval".equals(mode)){
			setApproval(ws);
		}else if ("setProgressCode".equals(mode)){
			setProgressCode(ws);
		}else if ("setPayFinish".equals(mode)){
			setPayFinish(ws);
		}
	}
	
	private GridData getTrList(GridData gdReq, SepoaInfo info) throws Exception
	{
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 try{
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				
//				SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getTrList",obj);
				SepoaOut value = ServiceConnector.doService(info, "TX_002", "CONNECTION","getTrList",obj);
				SepoaFormater wf = new SepoaFormater(value.result[0]);
				if (wf.getRowCount() == 0) {
				    gdRes.setMessage(message.get("MESSAGE.1001").toString()); 
				    return gdRes;
				}
				for (int i = 0; i < wf.getRowCount(); i++) {
					for(int k=0; k < grid_col_ary.length; k++) {
					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
				    	} else {
				        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
				        }
					}
				}
				
		 } catch (Exception e) {
			    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
		    }
			
			return gdRes;
		
	}

	private GridData getTxList(GridData gdReq, SepoaInfo info) throws Exception
	{
		GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 String ITEM_SPEC = "";
		 try {
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
				Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String inv_data = "";
				inv_data  = JSPUtil.CheckInjection(gdReq.getParam("inv_data"));
				header.put("inv_data", inv_data);
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {header};
				// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
				SepoaOut value = ServiceConnector.doService(info, "TX_003", "CONNECTION","getTxDT",obj);
				
				if(value.flag) {
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
					for(int k=0; k < grid_col_ary.length; k++) {
					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue("BUY_DATE", i)));
	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ITEM_NAME")) {
	    	            	gdRes.addValue(grid_col_ary[k], wf.getValue("ITEM_DESC", i));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("SPEC")) {
				    		ITEM_SPEC = wf.getValue("ITEM_SPEC", i);
				    		
				    		if(ITEM_SPEC.getBytes().length > 40) ITEM_SPEC = ITEM_SPEC.substring(0,20); 
	    	            	gdRes.addValue(grid_col_ary[k], ITEM_SPEC);
	    	            		    	            	
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("QTY")) {
	    	            	gdRes.addValue(grid_col_ary[k], wf.getValue("ITEM_QTY", i));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("PRICE")) {
	    	            	gdRes.addValue(grid_col_ary[k], wf.getValue("UNIT_PRICE", i));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("SUPPLIER_PRICE")) {
	    	            	gdRes.addValue(grid_col_ary[k], wf.getValue("SUP_AMT", i));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("TAX_PRICE")) {
	    	            	gdRes.addValue(grid_col_ary[k], wf.getValue("VAT_AMT", i));
				    	}else {
				        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
				        }
					}
				}
			} catch (Exception e) {
			    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
				gdRes.setStatus("false");
		    }
			
			return gdRes;
	}
	
	public GridData setTxData(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
	    try{
	    	Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	
	    	gdRes.setSelectable(false);
	    	Object[] obj = {data};
			SepoaOut value = ServiceConnector.doService(info, "TX_003", "TRANSACTION", "setTxData", obj);
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				gdRes.setStatus("true");
			}else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
	    }catch (Exception e) {
	    	Logger.err.println("setTxData servlet ==> "+e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
	
	// 세금계산서 발행 저장
	private void setTaxCheck(SepoaStream ws) throws Exception {
		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
    	SepoaFormater wf = ws.getSepoaFormater();
		
		String tax_no			= ws.getParam("tax_no");
		String progress_code	= ws.getParam("progress_code");
		       
		Object[] obj 	= {tax_no, progress_code};
		SepoaOut value 	= ServiceConnector.doService(info, "p2054", "TRANSACTION", "setProgressCode", obj);
		
		String[] res = new String[1];
		res[0] = value.message;

		
		String[] uObj = { ws.getParam("mode"),tax_no};
		ws.setUserObject(uObj);
		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();		
	}

	// 세금계산서 확인
	private void setTaxAppNo(SepoaStream ws) throws Exception {
		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
    	SepoaFormater wf = ws.getSepoaFormater();
		
		String tax_no			= ws.getParam("tax_no");
		String tax_app_no		= ws.getParam("tax_app_no");
		String tax_date			= ws.getParam("tax_date");
		String attach_no		= ws.getParam("attach_no");
		String progress_code	= ws.getParam("progress_code");
		       
		Object[] obj 	= {tax_no, tax_app_no, tax_date, attach_no, progress_code};
		SepoaOut value 	= ServiceConnector.doService(info, "p2054", "TRANSACTION", "setTxTaxAppNo", obj);
		
	
		Object[] obj1 	= {tax_no, progress_code};
		SepoaOut value1 	= ServiceConnector.doService(info, "p2054", "TRANSACTION", "setProgressCode", obj1);
			
	
		
		String[] res = new String[1];
		res[0] = value.message;

		
		String[] uObj = { ws.getParam("mode")};
		ws.setUserObject(uObj);
		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();		
	}	

	// 결제 요청
	private void setApproval(SepoaStream ws) throws Exception {
		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
    	SepoaFormater wf = ws.getSepoaFormater();		
    	
    	String approval_str =  ws.getParam("approval_str");
    	String project	    =  ws.getParam("project");  	
    	String sign_status	=  ws.getParam("sign_status");
    	
    	String tax_no_list[] =  wf.getValue("TAX_NO");
    	String pay_end_date_list[] =  wf.getValue("PAY_END_DATE");      
   	
    	
    	Object[] obj 	= {tax_no_list,pay_end_date_list, project, sign_status,approval_str};
		SepoaOut value 	= ServiceConnector.doService(info, "p2054", "TRANSACTION", "setApproval", obj);

		String[] res = new String[1];
		res[0] = value.message;
		
		String[] uObj = { ws.getParam("mode")};
		ws.setUserObject(uObj);
		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();		
	}
	private void setProgressCode(SepoaStream ws) throws Exception {
	
		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
    	SepoaFormater wf = ws.getSepoaFormater();
		
		String tax_no			= ws.getParam("tax_no");
		String mode				= ws.getParam("mode");
		String progress_code	= ws.getParam("progress_code");
		String buyer_reject_Remark = JSPUtil.nullToEmpty(ws.getParam("buyer_reject_Remark"));
		       	
		
		if(!"".equals(buyer_reject_Remark)){
			Object[] obj1 	= {tax_no, buyer_reject_Remark};
			SepoaOut value1 	= ServiceConnector.doService(info, "p2054", "TRANSACTION", "setBuyerRejectRemark", obj1);		
		}		
		
		Object[] obj 	= {tax_no, progress_code};
		SepoaOut value 	= ServiceConnector.doService(info, "p2054", "TRANSACTION", "setProgressCode", obj);
				
		String[] res = new String[1];
		res[0] = value.message;

		
		String[] uObj = { mode, progress_code};
		ws.setUserObject(uObj);
		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();			
	}
	
	
	private void setPayFinish(SepoaStream ws) throws Exception {
		
		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
    	SepoaFormater wf = ws.getSepoaFormater();
		String user_id 		= info.getSession("ID");
		String house_code 	= info.getSession("HOUSE_CODE");
    	
    	String[] tax_no			= wf.getValue("TAX_NO");
		String progress_code	= ws.getParam("progress_code");
		
		int iRowCount = wf.getRowCount();
		
		String[][] data = new String[iRowCount][];

		for(int i=0; i < iRowCount ; i++) {
			String[] temp =  {user_id, progress_code , house_code , tax_no[i]};
			data[i] = temp;
		}	
		
		Object[] obj = {data, progress_code};
		
		SepoaOut value 	= ServiceConnector.doService(info, "p2054", "TRANSACTION", "setPayFinish", obj);
		
				
		String[] res = new String[1];
		res[0] = value.message;

		
		String[] uObj = { ws.getParam("mode"),progress_code};
		ws.setUserObject(uObj);
		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();			
	}
	
	
	private void getTxList2(SepoaStream ws, SepoaInfo info) throws Exception{
		String from_date		= ws.getParam("from_date"		);
		String to_date		    = ws.getParam("to_date"		    );
		String tax_app_no		= ws.getParam("tax_app_no"		);
		String progress_code	= ws.getParam("progress_code"	);
		String tax_div			= ws.getParam("tax_div"			);
		
		Object[] obj = {from_date
				   		,to_date
				   		,tax_app_no
				   		,progress_code
				   		,tax_div
				   		};
		
		SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getTxList2",obj);
		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
		int iRowCount = wf.getRowCount();
		String icon_con_gla = "/kr/images/icon/detail.gif";

		for(int i=0; i<iRowCount; i++)
		{
			String[] check 					= {"false", ""};
			String[] img_tax_no       		= {""			 , wf.getValue("TAX_NO"	   ,i)	, wf.getValue("TAX_NO"		,i)};
			String[] img_pay_no       		= {""			 , wf.getValue("PAY_NO"	   ,i)	, wf.getValue("PAY_NO"		,i)};
			String[] img_rehect_reason_flag1 = {icon_con_gla, wf.getValue("REJECT_REASON"	   ,i)	, wf.getValue("REJECT_REASON"		,i)};
			String[] img_rehect_reason_flag2 = {"", wf.getValue("REJECT_REASON"	   ,i)	, wf.getValue("REJECT_REASON"		,i)};
			
//			ws.addValue("SEL"				, check                            		, "");
//			ws.addValue("ADD_DATE"			, wf.getValue("ADD_DATE"			,i) , "");
//			ws.addValue("TAX_NO"			, img_tax_no 							, "");
//			ws.addValue("TAX_DATE"			, wf.getValue("TAX_DATE"			,i) , "");
//			ws.addValue("TAX_APP_NO"		, wf.getValue("TAX_APP_NO"			,i) , "");
//			ws.addValue("TAX_DIV"			, wf.getValue("TAX_DIV"				,i) , "");
//			ws.addValue("TAX_DIV_TXT"		, wf.getValue("TAX_DIV_TXT"			,i) , "");
//			ws.addValue("SUP_AMT"			, wf.getValue("SUP_AMT"				,i) , "");
//			ws.addValue("TAX_AMT"			, wf.getValue("TAX_AMT"				,i) , "");
//			ws.addValue("TOT_AMT"			, wf.getValue("TOT_AMT"				,i) , "");
//			ws.addValue("PAY_NO"			, img_pay_no 							, "");
//			ws.addValue("PROGRESS_CODE"		, wf.getValue("PROGRESS_CODE"		,i) , "");
//			ws.addValue("PROGRESS_CODE_TXT"	, wf.getValue("PROGRESS_CODE_TXT"	,i) , "");
//			ws.addValue("WBS"				, wf.getValue("WBS"					,i) , "");
//			ws.addValue("WBS_NAME"			, wf.getValue("WBS_NAME"			,i) , "");
			
			if(!"".equals(wf.getValue("REJECT_REASON"	   ,i))){
				Logger.debug.println();
//				ws.addValue("REJECT_REASON"		, img_rehect_reason_flag1 				, "");
			}else{
				Logger.debug.println();
//				ws.addValue("REJECT_REASON"		, img_rehect_reason_flag2 				, "");
			}
			ws.addValue("REJECT_REASON_FLAG"	, wf.getValue("REJECT_REASON_FLAG"		,i) , "");
		}

		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);
		ws.write();		
	}
	
	private void getTaxList(SepoaStream ws, SepoaInfo info) throws Exception{
		String from_date		= ws.getParam("from_date"		);
		String to_date		    = ws.getParam("to_date"		    );
		String tax_from_date	= ws.getParam("tax_from_date"	);
		String tax_to_date		= ws.getParam("tax_to_date"		);		
		String vendor_code		= ws.getParam("vendor_code"		);		
		String progress_code	= ws.getParam("progress_code"	);
		String tax_div			= ws.getParam("tax_div"			);
		String tax_app_no		= ws.getParam("tax_app_no"		);
		String sign_status		= ws.getParam("sign_status"		);
		String ctrl_person_id	= ws.getParam("ctrl_person_id"	);	
		
		Object[] obj = {from_date
				   		,to_date
				   		,tax_from_date
				   		,tax_to_date
				   		,vendor_code
				   		,progress_code
				   		,tax_div
				   		,tax_app_no
				   		,sign_status
				   		,ctrl_person_id
				   		};
		
		SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getTaxList",obj);
		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
		int iRowCount = wf.getRowCount();

		for(int i=0; i<iRowCount; i++)
		{
			String[] check 					= {"false", ""};
			String[] img_tax_no       		= {""			 , wf.getValue("TAX_NO"	    ,i)	, wf.getValue("TAX_NO"		,i)};
			String[] img_pay_no       		= {""			 , wf.getValue("PAY_NO"	    ,i)	, wf.getValue("PAY_NO"		,i)};
			String[] img_inv_no       		= {""			 , wf.getValue("INV_NO"	    ,i)	, wf.getValue("INV_NO"		,i)};
			String[] img_vendor_name       	= {""			 , wf.getValue("VENDOR_NAME",i)	, wf.getValue("VENDOR_NAME"	,i)};
						
//			ws.addValue("SEL"				, check                            		, "");
//			ws.addValue("ADD_DATE"			, wf.getValue("ADD_DATE"			,i) , "");
//			ws.addValue("TAX_NO"			, img_tax_no 							, "");
//			ws.addValue("PAY_NO"			, img_pay_no 							, "");
//			ws.addValue("INV_NO"			, img_inv_no 							, "");
//			ws.addValue("IV_NO"				, wf.getValue("IV_NO"				,i)	, "");
//			ws.addValue("VENDOR_CODE"		, wf.getValue("VENDOR_CODE"			,i) , "");
//			ws.addValue("VENDOR_NAME"		, img_vendor_name 						, "");
//			ws.addValue("SUP_IRS_NO"		, wf.getValue("SUP_IRS_NO"			,i) , "");			
//			ws.addValue("TAX_DATE"			, wf.getValue("TAX_DATE"			,i) , "");
//			ws.addValue("TAX_APP_NO"		, wf.getValue("TAX_APP_NO"			,i) , "");
//			ws.addValue("TAX_DIV"			, wf.getValue("TAX_DIV"				,i) , "");
//			ws.addValue("TAX_DIV_TXT"		, wf.getValue("TAX_DIV_TXT"			,i) , "");
//			ws.addValue("SUP_AMT"			, wf.getValue("SUP_AMT"				,i) , "");
//			ws.addValue("TAX_AMT"			, wf.getValue("TAX_AMT"				,i) , "");
//			ws.addValue("TOT_AMT"			, wf.getValue("TOT_AMT"				,i) , "");
//			ws.addValue("PAY_DEMAND_DATE"	, wf.getValue("PAY_DEMAND_DATE"		,i) , "");
//			ws.addValue("PAY_END_DATE"		, wf.getValue("PAY_END_DATE"		,i) , "");
//			ws.addValue("PROGRESS_CODE"		, wf.getValue("PROGRESS_CODE"		,i) , "");
//			ws.addValue("PROGRESS_CODE_TXT"	, wf.getValue("PROGRESS_CODE_TXT"	,i) , "");
//			ws.addValue("PO_NO"				, wf.getValue("PO_NO"				,i) , "");
//			ws.addValue("SIGN_STATUS"		, wf.getValue("SIGN_STATUS"			,i) , "");
//			ws.addValue("WBS"				, wf.getValue("WBS"					,i) , "");
//			ws.addValue("WBS_NAME"			, wf.getValue("WBS_NAME"			,i) , "");
//			ws.addValue("PURCHARSE_ID"		, wf.getValue("PURCHARSE_ID"		,i) , "");
//			ws.addValue("PURCHARSE_NAME"	, wf.getValue("PURCHARSE_NAME"		,i) , "");
//			ws.addValue("PAY_TERMS_DESC"	, wf.getValue("PAY_TERMS_DESC"		,i) , "");
						
		}

		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);
		ws.write();		
	}	
	
	private void getSignTaxList(SepoaStream ws, SepoaInfo info) throws Exception{
		String group_tax_no		= ws.getParam("group_tax_no"		);
		
		Object[] obj = {group_tax_no};
		
		SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getSignTaxList",obj);
		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
		int iRowCount = wf.getRowCount();

		for(int i=0; i<iRowCount; i++)
		{
			String[] img_tax_no       		= {""			 , wf.getValue("TAX_NO"	    ,i)	, wf.getValue("TAX_NO"		,i)};
			String[] img_vendor_name       	= {""			 , wf.getValue("VENDOR_NAME",i)	, wf.getValue("VENDOR_NAME"	,i)};
						
//			ws.addValue("TAX_NO"			, img_tax_no 							, "");
//			ws.addValue("WBS_NAME"			, wf.getValue("WBS_NAME"			,i) , "");
//			ws.addValue("VENDOR_CODE"		, wf.getValue("VENDOR_CODE"			,i) , "");
//			ws.addValue("VENDOR_NAME"		, img_vendor_name 						, "");
//			ws.addValue("SUP_IRS_NO"		, wf.getValue("SUP_IRS_NO"			,i) , "");
//			ws.addValue("TAX_DIV"			, wf.getValue("TAX_DIV"				,i) , "");
//			ws.addValue("TAX_DIV_TXT"		, wf.getValue("TAX_DIV_TXT"			,i) , "");
//			ws.addValue("PAY_TERMS_DESC"	, wf.getValue("PAY_TERMS_DESC"		,i) , "");
//			ws.addValue("PAY_END_DATE"		, wf.getValue("PAY_END_DATE"		,i) , "");		
//			ws.addValue("SUP_AMT"			, wf.getValue("SUP_AMT"				,i) , "");
//			ws.addValue("TAX_AMT"			, wf.getValue("TAX_AMT"				,i) , "");
//			ws.addValue("TOT_AMT"			, wf.getValue("TOT_AMT"				,i) , "");
						
		}

		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);
		ws.write();		
	}
	
	 @SuppressWarnings({ "rawtypes", "unchecked" })
	    private GridData tax_tgt(GridData gdReq, SepoaInfo info) throws Exception{
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
	    		
	    		value = ServiceConnector.doService(info, "TX_002", "TRANSACTION", "tax_tgt",       obj);
	    		
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
}
