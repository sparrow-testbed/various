package master.user;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class use_bd_lis2  extends HttpServlet 
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
			if ("getInfoList".equals(mode)) {
				//gdRes = getInfoList(gdReq, info); // 조회
				Logger.debug.println();
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
}
	
	/*public void doQuery(SepoaStream ws) throws Exception   //사용자승인-조회
	{

		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());

		String house_code = info.getSession("HOUSE_CODE");

		String i_user_id        = ws.getParam("i_user_id");
		String i_user_name_loc  = ws.getParam("i_user_name_loc");
		String i_company_code   = ws.getParam("i_company_code");
		String i_dept           = ws.getParam("i_dept");
		String i_sign_status    = ws.getParam("i_sign_status");
		String i_user_type      = ws.getParam("i_user_type");
		String i_work_type      = ws.getParam("i_work_type");
		
		String setData[] = {
				  house_code
				, i_user_id
				, i_user_name_loc
				, i_company_code
				, i_dept
				, i_user_type
				, i_work_type
		};
		
		Object[] obj = {i_sign_status, setData};
		SepoaOut value = ServiceConnector.doService(info, "p0030", "CONNECTION","getMainternace", obj);
		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

		if(wf.getRowCount() == 0)
		{
			ws.setCode("M001");
			ws.setMessage(msg.getMessage("0008"));
			ws.write();
			return;
		}
		
		for(int i = 0; i < wf.getRowCount(); i++)
		{
			String check[] = {"false", ""};
			String image_text[] = {"/kr/images/button/query.gif", wf.getValue("MENU_NAME",i), wf.getValue("MENU_PROFILE_CODE",i)};
			
			ws.addValue("SEL"               , check, "");
			ws.addValue("USER_ID"           , wf.getValue("USER_ID"         , i), "");
			ws.addValue("USER_NAME_LOC"     , wf.getValue("USER_NAME_LOC"   , i), "");
			ws.addValue("COMPANY_NAME"      , wf.getValue("COMPANY_NAME"    , i), "");
			ws.addValue("TEXT_WORK_TYPE"    , wf.getValue("TEXT_WORK_TYPE"  , i), "");
			ws.addValue("DEPT_NAME"         , wf.getValue("DEPT_NAME"       , i), "");
			ws.addValue("POSITION"          , wf.getValue("POSITION"        , i), "");
			ws.addValue("MANAGER_POSITION"  , wf.getValue("MANAGER_POSITION", i), "");
			ws.addValue("PHONE_NO"          , wf.getValue("PHONE_NO"        , i), "");
			ws.addValue("MENU_NAME"         , image_text, "");
			ws.addValue("HOUSE_CODE"        , wf.getValue("HOUSE_CODE"     , i), "");
			ws.addValue("USER_TYPE"         , wf.getValue("USER_TYPE"     , i), "");
			ws.addValue("LOGIN_NCY_NAME"    , wf.getValue("LOGIN_NCY_NAME"     , i), "");
		}

		ws.setCode("M001");
		ws.setMessage(value.message);
		ws.write();
	}
	

	public void doData(SepoaStream ws) throws Exception
    {
		String mode = ws.getParam("mode");
		if(mode.equals("setApproval"))
		{
			setApproval(ws, mode);
		}
		else if(mode.equals("setDelete"))
		{
			setDelete(ws, mode);
			
		} 
		else if(mode.equals("setStatusD"))
		{
//			setStatusD(ws, mode);
		}
        
    }

// 사용자승인 - 승인 
	private void setApproval(SepoaStream ws, String mode) throws Exception
	{
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        SepoaFormater wf = ws.getSepoaFormater();
        
        String HOUSE_CODE[] = wf.getValue("HOUSE_CODE");
        String USER_ID[]    = wf.getValue("USER_ID");
        String MENU_NAME[]  = wf.getValue("MENU_NAME");
        
        
        String setData[][] = new String[wf.getRowCount()][];
        
        for(int i = 0; i < wf.getRowCount(); i++)
        {
            String Data[] = {MENU_NAME[i], HOUSE_CODE[i], USER_ID[i]};
            setData[i] = Data;
        }

        SepoaOut value = ServiceConnector.doService(info, "p0030", "TRANSACTION","setApproval", setData);
        String userObject[] = {value.message};
        ws.setUserObject(userObject);
        ws.setCode(value.status+"");
        ws.setMessage(value.message);
        ws.write();
	}
	
	
// 사용자승인 - 삭제 &  사용자현황-삭제(A72)	
	private void setDelete(SepoaStream ws, String mode) throws Exception
	{
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		SepoaFormater wf = ws.getSepoaFormater();

		String i_mode = ws.getParam("i_mode");

		String HOUSE_CODE[] = wf.getValue("HOUSE_CODE");
		String USER_ID[]    = wf.getValue("USER_ID");
		
		int iRowCount = wf.getRowCount();
		String args_user[][] = new String[iRowCount][];
		String args_addr[][] = new String[iRowCount][];

		for(int i = 0; i < iRowCount; i++)
		{
			String temp_user[] = {HOUSE_CODE[i], USER_ID[i]};
			args_user[i] = temp_user;
			String temp_addr[] = {HOUSE_CODE[i], USER_ID[i]};
			args_addr[i] = temp_addr;
		}
		
		Object[] obj = {args_user, args_addr};
        SepoaOut value = ServiceConnector.doService(info, "p0030", "TRANSACTION","setDelete", obj);
        
        String userObject[] = {value.message};
		ws.setUserObject(userObject);
        ws.setMessage(value.message);
        ws.write();
	}
	*/
	

