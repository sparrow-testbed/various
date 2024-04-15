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

public class po_list extends HttpServlet {
	
public void init(ServletConfig config) throws ServletException {
	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	// �몄뀡 Object
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

       		if ("getPoList".equals(mode))
       		{	
       			gdRes = getPoList(gdReq, info);		//議고쉶
       		}
       		else if ("getPoDetailLine".equals(mode))
       		{	
       			gdRes = getPoDetailLine(gdReq, info);		//��젣
       		}
       		/*
       		else if (mode.equals("doInsert")){
       			gdRes = doInsert(gdReq, info);
       		}
       		else if (mode.equals("doAddRow"))
       		{	
       			gdRes = doAddRow(gdReq, info);		//諛섎젮�ъ슜
       		}
       		else if (mode.equals("doQuery_DM"))
       		{	
       			gdRes = doQuery_DM(gdReq, info);		//諛섎젮�ъ슜
       		}*/
       		
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
    
    
	public GridData getPoList (GridData gdReq, SepoaInfo info) throws Exception {
   	    GridData gdRes   		= new GridData();
   	    Vector multilang_id 	= new Vector();
   	    multilang_id.addElement("MESSAGE");
   	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
   	
   		try {
   			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//洹몃━���곗씠��
   			
   			
   			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
   			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
   			
   			gdRes = OperateGridData.cloneResponseGridData(gdReq);
   			gdRes.addParam("mode", "getPoList");
   			
   			Object[] obj = {data};
   			// DB �곌껐諛⑸쾿 : CONNECTION, TRANSACTION, NONDBJOB
   			SepoaOut value = ServiceConnector.doService(info, "PO_002", "CONNECTION", "getPoList", obj);
   			
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
   			    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SEL")) {
   			    		gdRes.addValue("SEL", "0");
   			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
       	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
       	            	
   			    	} 
   			    	
                   	else {
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
	
	public GridData getPoDetailLine (GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
		Vector multilang_id 	= new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
		
		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//洹몃━���곗씠��
			
			
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "getPoList");
			
			Object[] obj = {data};
			// DB �곌껐諛⑸쾿 : CONNECTION, TRANSACTION, NONDBJOB
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
					if(grid_col_ary[k] != null && grid_col_ary[k].equals("SEL")) {
						gdRes.addValue("SEL", "0");
					} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("PO_CREATE_DATE")) {
						gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
						
					} 
					
					else {
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
   	

	/*public void doQuery(SepoaStream ws) throws Exception {

		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		String mode               = ws.getParam("mode");

		String po_from_date      	= ws.getParam("po_from_date"		);
		String po_to_date        	= ws.getParam("po_to_date"			);
		String po_no          		= ws.getParam("po_no"				);
		String vendor_code      	= ws.getParam("vendor_code"	    	);
		String vendor_name_loc      = ws.getParam("vendor_name_loc"		);
		String class_grade      	= ws.getParam("class_grade"	    	);
		String ctrl_person_id 		= ws.getParam("ctrl_person_id"		);
		String confirm_flag 		= ws.getParam("confirm_flag"		);
		String complete_mark    	= ws.getParam("complete_mark"   	);
		String po_status 			= ws.getParam("po_status"			);
		String material_type    	= ws.getParam("material_type"   	);
		String material_ctrl_type   = ws.getParam("material_ctrl_type"	);
		String material_class1    	= ws.getParam("material_class1"   	);
		String cont_from_date    	= ws.getParam("cont_from_date"   	);
		String cont_to_date    		= ws.getParam("cont_to_date"   		);
		String cont_seq    			= ws.getParam("cont_seq"   			);
		String cont_sign_from_date  = ws.getParam("cont_sign_from_date"	);
		String cont_sign_to_date    = ws.getParam("cont_sign_to_date"	);
		String cont_title    		= ws.getParam("cont_title"   		);
		String cont_status    		= ws.getParam("cont_status"   		);
		String cust_code    		= ws.getParam("cust_code"   		);
		String sales_dept    		= ws.getParam("sales_dept"   		);
		String req_dept    			= ws.getParam("req_dept"   			);

		String wbs_name    			= ws.getParam("wbs_name"   		);
		String po_name    			= ws.getParam("po_name"   		);
		String ct_name    			= ws.getParam("ct_name"   		);
		String maker_name    		= ws.getParam("maker_name"   	);
		String ctrl_code_session	= ws.getParam("ctrl_code"   	);
		StringTokenizer st = new StringTokenizer(ctrl_code_session, "&");
		String ctrl_code = "";
		int cnt = 0;
		while (st.hasMoreElements()) {
			if (cnt == 0) ctrl_code  = st.nextToken();
			else		  ctrl_code += ",'" + st.nextToken();
			cnt++;
		}

		String[] args = {
				 		  cont_seq
				 		 ,cont_title
				 		 ,cont_from_date
				 		 ,cont_to_date
				 		 ,cont_from_date
				 		 ,cont_to_date
				 		 ,cont_sign_from_date
				 		 ,cont_sign_to_date

						 ,info.getSession("HOUSE_CODE")
						 ,po_from_date
						 ,po_to_date
						 ,po_no
						 ,vendor_code
						 ,vendor_name_loc
						 ,class_grade
						 ,ctrl_code
						 ,ctrl_person_id
						 ,cust_code
						 ,req_dept
						 ,sales_dept
						 ,material_type
						 ,material_ctrl_type
						 ,material_class1

						 ,wbs_name
						 ,po_name
						 ,ct_name
						 ,maker_name
						};

		Object[] obj = {args, po_status, confirm_flag, cont_status, complete_mark};
		SepoaOut value = ServiceConnector.doService(info, "p2013", "CONNECTION","getPoList",obj);
		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

		int iRowCount = wf.getRowCount();

		for(int i=0; i<iRowCount; i++)
		{
			String[] check = {"false", ""};

			String[] img_po_no       = {"", wf.getValue("PO_NO",i), wf.getValue("PO_NO",i)};
			String[] img_vendor_code = {"", wf.getValue("VENDOR_CODE",i), wf.getValue("VENDOR_CODE",i)};
			String[] img_vendor_name = {"", wf.getValue("VENDOR_NAME",i), wf.getValue("VENDOR_NAME",i)};
			String[] img_EXEC_NO = {"", wf.getValue("EXEC_NO",i), wf.getValue("EXEC_NO",i)};
			String[] img_eval_flag_desc = {""			, wf.getValue("EVAL_FLAG_DESC"	   ,i)	, wf.getValue("EVAL_FLAG_DESC"		,i)};

			//ws.addValue("SEL"				 , check                                    , "");
			ws.addValue("STATUS"			 , wf.getValue("STATUS"			     	, i), "");
			ws.addValue("CONFIRM_FLAG_TEXT"	 , wf.getValue("CONFIRM_FLAG_TEXT"	 	, i), "");
			ws.addValue("CONFIRM_FLAG"		 , wf.getValue("CONFIRM_FLAG"		 	, i), "");
			ws.addValue("SEND_FLAG"			 , wf.getValue("SEND_FLAG"			 	, i), "");
			ws.addValue("CUST_CODE"		 	 , wf.getValue("CUST_CODE"				, i), "");
			ws.addValue("CUST_NAME"		 	 , wf.getValue("CUST_NAME"				, i), "");
			ws.addValue("WBS_NO"		 	 , wf.getValue("WBS_NO"					, i), "");
			ws.addValue("WBS_NAME"		 	 , wf.getValue("WBS_NAME"				, i), "");
			//ws.addValue("PO_NO"				 , img_po_no								, "");
			ws.addValue("PO_CREATE_DATE"	 , wf.getValue("PO_CREATE_DATE"	     	, i), "");
			//ws.addValue("VENDOR_CODE"		 , img_vendor_code							, "");
			//ws.addValue("VENDOR_NAME"		 , img_vendor_name							, "");
			ws.addValue("CTRL_NAME"			 , wf.getValue("CTRL_NAME"			 	, i), "");
			ws.addValue("CTRL_CODE"			 , wf.getValue("CTRL_CODE"			 	, i), "");
			ws.addValue("PR_TYPE"			 , wf.getValue("PR_TYPE"			 	, i), "");
			ws.addValue("TAKE_USER_NAME"	 , wf.getValue("TAKE_USER_NAME"	     	, i), "");
			ws.addValue("CUR"				 , wf.getValue("CUR"				 	, i), "");
			ws.addValue("PO_TTL_AMT"		 , wf.getValue("PO_TTL_AMT"		     	, i), "");
			ws.addValue("COMPLETE_MARK_TEXT" , wf.getValue("COMPLETE_MARK_TEXT"  	, i), "");
			ws.addValue("COMPLETE_MARK"		 , wf.getValue("COMPLETE_MARK"		 	, i), "");
			ws.addValue("SIGN_STATUS"		 , wf.getValue("SIGN_STATUS"		 	, i), "");
			ws.addValue("SUBJECT"			 , wf.getValue("SUBJECT"			 	, i), "");
			ws.addValue("PAY_TERMS"	         , wf.getValue("PAY_TERMS"	         	, i), "");
			ws.addValue("ORDER_NO"		     , wf.getValue("ORDER_NO"		     	, i), "");
			ws.addValue("CTR_DATE"		     , wf.getValue("CTR_DATE"		     	, i), "");
			ws.addValue("TAKE_TEL"		     , wf.getValue("TAKE_TEL"		     	, i), "");
			ws.addValue("REMARK"		     , wf.getValue("REMARK"		         	, i), "");
			ws.addValue("CTR_NO"		     , wf.getValue("CTR_NO"		         	, i), "");
			//ws.addValue("EXEC_NO"			 , img_EXEC_NO, "");
			ws.addValue("SIGN_STATUS_TEXT"	 , wf.getValue("SIGN_STATUS_DESC"		, i), "");
			ws.addValue("PR_TYPE_TEXT"		 , wf.getValue("PR_TYPE_DESC"			, i), "");
			ws.addValue("DEL_FLAG"		 	 , wf.getValue("DEL_FLAG"				, i), "");
			ws.addValue("EXEC_NAME"		 	 , wf.getValue("EXEC_NAME"				, i), "");
			ws.addValue("REQ_DEPT"		 	 , wf.getValue("REQ_DEPT"				, i), "");
			ws.addValue("CONTRACT_FLAG"	  	 , wf.getValue("CONTRACT_FLAG"			, i), "");
			ws.addValue("CONT_SEQ"	 	 	 , wf.getValue("CONT_SEQ"				, i), "");
			ws.addValue("CONT_COUNT"	 	 , wf.getValue("CONT_COUNT"				, i), "");
			ws.addValue("PR_INFO"	 	 	 , wf.getValue("PR_INFO"				, i), "");
			ws.addValue("PR_NO"	 	 		 , wf.getValue("PR_NO"					, i), "");
			ws.addValue("PR_SEQ"	 	 	 , wf.getValue("PR_SEQ"					, i), "");
			ws.addValue("CLASS_GRADE"	 	 , wf.getValue("CLASS_GRADE"			, i), "");
			ws.addValue("GAP_SIGN_DATE"	 	 , wf.getValue("GAP_SIGN_DATE"			, i), "");
			ws.addValue("CONT_PERIOD"	 	 , wf.getValue("CONT_PERIOD"			, i), "");
			ws.addValue("CONT_TITLE"	 	 , wf.getValue("CONT_TITLE"				, i), "");
			ws.addValue("CONT_STATUS"	 	 , wf.getValue("CONT_STATUS"			, i), "");
			ws.addValue("TOTAL_AMT"	 	 	 , wf.getValue("TOTAL_AMT"				, i), "");
			ws.addValue("SALES_DEPT_NAME"	 , wf.getValue("SALES_DEPT_NAME"		, i), "");
			ws.addValue("REQ_DEPT_NAME"	 	 , wf.getValue("REQ_DEPT_NAME"			, i), "");
			ws.addValue("END_REMARK"	 	 , wf.getValue("END_REMARK"				, i), "");
			ws.addValue("REJECT_REMARK"	 	 , wf.getValue("REJECT_REMARK"			, i), "");
			ws.addValue("PO_TYPE"		 	 , wf.getValue("PO_TYPE"				, i), "");
			ws.addValue("PO_TYPE_TEXT"	 	 , wf.getValue("PO_TYPE_TEXT"			, i), "");
			//ws.addValue("EVAL_FLAG_DESC"	 , img_eval_flag_desc					, "");
			ws.addValue("EVAL_FLAG"			 , wf.getValue("EVAL_FLAG"			, i), "");
			ws.addValue("EVAL_REFITEM"	 	 , wf.getValue("EVAL_REFITEM"			, i), "");
			ws.addValue("EVAL_ITEM_REFITEM"	  , wf.getValue("EVAL_ITEM_REFITEM"			, i), "");
			ws.addValue("EVAL_VALUER_REFITEM" , wf.getValue("EVAL_VALUER_REFITEM"			, i), "");
			ws.addValue("E_TEMPLATE_REFITEM" , wf.getValue("E_TEMPLATE_REFITEM"			, i), "");
			ws.addValue("TEMPLATE_TYPE" 	, wf.getValue("TEMPLATE_TYPE"			, i), "");
			ws.addValue("STOP_FLAG" 	, wf.getValue("STOP_FLAG"			, i), "");
		}

		ws.setCode(String.valueOf(value.status));
		ws.setMessage(value.message);

		ws.write();
	}*/

	/*public void doData(SepoaStream ws) throws Exception {

		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		SepoaFormater wf = ws.getSepoaFormater();
		String mode               = ws.getParam("mode");

		String PO_NO[]            = wf.getValue("PO_NO");
		if(mode.equals("setPoDelete")) {
			String delPOno            = "";

			String setPoData[][]    = new String[wf.getRowCount()][];

			for (int i = 0; i<wf.getRowCount(); i++) {
				String poData[] = {
									 SepoaDate.getShortDateString()
									,SepoaDate.getShortTimeString()
									,info.getSession("ID")
									,info.getSession("HOUSE_CODE")
									,PO_NO[i]
								  };
				setPoData[i] = poData;

	            if( wf.getRowCount() > 1 )
	            {
	                if( i == 0 ) delPOno = "[ "+ PO_NO[i]+", ";
	                else if ( i == (wf.getRowCount()-1) )
	                    delPOno += PO_NO[i]+" ] ";
	                else
	                    delPOno += PO_NO[i]+", ";
	            }
	            else
	                delPOno = "[ "+ PO_NO[i]+" ] ";
			}

			Object[] obj = {setPoData, delPOno};

			SepoaOut value = ServiceConnector.doService(info, "p2013", "TRANSACTION", "setPoDelete", obj);

			String[] res = new String[1];
			res[0] = value.message;

			ws.setUserObject(res);
			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
		} else if(mode.equals("setPoCompleteMark")) {
			String delPOno            = "";
			String setPohdData[][]    = new String[wf.getRowCount()][];
			String setPodtData[][]    = new String[wf.getRowCount()][];

			for (int i = 0; i<wf.getRowCount(); i++) {
				String pohdData[] = {
									 SepoaDate.getShortDateString()
									,SepoaDate.getShortTimeString()
									,info.getSession("ID")
									,info.getSession("HOUSE_CODE")
									,PO_NO[i]
								  };
				setPohdData[i] = pohdData;

				String podtData[] = {
									 SepoaDate.getShortDateString()
									,SepoaDate.getShortTimeString()
									,info.getSession("ID")
									,info.getSession("HOUSE_CODE")
									,PO_NO[i]
								  };
				setPodtData[i] = podtData;

	            if( wf.getRowCount() > 1 )
	            {
	                if( i == 0 ) delPOno = "[ "+ PO_NO[i]+", ";
	                else if ( i == (wf.getRowCount()-1) )
	                    delPOno += PO_NO[i]+" ] ";
	                else
	                    delPOno += PO_NO[i]+", ";
	            }
	            else
	                delPOno = "[ "+ PO_NO[i]+" ] ";
			}

			Object[] obj = {setPohdData, setPodtData, delPOno};
			SepoaOut value = ServiceConnector.doService(info, "p2013", "TRANSACTION", "setPoCompleteMark", obj);

			String[] res = new String[1];
			res[0] = value.message;

			ws.setUserObject(res);
			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
		}


		ws.write();
	}*/
}
