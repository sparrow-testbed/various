/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) ansi radix(10) lradix(10)
// Source File Name:   bulletin_list.java

package sepoa.svl.admin;

import java.util.HashMap;
import java.util.Vector;
import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.log.LoggerWriter;
import sepoa.fw.msg.*;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.*;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;

public class bulletin_list_new_1 extends SepoaServlet
{

    public bulletin_list_new_1()
    {
//        msg = new Message("KO", "STDCOMM");
    	Logger.debug.println();
    }

    public void doQuery(SepoaStream ws)
        throws Exception
    {
        String mode = ws.getParam("mode");

        //System.out.println("★★★★★★★★mode="+mode);

        if("getSendNotice".equals(mode)) {
            getSendNotice(ws, mode);
        }
        if("getSupNotice".equals(mode)){
            getSupNotice(ws, mode);
        }
    }

    private void getSendNotice(SepoaStream ws, String mode)
        throws Exception
    {
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        Object obj[] = (Object[])null;
        Logger.err.println(new StringBuilder("%%%%%%%%%%%%%%%%").append(mode).toString());
        SepoaOut value = ServiceConnector.doService(info, "MT_014", "CONNECTION", "getSendNotice", obj);
        SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
        Logger.debug.println(info.getSession("ID"), ws.getRequest(), new StringBuilder("info===>").append(info.getSession("ID")).toString());
        Config conf = new Configuration();
        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");

        String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

        for(int i = 0; i < wf.getRowCount(); i++)
        {
//            String check[] = {
//                "false", ""
//            };
//            String imagetext[] = {
//                "", wf.getValue("SUBJECT", i), wf.getValue("SUBJECT", i)
//            };
//            String imagetext1[] = {
//                (new StringBuilder(String.valueOf(POASRM_CONTEXT_NAME))).append("/images/button/detail.gif").toString(), "", wf.getValue("ATTACH_NO", i)
//            };
//            String imagetext_empty[] = {
//                "", "", ""
//            };
//            ws.addValue("SELECTED", check, "");
//            ws.addValue("COMPANY_NAME", wf.getValue("COMPANY_NAME", i), "");
//            ws.addValue("SUBJECT", imagetext, "");
//            ws.addValue("ADD_DATE", wf.getValue("ADD_DATE", i), "");
//            if(wf.getValue("ATTACH_NO", i).equals(""))
//                ws.addValue("ATTACH_NO", imagetext_empty, "");
//            else
//                ws.addValue("ATTACH_NO", imagetext1, "");
//            ws.addValue("CONTENT", wf.getValue("CONTENT", i), "");
//            ws.addValue("SEQ", wf.getValue("SEQ", i), "");

        	for(int k=0; k < grid_col_ary.length; k++)
            {
        		if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED"))
        		{
            		ws.addValue("SELECTED", "0");
            	}
        		else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE"))
        		{
        			ws.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
        		}
        		else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ATTACH_NAME"))
        		{
            		if("0".equals(wf.getValue("ATTACH_NAME", i)))
            		{
            			ws.addValue("ATTACH_NAME", POASRM_CONTEXT_NAME + "/images/icon/icon_disk_a.gif^"+wf.getValue("ATTACH_NAME", i),"");
            		}
            		else
            		{
            			ws.addValue("ATTACH_NAME", POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif^"+wf.getValue("ATTACH_NAME", i),"");
            		}
            	}
        		else
        		{
            		ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
            	}
            }
        }

        ws.setCode("M001");
        ws.setMessage("");
        ws.write();
    }

    private void getSupNotice(SepoaStream ws, String mode)
        throws Exception
    {

    	//System.out.println("★★★★★★★★getSupNotice");

        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        String gubun = JSPUtil.CheckInjection(ws.getParam("gubun")).trim().toUpperCase();
        String quest = JSPUtil.CheckInjection(ws.getParam("quest")).trim().toUpperCase();
        String company_code = JSPUtil.CheckInjection(ws.getParam("company_code")).trim().toUpperCase();
        String dept_type = JSPUtil.CheckInjection(ws.getParam("dept_type")).trim().toUpperCase();
        String type = JSPUtil.CheckInjection(ws.getParam("type")).trim().toUpperCase();
         
        String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
	        Object obj[] = {
	            gubun, quest, company_code,dept_type,type
	        };

	        SepoaOut value = ServiceConnector.doService(info, "MT_014", "CONNECTION", "getNotice", obj);
	        SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
	        Logger.debug.println(info.getSession("ID"), ws.getRequest(), new StringBuilder("info===>").append(info.getSession("ID")).toString());
	        Config conf = new Configuration();
	        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");

	        String user_type = info.getSession("USER_TYPE");
	        String is_admin_user = info.getSession("IS_ADMIN_USER");

	        //System.out.println("★★★★★★★★wf.getRowCount()="+wf.getRowCount());

	        for(int i = 0; i < wf.getRowCount(); i++)
	        {
//	            String check[] = {
//	                "false", ""
//	            };
//	            String imagetext[] = {
//	                "", wf.getValue("SUBJECT", i), wf.getValue("SUBJECT", i)
//	            };
//	            String imagetext1[] = {
//	                (new StringBuilder(String.valueOf(POASRM_CONTEXT_NAME))).append("/images/button/detail.gif").toString(), "", wf.getValue("ATTACH_NO", i)
//	            };
//	            String imagetext_empty[] = {
//	                "", "", ""
//	            };
//
//	            String imagetext_view_count[] = {
//		                "", wf.getValue("VIEW_COUNT", i), wf.getValue("VIEW_COUNT", i)
//		            };
//
//	            ws.addValue("SELECTED", check, "");
//	            ws.addValue("COMPANY_NAME", wf.getValue("COMPANY_NAME", i), "");
//	            ws.addValue("DEPT_TYPE", wf.getValue("DEPT_TYPE", i), "");
//	            ws.addValue("SUBJECT", imagetext, "");
//	            ws.addValue("GONGJI_GUBUN", wf.getValue("GONGJI_GUBUN_DESC", i), "");
//
//	            if(!sepoa.svc.common.constants.UserType.Seller.getValue().equals(user_type) && is_admin_user.equals("true")){
//	            	ws.addValue("VIEW_COUNT", imagetext_view_count, "");
//	        	}else{
//	        		ws.addValue("VIEW_COUNT", wf.getValue("VIEW_COUNT", i), "");
//	        	}
//	            ws.addValue("ADD_DATE", wf.getValue("ADD_DATE", i), "");
//	            if(wf.getValue("ATTACH_NO", i).equals(""))
//	                ws.addValue("ATTACH_NO", imagetext_empty, "");
//	            else
//	                ws.addValue("ATTACH_NO", imagetext1, "");
//	            ws.addValue("CONTENT", wf.getValue("CONTENT", i), "");
//	            ws.addValue("SEQ", wf.getValue("SEQ", i), "");

            	for(int k=0; k < grid_col_ary.length; k++)
                {
                	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
                		ws.addValue("SELECTED", "0");
                	}
                	else if(grid_col_ary[k] != null && ( grid_col_ary[k].equals("ADD_DATE") || grid_col_ary[k].equals("PUBLISH_FROM_DATE") || grid_col_ary[k].equals("PUBLISH_TO_DATE") ) )
            		{
            			ws.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
            		}
                	else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ATTACH_NAME"))
                	{
                		if("0".equals(wf.getValue("ATTACH_NAME", i)))
                		{
                			ws.addValue("ATTACH_NAME", POASRM_CONTEXT_NAME + "/images/icon/icon_disk_a.gif^"+wf.getValue("ATTACH_NAME", i),"");
                		}
                		else
                		{
                			ws.addValue("ATTACH_NAME", POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif^"+wf.getValue("ATTACH_NAME", i),"");
                		}
                	}
                	else
                	{
                		ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
	        }
        }
        catch (Exception e)
        {
        	ws.setCode("M001");
        	ws.setMessage(message.get("MESSAGE.1002").toString());
        	
        }

        ws.setCode("M001");
        ws.setMessage(message.get("MESSAGE.0001").toString());
        ws.write();
    }

    public void doData(SepoaStream ws)
        throws Exception
    {
        String mode = ws.getParam("mode");
        if("setDelete".equals(mode)) {
            setDelete(ws, mode);
        }
    }

    private void setDelete(SepoaStream ws, String mode)
        throws Exception
    {

    	

        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        SepoaFormater wf = ws.getSepoaFormater();
        Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>>>>>>>>>>>> 1");
        String seq[] = wf.getValue("SEQ");
        String setData[][] = new String[wf.getRowCount()][];
        for(int i = 0; i < wf.getRowCount(); i++)
        {
            String Data[] = {
                seq[i]
            };
            setData[i] = Data;
        }

        Object obj[] = {
            setData
        };
        Logger.debug.println(info.getSession("ID"), this, ">>>>>>>>>>>>>>>>>>>>>>>>> 2");
        SepoaOut value = ServiceConnector.doService(info, "MT_014", "TRANSACTION", "DeleteSendNotice_New", obj);
        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap messages = MessageUtil.getMessage(info, multilang_id);
        String uObj[] = {
            messages.get("MESSAGE.0001").toString(), String.valueOf(value.status)
        };
        ws.setUserObject(uObj);
        ws.setCode(String.valueOf(value.status));
        ws.setMessage(value.message);
        ws.write();
    }

    Message msg;
}
