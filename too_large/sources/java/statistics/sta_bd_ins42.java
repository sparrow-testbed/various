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
import sepoa.fw.mail.MailSendHistory;
import sepoa.fw.mail.MailSendVo;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class sta_bd_ins42 extends HttpServlet{
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
				//this.testSendMail(info);
				
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
	private void testSendMail(SepoaInfo info){
    	try{
    		Vector          reciveMailVector = new Vector();
    		Vector          recieveMailName  = new Vector();
    		MailSendHistory msh              = new MailSendHistory();
        	MailSendVo      vo               = new MailSendVo();
    		String          mailTitle        = "이메일 여러건 테스트 발송";
    		String          contents         = "<html><head></head><body>오늘도 행복한 하루 보내세요~</body></html>";
    		
    		reciveMailVector.addElement("90129682@woorifg.com");
    		reciveMailVector.addElement("tytolee@msn.com");
    		recieveMailName.addElement("이정훈");
    		recieveMailName.addElement("김정훈");
    		
        	vo.setContents(contents);
        	vo.setDoc_type("type");
        	vo.setM_to_values(reciveMailVector);
        	vo.setM_to_name_values(recieveMailName);
        	vo.setSender_addr("90129683@woorifg.com");
        	vo.setSubject(mailTitle);
        	
    		msh.setMailSendHistory(vo, info);
    	}
    	catch(Exception e){
    		this.loggerExceptionStackTrace(e);
    		
    		Logger.debug.println("으앙~ 메일 발송 안되~");
    	}
    	
    	try{
    		Map<String, String> map = new HashMap<String, String>();
    		
    		map.put("title", "야옹");
    		map.put("content", "멍멍");
    		
    		Object[] obj = {map};
    		
    		ServiceConnector.doService(info, "SMS", "TRANSACTION", "smsTest1", obj);
    	}
    	catch(Exception e){
    		this.loggerExceptionStackTrace(e);
    		
    		Logger.debug.println("으앙~ SMS 발송 안되~");
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
			
			

			value = ServiceConnector.doService(info, "p7008", "TRANSACTION", "setStaPubInsert", obj);
//			System.out.println("setPrCreate : ..........5555");
			if(value.flag) {
				gdRes.setMessage(value.message); 
				gdRes.setStatus("true");
			}
			else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
//			System.out.println("setPrCreate : ..........6666"+value.message);
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
		String   sign_date       = null;
		String   sign_person_id  = null;
		String   sign_person_name = null;
		
		String   house_code      = null;
	    String   co_no           = null;
		String   vendor_code     = null;
		String   vendor_name_loc = null;
		String   ceo_name_loc    = null;
		String   address_loc     = null;
		String   phone_no1       = null;
		String   irs_no          = null;
		String   company_reg_no  = null;
		
		String   purpose         = null;
	    String   present         = null;
		String   itype           = null;
		String   purcheser_id    = null;
		String   purcheser_name  = null;
		String   dept            = null;
		String   dept_name       = null;
		String   position        = null;
		String   position_name   = null;	
		
		String   issued_date     = null;
	    String   print_cnt       = null;
		String   status          = null;
		String   add_date        = null;
		String   add_time        = null;
		String   add_user_id     = null;
		String   change_date     = null;
		String   change_time     = null;
		String   change_user_id  = null;		
		
		sign_date        = SepoaDate.getShortDateString();				
		sign_person_id   = info.getSession("ID");
		sign_person_name = info.getSession("NAME_LOC");	
		
		house_code      = header.get("house_code");
	    co_no           = "";//header.get("vendor_name");
		vendor_code     = header.get("vendor_code");
		vendor_name_loc = header.get("vendor_name");
		ceo_name_loc    = header.get("ceo_name");
		address_loc     = header.get("address");
		phone_no1       = header.get("tel_no");
		irs_no          = header.get("irs_no");
		company_reg_no  = header.get("company_reg_no");		
		vendor_name_loc = header.get("vendor_name");
		
		purpose         = "";//header.get("vendor_name");
	    present         = "";//header.get("vendor_name");
		itype           = "";//header.get("vendor_name");
		purcheser_id    = "";//header.get("vendor_name");
		purcheser_name  = "";//header.get("vendor_name");
		dept            = "";//header.get("vendor_name");
		dept_name       = "";//header.get("vendor_name");
		position        = "";//header.get("vendor_name");
		position_name   = "";//header.get("vendor_name");			
		issued_date     = "";//header.get("vendor_name");
	    print_cnt       = "";//header.get("vendor_name");
		status          = "";//header.get("vendor_name");
		add_date        = "";//header.get("vendor_name");
		add_time        = "";//header.get("vendor_name");
		add_user_id     = "";//header.get("vendor_name");
		change_date     = "";//header.get("vendor_name");
		change_time     = "";//header.get("vendor_name");
		change_user_id  = "";//header.get("vendor_name");			

	
		header.put("house_code",                 house_code        );
	    header.put("vendor_name",                  co_no           );
		header.put("vendor_code",                  vendor_code     );
		header.put("vendor_name",                  vendor_name_loc );
		header.put("ceo_name",                    ceo_name_loc     );
		header.put("address",                      address_loc     );
		header.put("tel_no",                       phone_no1       );
		header.put("irs_no",                       irs_no          );
		header.put("company_reg_no",             company_reg_no    );		
		header.put("vendor_name",	             vendor_name_loc   );	


//		System.out.println("getHeader....."+house_code);
	//	System.out.println("getHeader....."+co_no);
	//	System.out.println("getHeader....."+vendor_code);
	//	System.out.println("getHeader....."+vendor_name_loc);
	//	System.out.println("getHeader....."+ceo_name_loc);
	//	System.out.println("getHeader....."+address_loc);
	//	System.out.println("getHeader....."+phone_no1);
	//	System.out.println("getHeader....."+irs_no);
	//	System.out.println("getHeader....."+company_reg_no);
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
		String              selected            = null;
		String              subject          = null;
		String              item_no          = null;
		String              item_name        = null;
		String              contract_to_date = null;
		String              unit_measure     = null;
		String              po_number        = null;
		String              po_amt           = null;		
		int                 i                = 0;
		int                 gridSize         = grid.size();
		
		for(i = 0; i < gridSize; i++){
			gridInfo         = grid.get(i);
			subject          = gridInfo.get("SUBJECT");
			item_no          = gridInfo.get("ITEM_NO");
			item_name        = gridInfo.get("ITEM_NAME");
			contract_to_date = gridInfo.get("CONTRACT_TO_DATE");
			unit_measure     = gridInfo.get("UNIT_MEASURE");
			po_number        = gridInfo.get("PO_NUMBER");
			po_amt           = gridInfo.get("PO_AMT");
//			prSeq            = String.valueOf((i + 1) * 10);
//			purchaseLocation = gridInfo.get("PURCHASE_LOCATION");
//			orderSeq         = gridInfo.get("ORDER_SEQ");
						
//			if("".equals(purchaseLocation)){
//				purchaseLocation = "01";
//			}
//			
//			if("B".equals(req_type) == false){
//				orderSeq = String.valueOf(i + 1);
//			}
			
			gridInfo.put("SUBJECT",             subject);
			gridInfo.put("ITEM_NO",             item_no);
			gridInfo.put("ITEM_NAME",           item_name);
			gridInfo.put("CONTRACT_TO_DATE",    contract_to_date);
			gridInfo.put("UNIT_MEASURE",          unit_measure);
			gridInfo.put("PO_NUMBER",           po_number);
			gridInfo.put("PO_AMT",          po_amt);
			
//			System.out.println("getGrid.....item_name ="+item_name + ", po_amt ="+ po_amt);
			

		}
		
		return grid;
	}
}