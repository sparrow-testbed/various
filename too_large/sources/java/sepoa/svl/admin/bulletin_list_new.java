package sepoa.svl.admin;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.Message;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;

public class bulletin_list_new extends SepoaServlet
{

	private static final long serialVersionUID = -8667182084747591247L;

	public bulletin_list_new()
    {
//        msg = new Message("KO", "STDCOMM");
		Logger.debug.println();
    }

    public void doQuery(SepoaStream ws)
        throws Exception
    {
        String mode = ws.getParam("mode");

        

        if("getSendNotice".equals(mode)){
            getSendNotice(ws, mode);
        }
        if("getSupNotice".equals(mode)) {
            getSupNotice(ws, mode);
        }
        if("getSupNotice_seller".equals(mode)){
        	getSupNotice_seller(ws, mode);
        }
        if("getSupFaq".equals(mode)){
        	getSupFaq(ws, mode);
        }
        if("getDataStore".equals(mode)) {
        	getDataStore(ws, mode);
        }
        if("getSupRpt".equals(mode)){
        	getSupRpt(ws, mode);
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

    private void getSupNotice(SepoaStream ws, String mode) throws Exception {
    	
    	Map<String,String> data1=new HashMap();
    	
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        String gubun = JSPUtil.CheckInjection(ws.getParam("gubun")).trim().toUpperCase();
        String quest = JSPUtil.CheckInjection(ws.getParam("quest")).trim().toUpperCase();
        String company_code = JSPUtil.CheckInjection(ws.getParam("company_code")).trim().toUpperCase();
        String dept_type = JSPUtil.CheckInjection(ws.getParam("dept_type")).trim().toUpperCase();
        String view_user_type = JSPUtil.CheckInjection(ws.getParam("view_user_type")).trim().toUpperCase();

        String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
        
        data1.put("gubun",gubun );
        data1.put("guest",quest );
        data1.put("company_code",company_code );
        data1.put("dept_type",dept_type );
        data1.put("view_user_type",view_user_type );
        
        Map<String,Object> data=new HashMap();
        data.put("headerData", data1);
        
        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
	        /*Object obj[] = {
	            gubun, quest, company_code,dept_type
	        };*/
        	
        	Object obj[] = {data};

	        Logger.debug.println(info.getSession("ID"), this, "gubun : " + gubun);
	        Logger.debug.println(info.getSession("ID"), this, "quest" + quest);
	        Logger.debug.println(info.getSession("ID"), this, "company_code : " + company_code);
	        Logger.debug.println(info.getSession("ID"), this, "dept_type : " + dept_type);
	        Logger.debug.println(info.getSession("ID"), this, "view_user_type : " + view_user_type);

	        SepoaOut value = ServiceConnector.doService(info, "MT_014", "CONNECTION", "getSupNotice", obj);
	        SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
	        Logger.debug.println(info.getSession("ID"), ws.getRequest(), new StringBuilder("info===>").append(info.getSession("ID")).toString());
	        Config conf = new Configuration();
	        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");

	        String user_type = info.getSession("USER_TYPE");
	        String is_admin_user = info.getSession("IS_ADMIN_USER");

	        

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
//	            if(!user_type.equals("S") && is_admin_user.equals("true")){
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
    
    /**
     * 자료실목록 조회
     */
    private void getDataStore(SepoaStream ws, String mode) throws Exception {
    	
    	Map<String,String> data1=new HashMap();
    	
        SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
        String gubun = JSPUtil.CheckInjection(ws.getParam("gubun")).trim().toUpperCase();
        String quest = JSPUtil.CheckInjection(ws.getParam("quest")).trim().toUpperCase();
        String company_code = JSPUtil.CheckInjection(ws.getParam("company_code")).trim().toUpperCase();
        String dept_type = JSPUtil.CheckInjection(ws.getParam("dept_type")).trim().toUpperCase();
        String view_user_type = JSPUtil.CheckInjection(ws.getParam("view_user_type")).trim().toUpperCase();

        String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
        
        data1.put("gubun",gubun );
        data1.put("guest",quest );
        data1.put("company_code",company_code );
        data1.put("dept_type",dept_type );
        data1.put("view_user_type",view_user_type );
        
        Map<String,Object> data=new HashMap();
        data.put("headerData", data1);
        
        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
	        /*Object obj[] = {
	            gubun, quest, company_code,dept_type
	        };*/
        	
        	Object obj[] = {data};

	        SepoaOut value = ServiceConnector.doService(info, "MT_014", "CONNECTION", "getDataStore", obj);
	        SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
	        Logger.debug.println(info.getSession("ID"), ws.getRequest(), new StringBuilder("info===>").append(info.getSession("ID")).toString());
	        Config conf = new Configuration();
	        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");

	        String user_type = info.getSession("USER_TYPE");
	        String is_admin_user = info.getSession("IS_ADMIN_USER");

	        

	        for(int i = 0; i < wf.getRowCount(); i++)
	        {
//    	            String check[] = {
//    	                "false", ""
//    	            };
//    	            String imagetext[] = {
//    	                "", wf.getValue("SUBJECT", i), wf.getValue("SUBJECT", i)
//    	            };
//    	            String imagetext1[] = {
//    	                (new StringBuilder(String.valueOf(POASRM_CONTEXT_NAME))).append("/images/button/detail.gif").toString(), "", wf.getValue("ATTACH_NO", i)
//    	            };
//    	            String imagetext_empty[] = {
//    	                "", "", ""
//    	            };
//
//    	            String imagetext_view_count[] = {
//    		                "", wf.getValue("VIEW_COUNT", i), wf.getValue("VIEW_COUNT", i)
//    		            };
//
//    	            ws.addValue("SELECTED", check, "");
//    	            ws.addValue("COMPANY_NAME", wf.getValue("COMPANY_NAME", i), "");
//    	            ws.addValue("DEPT_TYPE", wf.getValue("DEPT_TYPE", i), "");
//    	            ws.addValue("SUBJECT", imagetext, "");
//    	            ws.addValue("GONGJI_GUBUN", wf.getValue("GONGJI_GUBUN_DESC", i), "");
//
//    	            if(!user_type.equals("S") && is_admin_user.equals("true")){
//    	            	ws.addValue("VIEW_COUNT", imagetext_view_count, "");
//    	        	}else{
//    	        		ws.addValue("VIEW_COUNT", wf.getValue("VIEW_COUNT", i), "");
//    	        	}
//    	            ws.addValue("ADD_DATE", wf.getValue("ADD_DATE", i), "");
//    	            if(wf.getValue("ATTACH_NO", i).equals(""))
//    	                ws.addValue("ATTACH_NO", imagetext_empty, "");
//    	            else
//    	                ws.addValue("ATTACH_NO", imagetext1, "");
//    	            ws.addValue("CONTENT", wf.getValue("CONTENT", i), "");
//    	            ws.addValue("SEQ", wf.getValue("SEQ", i), "");

            	for(int k=0; k < grid_col_ary.length; k++)
                {
                	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
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
    
    
    private void getSupFaq(SepoaStream ws, String mode)
    		throws Exception
    		{
    	
    	
    	
    	Map<String,String> data1=new HashMap();
    	
    	SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
    	String gubun = JSPUtil.CheckInjection(ws.getParam("gubun")).trim().toUpperCase();
    	String quest = JSPUtil.CheckInjection(ws.getParam("quest")).trim().toUpperCase();
    	String company_code = JSPUtil.CheckInjection(ws.getParam("company_code")).trim().toUpperCase();
    	String dept_type = JSPUtil.CheckInjection(ws.getParam("dept_type")).trim().toUpperCase();
    	String view_user_type = JSPUtil.CheckInjection(ws.getParam("view_user_type")).trim().toUpperCase();
    	
    	String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
    	String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
    	
    	data1.put("gubun",gubun );
    	data1.put("guest",quest );
    	data1.put("company_code",company_code );
    	data1.put("dept_type",dept_type );
    	data1.put("view_user_type",view_user_type );
    	
    	Map<String,Object> data=new HashMap();
    	data.put("headerData", data1);
    	
    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
    	HashMap message = MessageUtil.getMessage(info,multilang_id);
    	
    	try
    	{
    		/*Object obj[] = {
	            gubun, quest, company_code,dept_type
	        };*/
    		
    		Object obj[] = {data};
    		
    		Logger.debug.println(info.getSession("ID"), this, "gubun : " + gubun);
    		Logger.debug.println(info.getSession("ID"), this, "quest" + quest);
    		Logger.debug.println(info.getSession("ID"), this, "company_code : " + company_code);
    		Logger.debug.println(info.getSession("ID"), this, "dept_type : " + dept_type);
    		Logger.debug.println(info.getSession("ID"), this, "view_user_type : " + view_user_type);
    		
    		SepoaOut value = ServiceConnector.doService(info, "MT_014", "CONNECTION", "getSupFaq", obj);
    		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
    		Logger.debug.println(info.getSession("ID"), ws.getRequest(), new StringBuilder("info===>").append(info.getSession("ID")).toString());
    		Config conf = new Configuration();
    		String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
    		
    		String user_type = info.getSession("USER_TYPE");
    		String is_admin_user = info.getSession("IS_ADMIN_USER");
    		
    		
    		
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
//	            if(!user_type.equals("S") && is_admin_user.equals("true")){
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
    private void getSupNotice_seller(SepoaStream ws, String mode)
            throws Exception
        {

        	

            SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
            String gubun = JSPUtil.CheckInjection(ws.getParam("gubun")).trim().toUpperCase();
            String quest = JSPUtil.CheckInjection(ws.getParam("quest")).trim().toUpperCase();
            String company_code = JSPUtil.CheckInjection(ws.getParam("company_code")).trim().toUpperCase();
            String dept_type = JSPUtil.CheckInjection(ws.getParam("dept_type")).trim().toUpperCase();

            String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

            Vector multilang_id = new Vector();
            multilang_id.addElement("MESSAGE");
            HashMap message = MessageUtil.getMessage(info,multilang_id);

            try
            {
    	        Object obj[] = {
    	            gubun, quest, company_code,dept_type
    	        };

    	        Logger.debug.println(info.getSession("ID"), this, "gubun : " + gubun);
    	        Logger.debug.println(info.getSession("ID"), this, "quest" + quest);
    	        Logger.debug.println(info.getSession("ID"), this, "company_code : " + company_code);
    	        Logger.debug.println(info.getSession("ID"), this, "dept_type : " + dept_type);

    	        SepoaOut value = ServiceConnector.doService(info, "MT_014", "CONNECTION", "getSupNotice_seller", obj);
    	        SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
    	        Logger.debug.println(info.getSession("ID"), ws.getRequest(), new StringBuilder("info===>").append(info.getSession("ID")).toString());
    	        Config conf = new Configuration();
    	        String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");

    	        String user_type = info.getSession("USER_TYPE");
    	        String is_admin_user = info.getSession("IS_ADMIN_USER");

    	        

    	        for(int i = 0; i < wf.getRowCount(); i++)
    	        {
//    	            String check[] = {
//    	                "false", ""
//    	            };
//    	            String imagetext[] = {
//    	                "", wf.getValue("SUBJECT", i), wf.getValue("SUBJECT", i)
//    	            };
//    	            String imagetext1[] = {
//    	                (new StringBuilder(String.valueOf(POASRM_CONTEXT_NAME))).append("/images/button/detail.gif").toString(), "", wf.getValue("ATTACH_NO", i)
//    	            };
//    	            String imagetext_empty[] = {
//    	                "", "", ""
//    	            };
    //
//    	            String imagetext_view_count[] = {
//    		                "", wf.getValue("VIEW_COUNT", i), wf.getValue("VIEW_COUNT", i)
//    		            };
    //
//    	            ws.addValue("SELECTED", check, "");
//    	            ws.addValue("COMPANY_NAME", wf.getValue("COMPANY_NAME", i), "");
//    	            ws.addValue("DEPT_TYPE", wf.getValue("DEPT_TYPE", i), "");
//    	            ws.addValue("SUBJECT", imagetext, "");
//    	            ws.addValue("GONGJI_GUBUN", wf.getValue("GONGJI_GUBUN_DESC", i), "");
    //
//    	            if(!user_type.equals("S") && is_admin_user.equals("true")){
//    	            	ws.addValue("VIEW_COUNT", imagetext_view_count, "");
//    	        	}else{
//    	        		ws.addValue("VIEW_COUNT", wf.getValue("VIEW_COUNT", i), "");
//    	        	}
//    	            ws.addValue("ADD_DATE", wf.getValue("ADD_DATE", i), "");
//    	            if(wf.getValue("ATTACH_NO", i).equals(""))
//    	                ws.addValue("ATTACH_NO", imagetext_empty, "");
//    	            else
//    	                ws.addValue("ATTACH_NO", imagetext1, "");
//    	            ws.addValue("CONTENT", wf.getValue("CONTENT", i), "");
//    	            ws.addValue("SEQ", wf.getValue("SEQ", i), "");

                	for(int k=0; k < grid_col_ary.length; k++)
                    {
                    	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
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
        else if("setFaqDelete".equals(mode)) {
        	setFaqDelete(ws, mode);
        }
        else if("setDataStoreDelete".equals(mode)) {
        	setDataStoreDelete(ws, mode);
        }
        else if("setRptDelete".equals(mode)) {
        	setRptDelete(ws, mode);
        }
    }

    
    private void setDataStoreDelete(SepoaStream ws, String mode)
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
            SepoaOut value = ServiceConnector.doService(info, "MT_014", "TRANSACTION", "DeleteSendDataStore_New", obj);
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
    private void setFaqDelete(SepoaStream ws, String mode)
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
    	SepoaOut value = ServiceConnector.doService(info, "MT_014", "TRANSACTION", "DeleteSendFaq_New", obj);
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

    
    
    private void getSupRpt(SepoaStream ws, String mode)
    		throws Exception
    		{
    	
    	
    	
    	Map<String,String> data1=new HashMap();
    	
    	SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
    	String gubun = JSPUtil.CheckInjection(ws.getParam("gubun")).trim().toUpperCase();
    	String quest = JSPUtil.CheckInjection(ws.getParam("quest")).trim().toUpperCase();
//    	String company_code = JSPUtil.CheckInjection(ws.getParam("company_code")).trim().toUpperCase();
    	String company_code = info.getSession("COMPANY_CODE");
    	String dept_type = JSPUtil.CheckInjection(ws.getParam("dept_type")).trim().toUpperCase();
    	String gongji_gubun = JSPUtil.CheckInjection(ws.getParam("gongji_gubun")).trim().toUpperCase();
    			
    			
    	
    	String grid_col_id = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
    	String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
    	
    	data1.put("gubun",gubun );
    	data1.put("guest",quest );
    	data1.put("company_code",company_code );
    	data1.put("dept_type",dept_type );
    	data1.put("gongji_gubun",gongji_gubun );
    	
    	Map<String,Object> data=new HashMap();
    	data.put("headerData", data1);
    	
    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
    	HashMap message = MessageUtil.getMessage(info,multilang_id);
    	
    	try
    	{
    		if (quest.indexOf("'") >= 0 || quest.indexOf("%") >= 0 || quest.indexOf("!") >= 0 || quest.indexOf("-") >= 0 || quest.indexOf("#") >= 0) {
				throw new Exception("특수문자 입력불가");
			}
    		/*Object obj[] = {
	            gubun, quest, company_code,dept_type
	        };*/
    		
    		Object obj[] = {data};
    		
//    		Logger.debug.println(info.getSession("ID"), this, "gubun : " + gubun);
//    		Logger.debug.println(info.getSession("ID"), this, "quest" + quest);
//    		Logger.debug.println(info.getSession("ID"), this, "company_code : " + company_code);
//    		Logger.debug.println(info.getSession("ID"), this, "dept_type : " + dept_type);
//    		Logger.debug.println(info.getSession("ID"), this, "view_user_type : " + view_user_type);
    		
    		SepoaOut value = ServiceConnector.doService(info, "MT_014", "CONNECTION", "getSupRpt", obj);
    		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);
    		Logger.debug.println(info.getSession("ID"), ws.getRequest(), new StringBuilder("info===>").append(info.getSession("ID")).toString());
    		Config conf = new Configuration();
    		String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
    		
    		String user_type = info.getSession("USER_TYPE");
    		String is_admin_user = info.getSession("IS_ADMIN_USER");
    		
    		
    		
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
//	            if(!user_type.equals("S") && is_admin_user.equals("true")){
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
    
    
    private void setRptDelete(SepoaStream ws, String mode)
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
    	SepoaOut value = ServiceConnector.doService(info, "MT_014", "TRANSACTION", "DeleteSendRpt_New", obj);
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
