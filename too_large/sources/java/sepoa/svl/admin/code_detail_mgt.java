package sepoa.svl.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;


public class code_detail_mgt extends HttpServlet {

    private static final long serialVersionUID = 4192327161504315436L;

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
            gdReq = OperateGridData.parse(req, res);

            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));

            if ("query".equals(mode))
            {
                gdRes = queryCodedList(gdReq, info);
            }
            else if ("insert".equals(mode))
            {
                gdRes = insertCodedList(gdReq, info);
            }
            else if ("delete".equals(mode))
            {
                gdRes = deleteCodedList(gdReq, info);
            }
            else if ("modify".equals(mode))
            {
               gdRes = modifyCodedList(gdReq, info);
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
                OperateGridData.write(req, res,gdRes, out);
            }
            catch (Exception e)
            {
            	Logger.debug.println();
            }
        }
    }

    public GridData queryCodedList(GridData gdReq, SepoaInfo info) throws Exception
    {	//쿼리조회
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaOut value = null;
        SepoaFormater wf = null;

        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
            //JSP 조회조건 받음
            String type = JSPUtil.CheckInjection(gdReq.getParam("type")).trim().toUpperCase();
            String code = JSPUtil.CheckInjection(gdReq.getParam("code")).trim().toUpperCase();
            String language = JSPUtil.CheckInjection(gdReq.getParam("language")).trim().toUpperCase();
            String search = JSPUtil.CheckInjection(gdReq.getParam("search")).trim().toUpperCase();
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");

            // Client에서 셋팅한 헤더와 동일하게 GridData를 복사한다.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");

            Object[] obj = {info, type, code, language, search};
	    	value = ServiceConnector.doService(info, "AD_015", "CONNECTION", "getCodedQuery", obj);

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

            //rowCount만큼 그리드헤더에 DB 조회값 셋팅
            for (int i = 0; i < rowCount; i++)
            {
                for(int k=0; k < grid_col_ary.length; k++)
                {
                	if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
                		gdRes.addValue("SELECTED", "0");
                	} else if(grid_col_ary[k] != null && grid_col_ary[k].equals("USE_FLAG")) {
                		if("Y".equals(wf.getValue("USE_FLAG", i))) {
                			gdRes.addValue("USE_FLAG", "1");
                		} else {
                			gdRes.addValue("USE_FLAG", "0");
                		}
                	} else {
                		gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                	}
                }
            }

        }
        catch (Exception e)
        {
        	
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }

    public GridData insertCodedList(GridData gdReq, SepoaInfo info) throws Exception
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
	        //공통타입만 따로 변수처리
	        String type = JSPUtil.CheckInjection(gdReq.getParam("type")).trim().toUpperCase();

	        for (int i = 0; i < row_count; i++)
	        {
	        	String sort_seq = "";
	        	if("".equals(gdReq.getValue("SORT_SEQ", i))){
	        		sort_seq = "1";
	        	}else{
	        		sort_seq = gdReq.getValue("SORT_SEQ", i);
	        	}

	        	//배열루프변수에 그리드 컬럼값 담기
	            String[] loop_data1 =
	            {
	            	gdReq.getValue("LANGUAGE", i),
	                gdReq.getValue("CODE", i),
	                gdReq.getValue("TEXT1", i),
	                gdReq.getValue("TEXT2", i),
	                gdReq.getValue("TEXT3", i),
	                gdReq.getValue("TEXT4", i),
	                gdReq.getValue("TEXT5", i),
	                gdReq.getValue("TEXT6", i),
	                gdReq.getValue("TEXT7", i),
	                gdReq.getValue("FLAG", i),
	                sort_seq,
	                gdReq.getValue("USE_FLAG", i)
	            };

	            bean_args[i] = loop_data1;
	            
	        }

            Object[] obj = {info, type, bean_args};
            SepoaOut value = ServiceConnector.doService(info, "AD_015", "TRANSACTION", "getCodedInsert", obj);

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
        gdRes.addParam("mode", "insert");
        return gdRes;
    }

    public GridData modifyCodedList(GridData gdReq, SepoaInfo info) throws Exception
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

	        //공통타입만 따로 변수처리
	        String type = JSPUtil.CheckInjection(gdReq.getParam("type")).trim().toUpperCase();

	        for (int i = 0; i < row_count; i++)
	        {
	        	String use_flag = "";
	        	if("1".equals(gdReq.getValue("USE_FLAG", i)))
	        	{
	        		use_flag = "Y";
            	}else{
            		use_flag = "N";
            	}

	            String[] loop_data1 =
	            {
	            	use_flag,
	            	gdReq.getValue("LANGUAGE", i),
	                gdReq.getValue("CODE", i),
	                gdReq.getValue("CODE", i),
	                gdReq.getValue("TEXT1", i),
	                gdReq.getValue("TEXT2", i),
	                gdReq.getValue("TEXT3", i),
	                gdReq.getValue("TEXT4", i),
	                gdReq.getValue("TEXT5", i),
	                gdReq.getValue("TEXT6", i),
	                gdReq.getValue("TEXT7", i),
	                gdReq.getValue("FLAG", i),
	                gdReq.getValue("SORT_SEQ", i)
	            };
	            Logger.debug.println(info.getSession("ID"), this, "######### getCodedModify------------------>>>>> : " + loop_data1);
	            bean_args[i] = loop_data1;

	        }

	         Object[] obj = {info, type, bean_args};
	         SepoaOut value = ServiceConnector.doService(info, "AD_015", "TRANSACTION", "getCodedModify", obj);

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

        gdRes.addParam("mode", "modify");
        return gdRes;
    }


    public GridData deleteCodedList(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();

        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
	        String type = JSPUtil.CheckInjection(gdReq.getParam("type")).trim().toUpperCase();

	        gdRes.setSelectable(false);
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data1 =
	            {
	            		gdReq.getValue("LANGUAGE", i),
	            		gdReq.getValue("CODE", i)
	            };

	            bean_args[i] = loop_data1;
	        }


	        Object[] obj = {info, type, bean_args};
	        SepoaOut value = ServiceConnector.doService(info, "AD_015", "TRANSACTION", "getCodedDelete", obj);

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
    }




    /*
     * ############################## Logger 관련 ##############################
     */

    /*
     * Logger(String method, String message)
     * method명과 message를 받아서 print한다.
     */
    public void Logger(String method, String message)
    {
        
    }

    /*
     * getSystemTime()
     * 현재의 시간을 Return한다.
     */
    private String getSystemTime()
    {
        Date currentDate = new Date();

        currentDate.setTime(System.currentTimeMillis());

        return currentDate.toString();
    }
}
