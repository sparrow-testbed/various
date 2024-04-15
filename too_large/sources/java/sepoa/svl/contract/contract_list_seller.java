/**
 * @���ϸ�   : contract_list_seller.java
 * @Location : sepoa.svl.contract
 * @������ : 2009. 07. 15
 * @�����̷� : 2013. 03. 29  //CTY
 * @���α׷� ���� :  
 */


package sepoa.svl.contract;

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

import sepoa.fw.cfg.Config;
import sepoa.fw.cfg.Configuration;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class contract_list_seller extends HttpServlet {

    
    public void init(ServletConfig config) throws ServletException {
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        
        SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(req);

        GridData gdReq = new GridData();
        GridData gdRes = new GridData();
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        String mode = "";
        PrintWriter out = res.getWriter();

        try {
            gdReq = OperateGridData.parse(req, res);
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));

            if ("query".equals(mode)) {
                gdRes = getReceiveListSeller(gdReq,info);
            }else if ("reject".equals(mode)) {
                gdRes = setReject(gdReq,info);
            }else if (mode.equals("delete")) {
				gdRes = getContractDelete(gdReq, info);
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
    
    public GridData getReceiveListSeller(GridData gdReq , SepoaInfo info) throws Exception {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaOut value = null;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info, multilang_id);
        Map< String, Object >   allData     = null; // request ��ü ������ ���� ��
        Map< String, String >   headerData  = null; // Header ������ ���� ��

        try {
            
            allData = SepoaDataMapper.getData( info, gdReq );
            headerData = MapUtils.getMap( allData, "headerData" );
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("cols_ids")).trim();
            String[] grid_col_ary = SepoaString.parser(grid_col_id, ",");

            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");

            // EJB CALL
            Object[] obj = {headerData};
            value = ServiceConnector.doService(info, "CTS_001", "CONNECTION", "getReceiveListSeller", obj);

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
             
            Config conf = new Configuration();
            String POASRM_CONTEXT_NAME = conf.getString("sepoa.context.name");
            
            for (int i = 0; i < rowCount; i++) {
                for (int k = 0; k < grid_col_ary.length; k++) {
                    if (grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")) {
                        gdRes.addValue("SELECTED", "0");
                    } 
                    else if (grid_col_ary[k] != null && grid_col_ary[k].equals("REJECT_REASON")) { 
                        if(wf.getValue("REJECT_REASON", i).length() >0)
                        {
                            gdRes.addValue("REJECT_REASON", POASRM_CONTEXT_NAME + "/images/button/icon_con_gla.gif"); 
                        }
                        else
                        {
                            gdRes.addValue("REJECT_REASON", POASRM_CONTEXT_NAME + "/images/blank.gif"); 
                        }
                    } 
                    else {
                        gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                    } 
                }
            }
            
        } catch (Exception e) {
            
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }
 
    //������û
    public GridData setReject(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        Map< String, Object >   allData     = null; // request ��ü ������ ���� ��

        try
        { 
             allData = SepoaDataMapper.getData( info, gdReq );
             
            gdRes.setSelectable(false);
            Object[] obj = {allData};
             
            SepoaOut value = ServiceConnector.doService(info, "CTS_001", "TRANSACTION","setCEUpdate", obj);

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
    

    public GridData getContractDelete(GridData gdReq, SepoaInfo info) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        try
        {
        	gdRes.setSelectable(false);
	        //int row_count = gdReq.getHeader("screen_id").getRowCount();
        	int row_count = gdReq.getRowCount();
	        String[][] bean_args = new String[row_count][];
	        
	        String delete_confirm		= JSPUtil.paramCheck(gdReq.getParam("delete_confirm")).trim();

	        for (int i = 0; i < row_count; i++)
	        {
	            String[] loop_data2 =
	            {
	            		gdReq.getValue("CONT_NO", i),
	            		gdReq.getValue("CONT_GL_SEQ", i)
	            };

	            bean_args[i] = loop_data2;
	        }

	        Object[] obj = {info, bean_args, delete_confirm};
	    	SepoaOut value = ServiceConnector.doService(info, "CTS_001", "TRANSACTION","getContractDelete", obj);

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
