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

public class qta_bd_lis1 extends HttpServlet {
	
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
			
			if("getCurrentQtaList".equals(mode)){ 					// 견적요청접수현황
				gdRes = this.getCurrentQtaList(gdReq, info);
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
     * 견적진행현황현황 
     * getCurrentQtaList
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2014-10-07
     * @modify 2014-10-07
     */  
	private GridData getCurrentQtaList(GridData gdReq, SepoaInfo info) throws Exception{
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
	    	value = ServiceConnector.doService(info, "s2021", "CONNECTION", "getCurrentQtaList", obj);

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

        String start_date 	= ws.getParam("start_date");
        String end_date 	= ws.getParam("end_date"); 
        String status 		= ws.getParam("status");
        String settle_type 	= ws.getParam("settle_type");
        String subject		= ws.getParam("subject");
        String bid_rfq_type 	= ws.getParam("bid_rfq_type");
		String create_type = CommonUtil.nullToEmpty(ws.getParam("create_type")); 
        
        Object[] obj = {start_date,end_date,status,settle_type,subject,bid_rfq_type, create_type};
        
        SepoaOut value = ServiceConnector.doService(info, "s2021", "CONNECTION", "getCurrentQtaList", obj);

        SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

        int cnt = wf.getRowCount();
        
        for(int i=0; i<cnt; i++) {
            String[] check = {"false", ""};

            String[] img_buyer_comp = {"",wf.getValue("BUYER_COMPANY_NAME", i),wf.getValue("BUYER_COMPANY_NAME", i)};
            String[] img_qta_no = {"",wf.getValue("QTA_NO", i),wf.getValue("QTA_NO", i)};
            String[] img_rfq_no = {"",wf.getValue("RFQ_NO",  i),wf.getValue("RFQ_NO",  i)};
            
            ws.addValue("SELECTED"               , check                                 , "");
            ws.addValue("BUYER_COMPANY_NAME"     , img_buyer_comp                        , "");
            ws.addValue("QTA_NO"                 , img_qta_no                            , "");
            ws.addValue("QTA_STATUS"             , wf.getValue("QTA_STATUS         	", i), "");
            ws.addValue("QTA_DATE"               , wf.getValue("QTA_DATE          	", i), "");
            ws.addValue("QTA_VAL_DATE"           , wf.getValue("QTA_VAL_DATE      	", i), "");
                                                                                  	
            ws.addValue("RFQ_NO"                 , img_rfq_no                     	     , "");
            ws.addValue("RFQ_COUNT"              , wf.getValue("RFQ_COUNT         	", i), "");
            ws.addValue("SETTLE_TYPE"            , wf.getValue("SETTLE_TYPE       	", i), "");
            ws.addValue("SITUATION"              , wf.getValue("SITUATION         	", i), "");
            ws.addValue("SUBJECT"                , wf.getValue("SUBJECT           	", i), "");
                                                                                  	
            ws.addValue("CLOSE_DATE"             , wf.getValue("CLOSE_DATE        	", i), "");
            ws.addValue("ITEM_CNT"               , wf.getValue("ITEM_CNT          	", i), "");
            ws.addValue("CONFIRM_DATE"           , wf.getValue("CONFIRM_DATE      	", i), "");
            ws.addValue("ADD_USER_NAME"          , wf.getValue("ADD_USER_NAME     	", i), "");
            ws.addValue("STATUS"                 , wf.getValue("STATUS            	", i), "");
            
            ws.addValue("BUYER_COMPANY_CODE"     , wf.getValue("BUYER_COMPANY_CODE	", i), "");
            ws.addValue("RFQ_FLAG"               , wf.getValue("RFQ_FLAG          	", i), "");
            ws.addValue("RFQ_CLOSE_DATE"         , wf.getValue("RFQ_CLOSE_DATE    	", i), "");       
        
        }

        ws.setMessage(value.message);
        ws.write();
    }


///////////////////////////////// doData /////////////////////////////////////////////

    public void doData(SepoaStream ws) throws Exception {

        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        String mode = ws.getParam("mode");

        if(mode.equals("setQtDelete")) {
            //SepoaTable로부터 upload된 data을 formatting하여 얻는다.
            SepoaFormater wf = ws.getSepoaFormater();

            String[] QTA_NO = wf.getValue("QTA_NO");
            String[] RFQ_NO = wf.getValue("RFQ_NO");
            String[] RFQ_COUNT = wf.getValue("RFQ_COUNT");

            String setData[][] = new String[wf.getRowCount()][];

            String[] sendobj = new String[3];

            for (int i = 0; i<wf.getRowCount(); i++) {
                String tmp_Data[] = {QTA_NO[i], RFQ_NO[i], RFQ_COUNT[i]};
                setData[i] = tmp_Data;    
            }

            SepoaOut value = setSave(setData,info);

            //SepoaTable에 message를 전송할 수 있다. 또한 script에서 code와 message를 얻을 수 있다.
            sendobj[0] = value.message;
            if( value.status >= 1 ) 
                sendobj[1] = "success";
            else
                sendobj[1] = "fail";

            ws.setUserObject(sendobj);
            ws.setCode(String.valueOf(value.status));
            ws.setMessage(sendobj[0]);
            ws.write();
        }
    }

    public SepoaOut setSave(String[][] setData, SepoaInfo info ) {
        String nickName= "s2021";
        String conType = "TRANSACTION";
        String MethodName = "setQtDelete";
        SepoaOut value = null; 
        SepoaRemote wr = null; 
        Object[] args = {setData};

        try {
            wr = new wise.util.SepoaRemote(nickName,conType,info);
            value = wr.lookup(MethodName,args);
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,"err = " + e.getMessage());
        }finally{
            try{
                wr.Release();
            }catch(Exception e){
            	e.printStackTrace();
            }
        }
        return value;
    }*/

}


