package sepoa.svl.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.*;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class duty_code_list extends SepoaServlet
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
                gdRes = getMaintain(gdReq , info);
            }           
            else if ("setInsert".equals(mode))
            {
                gdRes = setInsert(gdReq,info);
            } else if ("setUpdate".equals(mode))
            {
                gdRes = setUpdate(gdReq,info);
            } else if ("setDelete".equals(mode))
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
	 * 총괄코드관리 조회 메소드
	*  getMaintain
	*  수정일 : 2013/02
	*/
    public GridData getMaintain(GridData gdReq , SepoaInfo info) throws Exception
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
	    	value = ServiceConnector.doService(info, "AD_115", "CONNECTION", "getMaintain", obj);
	    	
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
    } // getMaintain() end
    
    
    
    /**
	 * 직무코드 등록 메소드
	*  setInsert
	*  수정일 : 2013/02
	*/
    public GridData setInsert(GridData gdReq, SepoaInfo info) throws Exception
    {
    	
        GridData gdRes = new GridData();

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

            Object[] obj = {gridData , allData};

            SepoaOut value = ServiceConnector.doService(info, "AD_115", "TRANSACTION", "setInsert", obj);

            //성공이라면
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
        {	//실패라면
        	gdRes.setMessage(message.get("MESSAGE.1003").toString());
            gdRes.setStatus("false");
        }
        //수행후 모드 반환
        gdRes.addParam("mode", "setInsert");
        return gdRes;
    } //setInsert() end
    
    
    /**
  	 * 직무코드 수정 메소드
  	*  setUpdate
  	*  수정일 : 2013/02
  	*/
    public GridData setUpdate(GridData gdReq , SepoaInfo info) throws Exception
    {
    	  GridData gdRes = new GridData();

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

	         Object[] obj = {gridData , allData};
	         SepoaOut value = ServiceConnector.doService(info, "AD_115", "TRANSACTION", "setUpdate", obj);
	         
	    	 
            //성공이라면
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
        	//실패라면
        	gdRes.setMessage(message.get("MESSAGE.1003").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "setUpdate");
        return gdRes;
    }// setUpdate() end
    
    
    

    /**
     * 직무코드 삭제 메소드
    *  setDelete
    *  수정일 : 2013/02
    */
    public GridData setDelete(GridData gdReq , SepoaInfo info) throws Exception
    {
          GridData gdRes = new GridData();

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

             Object[] obj = {gridData , allData};
             SepoaOut value = ServiceConnector.doService(info, "AD_115", "TRANSACTION", "setDelete", obj);
            
            //성공이라면
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
            //실패라면
            gdRes.setMessage(message.get("MESSAGE.1003").toString());
            gdRes.setStatus("false");
        }

        gdRes.addParam("mode", "delete");
        return gdRes;
    }// setDelete() end   
    
    

}
