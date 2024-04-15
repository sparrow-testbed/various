package dt.ebd;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

/**
 * 
 * @author tykim
 * 
 */
public class ebd_bd_ins4_main extends HttpServlet{
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

			if("setReqBidChange".equals(mode)){ // 구매요청 수정
				gdRes = this.setReqBidChange(gdReq, info);
			}
			else if("getReqBidDTDisplayChange".equals(mode)){ // 구매요청 수정
				gdRes = this.getReqBidDTDisplayChange(gdReq, info);
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
    
    private Map<String, String> setReqBidChangeHeader(Map<String, String> header, SepoaInfo info) throws Exception{
    	String signStatus      = header.get("sign_status");
    	String salesType       = header.get("sales_type");
    	String addDate         = header.get("add_date");
    	String scmsCustType    = header.get("scms_cust_type");
    	String signAttachNo    = header.get("sign_attach_no");
    	String id              = info.getSession("ID");
    	String nameLoc         = info.getSession("NAME_LOC");
    	String shortDateString = SepoaDate.getShortDateString();
    	String signDate        = null;
		String signPersonId    = null;
		String signPersonName  = null;
		
		if("E".equals(signStatus)){
			signDate       = shortDateString;
			signPersonId   = id;
			signPersonName = nameLoc;
		}
		else{
			signDate       = "";
			signPersonId   = "";
			signPersonName = "";
		}
		
		addDate = SepoaString.getDateUnSlashFormat(addDate);
		
		header.put("sign_date",        signDate);
		header.put("sign_person_id",   signPersonId);
		header.put("sign_person_name", signPersonName);
		header.put("req_type",         "B");
		header.put("zexkn",            "01");
		header.put("knttp",            salesType);
		header.put("cust_type",        scmsCustType);
		header.put("attach_no",        signAttachNo);
		header.put("add_date",         addDate);
		
    	return header;
    }
    
    private List<Map<String, String>> setReqBidChangeGrid(Map<String, String> header, List<Map<String, String>> grid, SepoaInfo info) throws Exception{
    	Map<String, String> gridInfo     = null;
    	String              house_code   = info.getSession("HOUSE_CODE");
    	String              company_code = info.getSession("COMPANY_CODE");
    	String              plan_code    = header.get("plan_code");
    	String              add_user_id  = header.get("add_user_id");
    	String              knttp        = header.get("knttp");
    	String              zexkn        = header.get("zexkn");
    	String              order_no     = header.get("order_no");
    	String              strPR_NO     = null;
    	String              prSeq        = null;
    	String              rdDate       = null;
    	int                 i            = 0;
    	int                 gridSize     = grid.size();
    	
    	gridInfo = grid.get(0);
    	strPR_NO = gridInfo.get("PR_NO");
		
    	for(i = 0; i < gridSize; i++){
    		gridInfo = grid.get(i);
    		prSeq    = String.valueOf((i + 1) * 10);
    		rdDate   = gridInfo.get("RD_DATE");
    		rdDate   = rdDate.replace("-", "");
    		rdDate   = rdDate.replace("/", "");
    		
    		gridInfo.put("HOUSE_CODE",         house_code);
    		gridInfo.put("PR_NO",              strPR_NO);
    		gridInfo.put("PR_SEQ",             prSeq);
    		gridInfo.put("STATUS",             "C");
    		gridInfo.put("COMPANY_CODE",       company_code);
    		gridInfo.put("PLANT_CODE",         plan_code);
    		gridInfo.put("PR_PROCEEDING_FLAG", "P");
    		gridInfo.put("add_user_id",        add_user_id);
    		gridInfo.put("knttp",              knttp);
    		gridInfo.put("zexkn",              zexkn);
    		gridInfo.put("order_no",           order_no);
    		gridInfo.put("order_count",        "");
    		gridInfo.put("RD_DATE",            rdDate);
    	}
    	
    	return grid;
    }
    
    @SuppressWarnings({ "unchecked", "rawtypes" })
	private GridData setReqBidChange(GridData gdReq, SepoaInfo info) throws Exception {
		GridData                  gdRes       = new GridData();
	    Vector                    multilangId = new Vector();
	    HashMap                   message     = null;
	    SepoaOut                  value       = null;
	    Map<String, Object>       data        = null;
		Map<String, String>       header      = null;
		List<Map<String, String>> grid        = null;
	    
	    multilangId.addElement("MESSAGE");
	    
		message = MessageUtil.getMessage(info, multilangId);
		
		try {
			gdRes.addParam("mode", "doSave");
			gdRes.setSelectable(false);
			
			data   = SepoaDataMapper.getData(info, gdReq);
			header = MapUtils.getMap(data, "headerData"); // 조회 조건 조회
			header = this.setReqBidChangeHeader(header, info); // 헤더 설정
			
			header.put( "add_date          ".trim(), SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "add_date" ) )          );
			header.put( "contract_hope_day ".trim(), SepoaString.getDateUnSlashFormat( MapUtils.getString( header, "contract_hope_day" ) ) );
			
			grid   = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			grid   = this.setReqBidChangeGrid(header, grid, info); // 그리드 설정
			
			Object[] obj = {data};
			
			value = ServiceConnector.doService(info, "p1015", "TRANSACTION", "setReqBidChangePur", obj);
			
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
    
    /**
     * 조회 예제
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getReqBidDTDisplayChange(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "p1015", "CONNECTION","ReqBidDTQueryDisplay_Change", obj);
	
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
			    			else if("RD_DATE".equals(gridColAry[k])){
			    				String        rdDate       = null;
			    		    	String        rdDateYear   = null;
			    		    	String        rdDateMonth  = null;
			    		    	String        rdDateDate   = null;
			    		    	StringBuffer  stringBuffer = null;
			    		    	
			    				stringBuffer = new StringBuffer();
			    				
			    				rdDate      = sf.getValue("RD_DATE", i);
			    				rdDateYear  = rdDate.substring(0, 4);
			    				rdDateMonth = rdDate.substring(4, 6);
			    				rdDateDate  = rdDate.substring(6);
			    				
			    				stringBuffer.append(rdDateYear).append("/").append(rdDateMonth).append("/").append(rdDateDate);
			    				
			    				rdDate = stringBuffer.toString();
			    				
			    				
			    				
			    				gdRes.addValue("RD_DATE", rdDate);
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
}