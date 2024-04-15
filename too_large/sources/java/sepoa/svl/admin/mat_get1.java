package sepoa.svl.admin;

import java.util.HashMap;
import java.util.Vector;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;

public class mat_get1 extends SepoaServlet
{

	private static final long serialVersionUID = 7533392742216468918L;

	public mat_get1()
    {
		Logger.debug.println();
    }

    public void doQuery(SepoaStream ws)
        throws Exception
    {
        String case_no = ws.getParam("case_no");

        

        switch(Integer.parseInt(case_no))
        {
        case 100: // 'd'
            getReceviedMail(ws);
            break;

        case 200:
            SelectVendorToMail(ws);
            break;

        case 300:
            getSendMail(ws);
            break;

        case 400:
            getUserList(ws);
            break;

        case 500:
            getCommUserList(ws);
            break;
        }
    }

    private void getReceviedMail(SepoaStream ws)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        Config conf = new Configuration();
        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
        String from_date = SepoaString.getDateUnSlashFormat(ws.getParam("from_date"));
        String to_date = SepoaString.getDateUnSlashFormat(ws.getParam("to_date"));
        String conf_yn = ws.getParam("conf_yn");
        String send_comp = ws.getParam("send_comp");
        String send_user = ws.getParam("send_user");

        String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

        String args[] = {
            from_date, to_date, conf_yn, send_comp, send_user
        };
        SepoaOut value = ServiceConnector.doService(info, "EM_001", "CONNECTION", "getReceviedMail", args);
        SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
        Logger.debug.println(info.getSession("ID"), ws.getRequest(), new StringBuilder("info===>").append(info.getSession("ID")).toString());
        String tmp = "";
        for(int i = 0; i < wf.getRowCount(); i++)
        {
//            String imagetext[] = {
//                "", wf.getValue("SUBJECT", i), wf.getValue("SUBJECT", i)
//            };
//            String imagetext1[] = {
//                (new StringBuilder(String.valueOf(POASRM_CONTEXT_NAME))).append("/images/button/detail.gif").toString(), wf.getValue("ATTACH_CNT", i), wf.getValue("ATTACH_NO", i)
//            };
//            String imagetext2[] = {
//                "", "", wf.getValue("ATTACH_NO", i)
//            };
//            String check[] = {
//                "false", ""
//            };
//            ws.addValue("SELECTED", check, "");
//            ws.addValue("COMPANY_CODE", wf.getValue("COMPANY_CODE", i), "");
//            ws.addValue("COMPANY_NAME", wf.getValue("COMPANY_NAME", i), "");
//            ws.addValue("SUBJECT", imagetext, "");
//            ws.addValue("CONFIRM_DATE", wf.getValue("CONFIRM_DATE", i), "");
//            ws.addValue("ADD_DATE", wf.getValue("ADD_DATE", i), "");
//            if(wf.getValue("ATTACH_NO", i).trim().length() > 0)
//                ws.addValue("ATTACH_NO", imagetext1, "");
//            else
//                ws.addValue("ATTACH_NO", imagetext2, "");
//            ws.addValue("ADD_USER_DEPT_NAME", wf.getValue("ADD_USER_DEPT_NAME", i), "");
//            ws.addValue("ADD_USER_NAME_LOC", wf.getValue("ADD_USER_NAME_LOC", i), "");
//            ws.addValue("DOC_NO", wf.getValue("DOC_NO", i), "");
//            ws.addValue("TEXT1", wf.getValue("TEXT1", i), "");
//            ws.addValue("STAR", wf.getValue("STAR", i), "");
//            ws.addValue("ADD_USER_ID", wf.getValue("ADD_USER_ID", i), "");
//            ws.addValue("DEPT_NAME_LOC", wf.getValue("ADD_USER_DEPT_NAME", i), "");
//            ws.addValue("USER_TYPE", wf.getValue("USER_TYPE", i), "");
//            ws.addValue("DEPT", wf.getValue("DEPT", i), "");

        	for(int k=0; k < grid_col_ary.length; k++)
            {
            	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
            		ws.addValue("SELECTED", "0");
            	}
            	else if(grid_col_ary[k] != null && (grid_col_ary[k].equals("ADD_DATE") || grid_col_ary[k].equals("CONFIRM_DATE")))
        		{
        			ws.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
        		}
            	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ATTACH_CNT"))
            	{
            		if("0".equals(wf.getValue("ATTACH_CNT", i)))
            		{
            			ws.addValue("ATTACH_CNT", POASRM_CONTEXT_NAME + "/images/icon/icon_disk_a.gif^"+wf.getValue("ATTACH_NAME", i),"");
            		}
            		else
            		{
            			ws.addValue("ATTACH_CNT", POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif^"+wf.getValue("ATTACH_NAME", i),"");
            		}
            	}
            	else
            	{
            		ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
            	}
            }
        }

        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        ws.setCode("M001");
        ws.setMessage(message.get("MESSAGE.0001").toString());
        ws.write();
    }

    private void SelectVendorToMail(SepoaStream ws)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        String house_code = info.getSession("HOUSE_CODE");
        String my_id = info.getSession("ID");
        String user_type = ws.getParam("USER_TYPE") != null ? ws.getParam("USER_TYPE") : "%";
        String company = ws.getParam("company") != null ? ws.getParam("company") : "%";
        String user_id = ws.getParam("USER_ID") != null ? ws.getParam("USER_ID") : "%";
        String user_nm = ws.getParam("USER_NM") != null ? ws.getParam("USER_NM") : "%";
        String dept = ws.getParam("DEPT") != null ? ws.getParam("DEPT") : "%";
        String dept_nm_loc = ws.getParam("DEPT_NM_LOC") != null ? ws.getParam("DEPT_NM_LOC") : "%";

        String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");


        String args[] = {
            dept_nm_loc, house_code, user_type,company,user_id, user_nm, dept, my_id
        };
        String value = ServiceConnector.doService(info, "EM_001", "CONNECTION", "SelectVendorToMail", args).result[0];
        SepoaFormater wf = ws.getSepoaFormater(value);
        Logger.debug.println(info.getSession("ID"), ws.getRequest(), new StringBuilder("opr_lis1:servlet:info===>").append(info.getSession("ID")).toString());

        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        if(wf.getRowCount() == 0)
        {
            ws.setCode("M001");
            ws.setMessage(message.get("MESSAGE.1001").toString());
            ws.write();
            return;
        }
        String tmp = "";
        for(int i = 0; i < wf.getRowCount(); i++)
        {
//            String check[] = {
//                "false", ""
//            };
//            ws.addValue(0, check, "");
//            ws.addValue(1, tmp = wf.getValue(i, 1).equals("null") ? "" : wf.getValue(i, 1), "");
//            ws.addValue(2, tmp = wf.getValue(i, 2).equals("null") ? "" : wf.getValue(i, 2), "");
//            ws.addValue(3, tmp = wf.getValue(i, 3).equals("null") ? "" : wf.getValue(i, 3), "");
//            ws.addValue(4, tmp = wf.getValue(i, 4).equals("null") ? "" : wf.getValue(i, 4), "");
//            ws.addValue(5, tmp = wf.getValue(i, 5).equals("null") ? "" : wf.getValue(i, 5), "");
//            ws.addValue(6, tmp = wf.getValue(i, 6).equals("null") ? "" : wf.getValue(i, 6), "");
//            ws.addValue(7, tmp = wf.getValue(i, 0).equals("null") ? "" : wf.getValue(i, 0), "");
//            ws.addValue(8, tmp = wf.getValue(i, 1).equals("null") ? "" : wf.getValue(i, 1), "");

        	for(int k=0; k < grid_col_ary.length; k++)
            {
            	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
            		ws.addValue("SELECT", "0");
            	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("company")) {
            		ws.addValue("company", wf.getValue("COMPANY_NAME", i));
            	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("USER")) {
            		ws.addValue("USER", wf.getValue("USER_ID", i));
            	} else {
            		ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
            	}
            }
        }
        ws.setCode("M001");
        ws.setMessage(message.get("MESSAGE.0001").toString());
        ws.write();
        
    }

    private void getSendMail(SepoaStream ws)
        throws Exception
    {

    	

        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        Config conf = new Configuration();
        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
        String from_date = SepoaString.getDateUnSlashFormat(ws.getParam("from_date"));
        String to_date = SepoaString.getDateUnSlashFormat(ws.getParam("to_date"));
        String rcv_comp = ws.getParam("rcv_comp");
        String rcv_user = ws.getParam("rcv_user");

        String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

        

        String args[] = {
            from_date, to_date, rcv_comp, rcv_user
        };
        String value = ServiceConnector.doService(info, "EM_001", "CONNECTION", "getSendMail", args).result[0];
        SepoaFormater wf = ws.getSepoaFormater(value);
        String tmp = "";


        


        for(int i = 0; i < wf.getRowCount(); i++)
        {
//            String imagetext[] = {
//                "", wf.getValue("SUBJECT", i), wf.getValue("SUBJECT", i)
//            };
//            String imagetext1[] = {
//                (new StringBuilder(String.valueOf(POASRM_CONTEXT_NAME))).append("/images/button/detail.gif").toString(), wf.getValue("ATTACH_CNT", i), wf.getValue("ATTACH_NO", i)
//            };
//            String imagetext2[] = {
//                "", "", wf.getValue("ATTACH_NO", i)
//            };
//            String check[] = {
//                "false", ""
//            };
//            ws.addValue("SELECTED", check, "");
//            ws.addValue("COMPANY_CODE", wf.getValue("COMPANY_CODE", i), "");
//            ws.addValue("COMPANY_NAME", wf.getValue("COMPANY_NAME", i), "");
//            ws.addValue("DEPT_NAME", wf.getValue("DEPT_NAME", i), "");
//            ws.addValue("USER_NAME_LOC", wf.getValue("USER_NAME_LOC", i), "");
//            ws.addValue("SUBJECT", imagetext, "");
//            ws.addValue("CONFIRM_DATE", wf.getValue("CONFIRM_DATE", i), "");
//            ws.addValue("ADD_DATE", wf.getValue("ADD_DATE", i), "");
//            if(wf.getValue("ATTACH_NO", i).trim().length() > 0)
//                ws.addValue("ATTACH_NO", imagetext1, "");
//            else
//                ws.addValue("ATTACH_NO", imagetext2, "");
//            ws.addValue("DOC_NO", wf.getValue("DOC_NO", i), "");
//            ws.addValue("TEXT1", wf.getValue("TEXT1", i), "");
//            ws.addValue("STAR", wf.getValue("STAR", i), "");
//            ws.addValue("RECV_USER_ID", wf.getValue("RECV_USER_ID", i), "");

        	for(int k=0; k < grid_col_ary.length; k++)
            {
            	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) 
            	{
            		ws.addValue("SELECTED", "0");
            	}
            	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ATTACH_CNT")) 
	            {
	        		if("0".equals(wf.getValue("ATTACH_CNT", i))) 
	        		{
	        			ws.addValue("ATTACH_CNT", POASRM_CONTEXT_NAME + "/images/icon/icon_disk_a.gif^"+wf.getValue("ATTACH_CNT", i));
	        		} 
	        		else 
	        		{
	        			ws.addValue("ATTACH_CNT", POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif^"+wf.getValue("ATTACH_CNT", i));
	        		}
	            }
            	else 
            	{
            		ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
            	}
            }
        }

        ws.setCode("M001");
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        ws.setMessage(message.get("MESSAGE.0001").toString());
        ws.write();
    }

    private void getUserList(SepoaStream ws)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        String house_code = info.getSession("HOUSE_CODE");
        String my_id = info.getSession("ID");
        String COMPANY_CODE = ws.getParam("COMPANY_CODE");
        String DEPART_CODE = ws.getParam("DEPART_CODE");
        String USER_ID = ws.getParam("USER_ID");

        String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

        String args[] = {
            COMPANY_CODE, DEPART_CODE, USER_ID
        };
        String value = DoService(info, args, "getUserList");
        SepoaFormater wf = ws.getSepoaFormater(value);
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        if(wf.getRowCount() == 0)
        {
            ws.setCode("M001");
//            ws.setMessage("v占쎌돳占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼟?ⓦ끉??占쎈쐻占쎈짗占쎌굲4癲됯퇊?앭뜝占?");
            ws.setMessage(message.get("MESSAGE.1001").toString());
            ws.write();
            return;
        }
        String tmp = "";
//        int INDEX_SELECT = ws.getColumnIndex("SELECT");
//        int INDEX_COMPANY_CODE = ws.getColumnIndex("COMPANY_CODE");
//        int INDEX_COMPANY_NAME = ws.getColumnIndex("COMPANY_NAME");
//        int INDEX_DEPT = ws.getColumnIndex("DEPT");
//        int INDEX_DEPT_NAME = ws.getColumnIndex("DEPT_NAME");
//        int INDEX_USER = ws.getColumnIndex("USER");
//        int INDEX_USER_NAME = ws.getColumnIndex("USER_NAME");
//        int INDEX_DEPT_NAME_ENG = ws.getColumnIndex("DEPT_NAME_ENG");
        for(int i = 0; i < wf.getRowCount(); i++)
        {
//            String check[] = {
//                "false", ""
//            };
//            ws.addValue(INDEX_SELECT, check, "");
//            ws.addValue(INDEX_COMPANY_CODE, wf.getValue("COMPANY_CODE", i), "");
//            ws.addValue(INDEX_COMPANY_NAME, wf.getValue("COMPANY_NAME", i), "");
//            ws.addValue(INDEX_DEPT, wf.getValue("DEPT", i), "");
//            ws.addValue(INDEX_DEPT_NAME, wf.getValue("NAME_LOC", i), "");
//            ws.addValue(INDEX_USER, wf.getValue("USER_ID", i), "");
//            ws.addValue(INDEX_USER_NAME, wf.getValue("USER_NAME_LOC", i), "");
//            ws.addValue(INDEX_DEPT_NAME_ENG, wf.getValue("NAME_LOC", i), "");

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
//        ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??query占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
        ws.setMessage(message.get("MESSAGE.0001").toString());
        ws.write();
    }

    private void getCommUserList(SepoaStream ws)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        String house_code = info.getSession("HOUSE_CODE");
        String my_id = info.getSession("ID");
        String CUMT_ID = ws.getParam("CUMT_ID");

        String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");


    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        String args[] = {
            CUMT_ID
        };
        Object sendargs[] = {
            args
        };
        String value = DoService(info, args, "getCommUserList");
        SepoaFormater wf = ws.getSepoaFormater(value);
        if(wf.getRowCount() == 0)
        {
            ws.setCode("M001");
//            ws.setMessage("v占쎌돳占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼟?ⓦ끉??占쎈쐻占쎈짗占쎌굲4癲됯퇊?앭뜝占?");
            ws.setMessage(message.get("MESSAGE.1001").toString());
            ws.write();
            return;
        }
        String tmp = "";
//        int INDEX_SELECT = ws.getColumnIndex("SELECT");
//        int INDEX_COMPANY_CODE = ws.getColumnIndex("COMPANY_CODE");
//        int INDEX_COMPANY_NAME = ws.getColumnIndex("COMPANY_NAME");
//        int INDEX_DEPT = ws.getColumnIndex("DEPT");
//        int INDEX_DEPT_NAME = ws.getColumnIndex("DEPT_NAME");
//        int INDEX_USER = ws.getColumnIndex("USER");
//        int INDEX_USER_NAME = ws.getColumnIndex("USER_NAME");
//        int INDEX_DEPT_NAME_ENG = ws.getColumnIndex("DEPT_NAME_ENG");
        for(int i = 0; i < wf.getRowCount(); i++)
        {
//            String check[] = {
//                "true", ""
//            };
//            ws.addValue(INDEX_SELECT, check, "");
//            ws.addValue(INDEX_COMPANY_CODE, wf.getValue("COMPANY_CODE", i), "");
//            ws.addValue(INDEX_COMPANY_NAME, wf.getValue("COMPANY_NAME", i), "");
//            ws.addValue(INDEX_DEPT, wf.getValue("DEPT", i), "");
//            ws.addValue(INDEX_DEPT_NAME, wf.getValue("NAME_LOC", i), "");
//            ws.addValue(INDEX_USER, wf.getValue("USER_ID", i), "");
//            ws.addValue(INDEX_USER_NAME, wf.getValue("USER_NAME_LOC", i), "");
//            ws.addValue(INDEX_DEPT_NAME_ENG, wf.getValue("NAME_LOC", i), "");

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
//        ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??query占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
        ws.setMessage(message.get("MESSAGE.0001").toString());
        ws.write();
    }

    public String DoService(SepoaInfo info, String args[], String MethodName)
    {
        String nickName;
        String conType;
        SepoaOut value;
        SepoaRemote ws;
        Logger.debug.println("DoService = servlet start !!!!");
        nickName = "EM_001";
        conType = "CONNECTION";
        value = null;
        ws = null;
        try
        {
            ws = new SepoaRemote(nickName, conType, info);
            value = ws.lookup(MethodName, args);
    	}catch(Exception e) {
    		Logger.err.println("test1 err = " + e.getMessage());
//    		Logger.err.println("message = " + value.message);
//			Logger.err.println("status = " + value.status);
		} finally {
			try {
				if(ws != null){ ws.Release(); }
			}catch(Exception e) {Logger.debug.println();}
		}
		return (value != null)?value.result[0]:"";
	}

    public void doData(SepoaStream ws)
        throws Exception
    {
        String case_no = ws.getParam("case_no");
        switch(Integer.parseInt(case_no))
        {
        case 100: // 'd'
            DeleteReceviedMail(ws);
            break;

        case 200:
            DeleteSendMail(ws);
            break;

        case 300:
            setTempTable(ws);
            break;
        }
    }

    private void DeleteReceviedMail(SepoaStream ws)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        SepoaFormater wf = ws.getSepoaFormater();
        String user_id = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");
        String doc_no[] = wf.getValue("DOC_NO");
        String setData[][] = new String[wf.getRowCount()][];
        for(int i = 0; i < wf.getRowCount(); i++)
        {
            String Data[] = {
                company_code, doc_no[i]
            };
            setData[i] = Data;
        }

        Object obj[] = {
            setData
        };
        SepoaOut value = DoServiceDel(info, obj, "DeleteReceviedMail");
        String userObject[] = {
            value.message
        };
        ws.setUserObject(userObject);
        ws.setCode(String.valueOf(value.status));
        
//        ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??占쎈쐻占쎈짗占쎌굲f占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        ws.setMessage(message.get("MESSAGE.0001").toString());

        ws.write();
    }

    private void DeleteSendMail(SepoaStream ws)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        SepoaFormater wf = ws.getSepoaFormater();
        String user_id = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");
        String company_code = info.getSession("COMPANY_CODE");
        Logger.debug.println(info.getSession("ID"), this, (new StringBuilder("))))) company_code =====> ")).append(company_code).toString());
        String doc_no[] = wf.getValue("DOC_NO");
        String setData[][] = new String[wf.getRowCount()][];
        for(int i = 0; i < wf.getRowCount(); i++)
        {
            String Data[] = {
                company_code, doc_no[i]
            };
            setData[i] = Data;
        }

        Object obj[] = {
            setData
        };
        SepoaOut value = DoServiceDel(info, obj, "DeleteSendMail");
        String userObject[] = {
            value.message
        };
        ws.setUserObject(userObject);
        ws.setCode(String.valueOf(value.status));
        
//        ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??占쎈쐻占쎈짗占쎌굲f占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        ws.setMessage(message.get("MESSAGE.0001").toString());
        ws.write();
    }

    public SepoaOut DoServiceDel(SepoaInfo info, Object obj[], String MethodName)
    {
        String nickName;
        String conType;
        SepoaOut value;
        SepoaRemote ws;
        nickName = "EM_001";
        conType = "TRANSACTION";
        value = null;
        ws = null;
        try
        {
            ws = new SepoaRemote(nickName, conType, info);
            value = ws.lookup(MethodName, obj);
            if(value.status == 1)
            {
                for(int i = 0; i < value.result.length; i++){
                    Logger.debug.println(new StringBuilder("value = ").append(value.result[0]).toString());
                }

            }
            Logger.debug.println((new StringBuilder("message = ")).append(value.message).toString());
            Logger.debug.println((new StringBuilder("status = ")).append(value.status).toString());
    	}catch(Exception e) {
        	Logger.err.println("test1 err = " + e.getMessage());
//        	Logger.err.println("message = " + value.message);
//   			Logger.err.println("status = " + value.status);
    	}finally {
    		try{
				if(ws != null){ ws.Release(); }
			}catch(Exception e){Logger.debug.println();}
		}
    	return value;
	}

    private void setTempTable(SepoaStream ws)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        SepoaFormater wf = ws.getSepoaFormater();
        String user_id = info.getSession("ID");
        String house_code = info.getSession("HOUSE_CODE");
        String USER[] = wf.getValue("USER");
        String setData[][] = new String[wf.getRowCount()][];
        for(int i = 0; i < wf.getRowCount(); i++)
        {
            String Data[] = {
                info.getSession("ID"), USER[i]
            };
            setData[i] = Data;
        }

        Object obj[] = {
            setData
        };
        SepoaOut value = DoServiceDel(info, obj, "setTempTable");
        String userObject[] = {
            value.message
        };
        ws.setUserObject(userObject);
        ws.setCode(String.valueOf(value.status));
//        ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??upload占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        ws.setMessage(message.get("MESSAGE.0001").toString());
        ws.write();
    }
}



/***** DECOMPILATION REPORT *****

	DECOMPILED FROM: C:\Documents and Settings\cwb\占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 占쎌넅占쎈쐻占쎈짗占쎌굲\eclipse\workspace\Servlet/admin/mat_get1.class


	TOTAL TIME: 203 ms


	JAD REPORTED MESSAGES/ERRORS:

Couldn't fully decompile method DoService
Couldn't resolve all exception handlers in method DoService
Couldn't fully decompile method DoServiceDel
Couldn't resolve all exception handlers in method DoServiceDel

	EXIT STATUS:	0


	CAUGHT EXCEPTIONS:

 ********************************/



//package sepoa.svl.admin;
//
//import sepoa.fw.srv.ServiceConnector;
//import sepoa.svl.util.SepoaServlet;
//import sepoa.svl.util.SepoaStream;
//import sepoa.fw.cfg.Config;
//import sepoa.fw.cfg.Configuration;
//import sepoa.fw.log.Logger;
//import sepoa.fw.ses.SepoaInfo;
//import sepoa.fw.ses.SepoaSession;
//import sepoa.fw.srv.SepoaOut;
//import sepoa.fw.util.SepoaFormater;
//import sepoa.fw.util.SepoaRemote;
//import xlib.cmc.GridData;
//import xlib.cmc.OperateGridData;
//
//
//public class mat_get1 extends SepoaServlet
//{
//    	public void doQuery(SepoaStream ws) throws Exception
//    	{
//    		String case_no = ws.getParam("case_no");
//
//			switch(Integer.parseInt(case_no))
//			{
//				case 100: // 占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙
//					getReceviedMail(ws);
//				break;
//
//				case 200: // 占쎈쐻占쎈짗占쎌굲筌ｋ떣?앾옙猷욑옙?뺧옙?앾옙猷욑옙??
//					SelectVendorToMail(ws);
//				break;
//
//				case 300: // 占쎈쐻占쎈솯占쎈짗占쎌굲
//					getSendMail(ws);
//				break;
//
//				case 400: // 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙 v占쎌돳
//                  	getUserList(ws);
//				break;
//
//				case 500: // 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 community 占쎈쐻占쎈짗占쎌굲 assign占쎈쐻占쎈뼃椰꾧퀡?뀐옙?? 占쎈쐻占쎈셽占쎈뻻筌뚭쑴??assign 占쎈쐻占쎈짗占쎌굲 user v占쎌돳
//                  	getCommUserList(ws);
//				break;
//        	}
//
//    	}
//
//
//    	// 占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙
//    	private void getReceviedMail(SepoaStream ws) throws Exception {
//
//    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//    		Config conf = new Configuration();
//    		String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
//
//            String from_date = ws.getParam("from_date");
//            String to_date   = ws.getParam("to_date");
//            String conf_yn   = ws.getParam("conf_yn");
//            String send_comp = ws.getParam("send_comp");
//            String send_user = ws.getParam("send_user");
//
//            String[] args = {from_date,to_date,conf_yn,send_comp,send_user};
//
//            //Object[] obj = {(Object[])args};
//
//			SepoaOut value = ServiceConnector.doService(info, "EM_001", "CONNECTION", "getReceviedMail", args);
//        	//String value = DoService(info, args, "getReceviedMail");
//			SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
//			Logger.debug.println(info.getSession("ID"),ws.getRequest(),"info===>"+info.getSession("ID"));
//
//        	String tmp = new String();
//
//        	for(int i=0; i<wf.getRowCount(); i++)
//        	{
//    			String[] imagetext =
//    			{
//    				"", wf.getValue("SUBJECT", i), wf.getValue("SUBJECT", i)
//    			};
//				String[] imagetext1 = {
//										POASRM_CONTEXT_NAME + "/images/button/detail.gif",
//										wf.getValue("ATTACH_CNT", i), wf.getValue("ATTACH_NO", i)};
//				String[] imagetext2 = {"", "", wf.getValue("ATTACH_NO", i)};
//        		String[] check = {"false", ""};
//
//
//
//        		ws.addValue("SELECTED",				check,									"");  //占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲
//        		ws.addValue("COMPANY_CODE",			wf.getValue("COMPANY_CODE",			i), "");  //占쎌돳占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈솓占쎈쿈占쎌굲  //#Operating Unit
//        		ws.addValue("COMPANY_NAME",			wf.getValue("COMPANY_NAME",			i), "");  //占쎌돳占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙
//            	ws.addValue("SUBJECT",				imagetext,								"");  //f占쎈쐻占쎈짗占쎌굲
//        		ws.addValue("CONFIRM_DATE",			wf.getValue("CONFIRM_DATE",			i), "");  //CONFIRM_DATE
//            	ws.addValue("ADD_DATE",				wf.getValue("ADD_DATE",				i), "");  //占쎈쐻占쎈솙占쎈닰占쎌굲占쎈쐻占쎈짗占쎌굲
//        		//ws.addValue("ATTACH_NO",			imagetext1,								"");  //筌ｂ벂?앾옙猷욑옙??
//
//            	if(wf.getValue("ATTACH_NO", i).trim().length() > 0) {
//					ws.addValue("ATTACH_NO", imagetext1, ""); // 筌ｂ벂?앾옙猷욑옙??
//				} else {
//					ws.addValue("ATTACH_NO", imagetext2, ""); // 筌ｂ벂?앾옙猷욑옙??
//				}
//        		ws.addValue("ADD_USER_DEPT_NAME",	wf.getValue("ADD_USER_DEPT_NAME",	i), "");  //ADD_USER_DEPT_NAME
//        		ws.addValue("ADD_USER_NAME_LOC",	wf.getValue("ADD_USER_NAME_LOC",	i), "");  //ADD_USER_NAME_LOC
//        		ws.addValue("DOC_NO",				wf.getValue("DOC_NO",				i), "");  //DOC_NO
//        		ws.addValue("TEXT1",				wf.getValue("TEXT1",				i), "");  //TEXT1
//        		ws.addValue("STAR",					wf.getValue("STAR",					i), "");  //STAR
//        		ws.addValue("ADD_USER_ID",			wf.getValue("ADD_USER_ID",			i), "");  //ADD_USER_ID
//        		ws.addValue("DEPT_NAME_LOC",		wf.getValue("ADD_USER_DEPT_NAME",	i), "");  //DEPT_NAME_LOC
//        		ws.addValue("USER_TYPE",			wf.getValue("USER_TYPE",			i), "");  //USER_TYPE
//                ws.addValue("DEPT",					wf.getValue("DEPT",					i), "");  //DEPT
//        	}
//
//        	ws.setCode("M001");
//        	ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??v占쎌돳占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
//        	ws.write();
//    	}
//
//    	// 占쎈쐻占쎈짗占쎌굲筌ｋ떣?앾옙猷욑옙?뺧옙?앾옙猷욑옙??
//    	private void SelectVendorToMail(SepoaStream ws) throws Exception {
//
//    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//
//        	String house_code = info.getSession("HOUSE_CODE");
//            String my_id      = info.getSession("ID");
//
//    		String user_type   = ws.getParam("USER_TYPE")== null ? "%" : ws.getParam("USER_TYPE");
//    		String user_id     = ws.getParam("USER_ID")== null ? "%" : ws.getParam("USER_ID");
//            String user_nm     = ws.getParam("USER_NM")== null ? "%" : ws.getParam("USER_NM");
//            String dept        = ws.getParam("DEPT")== null ? "%" : ws.getParam("DEPT");
//            String dept_nm_loc = ws.getParam("DEPT_NM_LOC")== null ? "%" : ws.getParam("DEPT_NM_LOC");
//
//
//    		String args[] = {dept_nm_loc, house_code, user_type,user_id,user_nm,dept,my_id};
//    		//Object[] sendargs = {args};
//    		//String value = DoService(info, args, "SelectVendorToMail");
//			String value = ServiceConnector.doService(info, "EM_001", "CONNECTION","SelectVendorToMail", args).result[0];
//
//			SepoaFormater wf = ws.getSepoaFormater(value);
//        	Logger.debug.println(info.getSession("ID"),ws.getRequest(),"opr_lis1:servlet:info===>"+info.getSession("ID"));
//
//			if(wf.getRowCount() == 0)
//			{
//	        	ws.setCode("M001");
//    	    	ws.setMessage("v占쎌돳占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼟?ⓦ끉??占쎈쐻占쎈짗占쎌굲4癲됯퇊?앭뜝占?");
//        		ws.write();
//        		return;
//        	}
//
//        	String tmp = new String();
//
//
//        	//占쎈쐻占쎈쎘癰귢쐼?앾옙猷욑옙??占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈뻻筌뚭쑴?뺧옙?앾옙猷욑옙??Query占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲; Setting占쎈쐻占쎈뼩占쎈솇占쎌굲.
//        	for(int i=0; i<wf.getRowCount(); i++) {
//        		//Check Value Set
//        		String[] check = {"false", ""};	//Check flag, Check Tooltip
//            	ws.addValue(0, check, "");
//        		ws.addValue(1, tmp = (wf.getValue(i, 2).equals("null") ? "" : wf.getValue(i, 2)), "");	//占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈＇D
//        		ws.addValue(2, tmp = (wf.getValue(i, 3).equals("null") ? "" : wf.getValue(i, 3)), "");	//占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲?곕‥?앭뜝占?
//        		ws.addValue(3, tmp = (wf.getValue(i, 4).equals("null") ? "" : wf.getValue(i, 4)), "");	//占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎌몝占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙
//        		ws.addValue(4, tmp = (wf.getValue(i, 5).equals("null") ? "" : wf.getValue(i, 5)), "");	//占쎈쐻占쎈뼢占쎈닰占쎌굲
//        		ws.addValue(5, tmp = (wf.getValue(i, 6).equals("null") ? "" : wf.getValue(i, 6)), "");	//占쎈쐻占쎈뼢占쎈닰占쎌굲占쎈쐻占쎈짗占쎌굲
//                ws.addValue(6, tmp = (wf.getValue(i, 0).equals("null") ? "" : wf.getValue(i, 0)), "");  //COMPANY_CODE
//                ws.addValue(7, tmp = (wf.getValue(i, 1).equals("null") ? "" : wf.getValue(i, 1)), "");  //COMPANY_NAME
//
//        	}
//
//	        ws.setCode("M001");
//	        ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??query占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
//	       	ws.write();
//     	}
//
//
//    	// 占쎈쐻占쎈솯占쎈짗占쎌굲
//    	private void getSendMail(SepoaStream ws) throws Exception {
//
//    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//    		Config conf = new Configuration();
//    		String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
//
//            String from_date = ws.getParam("from_date");
//            String to_date   = ws.getParam("to_date");
//            String rcv_comp  = ws.getParam("rcv_comp");
//            String rcv_user  = ws.getParam("rcv_user");
//
//            String[] args = {from_date,to_date,rcv_comp,rcv_user};
//
//            //Object[] obj = {(Object[])args};
//
//        	//String value = DoService(info, args, "getSendMail");
//			String value = ServiceConnector.doService(info, "EM_001", "CONNECTION","getSendMail", args).result[0];
//
//			SepoaFormater wf = ws.getSepoaFormater(value);
//
//        	String tmp = new String();
//        	for(int i=0; i<wf.getRowCount(); i++)
//        	{
//
//				String[] imagetext  = {"", wf.getValue("SUBJECT", i), wf.getValue("SUBJECT", i)};
//				String[] imagetext1 = {POASRM_CONTEXT_NAME + "/images/button/detail.gif", wf.getValue("ATTACH_CNT", i), wf.getValue("ATTACH_NO", i)};
//				String[] imagetext2 = {"", "", wf.getValue("ATTACH_NO", i)};
//        		String[] check = {"false", ""};
//
//        		ws.addValue("SELECTED",				check,									"");  //占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲
//        		ws.addValue("COMPANY_CODE",			wf.getValue("COMPANY_CODE",			i), "");  //占쎌돳占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈솓占쎈쿈占쎌굲  //#Operating Unit
//        		ws.addValue("COMPANY_NAME",			wf.getValue("COMPANY_NAME",			i), "");  //占쎌돳占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙
//				ws.addValue("DEPT_NAME",			wf.getValue("DEPT_NAME",			i), "");  //占쎈쐻占쎈뼢占쎈닰占쎌굲占쎈쐻占쎈짗占쎌굲
//				ws.addValue("USER_NAME_LOC",		wf.getValue("USER_NAME_LOC",		i), "");  //占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙
//            	ws.addValue("SUBJECT",				imagetext,								"");  //f占쎈쐻占쎈짗占쎌굲
//        		ws.addValue("CONFIRM_DATE",			wf.getValue("CONFIRM_DATE",			i), "");  //CONFIRM_DATE
//            	ws.addValue("ADD_DATE",				wf.getValue("ADD_DATE",				i), "");  //占쎈쐻占쎈솙占쎈닰占쎌굲占쎈쐻占쎈짗占쎌굲
//        		//ws.addValue("ATTACH_NO",			imagetext1,								"");  //筌ｂ벂?앾옙猷욑옙??
//				if(wf.getValue("ATTACH_NO", i).trim().length() > 0) {
//					ws.addValue("ATTACH_NO", imagetext1, ""); // 筌ｂ벂?앾옙猷욑옙??
//				} else {
//					ws.addValue("ATTACH_NO", imagetext2, ""); // 筌ｂ벂?앾옙猷욑옙??
//				}
//        		ws.addValue("DOC_NO",				wf.getValue("DOC_NO",				i), "");  //DOC_NO
//        		ws.addValue("TEXT1",				wf.getValue("TEXT1",				i), "");  //TEXT1
//        		ws.addValue("STAR",					wf.getValue("STAR",					i), "");  //STAR
//                ws.addValue("RECV_USER_ID",			wf.getValue("RECV_USER_ID",			i), "");  //DEPT
//
//        	}
//
//        	ws.setCode("M001");
//        	ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??v占쎌돳占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
//        	ws.write();
//    	}
//
//    	// 占쎈쐻占쎈짗占쎌굲筌ｋ떣?앾옙猷욑옙?뺧옙?앾옙猷욑옙??
//    	private void getUserList(SepoaStream ws) throws Exception {
//
//    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//
//        	String house_code = info.getSession("HOUSE_CODE");
//            String my_id      = info.getSession("ID");
//
//    		String COMPANY_CODE  = ws.getParam("COMPANY_CODE");
//    		String DEPART_CODE   = ws.getParam("DEPART_CODE");
//            String USER_ID       = ws.getParam("USER_ID");
//
//    		String args[] = {COMPANY_CODE, DEPART_CODE, USER_ID};
//
//    		//Object[] sendargs = {args};
//    		String value = DoService(info, args, "getUserList");
//
//        	SepoaFormater wf = ws.getSepoaFormater(value);
//
//			if(wf.getRowCount() == 0)
//			{
//	        	ws.setCode("M001");
//    	    	ws.setMessage("v占쎌돳占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼟?ⓦ끉??占쎈쐻占쎈짗占쎌굲4癲됯퇊?앭뜝占?");
//        		ws.write();
//        		return;
//        	}
//
//        	String tmp = new String();
//
//            int INDEX_SELECT             =  ws.getColumnIndex("SELECT");
//            int INDEX_COMPANY_CODE       =  ws.getColumnIndex("COMPANY_CODE");
//            int INDEX_COMPANY_NAME       =  ws.getColumnIndex("COMPANY_NAME");
//            int INDEX_DEPT               =  ws.getColumnIndex("DEPT");
//            int INDEX_DEPT_NAME          =  ws.getColumnIndex("DEPT_NAME");
//            int INDEX_USER               =  ws.getColumnIndex("USER");
//            int INDEX_USER_NAME          =  ws.getColumnIndex("USER_NAME");
//            int INDEX_DEPT_NAME_ENG      =  ws.getColumnIndex("DEPT_NAME_ENG");
//
//        	//占쎈쐻占쎈쎘癰귢쐼?앾옙猷욑옙??占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈뻻筌뚭쑴?뺧옙?앾옙猷욑옙??Query占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲; Setting占쎈쐻占쎈뼩占쎈솇占쎌굲.
//        	for(int i=0; i<wf.getRowCount(); i++) {
//        		//Check Value Set
//        		String[] check = {"false", ""};	//Check flag, Check Tooltip
//            	ws.addValue(INDEX_SELECT, check, "");
//        		ws.addValue(INDEX_COMPANY_CODE,     wf.getValue("COMPANY_CODE"         , i), "");
//        		ws.addValue(INDEX_COMPANY_NAME,     wf.getValue("COMPANY_NAME"         , i), "");
//        		ws.addValue(INDEX_DEPT,             wf.getValue("DEPT"                 , i), "");
//        		ws.addValue(INDEX_DEPT_NAME,        wf.getValue("NAME_LOC"             , i), "");
//        		ws.addValue(INDEX_USER,             wf.getValue("USER_ID"              , i), "");
//                ws.addValue(INDEX_USER_NAME,        wf.getValue("USER_NAME_LOC"        , i), "");
//                ws.addValue(INDEX_DEPT_NAME_ENG,    wf.getValue("NAME_LOC"             , i), "");
//        	}
//
//	        ws.setCode("M001");
//	        ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??query占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
//	       	ws.write();
//     	}
//
//    	// 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 community 占쎈쐻占쎈짗占쎌굲 assign占쎈쐻占쎈뼃椰꾧퀡?뀐옙?? 占쎈쐻占쎈셽占쎈뻻筌뚭쑴??assign 占쎈쐻占쎈짗占쎌굲 user v占쎌돳
//    	private void getCommUserList(SepoaStream ws) throws Exception {
//
//    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//
//        	String house_code = info.getSession("HOUSE_CODE");
//            String my_id      = info.getSession("ID");
//
//    		String CUMT_ID  = ws.getParam("CUMT_ID");
//
//    		String args[] = {CUMT_ID};
//
//    		Object[] sendargs = {args};
//    		String value = DoService(info, args, "getCommUserList");
//
//    		SepoaFormater wf = ws.getSepoaFormater(value);
//
//			if(wf.getRowCount() == 0)
//			{
//	        	ws.setCode("M001");
//    	    	ws.setMessage("v占쎌돳占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼟?ⓦ끉??占쎈쐻占쎈짗占쎌굲4癲됯퇊?앭뜝占?");
//        		ws.write();
//        		return;
//        	}
//
//        	String tmp = new String();
//
//            int INDEX_SELECT             =  ws.getColumnIndex("SELECT");
//            int INDEX_COMPANY_CODE       =  ws.getColumnIndex("COMPANY_CODE");
//            int INDEX_COMPANY_NAME       =  ws.getColumnIndex("COMPANY_NAME");
//            int INDEX_DEPT               =  ws.getColumnIndex("DEPT");
//            int INDEX_DEPT_NAME          =  ws.getColumnIndex("DEPT_NAME");
//            int INDEX_USER               =  ws.getColumnIndex("USER");
//            int INDEX_USER_NAME          =  ws.getColumnIndex("USER_NAME");
//            int INDEX_DEPT_NAME_ENG      =  ws.getColumnIndex("DEPT_NAME_ENG");
//
//        	//占쎈쐻占쎈쎘癰귢쐼?앾옙猷욑옙??占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈뻻筌뚭쑴?뺧옙?앾옙猷욑옙??Query占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲; Setting占쎈쐻占쎈뼩占쎈솇占쎌굲.
//        	for(int i=0; i<wf.getRowCount(); i++) {
//        		//Check Value Set
//        		String[] check = {"true", ""};	//Check flag, Check Tooltip
//            	ws.addValue(INDEX_SELECT, check, "");
//        		ws.addValue(INDEX_COMPANY_CODE,     wf.getValue("COMPANY_CODE"         , i), "");
//        		ws.addValue(INDEX_COMPANY_NAME,     wf.getValue("COMPANY_NAME"         , i), "");
//        		ws.addValue(INDEX_DEPT,             wf.getValue("DEPT"                 , i), "");
//        		ws.addValue(INDEX_DEPT_NAME,        wf.getValue("NAME_LOC"             , i), "");
//        		ws.addValue(INDEX_USER,             wf.getValue("USER_ID"              , i), "");
//                ws.addValue(INDEX_USER_NAME,        wf.getValue("USER_NAME_LOC"        , i), "");
//                ws.addValue(INDEX_DEPT_NAME_ENG,    wf.getValue("NAME_LOC"             , i), "");
//        	}
//
//	        ws.setCode("M001");
//	        ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??query占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
//	       	ws.write();
//     	}
//
//	//framework占쎈쐻占쎈짗占쎌굲 b占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼣占쎌뒻占쎌굲 data; 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼣占쎈솇占쎌굲 Method占쎈쐻占쎈뼓占쎈솇占쎌굲. 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼄筌뚭쑴??占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲鵝?벨??占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲濚뱀빆?앾옙猷욑옙?뺧옙?앭뜝占?占쎈쐻占쎈뼩占쎈솇占쎌굲.
//    	public String DoService(SepoaInfo info , String[] args ,  String MethodName ) {
//	        	Logger.debug.println("DoService = servlet start !!!!");
//
//    		String nickName= "EM_001";		//wisehub.srv占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲濚뱀빆?앭뜝占?Alias
//    		String conType = "CONNECTION";	//conType : CONNECTION/TRANSACTION/NONDBJOB
//
//    		SepoaOut value = null;
//    		SepoaRemote ws =  null;
//	        //占쎈쐻占쎈짗占쎌굲=: 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 class; loading占쎈쐻占쎈뼣?ⓦ끉??Method占쎌깈占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙 占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙 return占쎈쐻占쎈뼣占쎈솇占쎌굲 占쎈쐻占쎈뼢?됱빘?뺧옙?앾옙?쏉옙?뗰옙??
//	    	try {
//
//                ws = new sepoa.fw.util.SepoaRemote(nickName,conType,info);
//	        	value = ws.lookup(MethodName,args);
//
//	    	}catch(Exception e) {
//	        	Logger.err.println("test1 err = " + e.getMessage());
//	        	Logger.err.println("message = " + value.message);
//	   			Logger.err.println("status = " + value.status);
//	    	} finally {
//	    		try {
//	    			ws.Release();
//	    		}catch(Exception e) {}
//	    	}
//	    	return value.result[0];
//    	}
//
//
//
//    	//占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙, 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲, 占쎈쐻占쎈짗占쎌굲f占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼄占쎈솇占쎌굲 Method 占쎈쐻占쎈셾占쎈빍占쎈솇占쎌굲. Method Name(doData)占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲4癲됯퇊?앭뜝占?
//    	public void doData(SepoaStream ws) throws Exception {
//
//     		String case_no = ws.getParam("case_no");
//
//			switch(Integer.parseInt(case_no))
//			{
//				case 100: // 占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙?뺧옙?앭뜝占?占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲
//					DeleteReceviedMail(ws);
//				break;
//
//				case 200: // 占쎈쐻占쎈솯占쎈뻿筌뤿슣?뺧옙?앾옙猷욑옙??占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲
//					DeleteSendMail(ws);
//				break;
//
//				case 300: // temp table insert 占쎈쐻占쎈뼣繹먮씮??
//					setTempTable(ws);
//				break;
//
//        	}
//
//    	}
//
//
//    	// 占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙?뺧옙?앭뜝占?占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲
//    	private void DeleteReceviedMail(SepoaStream ws) throws Exception {
//
//    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//    		//WiseTable占쎈쐻占쎈뼢?됱빘?뺧옙?앾옙猷욑옙??upload占쎈쐻占쎈짗占쎌굲 data; formatting占쎈쐻占쎈뼣占쎌뒻占쎌굲 占쎈쐻占쎈짗占쎌굲鸚룸뛼?앭뜝占?
//    		SepoaFormater wf = ws.getSepoaFormater();
//
//			String user_id = info.getSession("ID");
//			String house_code = info.getSession("HOUSE_CODE");
//			String company_code = info.getSession("COMPANY_CODE");
//
//	        String[] doc_no = wf.getValue("DOC_NO");
//
//			String setData[][] = new String[wf.getRowCount()][];
//			for (int i = 0; i<wf.getRowCount(); i++) {
//				String Data[] = { company_code, doc_no[i] };
//				setData[i] = Data;
//			}
//			Object[] obj = { setData} ;
//			SepoaOut value = DoServiceDel(info, obj, "DeleteReceviedMail");
//			//占쎈쐻占쎈솋占쎈솇占쎌굲占쎄깻占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲, 占쎈쐻占쎈솭占쎈꺖占쎈쿈占쎌굲, nickName, ConType; Mapping占쎈쐻占쎈뼩占쎈솇占쎌굲.
//        	//WiseOut value = setDel(info, setData);
//
//			//client占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈솭占쎈닰占쎌굲占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈뼩筌뚭쑴?뺧옙?앾옙?뉑틦?우굲'占쎈쐻占쎈짗占쎌굲
//        	String [] userObject = { value.message };
//            ws.setUserObject( userObject );
//
//
//
//			//WiseTable占쎈쐻占쎈짗占쎌굲 message占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙 占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈솂占쎈솇占쎌굲. 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 script占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 code占쎈쐻占쎈짗占쎌굲 message占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲; 占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈솂占쎈솇占쎌굲.
//        	ws.setCode(String.valueOf(value.status));
//        	System.out.println("aaaa==>" + String.valueOf(value.status));
//        	ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??占쎈쐻占쎈짗占쎌굲f占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
//
//        	//'占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 data占쎈쐻占쎈짗占쎌굲 WiseTable占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲遙ο옙占쎈쐻?좑옙.
//        	ws.write();
//    	}
//
//		// 占쎈쐻占쎈솯占쎈뻿筌뤿슣?뺧옙?앾옙猷욑옙??占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲
//    	private void DeleteSendMail(SepoaStream ws) throws Exception {
//
//    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//    		//WiseTable占쎈쐻占쎈뼢?됱빘?뺧옙?앾옙猷욑옙??upload占쎈쐻占쎈짗占쎌굲 data; formatting占쎈쐻占쎈뼣占쎌뒻占쎌굲 占쎈쐻占쎈짗占쎌굲鸚룸뛼?앭뜝占?
//    		SepoaFormater wf = ws.getSepoaFormater();
//
//			String user_id = info.getSession("ID");
//			String house_code = info.getSession("HOUSE_CODE");
//	        String company_code = info.getSession("COMPANY_CODE");
//
//	        Logger.debug.println(info.getSession("ID"), this, ")))))) company_code =====> " + company_code);
//
//	        String[] doc_no = wf.getValue("DOC_NO");
//			String setData[][] = new String[wf.getRowCount()][];
//			for (int i = 0; i<wf.getRowCount(); i++) {
//				String Data[] = {company_code, doc_no[i] };
//				setData[i] = Data;
//			}
//			Object[] obj = { setData} ;
//			SepoaOut value = DoServiceDel(info, obj, "DeleteSendMail");
//			//占쎈쐻占쎈솋占쎈솇占쎌굲占쎄깻占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲, 占쎈쐻占쎈솭占쎈꺖占쎈쿈占쎌굲, nickName, ConType; Mapping占쎈쐻占쎈뼩占쎈솇占쎌굲.
//        	//WiseOut value = setDel(info, setData);
//
//			//client占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈솭占쎈닰占쎌굲占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈뼩筌뚭쑴?뺧옙?앾옙?뉑틦?우굲'占쎈쐻占쎈짗占쎌굲
//        	String [] userObject = { value.message };
//            ws.setUserObject( userObject );
//
//			//WiseTable占쎈쐻占쎈짗占쎌굲 message占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙 占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈솂占쎈솇占쎌굲. 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 script占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 code占쎈쐻占쎈짗占쎌굲 message占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲; 占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈솂占쎈솇占쎌굲.
//        	ws.setCode(String.valueOf(value.status));
//        	System.out.println("bbbb==>" + String.valueOf(value.status));
//
//            ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??占쎈쐻占쎈짗占쎌굲f占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
//        	//'占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 data占쎈쐻占쎈짗占쎌굲 WiseTable占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲遙ο옙占쎈쐻?좑옙.
//        	ws.write();
//    	}
//
//
//
//
//    	//framework占쎈쐻占쎈짗占쎌굲 b占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼣占쎌뒻占쎌굲 data; 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼣占쎈솇占쎌굲 Method占쎈쐻占쎈뼓占쎈솇占쎌굲. 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈뼄筌뚭쑴??占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲鵝?벨??占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲濚뱀빆?앾옙猷욑옙?뺧옙?앭뜝占?占쎈쐻占쎈뼩占쎈솇占쎌굲.
//    	public SepoaOut DoServiceDel(SepoaInfo info, Object[] obj , String MethodName) {
//    		String nickName= "EM_001";
//    		String conType = "TRANSACTION";
//
//    		SepoaOut value = null;
//	    	sepoa.fw.util.SepoaRemote ws = null;
//
//	        //占쎈쐻占쎈짗占쎌굲=: 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 class; loading占쎈쐻占쎈뼣?ⓦ끉??Method占쎌깈占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙 占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙 return占쎈쐻占쎈뼣占쎈솇占쎌굲 占쎈쐻占쎈뼢?됱빘?뺧옙?앾옙?쏉옙?뗰옙??
//	    	try {
//		        ws = new sepoa.fw.util.SepoaRemote(nickName,conType,info);
//		        value = ws.lookup(MethodName,obj);
//		 		if(value.status == 1) {
//		  			for(int i = 0 ; i < value.result.length ; i++){
//		   				Logger.debug.println("value = " + value.result[0]);
//		   			}
//   				}
//				Logger.debug.println("message = " + value.message);
//	   			Logger.debug.println("status = " + value.status);
//
//	    	}catch(Exception e) {
//	        	Logger.err.println("test1 err = " + e.getMessage());
//	        	Logger.err.println("message = " + value.message);
//	   			Logger.err.println("status = " + value.status);
//	    	}finally {
//	    		try{
//					ws.Release();
//				}catch(Exception e){}
//			}
//	    	return value;
//    	}
//
//    	// 占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙?뺧옙?앭뜝占?占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲
//    	private void setTempTable(SepoaStream ws) throws Exception {
//
//    		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
//    		//WiseTable占쎈쐻占쎈뼢?됱빘?뺧옙?앾옙猷욑옙??upload占쎈쐻占쎈짗占쎌굲 data; formatting占쎈쐻占쎈뼣占쎌뒻占쎌굲 占쎈쐻占쎈짗占쎌굲鸚룸뛼?앭뜝占?
//    		SepoaFormater wf = ws.getSepoaFormater();
//
//			String user_id = info.getSession("ID");
//			String house_code = info.getSession("HOUSE_CODE");
//
//	        String[] USER = wf.getValue("USER");
//			String setData[][] = new String[wf.getRowCount()][];
//
//			for (int i = 0; i<wf.getRowCount(); i++) {
//				String Data[] = {
//				        			info.getSession("ID"),
//				        			USER[i]
//				        		};
//				setData[i] = Data;
//			}
//
//			Object[] obj = { setData} ;
//			SepoaOut value = DoServiceDel(info, obj, "setTempTable");
//			//占쎈쐻占쎈솋占쎈솇占쎌굲占쎄깻占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲, 占쎈쐻占쎈솭占쎈꺖占쎈쿈占쎌굲, nickName, ConType; Mapping占쎈쐻占쎈뼩占쎈솇占쎌굲.
//        	//WiseOut value = setDel(info, setData);
//
//			//client占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈솭占쎈닰占쎌굲占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈뼩筌뚭쑴?뺧옙?앾옙?뉑틦?우굲'占쎈쐻占쎈짗占쎌굲
//        	String [] userObject = { value.message };
//            ws.setUserObject( userObject );
//
//			//WiseTable占쎈쐻占쎈짗占쎌굲 message占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻?좑옙 占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈솂占쎈솇占쎌굲. 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 script占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 code占쎈쐻占쎈짗占쎌굲 message占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲; 占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈솂占쎈솇占쎌굲.
//        	ws.setCode(String.valueOf(value.status));
//        	ws.setMessage("d占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲8占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쏙옙占쏙옙?앾옙猷욑옙??upload占쎈쐻占쎈뼄占쎈섣占쎌굲4癲됯퇊?앭뜝占?");
//
//        	//'占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲 data占쎈쐻占쎈짗占쎌굲 WiseTable占쎈쐻占쎈짗占쎌굲 占쎈쐻占쎈짗占쎌굲占쎈쐻占쎈짗占쎌굲遙ο옙占쎈쐻?좑옙.
//        	ws.write();
//    	}
//
//}


