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

import sepoa.fw.log.Logger ;
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
import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;

public class duty_user_mgt extends SepoaServlet
{
    
    

    public void init(ServletConfig config) throws ServletException
    {
        //System.out.println("Servlet호출");
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
                gdRes = getMaintain1(gdReq , info);
            }           
            else if ("setInsert".equals(mode))
            {
                gdRes = setInsert1(gdReq,info);
            } else if ("setDelete1".equals(mode))
            {
                gdRes = setDelete1(gdReq,info);
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
     * 직무담당자 조회 메소드
    *  getMaintain1
    *  수정일 : 2013/02
    */
    public GridData getMaintain1(GridData gdReq , SepoaInfo info) throws Exception
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
            value = ServiceConnector.doService(info, "AD_115", "CONNECTION", "getMaintain1", obj);
            
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

                    } else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CTRL_TYPE_IMG")) {
                        gdRes.addValue("CTRL_TYPE_IMG", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
                    } else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CTRL_CODE_IMG")) {
                        gdRes.addValue("CTRL_CODE_IMG", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
                    } else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CTRL_PERSON")) {
                        gdRes.addValue("CTRL_PERSON", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
                    } else if ( grid_col_ary[k] != null && grid_col_ary[k].equals("PHONE_NO") ){
                        gdRes.addValue("PHONE_NO", SepoaString.decString ( wf.getValue(grid_col_ary[k], i) ,"PHONE"));
                    } else if(grid_col_ary[k] != null && grid_col_ary[k].equals("GUBUN")) {
                        gdRes.addValue("GUBUN", "U");
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
     * 직무담당자 등록 메소드
    *  setInsert1
    *  수정일 : 2013/02
    */
    public GridData setInsert1(GridData gdReq, SepoaInfo info) throws Exception
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

            Object[] obj = {gridData , headerData};

            SepoaOut value = ServiceConnector.doService(info, "AD_115", "TRANSACTION", "setInsert1", obj);

            if(value.status == 1) {
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            } else {
                gdRes.setMessage(value.message);
                gdRes.setStatus("false");
            }

            gdRes.setMessage(value.message);
            String[] str = new String[2];
            str[0] = String.valueOf(value.status);
            str[1] = value.message;

            //gdRes.setStatus(str);
            gdRes.getMessage();
        }
        catch (Exception e)
        {   //실패라면
            gdRes.setMessage(message.get("MESSAGE.1003").toString());
            gdRes.setStatus("false");
        }
        //수행후 모드 반환
        gdRes.addParam("mode", "setinsert1");
        return gdRes;
    } //setInsert() end
    
    
   

    /**
     * 직무코드 삭제 메소드
    *  setDelete1
    *  수정일 : 2013/02
    */
    public GridData setDelete1(GridData gdReq , SepoaInfo info) throws Exception
    {
          GridData gdRes = new GridData();

          Vector multilang_id = new Vector();
          multilang_id.addElement("MESSAGE");
          HashMap message = MessageUtil.getMessage(info,multilang_id);
                
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
             SepoaOut value = ServiceConnector.doService(info, "AD_115", "TRANSACTION", "setDelete1", obj);
            
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
    
    
	/*public void doQuery(SepoaStream ws) throws Exception
	{
		// Session d��
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());
		String house_code = info.getSession("HOUSE_CODE");

		// Parameter d��
		String i_company_code = JSPUtil.paramCheck(ws.getParam("i_company_code"));
		String i_ctrl_code = JSPUtil.paramCheck(ws.getParam("i_ctrl_code"));
		String i_ctrl_type = JSPUtil.paramCheck(ws.getParam("i_ctrl_type"));
		String i_ctrl_person_id = JSPUtil.paramCheck(ws.getParam("i_ctrl_person_id"));
		String grid_col_id     = JSPUtil.CheckInjection(ws.getParam("grid_col_id")).trim();
        String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

		String[] args =
		{
			i_company_code, i_ctrl_code, i_ctrl_type, i_ctrl_person_id
		};

		SepoaOut value = ServiceConnector.doService(info, "AD_115", "CONNECTION", "getMaintain1", args);

		if(value.status == 1) {
            ws.setStatus(true);
        } else {
        	ws.setStatus(false);
        }

		SepoaFormater wf = ws.getSepoaFormater(value.result[0]);

//		if(wf.getRowCount() > 0) {
//			java.util.HashMap rows_merge_map = new java.util.HashMap();
//			rows_merge_map.put("CTRL_TYPE_NAME", wf.getAllColumnValue("CTRL_TYPE_NAME"));
//			rows_merge_map.put("CTRL_CODE", wf.getAllColumnValue("CTRL_CODE"));
//			ws.setRowsMergeMap(rows_merge_map);
//		}

		Config olConfxxxx = new Configuration();
		String POASRM_CONTEXT_NAME = olConfxxxx.getString("sepoa.context.name");

		for (int i = 0; i < wf.getRowCount(); i++)
		{
			for(int k=0; k < grid_col_ary.length; k++)
            {
            	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
            		ws.addValue("SELECTED", "0");
//            	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CTRL_TYPE_NAME")) {
//            		ws.addRowSpanValue("CTRL_TYPE_NAME", wf.getValue(grid_col_ary[k], i));
//            	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CTRL_CODE")) {
//            		ws.addRowSpanValue("CTRL_CODE", wf.getValue(grid_col_ary[k], i));
            	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CTRL_TYPE_IMG")) {
            		ws.addValue("CTRL_TYPE_IMG", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
            	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CTRL_CODE_IMG")) {
            		ws.addValue("CTRL_CODE_IMG", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
            	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CTRL_PERSON")) {
            		ws.addValue("CTRL_PERSON", POASRM_CONTEXT_NAME + "/images/icon/icon.gif");
            	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("GUBUN")) {
            		ws.addValue("GUBUN", "U");
            	} else {
            		ws.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
            	}
            }
		}

		ws.setMessage(value.message);
		ws.write();
	}

	public void doData(SepoaStream ws) throws Exception
	{
		//Sessin d��
		SepoaInfo info = SepoaSession.getAllValue(ws.getRequest());

		String house_code = info.getSession("HOUSE_CODE");
		String add_user_name1 = info.getSession("NAME_LOC");
		String add_user_name2 = info.getSession("NAME_ENG");
		String add_user_dept = info.getSession("DEPARTMENT");

		String i_mode = ws.getParam("i_mode");
		System.out.println("i_mode : " + i_mode);
		if (i_mode.equals("setInsert1"))
		{
			SepoaFormater wf = ws.getSepoaFormater();

			String[] CTRL_CODE = wf.getValue("CTRL_CODE");
			String[] CTRL_PERSON_ID = wf.getValue("CTRL_PERSON_ID");
			String[] CTRL_PERSON_NAME_LOC = wf.getValue("CTRL_PERSON_NAME_LOC");
			String[] PHONE_NO = wf.getValue("PHONE_NO");
			String[] COMPANY_CODE = wf.getValue("COMPANY_CODE");
			String[] CTRL_TYPE = wf.getValue("CTRL_TYPE");

			String[][] data = new String[wf.getRowCount()][];
			String[][] chkData = new String[wf.getRowCount()][];

			for (int i = 0; i < wf.getRowCount(); i++)
			{
				String[] temp =
				{
					COMPANY_CODE[i], CTRL_CODE[i], CTRL_TYPE[i],
					CTRL_PERSON_ID[i]
				};
				data[i] = temp;

				String[] chk_data =
				{
					COMPANY_CODE[i], CTRL_CODE[i], CTRL_TYPE[i],
					CTRL_PERSON_ID[i]
				};
				chkData[i] = chk_data;
			}

			Object[] obj = { (Object[]) data, (Object[]) chkData };
			SepoaOut value = ServiceConnector.doService(info, "AD_115", "TRANSACTION", "setInsert1", obj);

			if(value.status == 1) {
	            ws.setStatus(true);
	        } else {
	        	ws.setStatus(false);
	        }

			ws.setMessage(value.message);
			String[] str = new String[2];
			str[0] = String.valueOf(value.status);
			str[1] = value.message;

			ws.setUserObject(str);
		}
		else if (i_mode.equals("setDelete1"))
		{
			//Parameter d��
			SepoaFormater wf = ws.getSepoaFormater();
			String[] CTRL_CODE = wf.getValue("CTRL_CODE");
			String[] CTRL_PERSON_ID = wf.getValue("CTRL_PERSON_ID");
			String[] COMPANY_CODE = wf.getValue("COMPANY_CODE");
			String[] CTRL_TYPE = wf.getValue("CTRL_TYPE");

			String[][] args = new String[wf.getRowCount()][];

			for (int i = 0; i < wf.getRowCount(); i++)
			{
				String[] temp =
				{
					COMPANY_CODE[i], CTRL_TYPE[i], CTRL_CODE[i],
					CTRL_PERSON_ID[i]
				};
				args[i] = temp;
			}

			SepoaOut value = ServiceConnector.doService(info, "AD_115", "TRANSACTION", "setDelete1", args);

			if(value.status == 1) {
	            ws.setStatus(true);
	        } else {
	        	ws.setStatus(false);
	        }

			ws.setMessage(value.message);

			String[] str = new String[2];
			str[0] = String.valueOf(value.status);
			str[1] = value.message;

			ws.setUserObject(str);
		}

		ws.write();
	}*/
}
