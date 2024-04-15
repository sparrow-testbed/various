package sepoa.svl.master;

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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;



public class item_confirm_list extends HttpServlet
{
    private static SepoaInfo info;

    public void init(ServletConfig config) throws ServletException
    {
        //System.out.println("Servlet call");
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

        String mode = "";
        PrintWriter out = res.getWriter();

        try{
            //String rawData = req.getParameter("WISEGRID_DATA");
            //Logger.debug.println(info.getSession("ID"), this, "######### rawdata : " + rawData);


            gdReq = OperateGridData.parse(req, res);
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
            
            if ("query".equals(mode)){  //������� ��ȸ
                gdRes = getItemConfirmList(gdReq);
            }
            else if("setCancel".equals(mode)){
                gdRes = setCancel(gdReq);
            }
            
        }catch (Exception e){
            gdRes.setMessage("Error: " + e.getMessage());
            gdRes.setStatus("false");
            
        }finally{
            try{
                OperateGridData.write(req, res, gdRes, out);
            }catch (Exception e){
                Logger.debug.println();
            }
        }
    }
   
    
    
    
    
    /**
     * 품목승인
     * 
     * @param gdReq
     * @return
     * @throws Exception
     */
    public GridData getItemConfirmList(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector v = new Vector();
        v.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,v);
        Map< String, Object > allData = null; // 해더데이터와 그리드데이터 함께 받을 변수
        Map< String, String > header = null;
        
        try{

        	allData = SepoaDataMapper.getData( info, gdReq );
            header = MapUtils.getMap( allData, "headerData" );

            String grid_col_id = JSPUtil.paramCheck( gdReq.getParam( "cols_ids" ) ).trim();
            String[] grid_col_ary = SepoaString.parser( grid_col_id, "," );

            gdRes = OperateGridData.cloneResponseGridData( gdReq );
            gdRes.addParam( "mode", "query" );

            Object[] obj = {header};
            //SepoaOut value = ServiceConnector.doService(info, "BD_002", "CONNECTION","getCompletionaintain", obj);
            SepoaOut value = ServiceConnector.doService(info, "MT_003", "CONNECTION","getItemConfirmList", obj);

            if(value.flag){
                gdRes.setMessage(message.get("MESSAGE.0001").toString());
                gdRes.setStatus("true");
            }else{
                gdRes.setMessage(value.message);
                gdRes.setStatus("false");
                return gdRes;
            }

            wf = new SepoaFormater(value.result[0]);
            rowCount = wf.getRowCount();

            if (rowCount == 0){
                gdRes.setMessage(message.get("MESSAGE.1001").toString());
                return gdRes;
            }
            
            String[] remark_tmep = new String[1];
            
            for (int i = 0; i < rowCount; i++)
            {
                for(int k=0; k < grid_col_ary.length; k++)
                {
                    if(grid_col_ary[k] != null && grid_col_ary[k].equals("SELECTED")){
                        gdRes.addValue("SELECTED", "0");
                    }else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")){
                        gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
                    }else if(grid_col_ary[k] != null && grid_col_ary[k].equals("USED_DATE")){
                        gdRes.addValue(grid_col_ary[k], SepoaString.getDateDashFormat(wf.getValue(grid_col_ary[k], i)));
                    }else if(grid_col_ary[k] != null && grid_col_ary[k].equals("SIGN_REMARK")){
                        remark_tmep[0] = wf.getValue(grid_col_ary[k], i).replace("<BR>", "");
                        if(i == 0){
                            if("".equals(remark_tmep[0])){
                                gdRes.addValue(grid_col_ary[k], "-");
                            }else{
                                gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i).replaceAll("<BR>", "\n"));
                            }
                        }else{
                            if("".equals(remark_tmep[0])){
                                gdRes.addValue(grid_col_ary[k], "-");
                            }else{
                                gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i).replaceAll("<BR>", "\r\n"));
                            }
                        }
                    }else{
                        gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));
                    }
                }
            }
            
        }catch (Exception e){
            //System.out.println("Exception : " + e.getMessage());
            gdRes.setMessage(message.get("MESSAGE.1002").toString());
            gdRes.setStatus("false");
        }

        return gdRes;
    }

    /**
     * 
     * @param gdReq
     * @return
     * @throws Exception
     */
    public GridData setCancel(GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        Vector multilang_id = new Vector();
        multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);

        String user_id      = info.getSession("ID");
        String house_code   = info.getSession("HOUSE_CODE");
        String dept         = info.getSession("DEPARTMENT");        
        
        try
        {
            gdRes.setSelectable(false);
            
            int row_count = gdReq.getRowCount();
            String[][] bean_args = new String[row_count][];

            for (int i = 0; i < row_count; i++)
            {
                String[] loop_data1 =
                {
                        gdReq.getValue("DOC_NO", i),
                        gdReq.getValue("DOC_TYPE", i),
                        gdReq.getValue("DOC_SEQ", i),
                        gdReq.getValue("APP_STAGE", i), 
                        gdReq.getValue("ARGENT_FLAG", i),   
                        gdReq.getValue("SHIPPER_TYPE", i),  
                        gdReq.getValue("COMPANY_CODE", i)
                };

                bean_args[i] = loop_data1;
            }

            Object[] obj = {info, bean_args};
            SepoaOut value = ServiceConnector.doService(info, "BD_002", "TRANSACTION","setCancel", obj);

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

        gdRes.addParam("mode", "query");
        return gdRes;
    }
                            
}
//////////////////////////////////////////////////////////////////
