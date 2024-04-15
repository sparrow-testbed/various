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

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class evaluator_list extends HttpServlet 
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
			if ("getEvaluatorList".equals(mode)) {
				gdRes = getEvaluatorList(gdReq, info); // 조회
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
    public GridData getEvaluatorList(GridData gdReq, SepoaInfo info) throws Exception 
    {
        
        GridData gdRes = new GridData();
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

		try {
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq); // 그리드

			String grid_col_id = JSPUtil.CheckInjection(
					gdReq.getParam("grid_col_id")).trim();
			String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "doQuery");

			Object[] obj = { data };
			// DB 연결방법 : CONNECTION, TRANSACTION, NONDBJOB
			SepoaOut value = ServiceConnector.doService(info, "SR_020", "CONNECTION", "getEvaluatorList", obj);

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
					gdRes.addValue(grid_col_ary[k],	wf.getValue(grid_col_ary[k], i));

				}
			}

		} catch (Exception e) {
			gdRes.setMessage(message.get("MESSAGE.1002").toString());
			gdRes.setStatus("false");
		}
		return gdRes;
    }

    //=========================================================================================================
    public SepoaOut getQuery(String USER_ID, String USER_NAME, SepoaInfo info) 
    {
        Object[] args = {USER_ID, USER_NAME};

        SepoaOut value = null;
        SepoaRemote wr = null;

        String nickName = "p0080";
        String MethodName = "getEvappins1";  
        String conType = "CONNECTION";

        try {
            wr = new SepoaRemote(nickName,conType,info);
            value = wr.lookup(MethodName,args);
        }catch(Exception e) {
            Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
            Logger.dev.println(e.getMessage());
        }finally{
            try{
                if(wr != null){ wr.Release(); }
            }catch(Exception e){
            	Logger.debug.println();
            }
        }
        return value;
    }

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
}
