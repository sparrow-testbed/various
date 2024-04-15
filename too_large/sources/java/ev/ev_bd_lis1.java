package ev;

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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ev_bd_lis1 extends HttpServlet
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException
    {
    	Logger.debug.println();
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
	{
		doPost(req, res);
	}

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
    {
        info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        String mode = "";
        PrintWriter out = res.getWriter();
        
        try {
    		
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("ev_bd_lis1".equals(mode)){ 
    			gdRes = this.ev_bd_lis1(gdReq, info);
    		}else if("copy".equals(mode)){
    			gdRes = this.ev_copy(gdReq, info);
//    			Logger.debug.println();
    		}else if("delete".equals(mode)){
    			gdRes = ev_delete(gdReq, info);
//    			Logger.debug.println();
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


    public GridData ev_bd_lis1(GridData gdReq, SepoaInfo info) throws Exception
    {
    	
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
	    	
	    	value = ServiceConnector.doService(info, "WO_001", "CONNECTION","ev_bd_lis1", obj);
	
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
    	
        /* GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	String sheet_kind = JSPUtil.CheckInjection(gdReq.getParam("sheet_kind")).trim();
        	String sg_kind = JSPUtil.CheckInjection(gdReq.getParam("sg_kind")).trim();
        	String use_flag = JSPUtil.CheckInjection(gdReq.getParam("use_flag")).trim();
        	String ev_year = JSPUtil.CheckInjection(gdReq.getParam("ev_year")).trim();
        	String subject = JSPUtil.CheckInjection(gdReq.getParam("subject")).trim();
        	String sheet_status = JSPUtil.CheckInjection(gdReq.getParam("sheet_status")).trim();

        	
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            //EJB CALL
	        Object[] obj = { sheet_kind,  sg_kind,  use_flag,  ev_year,  subject, sheet_status };
	    	SepoaOut value = ServiceConnector.doService(info, "WO_001", "CONNECTION","ev_bd_lis1", obj);

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
            		if(grid_col_ary[k] != null && grid_col_ary[k].equals("selected")) {
                		gdRes.addValue("selected", "0");
                	} 
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("ST_DATE") ){
            			gdRes.addValue("ST_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
            		}
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("END_DATE") ){
            			gdRes.addValue("END_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
            		}
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE") ){
            			gdRes.addValue("ADD_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
            		}
            		else if( grid_col_ary[k] != null && grid_col_ary[k].equals("CHANGE_DATE") ){
            			gdRes.addValue("CHANGE_DATE", SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
            		}		
            		else {
                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
            }
        }
        catch (Exception e)
        {
        	System.out.println("Exception : " + e.getMessage());
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;*/
    }
    
    public GridData ev_copy( GridData gdReq , SepoaInfo info) throws Exception {
    	GridData gdRes      = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message     = MessageUtil.getMessage( info, multilang_id );
        String cur_yyyy     = ""+SepoaDate.getYear();
        try
        {
        	gdRes.setSelectable(false);
        	String temp_ev_no   = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("temp_ev_no") )).replaceAll("/", "").trim();
        	String temp_ev_year = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("temp_ev_year") )).replaceAll("/", "").trim();
        	String temp_subject = JSPUtil.CheckInjection( JSPUtil.convertStr( gdReq.getParam("temp_subject") )).replaceAll("/", "").trim();
        	
	        Object[] obj   = { temp_ev_no, temp_ev_year, temp_subject };
	        SepoaOut value = ServiceConnector.doService(info, "WO_001", "TRANSACTION", "ev_copy", obj);
	        
	        
	        
	        if(value.flag){
	        	gdRes.setMessage(message.get("MESSAGE.0001").toString());
	        	gdRes.addParam("POP", "Y");
                gdRes.addParam("ev_no"   , value.result[0]);
                gdRes.addParam("ev_year" , cur_yyyy);
                
                gdRes.setStatus("true");
            }
            else{
            	gdRes.setMessage(value.message);
            	gdRes.setStatus("false");
            }
        }
        catch (Exception e)
        {
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "insert");
        return gdRes;
    } 
    
    public GridData ev_delete(GridData gdReq, SepoaInfo info) throws Exception
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
            		gdReq.getValue("EV_NO"    ,		i),
            		gdReq.getValue("EV_YEAR"  ,		i)
	            };

	            bean_args[i] = loop_data1;
	        }

	        Object[] obj = {	
				        		bean_args
	        				};
	        
	    	SepoaOut value = ServiceConnector.doService(info, "WO_001", "TRANSACTION","ev_delete", obj);

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
}
