/**
 * @���ϸ�   : contract_form_list.java
 * @Location : sepoa.svl.contract
 * @������ : 2015. 01. 20
 * @�����̷� :
 * @���α׷� ���� :  
 */

package sepoa.svl.contract;

import java.io.IOException ;
import java.io.PrintWriter ;
import java.util.HashMap ;
import java.util.Map;
import java.util.Vector ;

import javax.servlet.ServletConfig ;
import javax.servlet.ServletException ;
import javax.servlet.http.HttpServlet ;
import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Config ;
import sepoa.fw.cfg.Configuration ;
import sepoa.fw.log.Logger ;
import sepoa.fw.ses.SepoaInfo ;
import sepoa.fw.srv.SepoaOut ;
import sepoa.fw.srv.ServiceConnector ;
import sepoa.fw.util.JSPUtil ;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater ;
import sepoa.fw.util.SepoaString ;
import xlib.cmc.GridData ;
import xlib.cmc.OperateGridData ;

public class contract_form_list extends HttpServlet {

	private static SepoaInfo info;

	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		
		info = sepoa.fw.ses.SepoaSession.getAllValue(req);

		GridData gdReq = new GridData();
		GridData gdRes = new GridData();
		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
		String mode = "";
		PrintWriter out = res.getWriter();

		try {
			String rawData = req.getParameter("WISEGRID_DATA");
			gdReq = OperateGridData.parse(req, res);
			mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));

			if ("doQuery".equals(mode)) {
				 gdRes = getContractList(gdReq);
			}else if (mode.equals("doRegistQuery")){
            	gdRes = getRegistQuery(gdReq);
            }else if (mode.equals("delete")){
            	gdRes = getDelete(gdReq);
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
	
	
    public GridData getContractList(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
       
        try
        {
        	
        	String cont_type         = JSPUtil.CheckInjection(gdReq.getParam("cont_type")).trim().toUpperCase();
        	String cont_status 	     = JSPUtil.CheckInjection(gdReq.getParam("cont_status")).trim().toUpperCase();
            String use_flag          = JSPUtil.CheckInjection(gdReq.getParam("use_flag")).trim().toUpperCase();
            String cont_private_flag = JSPUtil.CheckInjection(gdReq.getParam("cont_private_flag")).trim().toUpperCase();
            String cont_form_name    = JSPUtil.CheckInjection(gdReq.getParam("cont_form_name")).trim();
            String from_date         = JSPUtil.CheckInjection(gdReq.getParam("from_date")).trim().replaceAll("/","");
            String to_date           = JSPUtil.CheckInjection(gdReq.getParam("to_date")).trim().replaceAll("/","");
            String ctrl_person_id    = JSPUtil.CheckInjection(gdReq.getParam("ctrl_person_id")).trim();
            
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            //EJB CALL
	        Object[] obj = { info, cont_type, cont_status, use_flag, cont_private_flag, cont_form_name, from_date, to_date, ctrl_person_id  };
	    	SepoaOut value = ServiceConnector.doService(info, "CT_001", "CONNECTION","getContractList", obj);
            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
                return gdRes;
            }
            
            wf = new SepoaFormater(value.result[0]);
            rowCount = wf.getRowCount();
            
            if (rowCount == 0)
            {
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }
            
            for (int i = 0; i < rowCount; i++)
            {
            	for(int k=0; k < grid_col_ary.length; k++)
                {
            		if (grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")) {
						gdRes.addValue("ADD_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					}else {
						gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
					}
                }
            }
        }
        catch (Exception e)
        {
//        	System.out.println("Exception : " + e.getMessage());
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
    
    public GridData getRegistQuery(GridData gdReq) throws Exception
    {
    	GridData gdRes = new GridData();
    	int rowCount = 0;
    	SepoaFormater wf = null;
    	Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
    	HashMap message = MessageUtil.getMessage(info,multilang_id);
    	
    	try
    	{
    		String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
    		String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
    		
    		String cont_form_no  = JSPUtil.CheckInjection(gdReq.getParam("cont_form_no")).trim().toUpperCase();

    		gdRes = OperateGridData.cloneResponseGridData(gdReq);
    		gdRes.addParam("mode", "query");
    		
    		//EJB CALL
    		Object[] obj = {info, cont_form_no};
    		SepoaOut value = ServiceConnector.doService(info, "CT_001", "CONNECTION","getRegistList", obj);
    		
    		if(value.flag)
    		{
    			gdRes.setMessage(message.get("MESSAGE.0001").toString());
    			gdRes.setStatus("true");
    		}
    		else
    		{
    			gdRes.setMessage(value.message);
    			gdRes.setStatus("false");
    			return gdRes;
    		}
    		
    		wf = new SepoaFormater(value.result[0]);
    		rowCount = wf.getRowCount();
    		
    		if (rowCount == 0)
    		{
    			gdRes.setMessage(message.get("MESSAGE.1001").toString());
    			return gdRes;
    		}
    		
    		Config olConfxxxx = new Configuration();
    		String POASRM_CONTEXT_NAME = olConfxxxx.getString("sepoa.context.name");

    		for (int i = 0; i < rowCount; i++)
    		{
    			for(int k=0; k < grid_col_ary.length; k++)
    			{
    				if(grid_col_ary[k] != null && grid_col_ary[k].equals("POP_UP")) {
    					gdRes.addValue("POP_UP", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
                	} else {
                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
    			}
    		}
    	}
    	catch (Exception e)
    	{
//    		System.out.println("Exception : " + e.getMessage());
    		gdRes.setMessage(message.get("MESSAGE.1002").toString());
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
    
    public GridData getDelete(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
			gdRes.setSelectable(false);
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
	            {
            		gdReq.getValue("CONT_FORM_NO"  , i)
	            };

	            bean_args[i] = loop_data1;
	        }

	        Object[] obj = { bean_args };
	        
	    	SepoaOut value = ServiceConnector.doService(info, "CT_001", "TRANSACTION","getDelete", obj);

            if(value.flag)
            {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
	            gdRes.setStatus("true");
            }
            else
            {
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
        }
        catch (Exception e)
        {
        	gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "delete");
        return gdRes;
    }    

/*	public GridData getCreateList(GridData gdReq) throws Exception {
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info, multilang_id);

		try {

   			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);	//洹몃━���곗씠��
   			String grid_col_id     = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
   			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
   			
   			gdRes = OperateGridData.cloneResponseGridData(gdReq);
   			gdRes.addParam("mode", "getPoList");
   			
   			Object[] obj = {data};
   			SepoaOut value = ServiceConnector.doService(info, "CT_014", "CONNECTION", "getCreateList", obj);

			if (value.flag) {
				gdRes.setMessage(message.get("MESSAGE.0001").toString());
				gdRes.setStatus("true");
			} else {
				gdRes.setMessage(value.message);
				gdRes.setStatus("false");
				return gdRes;
			}

			wf = new SepoaFormater(value.result[0]);
			rowCount = wf.getRowCount();
			
			if (rowCount == 0) {
				gdRes.setMessage(message.get("MESSAGE.1001").toString());
				return gdRes;
			}
            
            Config conf = new Configuration ( ) ;
            String POASRM_CONTEXT_NAME = conf.getString ( "sepoa.context.name" ) ;
            for ( int i = 0 ; i < rowCount ; i ++ ) {
                for ( int k = 0 ; k < grid_col_ary.length ; k ++ ) {
                    if ( grid_col_ary [ k ] != null && grid_col_ary [ k ].equals ( "SELECTED" ) ) {
                        gdRes.addValue ( "SELECTED" , "0" ) ;
                    }
                    else if ( grid_col_ary [ k ] != null && grid_col_ary [ k ].equals ( "PRE_FILE_NO_IMG" ) ) {
                        if ( "".equals(wf.getValue ( "PRE_FILE_NO" , i ).trim ( ) ) ) {
                            gdRes.addValue ( "PRE_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/blank.gif") ;
                        } else {
                            if ( "".equals ( wf.getValue ( "PRE_INS_PATH" , i ).trim ( ) ) ) {
                                gdRes.addValue ( "PRE_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" ) ;
                            } else {
                                gdRes.addColorValue ( "PRE_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" , "#F2FFF5" ) ;
                            }
                        }
                    }
                    else if ( grid_col_ary [ k ] != null && grid_col_ary [ k ].equals ( "CONT_FILE_NO_IMG" ) ) {
                        if ( "".equals(wf.getValue ( "CONT_FILE_NO" , i ).trim ( ) ) ) {
                            gdRes.addValue ( "CONT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/blank.gif") ;
                        } else {
                            if ( "".equals ( wf.getValue ( "CONT_INS_PATH" , i ).trim ( ) ) ) {
                                gdRes.addValue ( "CONT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" ) ;
                            } else {
                                gdRes.addColorValue ( "CONT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" , "#F2FFF5" ) ;
                            }
                        }
                    }
                    else if ( grid_col_ary [ k ] != null && grid_col_ary [ k ].equals ( "FAULT_FILE_NO_IMG" ) ) {
                        if ( "".equals(wf.getValue ( "FAULT_FILE_NO" , i ).trim ( ) ) ) {
                            gdRes.addValue ( "FAULT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/blank.gif") ;
                        } else {
                            if ( "".equals ( wf.getValue ( "FAULT_INS_PATH" , i ).trim ( ) ) ) {
                                gdRes.addValue ( "FAULT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" ) ;
                            } else {
                                gdRes.addColorValue ( "FAULT_FILE_NO_IMG" , POASRM_CONTEXT_NAME + "/images/icon/icon_disk_b.gif" , "#F2FFF5" ) ;
                            }
                        }
                    } else {
                        gdRes.addValue ( grid_col_ary [ k ] , wf.getValue ( grid_col_ary [ k ] , i ) ) ;
                    }
                }
            }
            
        } catch ( Exception e ) {
            
            gdRes.setMessage ( message.get ( "MESSAGE.1002" ).toString ( ) ) ;
            gdRes.setStatus ( "false" ) ;
        }

		return gdRes;
	}
 
 
    //����
    public GridData setDelete(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

		try {
			gdRes.addParam("mode", "setPoInsert");
			gdRes.setSelectable(false);
			
			Map<String, Object> data = SepoaDataMapper.getData(info, gdReq);
			Object[] obj = {data};
			Map<String,String> header = MapUtils.getMap(data,"headerData");
			SepoaOut value = ServiceConnector.doService(info, "CT_014", "TRANSACTION","setDelete", obj);
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

        gdRes.addParam("mode", "delete");
        return gdRes;
    }*/
  	
}
