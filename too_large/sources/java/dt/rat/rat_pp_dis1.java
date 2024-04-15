package dt.rat;

import java.util.*;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;

import java.io.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class rat_pp_dis1 extends HttpServlet {

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
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getratbddis1_1".equals(mode)){
    			gdRes = this.getratbddis1_1(gdReq, info);
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
	private GridData getratbddis1_1(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	    	value = ServiceConnector.doService(info, "p1008", "CONNECTION","getratbddis1_1", obj);
	
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

//    public void doQuery(WiseStream ws) throws Exception {
//        WiseInfo info = WiseSession.getAllValue(ws.getRequest());
//        String house_code = info.getSession("HOUSE_CODE");
//        String mode = ws.getParam("mode");
//        Logger.debug.println(info.getSession("ID"), this, "################################111111111111111");
//
//        if(mode.equals("getratbddis1_1")) {
//        	
//            String RA_NO = ws.getParam("RA_NO");
//            String RA_COUNT   = ws.getParam("RA_COUNT");
//            String[] args = {house_code, RA_NO, RA_COUNT};
//            Object[] obj = {args};
//
//            WiseOut out = getratbddis1_1(info, args );
//            //WiseOut out = ServiceConnector.doService(info, "p1008", "CONNECTION","getratbddis1_1", obj);
//            WiseFormater wf = ws.getWiseFormater(out.result[0]);
//
//            if(wf == null) { //����Ÿ ������ ��Ȯ���� �������
//                ws.setCode("M001");
//                ws.setMessage("����Ÿ ������ ��Ȯ���� �ʽ��ϴ�.");
//                ws.write();
//
//                return;
//            }
//
//            if(wf.getRowCount() == 0) { //����Ÿ�� ��� ���
//                ws.setCode("M001");
//                ws.setMessage("��ȸ�� ����Ÿ�� ����ϴ�.");
//                ws.write();
//
//                return;
//            }
//
//
//
//            for(int i=0; i<wf.getRowCount(); i++) { //����Ÿ�� �ִ� ���
//
//            	//String[] img_item_no  = {"", wf.getValue("ITEM_NO",i), wf.getValue("ITEM_NO",i)};	
//                
//            	ws.addValue("PR_NO",              	wf.getValue("PR_NO"             	,i)    , "" );
//            	ws.addValue("PR_SEQ",       		wf.getValue("PR_SEQ"         		,i)    , "" );
//            	ws.addValue("BUYER_ITEM_NO",        wf.getValue("ITEM_NO"				,i)    , "" );
//            	ws.addValue("DESCRIPTION_LOC",  	wf.getValue("DESCRIPTION_LOC"   	,i)    , "" );
//            	ws.addValue("UNIT_MEASURE",     	wf.getValue("UNIT_MEASURE"      	,i)    , "" );
//            	ws.addValue("SPECIFICATION",     	wf.getValue("SPECIFICATION"         ,i)    , "" );
//                ws.addValue("RD_DATE",     			wf.getValue("RD_DATE"              	,i)    , "" );
//                ws.addValue("DELY_TO_LOCATION_NAME",wf.getValue("DELY_TO_LOCATION_NAME"	,i)    , "" );
//                ws.addValue("PURCHASE_LOCATION",    wf.getValue("PURCHASE_LOCATION"     ,i)    , "" );
//                ws.addValue("DELY_TO_LOCATION",     wf.getValue("DELY_TO_LOCATION"		,i)    , "" );
//                ws.addValue("Z_CODE1",          	""    , "" );
//            } 
//        }
//
//        ws.setMessage("���������� �۾��� �����Ͽ����ϴ�..");
//        ws.write();
//    }
//
//    public WiseOut getratbddis1_1(WiseInfo info, String [] args) {
//        Object[] obj = {args};
//        WiseOut rtn = null;
//        WiseRemote wr = null;
//
//        String nickName = "p1008";
//        String MethodName = "getratbddis1_1";
//        String conType = "CONNECTION";
//
//        try {
//            wr = new WiseRemote(nickName, conType, info);
//            rtn = wr.lookup(MethodName, obj);
//        }catch(Exception e) {
//            Logger.dev.println(info.getSession("ID"), this, "servlet Exception = " + e.getMessage());
//        }finally{
//            try{
//                wr.Release();
//            }catch(Exception e){
//            	e.printStackTrace();
//            }
//        }
//
//        return rtn;
//    }
//
//    public String checkNull(String value) {
//        if(value == null) value = null;
//        else if(value.trim().equals("")) value = null;
//        return value;
//    }
//
//    public String null2Void(String pStr)  {
//        try {
//            if (pStr == null) {
//                return "";
//            } else {
//                return pStr.trim();
//            }
//        } catch (Exception e) {
//                  return "";
//       }
//    }

}
