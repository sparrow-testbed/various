/**
 * @파일명   : mail_send_history.java
 * @생성일자 : 2009. 03. 25
 * @작성자   : 전선경
 * @변경이력 :
 * @프로그램 설명 : Mail전송내역
 */
package sepoa.svl.admin;

import java.io.IOException;
import java.io.PrintWriter;
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

public class mail_send_history extends HttpServlet
{
	private static final long serialVersionUID = -7212746709457709775L;

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
            //String rawData = req.getParameter("WISEGRID_DATA");            
            //Logger.debug.println(info.getSession("ID"), this, "######### rawdata : " + rawData);
            
            gdReq = OperateGridData.parse(req, res);
            
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
            Logger.debug.println(info.getSession("ID"), this, "mode=="+mode);

            if ("query".equals(mode))
            {
                gdRes = getMailSendHistoryList(gdReq, info);
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

    
    public GridData getMailSendHistoryList(GridData gdReq, SepoaInfo info) throws Exception
    {
    	
    	//Logger.debug.println(info.getSession("ID"), this, "xxxxxxxxxxxxxxxxx");
    	
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaOut value = null;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        { 

            String start_sign_date		= SepoaString.getDateUnSlashFormat(JSPUtil.CheckInjection(gdReq.getParam("start_sign_date")).trim());
            String end_sign_date		= SepoaString.getDateUnSlashFormat(JSPUtil.CheckInjection(gdReq.getParam("end_sign_date")).trim());
            String mail_send_no			= JSPUtil.CheckInjection(gdReq.getParam("mail_send_no")).trim();
            String mail_send_search		= JSPUtil.CheckInjection(gdReq.getParam("mail_send_search")).trim();
            String mail_send_search_word= JSPUtil.CheckInjection(gdReq.getParam("mail_send_search_word")).trim();
            
        	
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            // Client에서 셋팅한 헤더와 동일하게 GridData를 복사한다.
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
         	
            Object[] obj = {start_sign_date, end_sign_date, mail_send_no, mail_send_search, mail_send_search_word};
	    	value = ServiceConnector.doService(info, "AD_051", "CONNECTION", "getMailSendHistoryList", obj);

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

            int rowNumber = rowCount;
            
            
            for (int i = 0; i < rowCount; i++)
            {
            	for(int k=0; k < grid_col_ary.length; k++)
                {
                	gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
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
    
       
}
