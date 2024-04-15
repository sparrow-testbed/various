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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class po_detail extends HttpServlet {
	
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
       		if ("getPoDetail".equals(mode))
       		{	
       			gdRes = getPoDetail(gdReq, info);		//조회
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

	public GridData getPoDetail(GridData gdReq, SepoaInfo info) throws Exception {
		 GridData gdRes   		= new GridData();
		 Vector multilang_id 	= new Vector();
		 multilang_id.addElement("MESSAGE");
		 HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		 
		 try {
				Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//그리드 데이터
				
				String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
				String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
				
				gdRes = OperateGridData.cloneResponseGridData(gdReq);
				gdRes.addParam("mode", "doQuery");
				
				Object[] obj = {data};
				// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
				SepoaOut value = ServiceConnector.doService(info, "PO_002", "CONNECTION", "getPoDetailLine", obj);
				
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
					    if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_QTY")) {
	    	            	gdRes.addValue(grid_col_ary[k], wf.getValue("ITEM_QTY", i));
					    }else if(grid_col_ary[k] != null && grid_col_ary[k].equals("RD_DATE")) {
	    	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue("RD_DATE", i)));
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
		
/*		
        Object[] obj = {
        				from_date  		    
		              , to_date    		    
		              , po_no 			    
		              , item_no 		    
		              , vendor_code 	    
		              , ctrl_person_id
		              , dept   	    
		              , complete_mark 
		              , order_no	
		              , cust_name
		              , wbs_name
		              , po_name
		              , ct_name
		              , maker_name
		              , req_dept
		              };

		SepoaOut value = ServiceConnector.doService(info, "p2014", "CONNECTION","getPoStatusSelect_B",obj);
		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

		int iRowCount = wf.getRowCount();

		for(int i=0; i<iRowCount; i++)
		{
			String[] check = {"false", ""};
			String[] img_po_no       = {"", wf.getValue("PO_NO",i), wf.getValue("PO_NO",i)};
			String[] img_item_no     = {"", wf.getValue("ITEM_NO",i), wf.getValue("ITEM_NO",i)};
			String[] img_vendor_code = {"", wf.getValue("VENDOR_CODE",i), wf.getValue("VENDOR_CODE",i)};
			String[] img_vendor_name = {"", wf.getValue("VENDOR_NAME",i), wf.getValue("VENDOR_NAME",i)};
			String[] img_description_loc = {"", wf.getValue("DESCRIPTION_LOC",i), wf.getValue("DESCRIPTION_LOC",i)};
			String[] img_pr_no       = {"", wf.getValue("PR_NO",i), wf.getValue("PR_NO",i)};
			String[] img_exec_no     = {"", wf.getValue("EXEC_NO",i), wf.getValue("EXEC_NO",i)};
			
			String qta_no = wf.getValue("QTA_NO",i);
			
			if(!"".equals(qta_no)){
				if(!qta_no.substring(0, 2).equals("QT")){
					 qta_no = "";
				}
			}
			
			String[] img_qta_no      = {"", qta_no, qta_no};
			
			String[] img_order_no      = {"", wf.getValue("ORDER_NO",i), wf.getValue("ORDER_NO",i)};
//			ws.addValue("SEL"						, check											, "");
//			ws.addValue("PO_NO"					    , img_po_no										, "");
//			ws.addValue("ITEM_NO"					, img_item_no									, "");
			ws.addValue("DESCRIPTION_LOC"			, wf.getValue("DESCRIPTION_LOC"    			, i), "");
			ws.addValue("SPECIFICATION"     		, wf.getValue("SPECIFICATION"    			, i), "");
			ws.addValue("MAKER_NAME"       			, wf.getValue("MAKER_NAME"     				, i), "");
			ws.addValue("MAKER_CODE"       			, wf.getValue("MAKER_CODE"     				, i), "");  
			ws.addValue("PO_CREATE_DATE"			, wf.getValue("PO_CREATE_DATE"			    , i), "");
			ws.addValue("CHANGE_USER_NAME_LOC"	    , wf.getValue("CHANGE_USER_NAME_LOC"	    , i), "");
			ws.addValue("RD_DATE"					, wf.getValue("RD_DATE"					    , i), "");
			ws.addValue("CUR"						, wf.getValue("CUR"						    , i), "");
			ws.addValue("UNIT_PRICE"				, wf.getValue("UNIT_PRICE"				    , i), "");
			ws.addValue("ITEM_AMT"				    , wf.getValue("ITEM_AMT"				    , i), "");
			ws.addValue("CUSTOMER_PRICE"			, wf.getValue("CUSTOMER_PRICE"			    , i), "");
			ws.addValue("S_ITEM_AMT"				, wf.getValue("S_ITEM_AMT"				    , i), "");
			ws.addValue("DISCOUNT"				    , wf.getValue("DISCOUNT"				    , i), "");
			ws.addValue("UNIT_MEASURE"			    , wf.getValue("UNIT_MEASURE"			    , i), "");
			ws.addValue("ITEM_QTY"				    , wf.getValue("ITEM_QTY"				    , i), "");
			ws.addValue("GR_QTY"				    , wf.getValue("GR_QTY"					    , i), "");
//			ws.addValue("VENDOR_CODE"				, img_vendor_code								, "");
//			ws.addValue("VENDOR_NAME"				, img_vendor_name								, "");
//			ws.addValue("PR_NO"					    , img_pr_no										, "");
			ws.addValue("PR_PRICE"				    , wf.getValue("PR_PRICE"				    , i), "");
			ws.addValue("PR_AMT"					, wf.getValue("PR_AMT"					    , i), "");
			ws.addValue("PR_TYPE"					, wf.getValue("PR_TYPE"					    , i), "");
			ws.addValue("COMPLETE_MARK"			    , wf.getValue("COMPLETE_MARK"			    , i), "");
			ws.addValue("SUBJECT"			    	, wf.getValue("SUBJECT"			    		, i), "");
//			ws.addValue("ORDER_NO"			    	, img_order_no									, "");
//			ws.addValue("QTA_NO"			    	, img_qta_no									, "");
//			ws.addValue("EXEC_NO"			    	, img_exec_no									, "");

			ws.addValue("WBS_NO"		 	 		, wf.getValue("WBS_NO"					, i), ""); 
			ws.addValue("WBS_NAME"		 	 		, wf.getValue("WBS_NAME"				, i), ""); 
			ws.addValue("EXEC_NAME"		 			, wf.getValue("EXEC_NAME"				, i), ""); 
			ws.addValue("CUST_CODE"		 	 		, wf.getValue("CUST_CODE"				, i), ""); 
			ws.addValue("CUST_NAME"		 	 		, wf.getValue("CUST_NAME"				, i), ""); 
			ws.addValue("REQ_DEPT"		 	 		, wf.getValue("REQ_DEPT"				, i), ""); 
			ws.addValue("CONTRACT_FLAG"		 	 	, wf.getValue("CONTRACT_FLAG"				, i), ""); 
			ws.addValue("CONT_SEQ"		 	 		, wf.getValue("CONT_SEQ"				, i), ""); 
			ws.addValue("CONT_COUNT"		 	 	, wf.getValue("CONT_COUNT"				, i), ""); 
			ws.addValue("CTRL_CODE"			 	 	, wf.getValue("CTRL_CODE"				, i), ""); 
			ws.addValue("CTRL_NAME"			 	 	, wf.getValue("CTRL_NAME"				, i), ""); 
		}                                            

		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);
		ws.write();*/
	}

	public void doData(SepoaStream ws) throws Exception {

		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		SepoaFormater wf = ws.getSepoaFormater();
		String mode               = ws.getParam("mode");

		String PO_NO[]            = wf.getValue("PO_NO");
		String PO_SEQ[]           = wf.getValue("PO_SEQ");

		if("setPoClose".equals(mode)) {

			String setPoData[][]    = new String[wf.getRowCount()][];

			for (int i = 0; i<wf.getRowCount(); i++) {
				String poData[] = {
									 SepoaDate.getShortDateString()
									,SepoaDate.getShortTimeString()
									,info.getSession("ID")
									,info.getSession("HOUSE_CODE")
									,PO_NO[i]
									,PO_SEQ[i]
								  };
				setPoData[i] = poData;
			}

			Object[] obj = {setPoData};
			SepoaOut value = ServiceConnector.doService(info, "p2014", "TRANSACTION", "setPoClose", obj);

			String[] res = new String[1];
			res[0] = value.message;

			ws.setUserObject(res);
			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
		}
		else if("setPoUpdate_DO".equals(mode)) {

			String DO_FLAG[]          		= wf.getValue("DO_FLAG");
			String Z_WORK_STAGE_FLAG[]      = wf.getValue("Z_WORK_STAGE_FLAG");
			String Z_DELIVERY_CONFIRM_FLAG[]= wf.getValue("Z_DELIVERY_CONFIRM_FLAG");

			String setPoData[][]    = new String[wf.getRowCount()][];

			for (int i = 0; i<wf.getRowCount(); i++) {
				String poData[] = {
									 DO_FLAG[i]
									,Z_WORK_STAGE_FLAG[i]
									,Z_DELIVERY_CONFIRM_FLAG[i]
									,info.getSession("HOUSE_CODE")
									,PO_NO[i]
									,PO_SEQ[i]
								  };
				setPoData[i] = poData;
			}

			Object[] obj = {setPoData};
			SepoaOut value = ServiceConnector.doService(info, "p2014", "TRANSACTION", "setPoUpdate_DO", obj);

			String[] res = new String[1];
			res[0] = value.message;

			ws.setUserObject(res);
			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
		}

		ws.write();
	}
}
