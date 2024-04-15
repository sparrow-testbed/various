package sepoa.svl.contract;

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

import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class contract_list extends HttpServlet {

	private static SepoaInfo info;

	public void init(ServletConfig config) throws ServletException {
		//System.out.println("Servlet call");
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		
		info = sepoa.fw.ses.SepoaSession.getAllValue(req);

		GridData gdReq = new GridData();
		GridData gdRes = new GridData();
		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
		String mode = "";
		PrintWriter out = res.getWriter();
		boolean   isJson = false;

		try {
			String rawData = req.getParameter("WISEGRID_DATA");
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));

			if (mode.equals("query")) {
				gdRes = getContractList(gdReq);
			}else if (mode.equals("query2")) {
					gdRes = getContractList2(gdReq);
			}else if (mode.equals("query3")) {
				gdRes = getContractList3(gdReq);
			}else if(mode.equals("insert")){
				gdRes = getContractSave(gdReq);  // 증권번호등록
			}else if(mode.equals("approval")){   //결재요청
				gdRes = setApproval(gdReq);  
			}else if(mode.equals("drop")){   //계약폐기요청
				gdRes = setDrop(gdReq);  
			}else if(mode.equals("delete")){   //계약폐기
				gdRes = setDelete(gdReq);  
			}else if("getChkFg".equals(mode)){ // 체크리스트 확인여부
    			gdRes  = this.getChkFg(gdReq, info);
    			isJson = true;
    		}else if("isChked".equals(mode)){ // 체크리스트 확인여부
    			gdRes  = this.isChked(gdReq, info);
    			isJson = true;
    		}else if("setChk".equals(mode)){ // 체크리스트 확인여부
    			gdRes  = this.setChk(gdReq, info);
    			isJson = true;
    		}else if (mode.equals("getContractDetailList")) {
				gdRes = getContractDetailList(gdReq);
    		}

		} catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
			gdRes.setStatus("false");
/*			e.printStackTrace();*/
		} finally {
			try {				
				if(isJson){
    				out.print(gdRes.getMessage());
    			}
    			else{
    				OperateGridData.write(req, res, gdRes, out);    				
    			}
			} catch (Exception e) {
/*				e.printStackTrace();*/ mode = "";
			}
		}	
	}
	
	private Map<String, String> getQuerySvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result       = new HashMap<String, String>();
    	String              houseCode    = info.getSession("HOUSE_CODE");
    	String              company_code = info.getSession("COMPANY_CODE");
     	String              cont_no      = gdReq.getParam("CONT_NO");
     	String              cont_gl_seq  = gdReq.getParam("CONT_GL_SEQ");
     	
    	result.put("HOUSE_CODE",   houseCode);
    	result.put("COMPANY_CODE", company_code);
    	result.put("CONT_NO",    cont_no);
    	result.put("CONT_GL_SEQ", cont_gl_seq);
    	
    	return result;
    }
	
	@SuppressWarnings({ "rawtypes"})
    private GridData getChkFg(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes   = new GridData();
	    SepoaOut            value   = null;
	    SepoaFormater       sf      = null;
	    Map<String, String> svcParm = this.getQuerySvcParam(gdReq, info);
	    String              message = "";
	    String              chk_date      = "";
	    String              chk_user_id   = "";
	    String              chk_user_name = "";
	    String              retval        = "";
	    
	    
	    int rowCount = 0;
	    
	    //retJson(String code,String retval1,String retval2) ;
        
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {svcParm};
	
	    	value   = ServiceConnector.doService(info, "CT_001", "CONNECTION","getChkFg", obj);
	    	sf = new SepoaFormater(value.result[0]);
	    	rowCount = sf.getRowCount();
			if (rowCount == 0) {
				gdRes.setMessage(this.retJson("-1","","","",""));
				gdRes.setStatus("false");
				return gdRes;
			}
			chk_date      = sf.getValue("CHK_DATE", 0); 
		    chk_user_id   = sf.getValue("CHK_USER_ID", 0); 
		    chk_user_name = sf.getValue("CHK_USER_NAME", 0); 
			
		    sf = new SepoaFormater(value.result[1]);
	    	rowCount = sf.getRowCount();
			if (rowCount == 0) {
				gdRes.setMessage(this.retJson("-2","","","",""));
				gdRes.setStatus("false");
				return gdRes;
			}
		    for(int i=0; i<rowCount; i++){
		    	retval += sf.getValue("CHK_FLAG", i);
		    	if(i < (rowCount-1)){
		    		retval += ",";
		    	}
		    }
		    
	    	gdRes.setMessage(this.retJson("000",chk_date,chk_user_id,chk_user_name,retval));
	    	gdRes.setStatus(Boolean.toString(value.flag));
	    }
	    catch (Exception e){
	    	gdRes.setMessage(this.retJson("-999","","","",""));
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData isChked(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes   = new GridData();
	    SepoaOut            value   = null;
	    SepoaFormater       sf      = null;
	    Map<String, String> svcParm = this.getQuerySvcParam(gdReq, info);
	    String              message = null;
	     
	    int rowCount = 0;
        
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {svcParm};
	
	    	value   = ServiceConnector.doService(info, "CT_001", "CONNECTION","isChked", obj);
	    	sf = new SepoaFormater(value.result[0]);
	    	
	    	rowCount = sf.getRowCount();
			
			if (rowCount == 0) {
				gdRes.setMessage("-1");
				gdRes.setStatus("false");
				return gdRes;
			}
	    	
	    	message = sf.getValue("CHK_FG", 0);
	    	
	    	gdRes.setMessage(message);
	    	gdRes.setStatus(Boolean.toString(value.flag));
	    }
	    catch (Exception e){
	    	gdRes.setMessage("-999");
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData setChk(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;
    	
    	Map<String, String> svcParm      = new HashMap<String, String>();
    	String              company_code = info.getSession("COMPANY_CODE");
     	String              cont_no      = gdReq.getParam("CONT_NO");
     	String              cont_gl_seq  = gdReq.getParam("CONT_GL_SEQ");  
     	String              chk_comment1 = gdReq.getParam("CHK_COMMENT1");
     	String              chk_flag1    = gdReq.getParam("CHK_FLAG1");
     	String              chk_comment2 = gdReq.getParam("CHK_COMMENT2");
     	String              chk_flag2    = gdReq.getParam("CHK_FLAG2");
     	String              chk_comment3 = gdReq.getParam("CHK_COMMENT3");
     	String              chk_flag3    = gdReq.getParam("CHK_FLAG3");
     	String              chk_comment4 = gdReq.getParam("CHK_COMMENT4");
     	String              chk_flag4    = gdReq.getParam("CHK_FLAG4");
     	svcParm.put("COMPANY_CODE" ,   company_code);
     	svcParm.put("CONT_NO"      ,   cont_no     );
     	svcParm.put("CONT_GL_SEQ"  ,   cont_gl_seq );
     	svcParm.put("CHK_COMMENT1" ,   chk_comment1);
     	svcParm.put("CHK_FLAG1"    ,   chk_flag1   );
     	svcParm.put("CHK_COMMENT2" ,   chk_comment2);
     	svcParm.put("CHK_FLAG2"    ,   chk_flag2   );
     	svcParm.put("CHK_COMMENT3" ,   chk_comment3);
     	svcParm.put("CHK_FLAG3"    ,   chk_flag3   );
     	svcParm.put("CHK_COMMENT4" ,   chk_comment4);
     	svcParm.put("CHK_FLAG4"    ,   chk_flag4   );
     	
     	try {
    		message  = this.getMessage(info);
     		Object[] obj      = {svcParm};
    		value    = ServiceConnector.doService(info, "CT_001", "TRANSACTION", "setChk", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = this.successJson();
    		}
    		else{
    			throw new Exception();
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
    	return result;
    }
	
	private String successJson() throws Exception{
		StringBuffer stringBuffer = new StringBuffer();
		String       result       = null;
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'000'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private String failJson(String message) throws Exception{
		StringBuffer stringBuffer = new StringBuffer();
		String       result       = null;
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'900',");
		stringBuffer.append(	"message:'").append(message).append("'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private String retJson(String code,String chk_date,String chk_user_id,String chk_user_name,String retval) throws Exception{
		StringBuffer stringBuffer = new StringBuffer();
		String       result       = null;
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'").append(code).append("',");
		stringBuffer.append(	"chk_date:'").append(chk_date).append("',");
		stringBuffer.append(	"chk_user_id:'").append(chk_user_id).append("',");
		stringBuffer.append(	"chk_user_name:'").append(chk_user_name).append("',");
		stringBuffer.append(	"retval:'").append(retval).append("'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	public GridData getContractList(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		String POASRM_CONTEXT_NAME = new Configuration().getString("sepoa.context.name");
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			String from_date		= JSPUtil.paramCheck(gdReq.getParam("from_date")).trim();
			String to_date			= JSPUtil.paramCheck(gdReq.getParam("to_date")).trim();
			String seller_code	    = JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim();
			String cont_no		    = JSPUtil.paramCheck(gdReq.getParam("cont_no")).trim();
			String status       	= JSPUtil.paramCheck(gdReq.getParam("status")).trim();
			String ele_cont_flag	= JSPUtil.paramCheck(gdReq.getParam("ele_cont_flag")).trim();
			String ctrl_person_id	= JSPUtil.paramCheck(gdReq.getParam("ctrl_person_id")).trim();
			String subject	        = JSPUtil.paramCheck(gdReq.getParam("subject")).trim();
			String view	        	= JSPUtil.paramCheck(gdReq.getParam("view")).trim();
			String sg_type1	        = JSPUtil.paramCheck(gdReq.getParam("sg_type1")).trim();
			String sg_type2	        = JSPUtil.paramCheck(gdReq.getParam("sg_type2")).trim();
			String sg_type3	        = JSPUtil.paramCheck(gdReq.getParam("sg_type3")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");

			// EJB CALL
			Object[] obj = { from_date, to_date,  seller_code, cont_no, status, ele_cont_flag, ctrl_person_id, subject ,view, sg_type1, sg_type2, sg_type3};
			SepoaOut value = ServiceConnector.doService(info, "CT_030", "CONNECTION", "getContractList", obj);

			if (value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
				return gdRes;
			}

			wf = new SepoaFormater(value.result[0]);
			rowCount = wf.getRowCount();
			
			if (rowCount == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString());
				return gdRes;
			}

			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "0");
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_DATE")) {
						gdRes.addValue("CONT_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_FROM")) {
						gdRes.addValue("CONT_FROM", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_TO")) {
						gdRes.addValue("CONT_TO", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELLER_CONFRIM_DATE")) {
						gdRes.addValue("SELLER_CONFRIM_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_FILE_IMG")) {
            			String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
            			if(!wf.getValue("CONT_FILE_NO", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif";
					    gdRes.addValue(grid_col_ary[k], fileImg);
            		} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("FAULT_FILE_IMG")) {
            			String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
            			if(!wf.getValue("FAULT_FILE_NO", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif";
					    gdRes.addValue(grid_col_ary[k], fileImg);
            		}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("RECT_IMG")) {
            			String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
            			if(!wf.getValue("REJECT_REASON", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/detail.gif";
					    gdRes.addValue(grid_col_ary[k], fileImg);
            		}
					else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			 
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}

		return gdRes;
	}
	
	
	public GridData getContractList2(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		String POASRM_CONTEXT_NAME = new Configuration().getString("sepoa.context.name");
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String from_date		= JSPUtil.paramCheck(gdReq.getParam("from_date")).trim();
			String to_date			= JSPUtil.paramCheck(gdReq.getParam("to_date")).trim();
			String seller_code	    = JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim();
			String cont_no		    = JSPUtil.paramCheck(gdReq.getParam("cont_no")).trim();
			String status       	= JSPUtil.paramCheck(gdReq.getParam("status")).trim();
			String ele_cont_flag	= JSPUtil.paramCheck(gdReq.getParam("ele_cont_flag")).trim();
			String ctrl_person_id	= JSPUtil.paramCheck(gdReq.getParam("ctrl_person_id")).trim();
			String subject	        = JSPUtil.paramCheck(gdReq.getParam("subject")).trim();
			String view	        	= JSPUtil.paramCheck(gdReq.getParam("view")).trim();
			String sg_type1	        = JSPUtil.paramCheck(gdReq.getParam("sg_type1")).trim();
			String sg_type2	        = JSPUtil.paramCheck(gdReq.getParam("sg_type2")).trim();
			String sg_type3	        = JSPUtil.paramCheck(gdReq.getParam("sg_type3")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");
			
			// EJB CALL
			Object[] obj = { from_date, to_date,  seller_code, cont_no, status, ele_cont_flag, ctrl_person_id, subject ,view, sg_type1, sg_type2, sg_type3};
			SepoaOut value = ServiceConnector.doService(info, "CT_030", "CONNECTION", "getContractList2", obj);
			
			if (value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
				return gdRes;
			}
			
			wf = new SepoaFormater(value.result[0]);
			rowCount = wf.getRowCount();
			
			if (rowCount == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString());
				return gdRes;
			}
			
			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "0");
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_DATE")) {
						gdRes.addValue("CONT_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_FROM")) {
						gdRes.addValue("CONT_FROM", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_TO")) {
						gdRes.addValue("CONT_TO", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELLER_CONFRIM_DATE")) {
						gdRes.addValue("SELLER_CONFRIM_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_FILE_IMG")) {
						String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
						if(!wf.getValue("CONT_FILE_NO", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif";
						gdRes.addValue(grid_col_ary[k], fileImg);
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("FAULT_FILE_IMG")) {
						String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
						if(!wf.getValue("FAULT_FILE_NO", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif";
						gdRes.addValue(grid_col_ary[k], fileImg);
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("RECT_IMG")) {
						String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
						if(!wf.getValue("REJECT_REASON", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/detail.gif";
						gdRes.addValue(grid_col_ary[k], fileImg);
					}
					else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
	
	public GridData getContractList3(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		String POASRM_CONTEXT_NAME = new Configuration().getString("sepoa.context.name");
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String from_date1		= JSPUtil.paramCheck(gdReq.getParam("from_date1")).trim();
			String to_date1			= JSPUtil.paramCheck(gdReq.getParam("to_date1")).trim();
			String from_date2		= JSPUtil.paramCheck(gdReq.getParam("from_date2")).trim();
			String to_date2			= JSPUtil.paramCheck(gdReq.getParam("to_date2")).trim();
			String seller_code	    = JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim();
			String cont_no		    = JSPUtil.paramCheck(gdReq.getParam("cont_no")).trim();
			String status       	= JSPUtil.paramCheck(gdReq.getParam("status")).trim();
			String ele_cont_flag	= JSPUtil.paramCheck(gdReq.getParam("ele_cont_flag")).trim();
			String ctrl_person_id	= JSPUtil.paramCheck(gdReq.getParam("ctrl_person_id")).trim();
			String subject	        = JSPUtil.paramCheck(gdReq.getParam("subject")).trim();
			String view	        	= JSPUtil.paramCheck(gdReq.getParam("view")).trim();
			String sg_type1	        = JSPUtil.paramCheck(gdReq.getParam("sg_type1")).trim();
			String sg_type2	        = JSPUtil.paramCheck(gdReq.getParam("sg_type2")).trim();
			String sg_type3	        = JSPUtil.paramCheck(gdReq.getParam("sg_type3")).trim();
			
			String gw_cod_no	    = JSPUtil.paramCheck(gdReq.getParam("gw_cod_no")).trim();
			String gw_title	        = JSPUtil.paramCheck(gdReq.getParam("gw_title")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");
			
			// EJB CALL
			Object[] obj = { from_date1, to_date1, from_date2, to_date2, seller_code, cont_no, status, ele_cont_flag, ctrl_person_id, subject ,view, sg_type1, sg_type2, sg_type3, gw_cod_no, gw_title};
			SepoaOut value = ServiceConnector.doService(info, "CT_030", "CONNECTION", "getContractList3", obj);
			
			if (value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
				return gdRes;
			}
			
			wf = new SepoaFormater(value.result[0]);
			rowCount = wf.getRowCount();
			
			if (rowCount == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString());
				return gdRes;
			}
			
			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "0");
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_DATE")) {
						gdRes.addValue("CONT_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_FROM")) {
						gdRes.addValue("CONT_FROM", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_TO")) {
						gdRes.addValue("CONT_TO", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELLER_CONFRIM_DATE")) {
						gdRes.addValue("SELLER_CONFRIM_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_FILE_IMG")) {
						String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
						if(!wf.getValue("CONT_FILE_NO", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif";
						gdRes.addValue(grid_col_ary[k], fileImg);
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("FAULT_FILE_IMG")) {
						String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
						if(!wf.getValue("FAULT_FILE_NO", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif";
						gdRes.addValue(grid_col_ary[k], fileImg);
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("RECT_IMG")) {
						String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
						if(!wf.getValue("REJECT_REASON", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/detail.gif";
						gdRes.addValue(grid_col_ary[k], fileImg);
					}
					else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
	
	//보증증권번호등록
	public GridData getContractSave(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

		try {
			gdRes.setSelectable(false);
	        //int row_count = gdReq.getHeader("screen_id").getRowCount();
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
	            {
	            		gdReq.getValue("CONT_INS_VN"   , i), //계약이행보증증권회사
		                gdReq.getValue("CONT_INS_NO"   , i), //계약이행보증증권번호
		                gdReq.getValue("FAULT_INS_NO"  , i), //하자이행보증증권번호
		                gdReq.getValue("CONT_NO"       , i), //계약번호
		                gdReq.getValue("CONT_FILE_NO"  , i), //계약이행보증증권파일번호
		                gdReq.getValue("FAULT_FILE_NO" , i), //하자이행보증증권파일번호
		                gdReq.getValue("CONT_GL_SEQ"   , i) 
	            };

	            bean_args[i] = loop_data1;
	        }

			// EJB CALL
			Object[] obj = { bean_args };
			SepoaOut value = ServiceConnector.doService(info, "CT_030", "CONNECTION", "getContractSave", obj);


            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}

		return gdRes;
	}


    public GridData setApproval(GridData gdReq) throws Exception
    {
    	
        GridData gdRes = new GridData();
        Vector v = new Vector();
    	v.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,v);
        
        try{        	
        	gdRes.setSelectable(false);
        	
        	String approval_str = JSPUtil.CheckInjection(JSPUtil.nullToEmpty(gdReq.getParam("APPROVAL_STR"))).trim();	//결재선 목록
        	String CONT_NO = JSPUtil.CheckInjection(JSPUtil.nullToEmpty(gdReq.getParam("CONT_NO"))).trim();			 
        	String CONT_GL_SEQ = JSPUtil.CheckInjection(JSPUtil.nullToEmpty(gdReq.getParam("CONT_GL_SEQ"))).trim();			 
        	String SUBJECT = JSPUtil.CheckInjection(JSPUtil.nullToEmpty(gdReq.getParam("SUBJECT"))).trim();			 
        	String CONT_AMT = JSPUtil.CheckInjection(JSPUtil.nullToEmpty(gdReq.getParam("CONT_AMT"))).trim();			 
        	 
        	//System.out.println("결재선목록 : "+approval_str); 
        	
        	HashMap  header = new HashMap ();
        	header.clear();
        	header.put("APPROVAL_STR", approval_str);
    		header.put("CONT_NO", CONT_NO); 
    		header.put("CONT_GL_SEQ", CONT_GL_SEQ); 
    		header.put("SUBJECT", SUBJECT); 
    		header.put("CONT_AMT", CONT_AMT); 
    		
/*
        	int row_count = gdReq.getRowCount();
        	System.out.println("로우카운트!!!!!!:"+row_count);
	        String[][] bean_args = new String[row_count][];
	        
	        for (int i = 0; i < row_count; i++)
	        {	
	        	String[] loop_data1 =
	            {	
		        	gdReq.getValue("T_TYPE",i),			//유형코드(차대변D,C)
		        	gdReq.getValue("T_TYPE_TXT",i),		//유형명(차대변)
	        		gdReq.getValue("TAX_CODE",i),		//세금코드
	        		gdReq.getValue("GL_ACCT_CODE",i),	//계정코드
	        		gdReq.getValue("GL_ACCT_NAME",i),	//계정명
	        		gdReq.getValue("COST_DEPT_CODE",i),	//귀속부서코드
	        		gdReq.getValue("COST_DEPT_NAME",i),	//귀속부서명
	        		gdReq.getValue("ORDER_CODE",i),		//귀속프로젝트코드
	        		gdReq.getValue("ORDER_NAME",i),		//귀속프로젝트명
	        		gdReq.getValue("D_AMT",i),			//차변금액
	        		gdReq.getValue("T_TEXT",i),			//사용내역
	        		
	        		gdReq.getValue("ORDER_VALUE",i)			//CCTR,오더인지 구분
	            };
	        	
	            bean_args[i] = loop_data1;
	        }
*/	        
	        
	        //Object[] obj = {info, bean_args, header};
	        Object[] obj = {info, header};
	    	SepoaOut value = ServiceConnector.doService(info, "CT_002", "TRANSACTION","setApproval", obj);	//비용SSLLN에 비용라인 추가
	    	
            if(value.flag){ 
            	gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            gdRes.setStatus("true"); 
	            
            }else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
            
        }catch (Exception e){
/*        	e.printStackTrace();*/
        	gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        gdRes.addParam("mode", "approval");
        
        return gdRes;
    }

    public GridData setDrop(GridData gdReq) throws Exception
    {
    	
        GridData gdRes = new GridData();
        Vector v = new Vector();
    	v.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,v);
        
        try{
        	String ct_flag = JSPUtil.CheckInjection(JSPUtil.nullToEmpty(gdReq.getParam("ct_flag"))).trim();
        	
        	gdRes.setSelectable(false);
        	int row_count        = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
	            {
		                gdReq.getValue("CONT_NO"       , i), //계약번호
		                gdReq.getValue("CONT_GL_SEQ"   , i) 
	            };

	            bean_args[i] = loop_data1;
	        }

			Object[] obj = { bean_args, ct_flag };
			SepoaOut value = ServiceConnector.doService(info, "CT_030", "CONNECTION", "setDrop", obj);

            if(value.flag){ 
            	gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            gdRes.setStatus("true"); 
	            
            }else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
            
        }catch (Exception e){
/*        	e.printStackTrace();*/
        	gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        gdRes.addParam("mode", "approval");
        
        return gdRes;
    }

    public GridData setDelete(GridData gdReq) throws Exception
    {
    	
        GridData gdRes = new GridData();
        Vector v = new Vector();
    	v.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,v);
        
        try{
        	String ct_flag = JSPUtil.CheckInjection(JSPUtil.nullToEmpty(gdReq.getParam("ct_flag"))).trim();
        	
        	gdRes.setSelectable(false);
        	int row_count        = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
	            {
		                gdReq.getValue("CONT_NO"       , i), //계약번호
		                gdReq.getValue("CONT_GL_SEQ"   , i) 
	            };

	            bean_args[i] = loop_data1;
	        }

			Object[] obj = { bean_args, ct_flag }; 
			SepoaOut value = ServiceConnector.doService(info, "CT_030", "CONNECTION", "setDelete", obj);

            if(value.flag){ 
            	gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            gdRes.setStatus("true"); 
	            
            }else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
            
        }catch (Exception e){
/*        	e.printStackTrace();*/
        	gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }
        gdRes.addParam("mode", "approval");
        
        return gdRes;
    }
    
    public GridData getContractDetailList(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);
		String POASRM_CONTEXT_NAME = new Configuration().getString("sepoa.context.name");
		
		try {
			String grid_col_id = JSPUtil.paramCheck(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String from_date		= JSPUtil.paramCheck(gdReq.getParam("from_date")).trim();
			String to_date			= JSPUtil.paramCheck(gdReq.getParam("to_date")).trim();
			String seller_code	    = JSPUtil.paramCheck(gdReq.getParam("seller_code")).trim();
			String cont_no		    = JSPUtil.paramCheck(gdReq.getParam("cont_no")).trim();
			String status       	= JSPUtil.paramCheck(gdReq.getParam("status")).trim();
			String ele_cont_flag	= JSPUtil.paramCheck(gdReq.getParam("ele_cont_flag")).trim();
			String ctrl_person_id	= JSPUtil.paramCheck(gdReq.getParam("ctrl_person_id")).trim();
			String subject	        = JSPUtil.paramCheck(gdReq.getParam("subject")).trim();
			String view	        	= JSPUtil.paramCheck(gdReq.getParam("view")).trim();
			String sg_type1	        = JSPUtil.paramCheck(gdReq.getParam("sg_type1")).trim();
			String sg_type2	        = JSPUtil.paramCheck(gdReq.getParam("sg_type2")).trim();
			String sg_type3	        = JSPUtil.paramCheck(gdReq.getParam("sg_type3")).trim();
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");
			
			String req_to_date     =sepoa.fw.util.SepoaDate.addSepoaDateMonth(from_date,12);
			
			if( Integer.parseInt(to_date) >= Integer.parseInt(req_to_date) ){
				gdRes.setMessage("계약작성일 기간은 1년 이내 이어야 합니다.");
				gdRes.setStatus("false");
				return gdRes;
			}
			
			// EJB CALL
			Object[] obj = { from_date, to_date,  seller_code, cont_no, status, ele_cont_flag, ctrl_person_id, subject ,view, sg_type1, sg_type2, sg_type3};
			SepoaOut value = ServiceConnector.doService(info, "CT_030", "CONNECTION", "getContractDetailList", obj);
			
			if (value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
				return gdRes;
			}
			
			wf = new SepoaFormater(value.result[0]);
			rowCount = wf.getRowCount();
			
			if (rowCount == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString());
				return gdRes;
			}
			
			for (int i = 0; i < rowCount; i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
						gdRes.addValue("SELECTED", "0");
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_DATE")) {
						gdRes.addValue("CONT_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_FROM")) {
						gdRes.addValue("CONT_FROM", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_TO")) {
						gdRes.addValue("CONT_TO", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELLER_CONFRIM_DATE")) {
						gdRes.addValue("SELLER_CONFRIM_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("CONT_FILE_IMG")) {
						String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
						if(!wf.getValue("CONT_FILE_NO", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif";
						gdRes.addValue(grid_col_ary[k], fileImg);
					} else if (grid_col_ary[k] != null && grid_col_ary[k].equals("FAULT_FILE_IMG")) {
						String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
						if(!wf.getValue("FAULT_FILE_NO", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif";
						gdRes.addValue(grid_col_ary[k], fileImg);
					}else if (grid_col_ary[k] != null && grid_col_ary[k].equals("RECT_IMG")) {
						String fileImg = POASRM_CONTEXT_NAME + "/images/blank.gif";
						if(!wf.getValue("REJECT_REASON", i).equals("")) fileImg = POASRM_CONTEXT_NAME + "/images/icon/detail.gif";
						gdRes.addValue(grid_col_ary[k], fileImg);
					}
					else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
				}
			}
			
		} catch (Exception e) {
			//System.out.println("Exception : " + e.getMessage());
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		
		return gdRes;
	}
}
