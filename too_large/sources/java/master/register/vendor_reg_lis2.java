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
import sepoa.fw.util.SepoaCombo;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class vendor_reg_lis2  extends HttpServlet 
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
			if ("getRegVenLst".equals(mode)) {
				gdRes = getRegVenLst(gdReq, info);        // 조회
			}else if ("real_setUpdate_vngl".equals(mode)) {
				gdRes = real_setUpdate_vngl(gdReq, info); // 협력사 신용등급 등록(첨부파일 저장)
			}else if ("setVendorReg".equals(mode)) {
				gdRes = setVendorReg(gdReq, info);        // 협력사정보 저장
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
	 * 협력사 신용등급 등록
	 * real_setUpdate_vngl
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-24
	 * @modify 2014-10-24
	 */
	private GridData real_setUpdate_vngl(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	
    	Map<String, String> result               = new HashMap<String, String>();
    	
	    result.put("house_code"               , gdReq.getParam("house_code"));
		result.put("company_code"             , gdReq.getParam("company_code"));
		result.put("dept_code"                , gdReq.getParam("dept_code"));
		result.put("req_user_id"              , gdReq.getParam("req_user_id"));
		result.put("doc_type"                 , gdReq.getParam("doc_type"));
		result.put("fnc_name"                 , gdReq.getParam("fnc_name"));
		result.put("ctrl_dept"                , gdReq.getParam("ctrl_dept"));
		result.put("ctrl_flag"                , gdReq.getParam("ctrl_flag"));
		result.put("query_flag"               , gdReq.getParam("query_flag"));
		result.put("model_flag"               , gdReq.getParam("model_flag"));
		result.put("model_no"                 , gdReq.getParam("model_no"));
		result.put("material_type"            , gdReq.getParam("material_type"));
		result.put("material_ctrl_type"       , gdReq.getParam("material_ctrl_type"));
		result.put("material_class1"          , gdReq.getParam("material_class1"));
		result.put("material_class2"          , gdReq.getParam("material_class2"));
		result.put("pr_flag"                  , gdReq.getParam("pr_flag"));
		result.put("material_class2_name"     , gdReq.getParam("material_class2_name"));
		result.put("basic_unit"               , gdReq.getParam("basic_unit"));
		result.put("item_abbreviation"        , gdReq.getParam("item_abbreviation"));
		result.put("app_tax_code"             , gdReq.getParam("app_tax_code"));
		result.put("item_block_flag"          , gdReq.getParam("item_block_flag"));
		result.put("attach_no"                , gdReq.getParam("attach_no"));
		result.put("vendor_code"              , gdReq.getParam("vendor_code"));
		result.put("att_mode"                 , gdReq.getParam("att_mode"));
		result.put("view_type"                , gdReq.getParam("view_type"));
		result.put("file_type"                , gdReq.getParam("file_type"));
		result.put("tmp_att_no"               , gdReq.getParam("tmp_att_no"));		
		result.put("credit_rating"            , gdReq.getParam("credit_rating"));		
    	
		
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);
    	
		
    	try {
    		
    		gdRes.addParam("mode", "doSaveEnd");
    		gdRes.setSelectable(false);
    		
    		Object[] obj = {result};
    		
    		value = ServiceConnector.doService(info, "t0002", "TRANSACTION","real_setUpdate_vngl", obj);
    		
    		gdRes.setMessage(value.message);
    		gdRes.setStatus(Boolean.toString(value.flag));
    		
    	}
    	catch(Exception e){
    		
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
	}

	/**
	 * 협력사 현황
	 * getRegVenLst
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-24
	 * @modify 2014-10-24
	 */
	private GridData getRegVenLst(GridData gdReq, SepoaInfo info) throws Exception {
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
	    	value = ServiceConnector.doService(info, "p0070", "CONNECTION","getRegVenLst",obj);
	
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

	public GridData setVendorReg(GridData gdReq, SepoaInfo info) throws Exception{
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
    		
    		value = ServiceConnector.doService(info, "p0070", "TRANSACTION", "setVendorReg",       obj);
    		
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
	
	/*
	
//		SepoaInfo info, String HOUSE_CODE, String vendor_code, String class_grade
        String nickName= "p0070";
        String conType = "TRANSACTION";
        String MethodName = "setVendorReg";

        SepoaOut value = null;
        SepoaRemote wr = null;

        Object[] args = {HOUSE_CODE, vendor_code, class_grade};

        try {
            wr = new SepoaRemote(nickName, conType, info);
            value = wr.lookup(MethodName,args);
        } catch(Exception e) {
        	try{
                Logger.err.println(info.getSession("ID"),this,"err = " + e.getMessage());
                Logger.err.println("status = " + value.status + "  message = " + value.message);        		
        	}catch(NullPointerException ne){
        		ne.printStackTrace();
        	}
        } finally{
            try {
                wr.Release();
            } catch(Exception e){
            	e.printStackTrace();
            }
        }

        return value;
    }*/
	
	/*//조회시 사용되는 Method 입니다. Method Name(doQuery)는 변경할 수 없습니다.
	@SuppressWarnings("static-access")
	public void doQuery(SepoaStream ws) throws Exception
	{
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());


		String house_code = info.getSession("HOUSE_CODE");
		String work_type  = info.getSession("WORK_TYPE");

		String vendor_name	= ws.getParam("vendor_name");
		String level 		= ws.getParam("level");
		String sg_refitem 	= ws.getParam("sg_refitem");

		//String RESIDENT_NO 	= enc.encrypt(ws.getParam("RESIDENT_NO"));

		String IRS_NO 		= ws.getParam("IRS_NO");
		String CLASS_GRADE	= ws.getParam("CLASS_GRADE");
		String pjt_name		= ws.getParam("pjt_name");
		
		String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
		//String add_date_start = ws.getParam("add_date_start");
		//String add_date_end = ws.getParam("add_date_end");

		String param[] = {vendor_name, level, sg_refitem, IRS_NO, CLASS_GRADE, pjt_name};
		//String param[] = {vendor_name, level, sg_refitem, RESIDENT_NO, IRS_NO, add_date_start, add_date_end};

		String value = getRegVenLst(info, param);
    	SepoaFormater wf = ws.getSepoaFormater(value);

		if(wf.getRowCount() == 0)
		{
        	ws.setCode("M001");
	    	ws.setMessage("조회된 데이터가 없습니다.");
    		ws.write();
    		return;
    	}

		SepoaCombo combo_d = new SepoaCombo();
        String combo_SPEC_FLAG[][] = combo_d.getCombo(ws.getRequest(), "SL0022", info.getSession("HOUSE_CODE") + "#" +"M634#", null); // 결과
        
    	for(int i=0; i<wf.getRowCount(); i++)
    	{
    		String[] check = {"false", ""};
    		String[] imagetext1 = {"",wf.getValue("NAME_LOC", i),wf.getValue("NAME_LOC", i)};
        	String[] imagetext2 = {"",wf.getValue("CREDIT_GRADE", i),wf.getValue("CREDIT_GRADE", i)};
    		String tmp = wf.getValue("PURCHASE_BLOCK_FLAG", i);
    		
    		int index_SPEC_FLAG 	= combo_d.getIndex( wf.getValue("CLASS_GRADE", i ) );
            String tmp_SPEC_FLAG 	= wf.getValue("CLASS_GRADE", i);

    		//String resident_no = enc.decrypt(wf.getValue("RESIDENT_NO", i)); // 복호화
            for(int k=0; k < grid_col_ary.length; k++)
            {
        		if(grid_col_ary[k] != null && grid_col_ary[k].equals("sel")) {
            		ws.addValue("sel", "0");
            	} else {
            		ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
            	}
            }
        	
        	
        	String irsNo = wf.getValue("IRS_NO", i);
        	
        	irsNo = irsNo.substring(0, 3)+"-"+irsNo.substring(3, 5)+"-"+irsNo.substring(5, 10);

        	ws.addValue("IRS_NO", 		 irsNo, "");
        	//ws.addValue("CLASS_GRADE"  , combo_SPEC_FLAG, tmp_SPEC_FLAG, index_SPEC_FLAG);

        	//if("Z".equals(work_type)){
        	//	ws.addValue("RESIDENT_NO", 	resident_no, "");
        	//}else{
        	//	ws.addValue("RESIDENT_NO", 	"".equals(resident_no) ? "" : resident_no.substring(0, 6)+"*******" , "");
        	//}

    	}
        ws.setCode("M001");
        ws.setMessage("정상적으로 데이타가 query되었습니다.");

       	ws.write();
 	}
	
	public void doData(SepoaStream ws) throws Exception{
        //session 정보를 가져온다.
        SepoaInfo info	= SepoaSession.getAllValue(ws.getRequest());
        SepoaFormater wf	= ws.getSepoaFormater();
        String HOUSE_CODE = info.getSession("HOUSE_CODE");
        String COMPANY_CODE = info.getSession("COMPANY_CODE");
        
        SepoaOut value = null;
        String mode = ws.getParam("mode");
        Logger.debug.println(info.getSession("ID"), this,"mode=========>"+mode );

        String vendor_code           = ws.getParam("vendor_code");
        String class_grade			= ws.getParam("class_grade");

        if(mode.equals("setVendorReg")) {  // 참가여부등록
            value = setVendorReg(info, HOUSE_CODE, vendor_code,class_grade);
        }
        try{
	        ws.setCode(String.valueOf(value.status));
	        ws.setMessage(value.message);
	        ws.write();
        }catch(NullPointerException ne){
			ne.printStackTrace();
		}
    }

	public String getRegVenLst(SepoaInfo info, String[] args) throws Exception
	{
		Object obj[] = {(Object[])args};

		String nickName= "p0070";
		String conType = "CONNECTION";
   		String MethodName = "getRegVenLst";
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
	}
	
	*/
}

