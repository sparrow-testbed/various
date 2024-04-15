package dt.ebd;

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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ebd_bd_ins3 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
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

			if("setPrCreate".equals(mode)){
				gdRes = this.setPrCreate(gdReq, info);
			}
		}
		catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
			gdRes.setStatus("false");
			
		}
		finally {
			try{
				OperateGridData.write(req, res, gdRes, out);
			}
			catch (Exception e) {
				Logger.debug.println();
			}
		}
	}
    
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData setPrCreate(GridData gdReq, SepoaInfo info) throws Exception{
		GridData                  gdRes            = new GridData();
	    Vector                    multilangId      = new Vector();
	    HashMap                   message          = null;
	    SepoaOut                  value            = null;
	    Map<String, Object>       data             = null;
	    Map<String, String>       header           = null;
	    List<Map<String, String>> grid             = null;
	    
	    multilangId.addElement("MESSAGE");
	    
		message = MessageUtil.getMessage(info, multilangId);
		
		try {
			gdRes.addParam("mode", "doSave");
			gdRes.setSelectable(false);
			
			data   = SepoaDataMapper.getData(info, gdReq);
			header = MapUtils.getMap(data, "headerData"); // 조회 조건 조회
			header = this.getHeader(info, header); // 조회 조건 조작
			grid   = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			grid   = this.getGrid(header, grid); // 그리드 정보 조작
			
			Object[] obj = {data};
			
			value = ServiceConnector.doService(info, "p1015", "TRANSACTION", "setReqBidCreate", obj);
			
			if(value.flag) {
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
	
	@SuppressWarnings("unused")
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
	
	/**
	 * 문서번호를 따오는 메소드인가?
	 * 
	 * @param info
	 * @param docType
	 * @return String
	 * @throws Exception
	 */
	private String getPrNo(SepoaInfo info, String docType) throws Exception{
		SepoaOut wo   = DocumentUtil.getDocNumber(info, docType);
	    String   prNo = wo.result[0];
	    
	    return prNo;
	}
	
	/**
	 * 서비스에서 사용할 헤더의 정보를 조작하는 메소드
	 * 
	 * @param info
	 * @param header
	 * @return Map
	 * @throws Exception
	 */
	private Map<String, String> getHeader(SepoaInfo info, Map<String, String> header) throws Exception{
		String                    sign_status      = null;
	    String                    sign_date        = null;
		String                    sign_person_id   = null;
		String                    sign_person_name = null;
		String                    sales_type       = null;
		String                    prNo             = null;
		String                    doc_type         = null;
		String                    pr_gubun         = null;
		String                    pc_flag          = null;
		String                    addDate          = null;
		
		sign_status = header.get("sign_status");
		sales_type  = header.get("sales_type");
		doc_type    = header.get("doc_type");
		pr_gubun    = header.get("pr_gubun");
		pc_flag     = header.get("pc_flag");
		addDate     = header.get("add_date");
		
		if("E".equals(sign_status)){
			sign_date        = SepoaDate.getShortDateString();				
			sign_person_id   = info.getSession("ID");
			sign_person_name = info.getSession("NAME_LOC");
		}
		else{
			sign_date        = "";
			sign_person_id   = "";
			sign_person_name = "";
		}
		
		if(pc_flag.equals("true")){
			pc_flag = "Y";
		}
		else{
			pc_flag = "N";
		}
		
		addDate = SepoaString.getDateUnSlashFormat(addDate);
		
		prNo = this.getPrNo(info, doc_type);
		
		header.put("sign_date",        sign_date);
		header.put("sign_person_id",   sign_person_id);
		header.put("sign_person_name", sign_person_name);
		header.put("req_type",         pr_gubun);
		header.put("zexkn",            "01");
		header.put("knttp",            sales_type);
		header.put("prNo",             prNo);
		header.put("prHeadStatus",     "C");
		header.put("order_name",       "");
		header.put("cust_type",        "");
		header.put("dely_to_user",     "");
		header.put("dely_to_phone",    "");
		header.put("pc_flag",          pc_flag);
		header.put("add_date",         addDate);
		
		return header;
	}
	
	/**
	 * 서비스에서 사용할 그리드 정보를 조작하는 메소드
	 * 
	 * @param grid
	 * @return List
	 * @throws Exception
	 */
	private List<Map<String, String>> getGrid(Map<String, String> header, List<Map<String, String>> grid) throws Exception{
		Map<String, String> gridInfo         = null;
		String              prSeq            = null;
		String              purchaseLocation = null;
		String              orderSeq         = null;
		String              req_type         = header.get("req_type");
		String              ktgrm            = null;
		int                 i                = 0;
		int                 gridSize         = grid.size();
		
		for(i = 0; i < gridSize; i++){
			gridInfo         = grid.get(i);
			prSeq            = String.valueOf((i + 1) * 10);
			purchaseLocation = gridInfo.get("PURCHASE_LOCATION");
			orderSeq         = gridInfo.get("ORDER_SEQ");
			ktgrm            = gridInfo.get("KTGRM");
						
			if("".equals(purchaseLocation)){
				purchaseLocation = "01";
			}
			
			if("B".equals(req_type) == false){
				orderSeq = String.valueOf(i + 1);
			}
			
			gridInfo.put("PR_SEQ",             prSeq);
			gridInfo.put("STATUS",             "C");
			gridInfo.put("PR_PROCEEDING_FLAG", "P");
			gridInfo.put("PURCHASE_LOCATION",  purchaseLocation);
			gridInfo.put("ORDER_SEQ",          orderSeq);
			gridInfo.put("PRE_TYPE",           "");
			gridInfo.put("PRE_PO_NO",          "");
			gridInfo.put("PRE_PO_SEQ",         "");
			gridInfo.put("ACCOUNT_TYPE",       ktgrm);
		}
		
		return grid;
	}
}