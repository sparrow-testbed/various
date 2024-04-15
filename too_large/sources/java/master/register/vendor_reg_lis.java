package master.register;

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
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class vendor_reg_lis  extends HttpServlet 
{
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
			if ("getVendorSgLst".equals(mode)) {
				gdRes = getVendorSgLst(gdReq, info); // 조회
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

	
	/**
	 * 등록진행업체목록 
	 * setDeleteInfo
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-23
	 * @modify 2014-10-23
	 */
	private GridData getVendorSgLst(GridData gdReq, SepoaInfo info) throws Exception {
		GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	    int                 rowCount   = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "doQuery");
	
	    	Object[] obj = {header};
	    	value = ServiceConnector.doService(info, "p0070", "CONNECTION","getVendorSgLst",obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		for (int i = 0; i < rowCount; i++){
			    		for(int k=0; k < gridColAry.length; k++){
			    			if("SELECTED".equals(gridColAry[k])){
			    				gdRes.addValue("SELECTED", "0");
			    			}
			    			else{
			    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
			    			}
			    		}
			    	}
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}





	/*//조회시 사용되는 Method 입니다. Method Name(doQuery)는 변경할 수 없습니다.
    	public void doQuery(SepoaStream ws) throws Exception {

    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
    		
    		String house_code       = info.getSession("HOUSE_CODE");
       		String vendor_name      = ws.getParam("vendor_name");
    		String progress_status  = ws.getParam("progress_status");
    		String screening_status = ws.getParam("screening_status");
    		String checklist_status = ws.getParam("checklist_status");
            String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

    		//String progress_status= "";
    		//String screening_status= "";
    		//String checklist_status= "";
    		//String sole_proprietor_flag= ws.getParam("sole_proprietor_flag");
    		//String vendor_code= ws.getParam("vendor_code");

    		String args[] = {vendor_name, progress_status, screening_status, checklist_status};

    		String value = getVendorSgLst(info, args);
    		
        	SepoaFormater wf = ws.getSepoaFormater(value);
    		
    		//String args[] = {vendor_name, progress_status, screening_status, checklist_status,sole_proprietor_flag ,vendor_code};
    		//String value = getVendorSgLst(info, args);
        	//SepoaFormater wf = ws.getSepoaFormater(value);

			if(wf.getRowCount() == 0)	{
	        	ws.setCode("M001");
    	    	ws.setMessage("조회된 데이터가 없습니다.");
        		ws.write();
        		return;
        	}

        	for(int i=0; i<wf.getRowCount(); i++) {

        		String[] check = {"false", ""};	//Check flag, Check Tooltip
        		String[] imagetext1 = {"",wf.getValue("NAME_LOC", i),wf.getValue("NAME_LOC", i)};

            	for(int k=0; k < grid_col_ary.length; k++)
                {
            		if(grid_col_ary[k] != null && grid_col_ary[k].equals("selected")) {
                		ws.addValue("selected", "0");
            		}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("name_loc")) {
                		ws.addValue(grid_col_ary[k], String.valueOf(i+1));
            		}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("progress_status")) {
            			ws.addValue(grid_col_ary[k], wf.getValue("PROGRESS_STATUS_NAME", i));
            		}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("screening_status")) {
            			ws.addValue(grid_col_ary[k], wf.getValue("SCREENING_STATUS_NAME", i));
            		}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("checklist_status")) {
            			ws.addValue(grid_col_ary[k], wf.getValue("CHECKLIST_STATUS_NAME", i));
            		}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("progress_status1")) {
            			ws.addValue(grid_col_ary[k], wf.getValue("PROGRESS_STATUS", i));
                	} else {
                		ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
        		
        		
//            	ws.addValue("sg_name", wf.getValue("SG_NAME", i), "");
//        		ws.addValue("request_date", wf.getValue("REQUEST_DATE", i), "");
//        		String[] imagetext2 = { "",  wf.getValue("PROGRESS_STATUS_NAME", i),  wf.getValue("PROGRESS_STATUS_NAME", i)};
        		
//        		ws.addValue("progress_status", imagetext2, "");	
//        		ws.addValue("screening_status", wf.getValue("SCREENING_STATUS_NAME", i), "");
//        		ws.addValue("checklist_status", wf.getValue("CHECKLIST_STATUS_NAME", i), "");	
//        		ws.addValue("vendor_code", wf.getValue("VENDOR_CODE", i), "");
//        		ws.addValue("progress_status1", wf.getValue("PROGRESS_STATUS", i), "");
//        		ws.addValue("sg_refitem", wf.getValue("SG_REFITEM", i), "");
//        		ws.addValue("vendor_sg_refitem", wf.getValue("VENDOR_SG_REFITEM", i), "");        		
//        		ws.addValue("IRS_NO", wf.getValue("IRS_NO", i), "");
//        		ws.addValue("CREDIT_RATING", wf.getValue("CREDIT_RATING", i), "");
//        		ws.addValue("CASH_GRADE", wf.getValue("CASH_GRADE", i), "");        		
//        		ws.addValue("REGISTRY_FLAG", wf.getValue("REGISTRY_FLAG", i), "");
//        		ws.addValue("REGISTRY_FLAG_NAME", wf.getValue("REGISTRY_FLAG_NAME", i), "");
//        		ws.addValue("SIGN_STATUS"		, wf.getValue("SIGN_STATUS", i), "");
//        		ws.addValue("SIGN_STATUS_NAME"	, wf.getValue("SIGN_STATUS_NAME", i), "");

        		//ws.addValue("BUSINESS_TYPE"	, wf.getValue("BUSINESS_TYPE", i), "");
        		//ws.addValue("INDUSTRY_TYPE"	, wf.getValue("INDUSTRY_TYPE", i), "");
        		//ws.addValue("USER_NAME"	, wf.getValue("USER_NAME", i), "");
        		//ws.addValue("PHONE_NO"	, wf.getValue("PHONE_NO", i), "");
        		//ws.addValue("EMAIL"	, wf.getValue("EMAIL", i), "");
        	}
	        ws.setCode("M001");
	        ws.setMessage("정상적으로 데이타가 query되었습니다.");

	       	ws.write();
     	}


    	public String getVendorSgLst(SepoaInfo info, String[] args) throws Exception {

    		Object obj[] = {(Object[])args};

    		String nickName= "p0070";
    		String conType = "CONNECTION";
       		String MethodName = "getVendorSgLst";
       		SepoaOut value = new SepoaOut();
       		SepoaRemote ws;

	        try {

		        ws = new SepoaRemote(nickName,conType,info);
		        value = ws.lookup(MethodName,obj);

	    	} catch(Exception e) {
	    		try{
		        	Logger.err.println("err = " + e.getMessage());
		        	Logger.err.println("message = " + value.message);
		        	Logger.err.println("status = " + value.status);	    			
	    		}catch(NullPointerException ne){
	        		ne.printStackTrace();
	        	}
	     	}
	    	return value.result[0];
    	}*/
}

