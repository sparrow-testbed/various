package sepoa.svl.tax;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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

public class s_tax_list extends HttpServlet
{
public void init(ServletConfig config) throws ServletException {
	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	// 세션 Object
        SepoaInfo info = SepoaSession.getAllValue(req);

        GridData gdReq = null;
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String mode = "";
        PrintWriter out = res.getWriter();
        
        try {
       		gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));

//       		if (mode.equals("getTrList")) {				// (공급사) 세금계산서 발행 대상 조회
//    			gdRes = getTrList(gdReq, info);
//    		} else if (mode.equals("getTxList")) {		// (공급사) 세금계산서 상세 내역 조회
//    			gdRes = getTxList(gdReq, info);
//    		} else if (mode.equals("getTxList2")){		// (공급사) 세금계산서 현황 조회
//    			gdRes = getTxList2(gdReq, info);
    		 if("getTaxList".equals(mode)){		//  (공급사)세금계산서 현황 조회
    			gdRes = getTaxList(gdReq, info);
    		}else if("setTxApp".equals(mode)){
    			gdRes = setTxApp(gdReq, info);
    		}else if ("setProgressCode".equals(mode)) {
    			gdRes = setProgressCode(gdReq, info);
			}
    		 // else if(mode.equals("getSignTaxList")){	// 해당 결제건의 세금계산서 조회
//    			gdRes = getSignTaxList(gdReq, info);
//    		} else {
//    			gdRes = getTrList(gdReq);
//    		}
  
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
	public void doQuery(SepoaStream ws) throws Exception
	{
		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
		String mode 	= ws.getParam("mode");
		
		

	}
	
//	public void doData(SepoaStream ws) throws Exception {
//		SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
//    	SepoaFormater wf = ws.getSepoaFormater();
//		String mode 	= ws.getParam("mode");
//		
//		if (mode.equals("setTaxAppNo")){
//			setTaxAppNo(ws);
//		}else if (mode.equals("setTaxCheck")){
//			setTaxCheck(ws);
//		}else if (mode.equals("setApproval")){
//			setApproval(ws);
//		}else if (mode.equals("setProgressCode")){
//			setProgressCode(ws);
//		}else if (mode.equals("setPayFinish")){
//			setPayFinish(ws);
//		}
//	}
	
//	private void getTrList(SepoaStream ws, SepoaInfo info) throws Exception
//	{
//		String from_date		= ws.getParam("from_date"		);
//		String to_date		    = ws.getParam("to_date"		    );
//		String vendor_code	    = ws.getParam("vendor_code"	    );
//		String pay_no	    	= ws.getParam("pay_no"	    	);
//		
//		Object[] obj = {from_date
//				   ,to_date
//				   ,vendor_code
//				   ,pay_no
//				   };
//		
//		SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getTrList",obj);
//		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
//		int iRowCount = wf.getRowCount();
//		String icon_con_gla = "/kr/images/icon/detail.gif";
//		for(int i=0; i<iRowCount; i++)
//		{
//			String[] check = {"false", ""};
//			String[] img_pay_no       		= {""			 , wf.getValue("PAY_NO"	   ,i)	, wf.getValue("PAY_NO"		,i)};
//			String[] img_print		  		= {icon_con_gla, "인쇄"							, "인쇄"};
//			String[] img_rehect_reason_flag1 = {icon_con_gla, wf.getValue("REJECT_REASON"	   ,i)	, wf.getValue("REJECT_REASON"		,i)};
//			String[] img_rehect_reason_flag2 = {"", wf.getValue("REJECT_REASON"	   ,i)	, wf.getValue("REJECT_REASON"		,i)};
//						
//			ws.addValue("SEL"				, check                            		, "");
//			ws.addValue("JOB_STATUS"		, wf.getValue("JOB_STATUS"			,i) , "");
//			ws.addValue("JOB_STATUS_TXT"	, wf.getValue("JOB_STATUS_TXT"		,i) , "");
//			ws.addValue("PAY_NO"			, img_pay_no 							, "");
//			ws.addValue("PAY_DATE"			, wf.getValue("PAY_DATE"			,i) , "");
//			ws.addValue("ADD_USER_NAME"		, wf.getValue("ADD_USER_NAME"		,i) , "");
//			ws.addValue("COMPANY_CODE"		, wf.getValue("VENDOR_CODE"			,i) , "");
//			ws.addValue("COMPANY_NAME"		, wf.getValue("VENDOR_NAME"			,i) , "");
//			ws.addValue("ITEM_COUNT"		, wf.getValue("ITEM_COUNT"			,i) , "");
//			ws.addValue("ITEM_QTY"			, wf.getValue("ITEM_QTY"			,i) , "");
//			ws.addValue("PAY_AMT"			, wf.getValue("PAY_AMT"				,i) , "");
//			ws.addValue("PURCHASE_ID"		, wf.getValue("PURCHASE_ID"			,i) , "");
//			ws.addValue("PURCHASE_NAME"		, wf.getValue("PURCHASE_NAME"		,i) , "");
//			ws.addValue("PRINT"				, img_print								, "");
//			
//			if(!wf.getValue("REJECT_REASON"	   ,i).equals("")){
//				ws.addValue("REJECT_REASON", img_rehect_reason_flag1 				, "");				
//			}else{
//				ws.addValue("REJECT_REASON", img_rehect_reason_flag2 				, "");				
//			}
//			
//			ws.addValue("REJECT_REASON_FLAG", wf.getValue("REJECT_REASON_FLAG"	,i) , "");
//			ws.addValue("TAX_NO"			, wf.getValue("TAX_NO"				,i) , "");
//			ws.addValue("WBS"				, wf.getValue("WBS"					,i) , "");
//			ws.addValue("WBS_NAME"			, wf.getValue("WBS_NAME"			,i) , "");
//		}
//
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//		ws.write();
//		
//	}

//	private void getTxList(SepoaStream ws, SepoaInfo info) throws Exception
//	{
//		String tax_no		= ws.getParam("tax_no");
//		
//		Object[] obj = {tax_no};
//		
//		SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getTxDT",obj);
//		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
//		int iRowCount = wf.getRowCount();
//
//		for(int i=0; i<iRowCount; i++)
//		{
//			String[] img_item_name       	= {""			 , wf.getValue("ITEM_DESC"	   ,i)	, wf.getValue("ITEM_DESC"		,i)};
//						
//			ws.addValue("DATE"				, wf.getValue("BUY_DATE"		,i) , "");
//			ws.addValue("ITEM_CODE"			, wf.getValue("ITEM_CODE"		,i) , "");
//			ws.addValue("ITEM_NAME"			, img_item_name						, "");
//			ws.addValue("SPEC"				, wf.getValue("ITEM_SPEC"		,i) , "");
//			ws.addValue("QTY"				, wf.getValue("ITEM_QTY"		,i) , "");
//			ws.addValue("PRICE"				, wf.getValue("UNIT_PRICE"		,i) , "");
//			ws.addValue("SUPPLIER_PRICE"	, wf.getValue("SUP_AMT"			,i) , "");
//			ws.addValue("TAX_PRICE"			, wf.getValue("VAT_AMT"			,i) , "");
//			ws.addValue("ACCOUNT_TYPE"		, wf.getValue("ACCOUNT_TYPE"	,i) , "");
//			ws.addValue("REMARK"			, wf.getValue("REMARK"			,i) , "");
//			
//		}
//
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//		ws.write();
//		
//	}
	
	//세금계산서 반려
	public GridData setProgressCode(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
	    try{
	    	gdRes.setSelectable(false);
	    	Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	
	    	Map<String, String> header = MapUtils.getMap(data, SepoaDataMapper.KEY_HEADER_DATA);
			String buyer_reject_Remark = header.get("buyer_reject_Remark");
			if(!"".equals(buyer_reject_Remark)){
				Object[] obj1 	= {data};
				SepoaOut value1 	= ServiceConnector.doService(info, "TX_001_S", "TRANSACTION", "setBuyerRejectRemark", obj1);		
			}		
			
			Object[] obj 	= {data};
			SepoaOut value 	= ServiceConnector.doService(info, "TX_001_S", "TRANSACTION", "setTxApp", obj);
					
			String[] res = new String[1];
			res[0] = value.message;

			
			if(value.flag) {
				gdRes.setStatus("true");
			}else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
	    }catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
		return gdRes;
	}
	
	// 세금계산서 승인
	public GridData setTxApp(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
        try{
        	gdRes.setSelectable(false);
    		Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	
    		Object[] obj = {data};
    		SepoaOut value = ServiceConnector.doService(info, "TX_001_S", "TRANSACTION", "setTxApp", obj);
    		if(value.flag) {
    			gdRes.setStatus("true");
    		}else {
    			gdRes.setMessage(value.message);
    			gdRes.setStatus("false");
    		}
        }catch (Exception e) {
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
		
		return gdRes;
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
	
	
//	private void getTxList2(SepoaStream ws, SepoaInfo info) throws Exception{
//		String from_date		= ws.getParam("from_date"		);
//		String to_date		    = ws.getParam("to_date"		    );
//		String tax_app_no		= ws.getParam("tax_app_no"		);
//		String progress_code	= ws.getParam("progress_code"	);
//		String tax_div			= ws.getParam("tax_div"			);
//		
//		Object[] obj = {from_date
//				   		,to_date
//				   		,tax_app_no
//				   		,progress_code
//				   		,tax_div
//				   		};
//		
//		SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getTxList2",obj);
//		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
//		int iRowCount = wf.getRowCount();
//		String icon_con_gla = "/kr/images/icon/detail.gif";
//
//		for(int i=0; i<iRowCount; i++)
//		{
//			String[] check 					= {"false", ""};
//			String[] img_tax_no       		= {""			 , wf.getValue("TAX_NO"	   ,i)	, wf.getValue("TAX_NO"		,i)};
//			String[] img_pay_no       		= {""			 , wf.getValue("PAY_NO"	   ,i)	, wf.getValue("PAY_NO"		,i)};
//			String[] img_rehect_reason_flag1 = {icon_con_gla, wf.getValue("REJECT_REASON"	   ,i)	, wf.getValue("REJECT_REASON"		,i)};
//			String[] img_rehect_reason_flag2 = {"", wf.getValue("REJECT_REASON"	   ,i)	, wf.getValue("REJECT_REASON"		,i)};
//			
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
//			
//			if(!wf.getValue("REJECT_REASON"	   ,i).equals("")){
//				ws.addValue("REJECT_REASON"		, img_rehect_reason_flag1 				, "");
//			}else{
//				ws.addValue("REJECT_REASON"		, img_rehect_reason_flag2 				, "");
//			}
//			ws.addValue("REJECT_REASON_FLAG"	, wf.getValue("REJECT_REASON_FLAG"		,i) , "");
//		}
//
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//		ws.write();		
//	}
	
	private GridData getTaxList(GridData gdReq, SepoaInfo info) throws Exception{
		GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 
		 try {
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
				
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doSelect");
				Map<String,String> add = (Map<String, String>) data.get("headerData");
				add.put("mode","inv_person");
				Object[] obj = {data};
				// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
				SepoaOut value = ServiceConnector.doService(info, "TX_001_S", "CONNECTION", "getTaxList", obj);
				
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
					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("INV_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("TAX_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("PAY_DEMAND_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("PAY_END_DATE")) {
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
	
//	private void getSignTaxList(SepoaStream ws, SepoaInfo info) throws Exception{
//		String group_tax_no		= ws.getParam("group_tax_no"		);
//		
//		Object[] obj = {group_tax_no};
//		
//		SepoaOut value = ServiceConnector.doService(info, "p2054", "CONNECTION","getSignTaxList",obj);
//		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
//		int iRowCount = wf.getRowCount();
//
//		for(int i=0; i<iRowCount; i++)
//		{
//			String[] img_tax_no       		= {""			 , wf.getValue("TAX_NO"	    ,i)	, wf.getValue("TAX_NO"		,i)};
//			String[] img_vendor_name       	= {""			 , wf.getValue("VENDOR_NAME",i)	, wf.getValue("VENDOR_NAME"	,i)};
//						
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
//						
//		}
//
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//		ws.write();		
//	}
}
