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
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class invoice_list extends HttpServlet {
	
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
       		if ("getInvoiceList".equals(mode))
       		{	
       			gdRes = getInvoiceList(gdReq, info);		//조회
       		}
       		else if ("charge_transfer".equals(mode)){
       			gdRes = charge_transfer(gdReq, info);		//조회
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
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData charge_transfer(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "charge_transfer",       obj);
    		
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


	public GridData getInvoiceList(GridData gdReq, SepoaInfo info) throws Exception {
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
				
				String to_date          =sepoa.fw.util.SepoaDate.addSepoaDateMonth(add.get("inv_from_date ".trim() ),12);
				String req_to_date      = add.get("inv_to_date ".trim() );
				
				if( Integer.parseInt(req_to_date) >= Integer.parseInt(to_date) ){
					//sepoa.fw.util.SepoaDate.addSepoaDateMonth(sepoa.fw.util.SepoaDate.getShortDateString(),-1);
					//sepoa.fw.util.SepoaDate.addSepoaDateMonth(sepoa.fw.util.SepoaDate.getShortDateString(),-1);
					gdRes.setMessage("검수요청기간은 1년 이내 이어야 합니다.");
					gdRes.setStatus("false");
					return gdRes;
				}
				
				
				Object[] obj = {data};
				// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
				SepoaOut value = ServiceConnector.doService(info, "IV_001", "CONNECTION", "getInvoiceList", obj);
				
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
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
	                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
				    	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("INV_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
				    	} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("ATTACH_POP")) {
							if ( wf.getValue(grid_col_ary[k], i) != null && !("0".equals(wf.getValue(grid_col_ary[k], i).trim())) ) {
								gdRes.addValue(grid_col_ary[k],	"/images/icon/icon_disk_b.gif");
							} else {
								gdRes.addValue(grid_col_ary[k],	"/images/icon/icon_disk_a.gif");
							}
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

//		String mode              = ws.getParam("mode");
//		String from_date		= ws.getParam("from_date"		);
//		String to_date		    = ws.getParam("to_date"		    );
//		String inv_from_date	= ws.getParam("inv_from_date"	);
//		String inv_to_date	    = ws.getParam("inv_to_date"	    );
//		String ctrl_person_id	= ws.getParam("ctrl_person_id"	);
//		String sign_status	    = ws.getParam("sign_status"	    );
//		String pay_flag			= ws.getParam("pay_flag"		);
//		String vendor_code	    = ws.getParam("vendor_code"	    );
//		String inv_person_id	= ws.getParam("inv_person_id"	);
//		String po_no			= ws.getParam("po_no"			);
//		String order_no			= ws.getParam("order_no"		);
//		String dept				= ws.getParam("dept"			);
//		String app_status		= JSPUtil.nullToEmpty(ws.getParam("app_status"));
//        Object[] obj = {from_date
//					   ,to_date
//					   ,inv_from_date
//					   ,inv_to_date
//					   ,ctrl_person_id
//					   ,sign_status
//					   ,pay_flag
//					   ,vendor_code
//					   ,inv_person_id
//					   ,po_no
//					   ,order_no
//					   ,dept
//					   ,"inv_person"
//					   ,"A"
//					   ,app_status
//					   };
//		SepoaOut value = ServiceConnector.doService(info, "p2050", "CONNECTION","getInvList",obj);
//		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
//		int iRowCount = wf.getRowCount();
//		String icon_con_gla = "/kr/images/icon/detail.gif";
//		for(int i=0; i<iRowCount; i++)
//		{
//			String[] check = {"false", ""};
//			String[] img_po_no       = {""			, wf.getValue("PO_NO"	   ,i)	, wf.getValue("PO_NO"		,i)};
//			String[] img_iv_no       = {""			, wf.getValue("IV_NO"	   ,i)	, wf.getValue("IV_NO"		,i)};
//			String[] img_vendor_code = {""			, wf.getValue("VENDOR_CODE",i)	, wf.getValue("VENDOR_CODE"	,i)};
//			String[] img_vendor_name = {""			, wf.getValue("VENDOR_NAME",i)	, wf.getValue("VENDOR_NAME"	,i)};
//			String[] img_query		 = {icon_con_gla, wf.getValue("SIGN_REMARK",i)	, wf.getValue("SIGN_REMARK"	,i)};
//			String[] img_inv_no       = {""			, wf.getValue("INV_NO"	   ,i)	, wf.getValue("INV_NO"		,i)};
//			String[] img_eval_flag_desc = {icon_con_gla			, wf.getValue("EVAL_FLAG_DESC"	   ,i)	, wf.getValue("EVAL_FLAG_DESC"		,i)};
//			String[] img_attach		 = {icon_con_gla, wf.getValue("ATTACH_POP" ,i)  , wf.getValue("ATTACH_POP"  ,i)};
//			ws.addValue("SEL"				, check                            		, "");
//			ws.addValue("PO_NO"				, img_po_no 							, "");
//			ws.addValue("PO_SUBJECT"		, wf.getValue("PO_SUBJECT"			,i) , "");
//			ws.addValue("PO_CREATE_DATE"	, wf.getValue("PO_CREATE_DATE"	    ,i)	, "");
//			ws.addValue("VENDOR_CODE"		, img_vendor_code						, "");
//			ws.addValue("VENDOR_NAME"		, img_vendor_name						, "");
//			ws.addValue("PO_TTL_AMT"		, wf.getValue("PO_TTL_AMT"		    ,i)	, "");
//			ws.addValue("INV_PERSON_NAME"	, wf.getValue("INV_PERSON_NAME"		,i)	, "");
//			ws.addValue("ADD_USER_NAME"		, wf.getValue("ADD_USER_NAME"	    ,i)	, "");
//			ws.addValue("INV_PERSON_ID"		, wf.getValue("INV_PERSON_ID"		,i)	, "");
//			Logger.debug.println("INV_PERSON_ID::" + wf.getValue("INV_PERSON_ID"		,i));
//			ws.addValue("ADD_USER_ID"		, wf.getValue("ADD_USER_ID"	    	,i)	, "");
//			ws.addValue("IV_NO"				, img_iv_no								, "");
//			ws.addValue("DP_TEXT"			, wf.getValue("DP_TEXT"			    ,i)	, "");
//			ws.addValue("DP_PAY_TERMS"		, wf.getValue("DP_PAY_TERMS"		,i) , "");
//			ws.addValue("IV_SEQ"			, wf.getValue("IV_SEQ"			    ,i)	, "");
//			ws.addValue("DP_PERCENT"		, wf.getValue("DP_PERCENT"		    ,i)	, "");
//			ws.addValue("DP_AMT"			, wf.getValue("DP_AMT"			    ,i)	, "");
//			ws.addValue("INV_DATE"			, wf.getValue("INV_DATE"			,i) , "");
//			ws.addValue("CONFIRM_DATE"		, wf.getValue("CONFIRM_DATE"		,i)	, "");
//			ws.addValue("SIGN_STATUS"		, wf.getValue("SIGN_STATUS"		    ,i)	, "");
//			ws.addValue("SIGN_STATUS_DESC"	, wf.getValue("SIGN_STATUS_DESC"    ,i)	, "");
//			ws.addValue("ATTACH_POP"		, img_attach							, "");
//			ws.addValue("ATTACH_NO"			, wf.getValue("ATTACH_NO"    		,i)	, "");
//			ws.addValue("SIGN_REMARK"		, img_query								, "");
//			ws.addValue("PAY_FLAG"			, wf.getValue("DP_FLAG"				,i)	, "");
//			ws.addValue("INV_SUBJECT"		, wf.getValue("INV_SUBJECT"			, i), "");
//			ws.addValue("INV_QTY"			, wf.getValue("INV_QTY"				,i)	, "");
//			ws.addValue("ORDER_NO"			, wf.getValue("ORDER_NO"			,i)	, "");
//			ws.addValue("INV_NO"			, img_inv_no							, "");
//			ws.addValue("PIS_STATUS"		, wf.getValue("PIS_STATUS"			,i)	, "");
//			ws.addValue("EVAL_FLAG"			, wf.getValue("EVAL_FLAG"			,i)	, "");
//			ws.addValue("EVAL_FLAG_DESC"	, img_eval_flag_desc					, "");
//			ws.addValue("EVAL_REFITEM"		, wf.getValue("EVAL_REFITEM"		,i)	, "");
//			ws.addValue("EVAL_DATE"			, wf.getValue("EVAL_DATE"		,i)	, "");
//			ws.addValue("APP_STATUS"			, wf.getValue("APP_STATUS"		,i)	, "");
//			ws.addValue("APP_STATUS_TXT"			, wf.getValue("APP_STATUS_TXT"		,i)	, "");
//		}
//
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//		ws.write();
	}

	public void doData(SepoaStream ws) throws Exception
	{
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
    	SepoaFormater wf 	= ws.getSepoaFormater();
		String mode     	= ws.getParam("mode");
		
		if ("charge_transfer".equals(mode)) {
			charge_transfer(ws);
		} else if("cancel_inv".equals(mode)){
			cancel_inv(ws);
		} else {
			approval(ws);
		}
	}
	
	public void cancel_inv(SepoaStream ws) throws Exception
	{
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		SepoaFormater wf = ws.getSepoaFormater();
		
		String inv_no     = ws.getParam("inv_no");
		String house_code = info.getSession("HOUSE_CODE");
		
		HashMap<String, String> paramMap = new HashMap<String,String>();
		paramMap.put("inv_no", inv_no);
		paramMap.put("house_code", house_code);
		//최종검수요청건인데 반려일 경우 수행평가정보를 삭제해야한다.
		Object[] obj = {paramMap};
		SepoaOut value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "cancelInv", obj);

		String[] res = new String[2];
		res[0] = value.message;
		res[1] = String.valueOf(value.status);

		ws.setUserObject(res);
		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();
	}
	public void approval(SepoaStream ws) throws Exception
	{
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
    	SepoaFormater wf = ws.getSepoaFormater();
    	
		String inv_no     		= ws.getParam("inv_no");
		String sign_status		= ws.getParam("sign_status");
		String sign_remark  	= ws.getParam("sign_remark");
		String eval_refitem 	= ws.getParam("eval_refitem");	//최종검수요청건일 경우 평가번호가 있음.
		String inv_total_amt  	= ws.getParam("inv_total_amt");
		String inv_date		  	= ws.getParam("inv_date");
		String last_yn		  	= ws.getParam("last_yn");
		String exec_no		  	= ws.getParam("exec_no");
		String dp_div		  	= ws.getParam("dp_div");
		String confirm_date1	= ws.getParam("confirm_date1");
		
		HashMap<String, String> paramMap = new HashMap<String,String>();
		paramMap.put("last_yn", last_yn);
		paramMap.put("exec_no", exec_no);
		paramMap.put("dp_div", dp_div);
		
		String[] DT_INV_SEQ		= wf.getValue("INV_SEQ");
		String[] DT_GR_QTY		= wf.getValue("GR_QTY");
		String[] DT_INV_QTY		= wf.getValue("INV_QTY");
		String[] DT_INV_AMT		= wf.getValue("EXPECT_AMT");
		
		String IvhdData[][] = {{
			 info.getSession("ID") // CHANGE_USER_ID
				,inv_total_amt // INV_AMT
				,info.getSession("ID") // INV_PERSON_ID
				,confirm_date1   // INV_COMFRIM_DATE1
				//,inv_date // INV_DATE
				,sign_status // SIGN_STATUS
				,sign_remark // SIGN_REMARK
				,eval_refitem // EVAL_REFITEM
				,info.getSession("HOUSE_CODE") // HOUSE_CODE
				,inv_no // INV_NO
				
		}};

		String IvdtData[][] = new String[wf.getRowCount()][];
		String PodtData[][] = new String[wf.getRowCount()][];
		for (int i = 0; i<wf.getRowCount(); i++) {
			String tmpIvdt[] = {
					info.getSession("ID") // CHANGE_USER_ID
					,DT_GR_QTY[i] // GR_QTY (입고수량 : 전량입고)
					,DT_INV_QTY[i] // INV_QTY (검수합격수량)
					,DT_INV_AMT[i] // INV_AMT (검수금액)
					,info.getSession("HOUSE_CODE") // HOUSE_CODE
					,inv_no // INV_NO
					,DT_INV_SEQ[i] // INV_SEQ
			};
			IvdtData[i]    = tmpIvdt;
			
			String tmpPodt[] = {
					info.getSession("ID") // CHANGE_USER_ID
					,info.getSession("HOUSE_CODE") // HOUSE_CODE
					,info.getSession("HOUSE_CODE") // HOUSE_CODE
					,inv_no // INV_NO
					,DT_INV_SEQ[i] // INV_SEQ
			};
			PodtData[i]    = tmpPodt;
		}
		//Logger.debug.println(info.getSession("ID"), this, "여기1");
		
		//최종검수요청건인데 반려일 경우 수행평가정보를 삭제해야한다.
		Object[] obj = {inv_no, IvhdData, IvdtData, PodtData, paramMap};
		SepoaOut value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "setApproval", obj);

		String[] res = new String[2];
		res[0] = value.message;
		res[1] = String.valueOf(value.status);

		ws.setUserObject(res);
		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();

		/*반려 일 경우 업체로 email*/
/*		if(value.status == 1 && "R".equals(sign_status)) {
			sendMail(info, inv_no);
		}*/
		
		//검수완료 sms 발송.
		if(value.status == 1) {
			try{
				String[] args = {inv_no};
				Object[] sms_args = {args};
				
				ServiceConnector.doService(info, "SMS", "TRANSACTION", "S00010_1", sms_args);
			} catch (Exception e) {
				Logger.debug.println("mail error = " + e.getMessage());
				
			}	
		}
	}


	public void charge_transfer(SepoaStream ws) throws Exception {

		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		//SepoaTable로부터 upload된 data을 formatting하여 얻는다.
    	SepoaFormater wf = ws.getSepoaFormater();
		String[] inv_no     = wf.getValue("INV_NO");
	    String Transfer_person_id	= ws.getParam("Transfer_person_id");

	    Logger.debug.println(info.getSession("ID"), this, "   inv_no.length  === > " + inv_no.length);
		Object[] obj = {Transfer_person_id, inv_no };
		SepoaOut value = ServiceConnector.doService(info, "p2050", "TRANSACTION", "charge_transfer", obj);

		String[] res = new String[1];
		res[0] = value.message;

		ws.setUserObject(res);
		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();
	}

	public void sendMail(SepoaInfo info, String inv_no) throws Exception {
		try{
			Object[] sms_args = {inv_no};
	        String mail_type = "";

	        mail_type 	= "M00012";

	        if(!"".equals(mail_type)){
	        	ServiceConnector.doService(info, "mail", "CONNECTION", mail_type, sms_args);
	        }
		}catch(Exception e){
			Logger.debug.println();
		}

	}

}
