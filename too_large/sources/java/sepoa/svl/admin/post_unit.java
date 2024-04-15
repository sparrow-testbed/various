package sepoa.svl.admin;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;

public class post_unit extends SepoaServlet
{

	private static final long serialVersionUID = 7607493033944334988L;

	public post_unit()
    {
		Logger.debug.println();
    }

    public void doQuery(SepoaStream ws)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        String DEPT = ws.getParam("DEPT");
        String I_COMPANY_CODE = ws.getParam("I_COMPANY_CODE");
        String DEPT_NAME_LOC = ws.getParam("DEPT_NAME_ENG");
        String DEPT_NAME_ENG = ws.getParam("DEPT_NAME_ENG");
        String PR_LOCATION_NAME = ws.getParam("PR_LOCATION_NAME");
        String PR_LOCATION = ws.getParam("PR_LOCATION");
        String grid_col_id     = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
        
        Object obj[] = {
            DEPT, I_COMPANY_CODE, DEPT_NAME_LOC, DEPT_NAME_ENG, PR_LOCATION_NAME, PR_LOCATION
        };
        SepoaOut value = ServiceConnector.doService(info, "AD_126", "CONNECTION", "getMainternace", obj);
        SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
        
        for(int i = 0; i < wf.getRowCount(); i++)
        {
        	for(int k=0; k < grid_col_ary.length; k++)
            {
            	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
            		ws.addValue("SELECTED", "0");
            	} else {
            		ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
            	}
            }
        }

        ws.setCode("M001");
        ws.setMessage(value.message);
        ws.write();
    }

    public void doData(SepoaStream ws)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        SepoaFormater wf = ws.getSepoaFormater();
        String DEPT[] = wf.getValue("DEPT");
        String PR_LOCATION[] = wf.getValue("PR_LOCATION");
        String CHANGE_USER_ID = info.getSession("ID");
        String cur_date = SepoaDate.getShortDateString();
        String cur_time = SepoaDate.getShortTimeString();
        String status = "D";
        String setData[][] = new String[wf.getRowCount()][];
        for(int i = 0; i < wf.getRowCount(); i++)
        {
            String Data[] = {
                cur_date, cur_time, CHANGE_USER_ID, DEPT[i], PR_LOCATION[i]
            };
            setData[i] = Data;
        }

        SepoaOut value = ServiceConnector.doService(info, "AD_126", "TRANSACTION", "setDelete", setData);
        
        if(value.flag) {ws.setStatus(true);}
        else {ws.setStatus(false);}
        
        ws.setCode("M002");
        ws.setMessage(value.message);
        ws.write();
    }
}



/***** DECOMPILATION REPORT *****

	DECOMPILED FROM: C:\Documents and Settings\cwb\바탕 화면\eclipse\workspace\Servlet/admin/post_unit.class


	TOTAL TIME: 16 ms


	JAD REPORTED MESSAGES/ERRORS:


	EXIT STATUS:	0


	CAUGHT EXCEPTIONS:

 ********************************/



//package sepoa.svl.admin;
//
//import sepoa.fw.ses.SepoaInfo;
//import sepoa.fw.ses.SepoaSession;
//
//import sepoa.fw.srv.SepoaOut;
//import sepoa.fw.srv.ServiceConnector;
//
//import sepoa.fw.util.SepoaDate;
//import sepoa.fw.util.SepoaFormater;
//
//import sepoa.svl.util.SepoaServlet;
//import sepoa.svl.util.SepoaStream;
//
//public class post_unit extends SepoaServlet
//{
//	//	조회시 사용되는 Method 입니다. Method Name(doQuery)는 변경할 수 없습니다.
//	public void doQuery(SepoaStream ws) throws Exception
//	{
//		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//
//		//framework을 사용하여 원하는 결과값을 얻는다.
//	//	String I_HOUSE_CODE = 		ws.getParam("I_HOUSE_CODE");
////		String SELECTED = 	ws.getParam("SELECTED");
//		String DEPT = 				ws.getParam("DEPT");
//		String I_COMPANY_CODE = 		ws.getParam("I_COMPANY_CODE");	
//		String DEPT_NAME_LOC = 		ws.getParam("DEPT_NAME_LOC");	
//		String DEPT_NAME_ENG = 		ws.getParam("DEPT_NAME_ENG");	
//		String PR_LOCATION_NAME = 		ws.getParam("PR_LOCATION_NAME");	
//		String PR_LOCATION = 		ws.getParam("PR_LOCATION");
//	//	String I_PR_LOCATION = ws.getParam("I_PR_LOCATION");
//
//		//String value = getSelect(info, I_HOUSE_CODE, I_COMPANY_CODE, I_DEPT, I_DEPT_NAME, I_PR_LOCATION);
//		//결과값을 SepoaTable에서 조작가능하게 formatting한다.
//		Object[] obj = {DEPT, I_COMPANY_CODE, DEPT_NAME_LOC, DEPT_NAME_ENG, PR_LOCATION_NAME, PR_LOCATION};
//		
//		SepoaOut value = ServiceConnector.doService(info, "AD_126", "CONNECTION", "getMainternace", obj);
//		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
//
//		for (int i = 0; i < wf.getRowCount(); i++)
//		{
//			String[] check = { "false", "" }; //Check flag, Check Tooltip
//	//		ws.addValue("I_HOUSE_CODE", wf.getValue("I_HOUSE_CODE", i), "");
//			ws.addValue("SEL", 							check											, "");
//			ws.addValue("DEPT", wf.getValue("DEPT", i), ""); //depart Code
//			ws.addValue("DEPT_NAME_LOC",wf.getValue("DEPT_NAME_LOC", i), "");
//			ws.addValue("DEPT_NAME_ENG",wf.getValue("DEPT_NAME_ENG", i), "");
//			ws.addValue("PR_LOCATION_NAME",wf.getValue("PR_LOCATION_NAME", i), "");
//			ws.addValue("PR_LOCATION", wf.getValue("PR_LOCATION", i), "");
//		}
//
//		ws.setCode("M001");
//		ws.setMessage(value.message);
//
//		//위에서 구성한 data를 SepoaTable로 전송한다.
//		ws.write();
//	}
//
//	public void doData(SepoaStream ws) throws Exception
//	{
//		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//		SepoaFormater wf = ws.getSepoaFormater();
//
//		//Table에서 가져온 Data를 특정컬럼값으로 가져온다.
//	//	String I_COMPANY_CODE = ws.getParam("COMPANY_CODE");
//		String[] DEPT = wf.getValue("DEPT");
//		String[] PR_LOCATION = wf.getValue("PR_LOCATION");
//
//		//Sessing에서 가져올 User정보
//	//	String HOUSE_CODE = info.getSession("HOUSE_CODE");
//		String CHANGE_USER_ID = info.getSession("ID");
//		String cur_date = SepoaDate.getShortDateString();
//		String cur_time = SepoaDate.getShortTimeString();
//		String status = "D";
//
//		String[][] setData = new String[wf.getRowCount()][];
//
//		for (int i = 0; i < wf.getRowCount(); i++)
//		{
//			String[] Data = 
//			{
//				cur_date, cur_time, CHANGE_USER_ID, 
//				DEPT[i], PR_LOCATION[i]
//			};
//
//			setData[i] = Data;
//		}
//
//		//해당클래스, 메소드, nickName, ConType을 Mapping한다.
//		SepoaOut value = ServiceConnector.doService(info, "AD_126", "TRANSACTION", "setDelete", setData);
//
//		//SepoaTable에 message를 전송할 수 있다. 또한 script에서 code와 message를 얻을 수 있다.
//		ws.setCode("M002");
//		ws.setMessage(value.message);
//
//		//위에서 구성한 data를 SepoaTable로 전송한다.
//		ws.write();
//	}
//}





