/**
 *=============================================
 * Copyright(c) 2013 SEPOASOFT
 * 작성자                : CSH
 * 프로그램명            : 신규사용자 승인 / 사용자 현황
 * @LastModifyDate     : 2013.03
 *=============================================
 */
package ict.sepoa.svl.admin;

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

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.*;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.msg.*;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import sepoa.svl.util.SepoaServlet;
import sepoa.svl.util.SepoaStream;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class user_status_ict extends SepoaServlet
{


    public void init(ServletConfig config) throws ServletException
    {
        //System.out.println("Servlet호출");
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
            
            
            
            if ("query".equals(mode)) {
                gdRes = getMainternace(gdReq , info);
            } else if ("doApproval".equals(mode)) {
                gdRes = doApproval(gdReq,info);
            } else if ("delete".equals(mode)) {
                gdRes = setDelete(gdReq,info);
            } else if ("restore".equals(mode)) {
                gdRes = setRestore(gdReq,info);
            } else if("profile".equals(mode)){
            	gdRes = setProfile(gdReq,info);
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
    
    
    
    
    public GridData setProfile(GridData gdReq, SepoaInfo info) throws Exception
    {
        
        GridData gdRes = new GridData();
        //20131217 sendakun
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );
      
        Map< String, Object >   allData     = null; // request 전체 데이터 받을 맵
        Map< String, String >   headerData  = null; // Header 데이터 받을 맵
        List< Map<String, String> >   gridData  = null; // gridData 데이터 받을 리스트

        try
        {
             allData = SepoaDataMapper.getData( info, gdReq );
             headerData = MapUtils.getMap( allData, "headerData" );
             gridData  = (List< Map<String, String> >) MapUtils.getObject( allData, "gridData");
             gdRes.setSelectable(false);

            Object[] obj = {gridData };

            SepoaOut value = ServiceConnector.doService(info, "I_AD_132", "TRANSACTION", "setProfile", obj);
            
            if(value.status == 1) {
                gdRes.setStatus("true");
            } else {
                gdRes.setStatus("false");
            }

            gdRes.setMessage(value.message);
            String[] str = new String[2];
            str[0] = String.valueOf(value.status);
            str[1] = value.message;
            gdRes.getMessage();
        }
        catch (Exception e)
        {   //실패라면
            gdRes.setMessage(message.get("MESSAGE.1003").toString());
            gdRes.setStatus("false");
        }
        //수행후 모드 반환
        gdRes.addParam("mode", "doApproval");
        return gdRes;
    } //setInsert() end
    
    
    
    /* 사용자 조회 메소드 */
    /* ICT 사용 */
    public GridData getMainternace(GridData gdReq , SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaOut value = null;
        SepoaFormater wf = null;
        //20131217 sendakun
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );

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
            value = ServiceConnector.doService(info, "I_AD_132", "CONNECTION", "getMainternace", obj);
            
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
            for (int i = 0; i < wf.getRowCount(); i++)
            {
                for(int k=0; k < grid_col_ary.length; k++)
                {
                    if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
                        gdRes.addValue("SELECTED", "0");
                    } else if ( grid_col_ary[k] != null && grid_col_ary[k].equals("PHONE_NO") ){
                        gdRes.addValue("PHONE_NO", SepoaString.decString ( wf.getValue(grid_col_ary[k], i) ,"PHONE"));
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
     * 직무담당자 승인 메소드
    *  doApproval
    *  수정일 : 2013/02
    */
    public GridData doApproval(GridData gdReq, SepoaInfo info) throws Exception
    {
        
        GridData gdRes = new GridData();
        //20131217 sendakun
        HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );
      
        Map< String, Object >   allData     = null; // request 전체 데이터 받을 맵
        Map< String, String >   headerData  = null; // Header 데이터 받을 맵
        List< Map<String, String> >   gridData  = null; // gridData 데이터 받을 리스트

        try
        {
             allData = SepoaDataMapper.getData( info, gdReq );
             headerData = MapUtils.getMap( allData, "headerData" );
             gridData  = (List< Map<String, String> >) MapUtils.getObject( allData, "gridData");
             gdRes.setSelectable(false);

            Object[] obj = {gridData };

            SepoaOut value = ServiceConnector.doService(info, "I_AD_132", "TRANSACTION", "setApproval", obj);
            
            if(value.status == 1) {
                gdRes.setStatus("true");
            } else {
                gdRes.setStatus("false");
            }

            gdRes.setMessage(value.message);
            String[] str = new String[2];
            str[0] = String.valueOf(value.status);
            str[1] = value.message;
            gdRes.getMessage();
        }
        catch (Exception e)
        {   //실패라면
            gdRes.setMessage(message.get("MESSAGE.1003").toString());
            gdRes.setStatus("false");
        }
        //수행후 모드 반환
        gdRes.addParam("mode", "doApproval");
        return gdRes;
    } //setInsert() end
    
    
   

    /* ICT 수정
     * 신규사용자 삭제 메소드
    *  setDelete
    *  수정일 : 2013/03
    */
    public GridData setDelete(GridData gdReq , SepoaInfo info) throws Exception
    {
          GridData gdRes = new GridData();
          //20131217 sendakun
          HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );
                
          Map< String, Object >   allData     = null; 
          Map< String, String >   headerData  = null; 
          List< Map<String, String> >   gridData  = null; 
        try
        {

             allData = SepoaDataMapper.getData( info, gdReq );
             headerData = MapUtils.getMap( allData, "headerData" );
             gridData  = (List< Map<String, String> >) MapUtils.getObject( allData, "gridData");
             gdRes.setSelectable(false);

             Object[] obj = {gridData };
             SepoaOut value = ServiceConnector.doService(info, "I_AD_132", "TRANSACTION", "setDelete", obj);
            
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
    
   
    
    /* ICT 수정
     * 신규사용자 삭제 메소드
    *  setDelete
    *  수정일 : 2013/03
    */
    public GridData setRestore(GridData gdReq , SepoaInfo info) throws Exception
    {
          GridData gdRes = new GridData();

          HashMap message = MessageUtil.getMessageMap( info, "MESSAGE" );
                
          Map< String, Object >   allData     = null; 
          Map< String, String >   headerData  = null; 
          List< Map<String, String> >   gridData  = null; 
        try
        {

             allData = SepoaDataMapper.getData( info, gdReq );
             headerData = MapUtils.getMap( allData, "headerData" );
             gridData  = (List< Map<String, String> >) MapUtils.getObject( allData, "gridData");
             gdRes.setSelectable(false);

             Object[] obj = {gridData };
             SepoaOut value = ServiceConnector.doService(info, "I_AD_132", "TRANSACTION", "setRestore", obj);
            
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
        

        gdRes.addParam("mode", "restore");
        return gdRes;
    }// setDelete() end 
     
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////
////
//                       jsp에서 없는 로직. 주석처리 하였습니다. 2013.03.22 C.S.H                       //
////
//////////////////////////////////////////////////////////////////////////////////////////////////////////   
    
    
/*

	private void setStatusD(SepoaStream ws, String mode) throws Exception
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
			String temp_user[] = {USER_ID[i]};
			args_user[i] = temp_user;
			String temp_addr[] = {USER_ID[i]};
			args_addr[i] = temp_addr;
		}
		Object[] obj = {args_user, args_addr};
        SepoaOut value = ServiceConnector.doService(info, "I_AD_132", "TRANSACTION","setStatusD", obj);
        String userObject[] = {value.message};
		ws.setUserObject(userObject);
        ws.setCode(value.status+"");
        ws.setMessage(value.message);
        ws.write();
	}*/
}
