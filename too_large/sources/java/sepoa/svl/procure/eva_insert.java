package sepoa.svl.procure;

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
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class eva_insert extends HttpServlet 
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
			if ("getEvaList".equals(mode)) {
				gdRes = getEvaList(gdReq, info); // 조회
			}else if("getEvaInsert".equals(mode)){
				gdRes = getEvaInsert(gdReq, info);
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
	
    //=========================================================================================================
    public GridData getEvaList(GridData gdReq, SepoaInfo info) throws Exception 
    {
        String processId = "p40";
        
        GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message 	 	= MessageUtil.getMessage(info, multilang_id);
        boolean isOk     = true;        
		String msg_value = "";

        String evaltemp_num = gdReq.getParam("evaltemp_num");
        String sg_refitem = gdReq.getParam("sg_refitem");
        String mode_type = gdReq.getParam("mode_type");
        try {
			Map<String, String> headerData = new HashMap<String,String>();
			headerData.put("evaltemp_num",evaltemp_num);
			headerData.put("sg_refitem",sg_refitem);
			headerData.put("mode_type",mode_type);

			String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");

			Object[] obj = { headerData };
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "SR_019", "CONNECTION", "getEvaList", obj);

			if (value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
				return gdRes;
			}

			SepoaFormater wf = new SepoaFormater(value.result[0]);

			if (wf.getRowCount() == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString());
				return gdRes;
			}

			for (int i = 0; i < wf.getRowCount(); i++) {
				for (int k = 0; k < grid_col_ary.length; k++) {
					if(grid_col_ary[k] != null && grid_col_ary[k].equals("vendor_name")) {
						gdRes.addValue(grid_col_ary[k],	wf.getValue("NAME_LOC", i));
			    	}else{
					gdRes.addValue(grid_col_ary[k],	wf.getValue(grid_col_ary[k], i));
                	}
				}
			}

		} catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		return gdRes;
    }

    //=========================================================================================================

    //=========================================================================================================
    private String chkNull(String value) {
        if("".equals(value)){
           value = "0";
        }
        return value;
    }
    private String setZero(String value){
        if(value.indexOf(".") != -1 ){
           int decimal = Integer.parseInt(value.substring(value.indexOf(".")+1, value.length()));
           if(decimal == 0 ){
              value = value.substring(0,value.indexOf("."));
           }
      }
        return value;
    }

//	public void doData( SepoaStream ws ) throws Exception
//	{
//	   	String screenId = "eva_bd_ins1";
//        String processId = "p40";
//        
//        SepoaInfo info 	= SepoaSession.getAllValue(ws.getRequest());
//        String language = info.getSession("LANGUAGE");	
//		Message msg 	= new Message(language, processId); 
//		SepoaFormater wf = ws.getSepoaFormater();
//
//        boolean isOk     = true;        
//        String message   = "";
//		String msg_value = "";
//
//		String evalname  	= ws.getParam( "evalname" );
//		String fromdate  	= ws.getParam( "fromdate" );
//		String todate  		= ws.getParam( "todate" );
//		String evaltemp_num	= ws.getParam( "evaltemp_num" );
//		String flag			= ws.getParam( "flag" );
//
//		String[] vendor_code   			= wf.getValue("vendor_code");
//		String[] qty_yn   				= wf.getValue("qty_yn");
//		String[] sg_refitem				= wf.getValue("sg_refitem");
//		String[] value_id				= wf.getValue("value_id");
//
//		String setData[][] = new String[wf.getRowCount()][];
//
//		for (int i = 0; i<wf.getRowCount(); i++) 
//		{
//			String Data[] = { vendor_code[i], qty_yn[i], sg_refitem[i], value_id[i]};
//			setData[i] = Data;
//		}
//
//		// 해당클래스, 메소드, nickName, ConType을 Mapping한다.
//		SepoaOut value = setSave(info, setData, evalname, fromdate, todate,
//								evaltemp_num, flag);
//
//		if ( value.status != 1 )	
//		{
//			isOk = false;
//		}else{
//			isOk = true;
//		}
//
//		//등록중 오류가 발생하였다면...
//		if ( ! isOk ){
//			msg.setArg( "SCREEN_ID", screenId );
//			msg_value = msg.getMessage( "0004" );
//			ws.setMessage( msg_value );
//			String [] userObject = {msg_value, "F" };
//			ws.setUserObject( userObject );
//		}
//		else
//		{
//			msg.setArg( "SCREEN_ID", screenId );
//			msg_value = msg.getMessage( "0013" );
//			ws.setMessage( msg_value );
//			String [] userObject = {msg_value, "S" };
//			ws.setUserObject( userObject );
//		}		
//
//		ws.write();
//		return;
//	}   

	public GridData getEvaInsert(GridData gdReq, SepoaInfo info) throws Exception
	{
//		String serviceId = "p0080";
//		String conType = "TRANSACTION";
//		String MethodName = "setEvabdins1";

		GridData gdRes   		= new GridData();
	    Vector multilang_id 	= new Vector();
	    multilang_id.addElement("MESSAGE");
	    HashMap message = MessageUtil.getMessage(info, multilang_id);


		// 다음은 실행할 class을 =loading하고 Method호출수 결과를 return하는 부분
	    try {
			gdRes.addParam("mode", "doSave");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Map<String, String> header = MapUtils.getMap(data, "headerData");
			header.put("flag", JSPUtil.CheckInjection(gdReq.getParam("flag")).trim());
			Object[] obj = {data};
			SepoaOut value = ServiceConnector.doService(info, "SR_019", "TRANSACTION","getEvaInsert", obj);
			
			if(value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
				gdRes.setStatus("true");
			}else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
			}
		} catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
			gdRes.setStatus("false");
		}
		
	    return gdRes;
	}

}
