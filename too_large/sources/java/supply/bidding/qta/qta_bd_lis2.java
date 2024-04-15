package supply.bidding.qta;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
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

import com.icompia.util.CommonUtil;

public class qta_bd_lis2 extends HttpServlet {
	
private static final long serialVersionUID = 1L;

public void init(javax.servlet.ServletConfig config) throws ServletException {Logger.debug.println();}

public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
	this.doPost(req, res);
}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
		GridData  gdReq = null;
		GridData  gdRes = new GridData();
		String    mode  = null;
		SepoaFormater sf = null;
		
		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		try {
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
			
			if("getCompanyQtaList".equals(mode)){ 					// 견적결과현황
				gdRes = this.getCompanyQtaList(gdReq, info);
			}
			
		}
		catch (Exception e) {
			gdRes.setMessage("Error: " + e.getMessage());
			gdRes.setStatus("false");
			
		}finally {
			try{
				OperateGridData.write(req, res, gdRes, out);
			}
			catch (Exception e) {
				Logger.debug.println();
			}
		}
	}

	
	/**
	 * 견적결과현황 
	 * getCompanyQtaList
	 * @param  gdReq
	 * @param  info
	 * @return GridData
	 * @throws Exception
	 * @since  2014-10-07
	 * @modify 2014-10-07
	 */
	private GridData getCompanyQtaList(GridData gdReq, SepoaInfo info) throws Exception {
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
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids"));
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	
	    	
	    	
	    	
	    		
	    	gdRes.addParam("mode", "doQuery");
	    	
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "s2021", "CONNECTION", "getCompanyQtaList", obj);
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
	
	
	
	
	
	
	
    /*public void doQuery(SepoaStream ws) throws Exception {

        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
    	Message msg = new Message("STDCOMM");
        String mode = ws.getParam("mode");

        if(mode.equals("getCompanyQtaList"))
        {
            String start_date   = ws.getParam("start_date");
            String end_date     = ws.getParam("end_date"); 
            String settle_flag  = ws.getParam("settle_flag");
            String subject      = ws.getParam("subject");
            String st_rfq_no    = ws.getParam("rfq_no");
        	String bid_rfq_type = ws.getParam("bid_rfq_type");
			String create_type  = CommonUtil.nullToEmpty(ws.getParam("create_type")); 

			// create_type = all
			create_type = "";
			
			String[] args = {info.getSession("HOUSE_CODE"), start_date, end_date, info.getSession("COMPANY_CODE"), st_rfq_no, settle_flag, subject, bid_rfq_type, create_type};
            Object[] obj = {args }; 
            SepoaOut value = ServiceConnector.doService(info, "s2021", "CONNECTION", "getCompanyQtaList", obj);

            SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

			if(wf.getRowCount() == 0) 
			{ 
				ws.setMessage(msg.getMessage("0008"));
				ws.write();
				return;
	  	    }
		
            int cnt = wf.getRowCount();
            
            for(int i=0; i<cnt; i++) 
            {
            	String[] check = {"false", ""};      
            	String[] img_rfq_no = {"", wf.getValue("RFQ_NO" ,i), wf.getValue("RFQ_NO" ,i)};    
            	String[] img_qta_no = {"", wf.getValue("QTA_NO" ,i), wf.getValue("QTA_NO" ,i)};     
 
            	          
            	ws.addValue("SELECTED"              , check								 	     , "");
            	ws.addValue("RFQ_NO"   				, img_rfq_no							     , "");
            	ws.addValue("RFQ_COUNT"        		, wf.getValue("RFQ_COUNT           		" ,i), "");
            	ws.addValue("SUBJECT"        		, wf.getValue("SUBJECT       			" ,i), "");
            	ws.addValue("CHANGE_USER_NAME_LOC"  , wf.getValue("CHANGE_USER_NAME_LOC     " ,i), "");
            	ws.addValue("QTA_NO"             	, img_qta_no, "");
            	ws.addValue("VENDOR_NAME"        	, wf.getValue("VENDOR_NAME         		" ,i), "");
            	ws.addValue("SETTLE_FLAG"        	, wf.getValue("SETTLE_FLAG             	" ,i), "");
            	ws.addValue("PO_CREATE_DATE"        , wf.getValue("PO_CREATE_DATE           " ,i), "");
            	ws.addValue("ITEM_NO"				, wf.getValue("ITEM_NO      			" ,i), "");
            	ws.addValue("DESCRIPTION_LOC"		, wf.getValue("DESCRIPTION_LOC          " ,i), "");
            	ws.addValue("RFQ_QTY"				, wf.getValue("RFQ_QTY           		" ,i), "");
            	ws.addValue("UNIT_MEASURE"          , wf.getValue("UNIT_MEASURE       		" ,i), "");
            	ws.addValue("CUR"        			, wf.getValue("CUR       				" ,i), "");
            	ws.addValue("CUSTOMER_PRICE"		, wf.getValue("CUSTOMER_PRICE           " ,i), "");
            	ws.addValue("CUSTOMER_AMT"			, "0", "");
            	ws.addValue("SUPPLY_PRICE"		    , wf.getValue("UNIT_PRICE      			" ,i), "");
            	ws.addValue("SUPPLY_AMT"	    	, wf.getValue("ITEM_AMT      			" ,i), "");
            	ws.addValue("RD_DATE"      			, wf.getValue("RD_DATE         			" ,i), "");
            	ws.addValue("PR_NO"    			    , wf.getValue("PR_NO            		" ,i), ""); 
            }
            ws.setMessage(value.message);
            ws.write();
        }
        else
        {
            String vendor_code = ws.getParam("vendor_code");
            String rfq_no = ws.getParam("rfq_no");
            String rfq_count = ws.getParam("rfq_count");

            String data[] = {vendor_code,rfq_no,rfq_count};

            SepoaOut result = getQueryP(data, info);


            //결과값을 SepoaTable에서 조작가능하게 formatting한다.
            SepoaFormater wf = ws.getSepoaFormater(result.result[0]);
            int cnt = wf.getRowCount();
            //데이타가 있는 경우

            for(int i=0; i<cnt; i++) {

                ws.addValue(0, wf.getValue(i, 0), "");// 자재코드
                ws.addValue(1, wf.getValue(i, 1), ""); //내역
                ws.addValue(2, wf.getValue(i, 2), "");//단위
                ws.addValue(3, wf.getValue(i, 3), "");//수량
                ws.addValue(4, wf.getValue(i, 4), "");//배분율
            }

            //데이타가 없는 경우
            if(cnt == 0)
                ws.setMessage("조회된 데이타가 없습니다.");
            else
                ws.setMessage("QUERYED...");
            ws.write();
        }
    }

    public SepoaOut getQueryP(String[] data,SepoaInfo info)
    {
        Object[] args = {data};
        SepoaOut value = null;
        SepoaRemote wr = null;
        String nickName = "s2021";
        String MethodName = "getCompanyQtaListPopup";
        String conType = "CONNECTION";

        //다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
        try {
            wr = new sepoa.util.SepoaRemote(nickName,conType,info);
            value = wr.lookup(MethodName,args);
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
            Logger.dev.println(e.getMessage());
        }finally{
            try{
                wr.Release();
            }catch(Exception e){
            	e.printStackTrace();
            }
        }
        return value;
    }

///////////////////////////////// doData /////////////////////////////////////////////
*/

}
