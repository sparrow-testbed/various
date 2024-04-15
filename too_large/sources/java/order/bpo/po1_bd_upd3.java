package order.bpo;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class po1_bd_upd3 extends SepoaServlet
{

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

       		if ("doQuery".equals(mode))
       		{	
       			gdRes = doQuery(gdReq, info);		//議고쉶
       		}
       			       		
       		else if ("doData".equals(mode)){
       			gdRes = doData(gdReq, info);
       		}

       		else if ("setPoCancel".equals(mode)){
       			gdRes = setPoCancel(gdReq, info);
       		}
       		
       		else if ("setPoReturn".equals(mode)){
       			gdRes = setPoReturn(gdReq, info);
       		}
       		
       		else if("setExPoCancel".equals(mode)){
   				gdRes = setExPoCancel(gdReq, info);
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
	
    
    public GridData doQuery(GridData gdReq, SepoaInfo info) throws Exception {
		GridData gdRes   		= new GridData();
   	    Vector multilang_id 	= new Vector();
   	    multilang_id.addElement("MESSAGE");
   	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
   	    try{
   	    	Map<String,String> header=null;
	   	    Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//洹몃━���곗씠��
			
			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");
			header = (Map<String, String>) data.get("headerData");
			String po_no           =header.get("PO_NO");// ws.getParam("po_no");
			/*String combo 			 = ws.getParam("combo");*/
			String HOUSE_CODE 		= info.getSession("HOUSE_CODE");
	        Object[] obj = {po_no};
	
			SepoaOut value = ServiceConnector.doService(info, "p2090", "CONNECTION","getPOUPDDetail",obj);
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			if(value.flag) {
				    gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				    gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			    return gdRes;
			}
			
			for (int i = 0; i < wf.getRowCount(); i++) {
   				for(int k=0; k < grid_col_ary.length; k++) {
   			    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SEL")) {
   			    		gdRes.addValue("SEL", "1");
   			    	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("change_date")) {
       	            	gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
       	            	
   			    	} else {
   			        	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
   			        }
   			    	
   			    	
   				}
   			}
			
			/*StringTokenizer st = new StringTokenizer(combo,"#");
	
	
	
			int count = st.countTokens();
	
			String[][] d_combo = new String[count][2];
			for(int i = 0; i < count ; i++){
				StringTokenizer temp_st = new StringTokenizer(st.nextToken(),"&");
	
				d_combo[i][0] = temp_st.nextToken();
				d_combo[i][1] = temp_st.nextToken();
	
			}
	*/
			
	
			/*int iRowCount = wf.getRowCount();
	
			String strArr[][] = {{"유지","Y"},{"미유지","N"}};
	
			int	IDX_DELY_TO_LOCATION	= ws.getColumnIndex("DELY_TO_LOCATION");
	
			for(int i=0; i<iRowCount; i++)
			{
				String[] check 		= {"false", ""};
				String[] hd_check 	= {"true", ""};
	
				//String[] img_invest_no       	= {"", wf.getValue("INVEST_NO",i), wf.getValue("INVEST_NO",i)};
	
				String[] img_item_no     = {"", wf.getValue("ITEM_NO",i), wf.getValue("ITEM_NO",i)};
				//String[] img_pr_no       = {"", wf.getValue("PR_NO",i), wf.getValue("PR_NO",i)};
				String[] img_description_loc     = {"", wf.getValue("DESCRIPTION_LOC",i), wf.getValue("DESCRIPTION_LOC",i)};
				String[] img_exec_no     = {"", wf.getValue("EXEC_NO",i), wf.getValue("EXEC_NO",i)};
				ws.addValue("HD_SEL"			, hd_check                              	, "");
				ws.addValue("SEL"				, check                                  , "");
				ws.addValue("CUD_FG"			, wf.getValue("CUD_FG"				, i), "");
				ws.addValue("ITEM_NO"			, img_item_no, "");
				ws.addValue("MATERIAL_TYPE"		, wf.getValue("MATERIAL_TYPE"		, i), "");
				ws.addValue("DESCRIPTION_LOC"	, img_description_loc					, "");
				ws.addValue("RD_DATE"			, wf.getValue("RD_DATE"			    , i), "");
				ws.addValue("UNIT_MEASURE"		, wf.getValue("UNIT_MEASURE"		, i), "");
				//ws.addValue("CONTRACT_DIV"		, wf.getValue("CONTRACT_DIV"			, i), "");
	
				ws.addValue("CONTRACT_REMAIN"   	    	, strArr, "", 0);
	
				//ws.addValue("CONTRACT_REMAIN"	, ""								, "");
				ws.addValue("PO_QTY"			, wf.getValue("ITEM_QTY"			, i), "");
				ws.addValue("OLD_PO_QTY"			, wf.getValue("OLD_ITEM_QTY"			, i), "");
				ws.addValue("CHK_QTY"			, wf.getValue("CHK_QTY"			, i), "");
				ws.addValue("UNIT_PRICE"		, wf.getValue("UNIT_PRICE"		    , i), "");
				ws.addValue("ITEM_AMT"			, wf.getValue("ITEM_AMT"			, i), "");
				ws.addValue("HD_ITEM_AMT"		, wf.getValue("ITEM_AMT"			, i), "");
				ws.addValue("PR_UNIT_PRICE"		, wf.getValue("PR_UNIT_PRICE"		, i), "");
				ws.addValue("PR_AMT"			, wf.getValue("PR_AMT"			    , i), "");
	            ws.addValue("DOWN_AMT"			, wf.getValue("DOWN_AMT"			, i), "");
				ws.addValue("PR_NO"				, wf.getValue("PR_NO"				, i), "");
				ws.addValue("CUST_CODE"			, wf.getValue("CUST_CODE"			, i), "");
				ws.addValue("CUST_NAME"			, wf.getValue("CUST_NAME"			, i), "");
				ws.addValue("CUR"				, wf.getValue("CUR"				    , i), "");
				ws.addValue("EXCHANGE_RATE"		, wf.getValue("EXCHANGE_RATE"		, i), "");
				ws.addValue("EXEC_AMT_KRW"		, wf.getValue("ITEM_AMT_KRW"		, i), "");
				ws.addValue("SPACE"				, ""									, "");
	
	
				ws.addValue("CTRL_CODE"			, wf.getValue("CTRL_CODE"			, i), "");
				ws.addValue("QTA_NO"			, wf.getValue("QTA_NO"			    , i), "");
				ws.addValue("QTA_SEQ"			, wf.getValue("QTA_SEQ"	            , i), "");
				ws.addValue("PR_SEQ"			, wf.getValue("PR_SEQ"	            , i), "");
				ws.addValue("EXEC_NO"			, img_exec_no							, "");
				ws.addValue("EXEC_SEQ"			, wf.getValue("EXEC_SEQ"            , i), "");
				ws.addValue("CUSTOMER_PRICE"	, wf.getValue("CUSTOMER_PRICE"      , i), "");
				ws.addValue("DISCOUNT"			, wf.getValue("DISCOUNT"		    , i), "");
				ws.addValue("TECHNIQUE_GRADE"   , wf.getValue("TECHNIQUE_GRADE"     , i), "");
				ws.addValue("INPUT_FROM_DATE"	, wf.getValue("INPUT_FROM_DATE"	    , i), "");
				ws.addValue("INPUT_TO_DATE"		, wf.getValue("INPUT_TO_DATE"	    , i), "");
				ws.addValue("PR_USER_ID"		, wf.getValue("PR_USER_ID"			, i), "");
				ws.addValue("PR_DEPT"			, wf.getValue("PR_DEPT"				, i), "");
				ws.addValue("MAKER_CODE"		, wf.getValue("MAKER_CODE"			, i), "");
				ws.addValue("MAKER_NAME"		, wf.getValue("MAKER_NAME"			, i), "");
				ws.addValue("SPECIFICATION"		, wf.getValue("SPECIFICATION"		, i), "");
				ws.addValue("DELY_TO_ADDRESS"	, wf.getValue("DELY_TO_ADDRESS"		, i), "");
	  			ws.addValue("PO_NO"				, wf.getValue("PO_NO"			    , i), "");
				ws.addValue("PO_SEQ"			, wf.getValue("PO_SEQ"	            , i), "");
	
				ws.addValue("ORDER_NO"			, wf.getValue("ORDER_NO"			, i), "");
				ws.addValue("ORDER_SEQ"			, wf.getValue("ORDER_SEQ"			, i), "");
				ws.addValue("ORDER_COUNT"		, wf.getValue("ORDER_COUNT"			, i), "");
	
				ws.addValue("WBS_NO"			, wf.getValue("WBS_NO"				, i), "");
				ws.addValue("WBS_SUB_NO"		, wf.getValue("WBS_SUB_NO"			, i), "");
				ws.addValue("WBS_TXT"			, wf.getValue("WBS_TXT"				, i), "");
				ws.addValue("WBS_NAME"			, wf.getValue("WBS_NAME"			, i), "");
				ws.addValue("WARRANTY"			, wf.getValue("WARRANTY"			, i), "");
	
				String code1 = wf.getValue( "DELY_TO_LOCATION" 	, i);
				//콤보용 addValue
				ws.addValue(IDX_DELY_TO_LOCATION,  d_combo, "DELY_TO_LOCATION"  , getIndex(code1, d_combo));
	
	
			}
			
			ws.setCode(String.valueOf(value.status));
			ws.setMessage(value.message);
			ws.write();*/
   	    }catch (Exception e) {
		    gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
	    }
		return gdRes;	
			
	}

	private int getIndex(String code,String[][] payTerms_c){
		int vSize = payTerms_c.length;
		int index = 0;
		for(int i = 0 ; i < vSize ; i++ ){
			if(payTerms_c[i][1].equals(code))
				index = i ;
		}
		return index;
	}

//	public void doData(GridData gdReq, SepoaInfo info) throws Exception {
//
//		//SepoaTable로부터 upload된 data을 formatting하여 얻는다.
//    	SepoaFormater wf = gdReq.getSepoaFormater();
//
//    	Logger.sys.println("");
//    	Logger.sys.println("[Log Print]-------------------------------------------------------");
//
//
//    	String PR_USER_ID			=	ws.getParam("PR_USER_ID"		)	;
//    	String PR_USER_NAME			=	ws.getParam("PR_USER_NAME"		)	;
//    	String VENDOR_CODE			=	ws.getParam("VENDOR_CODE"		)	;
//    	String VENDOR_NAME			=	ws.getParam("VENDOR_NAME"		)	;
//    	String CTRL_CODE			=	ws.getParam("CTRL_CODE"			)	;
//
//    	String CUD_FG[] 			= 	wf.getValue("CUD_FG"			)	;
//    	String PO_NO[] 				= 	wf.getValue("PO_NO"				)	;
//    	String PO_SEQ[] 			= 	wf.getValue("PO_SEQ"			)	;
//    	String PR_NO[] 				= 	wf.getValue("PR_NO"				)	;
//    	String PR_SEQ[] 			= 	wf.getValue("PR_SEQ"			)	;
//    	String MATERIAL_TYPE[] 		= 	wf.getValue("MATERIAL_TYPE"		)	;
//    	String DELY_TO_ADDRESS[] 	= 	wf.getValue("DELY_TO_ADDRESS"	)	;
//    	String WARRANTY[] 			= 	wf.getValue("WARRANTY"			)	;
//    	String ITEM_NO[] 			= 	wf.getValue("ITEM_NO"			)	;
//    	String DESCRIPTION_LOC[] 	= 	wf.getValue("DESCRIPTION_LOC"	)	;
//    	String MAKER_CODE[] 		= 	wf.getValue("MAKER_CODE"		)	;
//    	String MAKER_NAME[] 		= 	wf.getValue("MAKER_NAME"		)	;
//    	String SPECIFICATION[] 		= 	wf.getValue("SPECIFICATION"		)	;
//    	String PO_QTY[] 			= 	wf.getValue("PO_QTY"			)	;
//    	String OLD_PO_QTY[] 		= 	wf.getValue("OLD_PO_QTY"		)	;
//    	String UNIT_MEASURE[] 		= 	wf.getValue("UNIT_MEASURE"		)	;
//    	String CUR[] 				= 	wf.getValue("CUR"				)	;
//    	String EXCHANGE_RATE[] 		= 	wf.getValue("EXCHANGE_RATE"		)	;
//    	String UNIT_PRICE[] 		= 	wf.getValue("UNIT_PRICE"		)	;
//    	String ITEM_AMT[] 			= 	wf.getValue("ITEM_AMT"			)	;
//    	String PR_AMT[] 			= 	wf.getValue("PR_AMT"			)	;
//    	String WBS_NO[] 			= 	wf.getValue("WBS_NO"			)	;
//    	String WBS_NAME[] 			= 	wf.getValue("WBS_NAME"			)	;
//    	String RD_DATE[] 			= 	wf.getValue("RD_DATE"			)	;
//    	String ORDER_NO[] 			= 	wf.getValue("ORDER_NO"			)	;
//    	String ORDER_COUNT[] 		= 	wf.getValue("ORDER_COUNT"		)	;
//    	String ORDER_SEQ[] 			= 	wf.getValue("ORDER_SEQ"			)	;
//    	String CONTRACT_REMAIN[] 	= 	wf.getValue("CONTRACT_REMAIN"	)	;
//
//    	String po_no			=	ws.getParam("po_no"			)	;
//    	String end_remark			=	ws.getParam("end_remark"			)	;
//
//    	Object params[] = 	{
//    							PR_USER_ID		,	PR_USER_NAME	,	VENDOR_CODE		,	VENDOR_NAME		,	CTRL_CODE		,
//    							CUD_FG			,	PR_NO			,	PR_SEQ			,	PO_NO			,	PO_SEQ			,
//    							MATERIAL_TYPE	,
//    							DELY_TO_ADDRESS	,	WARRANTY		,	ITEM_NO			,	DESCRIPTION_LOC	,
//    							MAKER_CODE		,	MAKER_NAME		,	SPECIFICATION	,	PO_QTY			,	OLD_PO_QTY		,
//    							UNIT_MEASURE	,	CUR				,	EXCHANGE_RATE	,	UNIT_PRICE		,	ITEM_AMT		,
//    							PR_AMT			,	WBS_NO			,	WBS_NAME		,	RD_DATE			,
//    							ORDER_NO		,	ORDER_COUNT		,	ORDER_SEQ		,	CONTRACT_REMAIN
//    						}	;
//
//    	SepoaOut value = ServiceConnector.doService(info, "p2090", "TRANSACTION", "setPoIngStop", new Object[]{po_no, end_remark}		);
//
//		String[] res = new String[1];
//		res[0] = value.message;
//
//		ws.setUserObject(res);
//		ws.setCode(String.valueOf(value.status));
//		ws.setMessage(value.message);
//
//		ws.write();
//
//    	
//	}
	
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doData(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);
    	Map<String, String> header = null;

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		header = (Map<String, String>) data.get("headerData");

    		Object[] obj = {header.get("PO_NO"),header.get("END_REMARK") };
    		
    		value = ServiceConnector.doService(info, "p2090", "TRANSACTION", "setPoIngStop",obj);
    		
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

	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setPoCancel(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);
    	Map<String, String> header = null;

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		header = (Map<String, String>) data.get("headerData");

    		Object[] obj = {header.get("hid_pr_no"),header.get("hid_pr_seq"),header.get("hid_exec_no"),header.get("hid_po_no")};

    		value = ServiceConnector.doService(info, "p2090", "TRANSACTION", "setPoCancel",obj);
    		
    		if(value.flag) {
    			//gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
    			gdRes.setMessage(value.message);
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setPoReturn(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);
    	Map<String, String> header = null;

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		header = (Map<String, String>) data.get("headerData");

    		Object[] obj = {header.get("hid_po_no")};

    		value = ServiceConnector.doService(info, "p2090", "TRANSACTION", "setPoReturn",obj);
    		
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setExPoCancel(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> data        = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);
    	Map<String, String> header = null;

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		data = SepoaDataMapper.getData(info, gdReq);
    		
    		header = (Map<String, String>) data.get("headerData");

    		Object[] obj = {header.get("hid_pr_no"),header.get("hid_pr_seq"),header.get("hid_exec_no"),header.get("hid_po_no")};

    		value = ServiceConnector.doService(info, "p2090", "TRANSACTION", "setExPoCancel",obj);
    		
    		if(value.flag) {
    			//gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
    			gdRes.setMessage(value.message);
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
