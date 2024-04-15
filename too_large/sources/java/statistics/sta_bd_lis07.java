package statistics;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
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
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class sta_bd_lis07  extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getStaProCustomerList".equals(mode)){			//고객별 구매현황
    			//gdRes = this.getStaProCustomerList(gdReq, info);
    			Logger.debug.println();
    		}else if("getStaProCustomerList2".equals(mode)){	 //품목별 구매현황
    			gdRes = this.getStaProCustomerList2(gdReq, info);
    		}
    		
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    		this.loggerExceptionStackTrace(e);
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
    			this.loggerExceptionStackTrace(e);
    		}
    	}
    }


    
    /**
     * 품목별 구매현황 
     * getStaProCustomerList2
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-11-24
     * @modify 2014-11-24
     */
	private GridData getStaProCustomerList2(GridData gdReq, SepoaInfo info) {
		
		GridData            gdRes            = new GridData();
	    SepoaOut            value            = null;
	    HashMap             message          = null;
	    String              gdResMessage     = null;
	    Object[]            obj              = null;
	    boolean             isStatus         = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	obj      = this.requestListHeader(gdReq, info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	value    = ServiceConnector.doService(info, "p7008", "CONNECTION", "getStaProCustomerList2", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		gdRes        = this.getPrProceedingListGdRes(gdReq, gdRes, value);
		    	gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch(Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
		
		/*WiseInfo info = WiseSession.getAllValue(ws.getRequest());
		
		String add_date_start   	= ws.getParam("add_date_start");  
		String add_date_end     	= ws.getParam("add_date_end");    
		String pr_proceeding_flag	= ws.getParam("pr_proceeding_flag");  		
		String MATERIAL_TYPE		= ws.getParam("MATERIAL_TYPE"); 	    
		String MATERIAL_CTRL_TYPE   = ws.getParam("MATERIAL_CTRL_TYPE");     
		String MATERIAL_CLASS1     	= ws.getParam("MATERIAL_CLASS1");     
		String cust_code      		= ws.getParam("cust_code");      
		String sales_dept      		= ws.getParam("sales_dept");    
		//String pr_user_session 		= ws.getParam("pr_user");		
		String req_dept     		= ws.getParam("req_dept");
		String req_user				= ws.getParam("req_user");
		String BID_DIV				= ws.getParam("BID_DIV");
		String purchaser_id			= ws.getParam("purchaser_id");
		
		String pr_user = "";
		//StringTokenizer st = new StringTokenizer(pr_user_session, "&");
		int cnt = 0;
		
		while (st.hasMoreTokens()) {
			if (cnt == 0) pr_user  = st.nextToken();
			else 		  pr_user += ",'" + st.nextToken();
			cnt++;
		}
		
		String[] args = {
				add_date_start   
				, add_date_end     
				, pr_proceeding_flag		 
				, MATERIAL_TYPE   		 
				, MATERIAL_CTRL_TYPE	   
				, MATERIAL_CLASS1      
				, cust_code    
				, sales_dept
				, pr_user
				, req_dept
				, req_user
				, purchaser_id
		};
		
		Object[] param = { args, BID_DIV};

		WiseOut value = ServiceConnector.doService(info, "p7008", "CONNECTION","prProceedingList", param);
	    WiseFormater wf = ws.getWiseFormater(value.result[0]);
	    
        if(wf.getRowCount() == 0)
        {
            ws.setMessage(msg.getMessage("0008")); //A¶E¸μE ³≫¿ªAI ¾ø½A´I´U.
            ws.write();

            return;
        }

        for(int i=0; i<wf.getRowCount(); i++){
        	
            String[] check = {"false", ""};
            String[] img_pr_no = {"", wf.getValue("PR_NO", i), wf.getValue("PR_NO", i)};//A≫±¸¹øE￡
            String[] img_item_no = {"", wf.getValue("ITEM_NO", i), wf.getValue("ITEM_NO", i)};
            String[] img_po_no = {"", wf.getValue("PO_NO", i), wf.getValue("PO_NO", i)};

            ws.addValue( "SELECTED"         		, check											, ""	);
            ws.addValue( "PR_PROCEEDING_FLAG"      	, wf.getValue("PR_PROCEEDING_FLAG"		, i)	, ""	);
            ws.addValue( "PR_PROCEEDING_FLAG_NAME" 	, wf.getValue("PR_PROCEEDING_FLAG_NAME"	, i)	, ""	);
            ws.addValue( "PR_NO"   		    		, img_pr_no										, ""	);
            ws.addValue( "PR_SEQ"   				, wf.getValue("PR_SEQ"					, i)	, ""	);
            ws.addValue( "SUBJECT"   	    		, wf.getValue("SUBJECT"					, i)	, ""	);   
            ws.addValue( "ADD_DATE"         		, wf.getValue("ADD_DATE"				, i)	, ""	);  
            ws.addValue( "REQ_DEPT"    				, wf.getValue("REQ_DEPT"				, i)	, ""	);          
            ws.addValue( "REQ_USER"    				, wf.getValue("REQ_USER"				, i)	, ""	);  
            ws.addValue( "CL_A"    					, wf.getValue("CL_A"					, i)	, ""	);  
            ws.addValue( "CL_B"    					, wf.getValue("CL_B"					, i)	, ""	);  
            ws.addValue( "CL_C"    					, wf.getValue("CL_C"					, i)	, ""	);  
            ws.addValue( "ITEM_NO"   	 			, img_item_no									, ""	);
			ws.addValue("DESCRIPTION_LOC"   		, wf.getValue("DESCRIPTION_LOC"         , i)	, ""	);  
			ws.addValue("MAKER_NAME"   				, wf.getValue("MAKER_NAME"         		, i)	, ""	);
			ws.addValue( "RD_DATE"          		, wf.getValue("RD_DATE"					, i)	, ""	);            
			ws.addValue( "UNIT_MEASURE" 			, wf.getValue("UNIT_MEASURE"			, i)	, ""	); 	     
            ws.addValue( "PR_QTY"     	    		, wf.getValue("PR_QTY"					, i)	, ""	);     	
            ws.addValue( "SHIPPER_TYPE"        	    , wf.getValue("SHIPPER_TYPE"			, i)	, ""	);       
            ws.addValue( "UNIT_PRICE"       		, wf.getValue("UNIT_PRICE"				, i)	, ""	);
            ws.addValue( "PR_AMT"      	    		, wf.getValue("PR_AMT"					, i)	, ""	); 
            ws.addValue( "CUST_NAME"       			, wf.getValue("CUST_NAME"				, i)	, ""	);  
            ws.addValue( "SALES_DEPT" 				, wf.getValue("SALES_DEPT"				, i)	, ""	);   
            ws.addValue( "PR_USER" 					, wf.getValue("PR_USER"					, i)	, ""	);
            ws.addValue( "LEAD_TIME"          		, wf.getValue("LEAD_TIME"				, i)	, ""	);       
            ws.addValue( "PO_NO"   	 				, img_po_no										, ""	);
            //ws.addValue( "PO_SHIPPER_TYPE"      	, wf.getValue("PO_SHIPPER_TYPE"			, i)	, ""	);              
            ws.addValue( "PO_UNIT_PRICE"    		, wf.getValue("PO_UNIT_PRICE"			, i)	, ""	);              
            ws.addValue( "PO_ITEM_AMT"      		, wf.getValue("PO_ITEM_AMT"				, i)	, ""	);            
            ws.addValue( "PO_ITEM_QTY"      		, wf.getValue("PO_ITEM_QTY"				, i)	, ""	);
            ws.addValue( "PO_CREATE_DATE"      		, wf.getValue("PO_CREATE_DATE"				, i)	, ""	);
            ws.addValue( "PR_CUR"      				, wf.getValue("PR_CUR"					, i)	, ""	);
            ws.addValue( "PO_CUR"      				, wf.getValue("PO_CUR"					, i)	, ""	);
            ws.addValue( "BID_DIV"      			, wf.getValue("BID_DIV"					, i)	, ""	);
            ws.addValue( "PURCHASER_ID"      		, wf.getValue("PURCHASER_ID"			, i)	, ""	);
            ws.addValue( "PURCHASER_NAME"     		, wf.getValue("PURCHASER_NAME"			, i)	, ""	);
        }

        String[] uObj = {mode, String.valueOf(value.status)};
        ws.setUserObject(uObj);
        ws.setCode(String.valueOf(value.status));
        ws.setMessage(value.message);
        ws.write();
*/
	}
	
	 @SuppressWarnings({ "rawtypes", "unchecked" })
		private HashMap getMessage(SepoaInfo info) throws Exception{
	    	HashMap result = null;
	    	Vector  v      = new Vector();
	    	
	    	v.addElement("MESSAGE");
	    	
	    	result = MessageUtil.getMessage(info, v);
	    	
	    	return result;
	    }
	    
	    @SuppressWarnings("unchecked")
		private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
	    	Map<String, String> result  = null;
	    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
	    	
	    	result = MapUtils.getMap(allData, "headerData");
	    	
	    	return result;
	    }
	    
	    @SuppressWarnings({ "unchecked" })
		private List<Map<String, String>> getGrid(GridData gdReq, SepoaInfo info) throws Exception{
	    	List<Map<String, String>> result  = null;
	    	Map<String, Object>       allData = SepoaDataMapper.getData(info, gdReq);
	    	
	    	result = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
	    	
	    	return result;
	    }
	    
	    private String[] getGridColArray(GridData gdReq) throws Exception{
	    	String[] result    = null;
	    	String   gridColId = gdReq.getParam("cols_ids");
	    	
	    	gridColId = JSPUtil.paramCheck(gridColId);
	    	gridColId = gridColId.trim();
	    	result    = SepoaString.parser(gridColId, ",");
	    	
	    	return result;
	    }
	    

	    private Object[] requestListHeader(GridData gdReq, SepoaInfo info) throws Exception{
	    	Object[]            result                = new Object[1];
	    	Map<String, String> resultInfo            = new HashMap<String, String>();
	    	Map<String, String> header                = this.getHeader(gdReq, info);
	    	//String              houseCode             = info.getSession("HOUSE_CODE");
	    	//String              add_date_start        = header.get("add_date_start");
	    	
	    	String from_date			         = header.get("from_date");
			String to_date				         = header.get("to_date");
			String cust_code			         = header.get("cust_code");
			String subject				         = header.get("subject");
			String material_type		         = header.get("material_type");
			String material_ctrl_type	         = header.get("material_ctrl_type");
			String material_class1		         = header.get("material_class1");
			String description_loc		         = header.get("description_loc");
			String unit_measure			         = header.get("unit_measure");
	    	
	    	
	    	resultInfo.put("from_date"              ,  from_date			);
	    	resultInfo.put("to_date"                ,  to_date				);   
	    	resultInfo.put("cust_code"              ,  cust_code			);
	    	resultInfo.put("subject"                ,  subject				);
	    	resultInfo.put("material_type"          ,  material_type		);
	    	resultInfo.put("material_ctrl_type"     ,  material_ctrl_type	);
	    	resultInfo.put("material_class1"        ,  material_class1		);
	    	resultInfo.put("description_loc"        ,  description_loc		);
	    	resultInfo.put("unit_measure"           ,  unit_measure		    );
    	
	    	result[0] = resultInfo;
	    	
	    	return result;
	    	
	    }
	    
	    private GridData getPrProceedingListGdRes(GridData gdReq, GridData gdRes, SepoaOut value) throws Exception{
	    	SepoaFormater sf               = new SepoaFormater(value.result[0]);
	    	String[]      gridColAry       = this.getGridColArray(gdReq);
	    	String        colKey           = null;
		    String        colValue         = null;
			int           rowCount         = sf.getRowCount();
			int           i                = 0;
			int           k                = 0;
			int           gridColAryLength = gridColAry.length;

	    	if(rowCount != 0){
	    		for(i = 0; i < rowCount; i++){
		    		for(k = 0; k < gridColAryLength; k++){
		    			colKey   = gridColAry[k];
		    			colValue = sf.getValue(colKey, i);
		    			
		    			if("SELECTED".equals(colKey)){
		    				gdRes.addValue("SELECTED", "0");
		    			}
		    			else{
		    				gdRes.addValue(colKey, colValue);
		    			}
		    		}
		    	}
	    	}
	    	
	    	return gdRes;
	    }

	    private String getExceptionStackTrace(Exception e){
			Writer      writer      = null;
			PrintWriter printWriter = null;
			String      s           = null;
			
			writer      = new StringWriter();
			printWriter = new PrintWriter(writer);
			
			e.printStackTrace(printWriter);
			
			s = writer.toString();
			
			return s;
		}
		
		private void loggerExceptionStackTrace(Exception e){
			String trace = this.getExceptionStackTrace(e);
			
			Logger.err.println(trace);
		}
}
