package sepoa.svl.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.rmi.PortableRemoteObject;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.*;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;


public class user_work_list extends HttpServlet
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException
    {
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
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
        String mode="";
        PrintWriter out = res.getWriter();

        try
        {
            String rawData = req.getParameter("WISEGRID_DATA");
            gdReq = OperateGridData.parse(req, res);
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
//            System.out.println("mode : " + mode);
            
            if ("query".equals(mode))
            {
                gdRes = getJobList(gdReq , info);
            } 
        }
        catch (Exception e)
        {
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("999");
            
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
    * 사용자별 작업내역페이지 조회 메소드
    *  getBulletinList
    *  수정일 : 2013/03
    *  C
    */   
    
    public GridData getJobList(GridData gdReq , SepoaInfo info) throws Exception
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
            
            headerData.put( "from_date" , SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "from_date" ) ) );
            headerData.put( "to_date" , SepoaString.getDateUnSlashFormat( MapUtils.getString( headerData, "to_date" ) ) );
            
            // Client에서 셋팅한 헤더와 동일하게 GridData를 복사한다.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");          
            
            //EJB CALL
            Object[] obj = {allData};
            value = ServiceConnector.doService(info, "AD_028", "CONNECTION", "getJobList", obj);
            
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
            
            Config conf = new Configuration();
            String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
            for (int i = 0; i < rowCount; i++)
            {
                for(int k=0; k < grid_col_ary.length; k++)
                {
                    if(grid_col_ary[k] != null && grid_col_ary[k].equals("selected"))
                    {
                        gdRes.addValue("selected", "0");
                    }
                    else
                    {
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
    } // getJobList() end
    
    
  
    
   
}
