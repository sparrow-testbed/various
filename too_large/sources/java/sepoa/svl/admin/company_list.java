package sepoa.svl.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.*;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.msg.*;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaRemote;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class company_list extends HttpServlet
{
	
	

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
    	SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
       
        String mode = "";
        PrintWriter out = res.getWriter();
        
        try
        {
           // String rawData = req.getParameter("WISEGRID_DATA");            
            gdReq = OperateGridData.parse(req, res);
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
            
            
            if ("query".equals(mode))
            {
                gdRes = getMaintenance(gdReq , info);
            }           
            else if ("delete".equals(mode))
            {
                gdRes = setDelete(gdReq,info);
            }
            
        }
        catch (Exception e)
        {
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
            
        }
        finally
        {
            try
            {
                OperateGridData.write(req, res, gdRes, out);
            }
            catch (Exception e)
            {
            	Logger.debug.println();
            }
        }
    }
    
    
	/**
	 * 회사정보 조회 메소드
	*  queryCodeh
	*  수정일 : 2013/02
	*/
    public GridData getMaintenance(GridData gdReq , SepoaInfo info) throws Exception
    {
    	GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaOut value = null;
        SepoaFormater wf = null;
        
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info, multilang_id);
        Map< String, Object >   allData     = null; // request 전체 데이터 받을 맵
        Map< String, String >   headerData  = null; // Header 데이터 받을 맵

        try
        { 
        	allData = SepoaDataMapper.getData( info, gdReq );
            headerData = MapUtils.getMap( allData, "headerData" );
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            // Client에서 셋팅한 헤더와 동일하게 GridData를 복사한다.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");          
            
            //EJB CALL
            Object[] obj = {allData};
	    	value = ServiceConnector.doService(info, "AD_102", "CONNECTION", "getMaintenance", obj);
	    
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
                	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
                		gdRes.addValue("SELECTED", "0");
                	} else {
                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
            }
            
            
        }
        catch (Exception e)
        {
        	
            gdRes.setMessage(message.get("MESSAGE.1002").toString()); //처리 중 오류가 발생하였습니다
            gdRes.setStatus("false");
        }
        
        return gdRes;
    }
    
    
	/**
	 * 회사정보 삭제 메소드
	*  deleteCodeh
	*  수정일 : 2013/02
	*/
    public GridData setDelete(GridData gdReq , SepoaInfo info) throws Exception
    {
      
		    	GridData gdRes = new GridData();
		        
		        //Servlet에서 사용할 Message를 가져온다.
		        Vector multilang_id = new Vector();
		    	multilang_id.addElement("MESSAGE");
		        HashMap message = MessageUtil.getMessage(info,multilang_id);
		        Map< String, Object >   allData     = null; // request 전체 데이터 받을 맵
		        Map< String, String >   headerData  = null; // Header 데이터 받을 맵
		        List< Map<String, String> >   gridData  = null; // gridData 데이터 받을 리스트
        
        try
        {
        	 allData = SepoaDataMapper.getData( info, gdReq );
             headerData = MapUtils.getMap( allData, "headerData" );
             gridData  = (List< Map<String, String> >) MapUtils.getObject( allData, "gridData");
        	 gdRes.setSelectable(false);

	        Object[] obj = {gridData};
	        SepoaOut value = ServiceConnector.doService(info, "AD_102", "TRANSACTION", "setDelete", obj);
	     
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
            
        }
        catch (Exception e)
        {
        	
        	
            gdRes.setMessage(message.get("MESSAGE.1002").toString()); //처리 중 오류가 발생하였습니다
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "delete");
        return gdRes;
    }
	
	
	/*public void doQuery(SepoaStream ws) throws Exception
	{
		String mode = ws.getParam("mode");
		if(mode.equals("getMaintain"))
    	{
			getMaintain(ws, mode);
    	}
	}

	private void getMaintain(SepoaStream ws, String mode) throws Exception {
		SepoaInfo info 		   = SepoaSession.getAllValue(ws.getRequest());
		String house_code 	   = info.getSession("house_code");
		String grid_col_id     = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

		String[] args = {house_code};
		Object[] obj = {args};
	    SepoaOut value = ServiceConnector.doService(info, "AD_102", "CONNECTION","getMaintenance", obj);
		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

	    //데이타가 없는 경우
        if(wf.getRowCount() == 0) {
        	Message msg = new Message(info,"p80");
        	ws.setCode("M001");
        	ws.setMessage(msg.getMessage("0024"));
        	ws.write();
        	return;
        }

        for(int i=0; i < wf.getRowCount(); i++) {
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

	public void doData(SepoaStream ws) throws Exception {
		String mode = ws.getParam("mode");
		
		if(mode.equals("delete"))
    	{
			setDelete(ws, mode);
    	}
	}

	private void setDelete(SepoaStream ws, String mode) throws Exception
	{
		SepoaFormater wf      = ws.getSepoaFormater();
		SepoaInfo info        = SepoaSession.getAllValue(ws.getRequest());
		String cur_date       = SepoaDate.getShortDateString();
		String cur_time       = SepoaDate.getShortTimeString();
		String change_user_id = ws.getParam("CHANGE_USER_ID");
		String[] st_com_code  = wf.getValue("COMPANY_CODE");
		
		String setData[][] = new String[wf.getRowCount()][];

		for (int i = 0; i<wf.getRowCount(); i++) {
			String Data[] = {sepoa.fw.util.CommonUtil.Flag.Yes.getValue(), change_user_id, cur_date, cur_time, st_com_code[i]};
			setData[i] = Data;
		}

		Object[] obj = {setData};
		SepoaOut value = ServiceConnector.doService(info,"AD_102","TRANSACTION","setDelete",obj);
		
		if(value.flag) ws.setStatus(true);
        else ws.setStatus(false);

	    String[] uObj = {String.valueOf(value.status), value.message };
	    ws.setUserObject(uObj);
	    ws.setCode(String.valueOf(value.status));
	    ws.setMessage(value.message);
	    ws.write();
	}*/

}
