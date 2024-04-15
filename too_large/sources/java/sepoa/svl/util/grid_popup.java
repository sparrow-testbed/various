package sepoa.svl.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class grid_popup extends HttpServlet
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
        String insertResult = "";
        
        try
        {
            gdReq = OperateGridData.parse(req, res);
            mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
           
            //grid_popup.jsp �� grid_cm_list.jsp ���� ȣ���Ѵ�.
            if ("grid_popup_query".equals(mode)){					//grid_popup ��ȸ
                gdRes = getPopupList(info,gdReq);
            }else if("grid_cm_list_query".equals(mode)){			//grid_cm_list ��ȸ
            	gdRes = getcmList(info,gdReq);
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

    //��ȸ
    public GridData getPopupList(SepoaInfo info,GridData gdReq) throws Exception
    {
        GridData gdRes = new GridData();
        int rowCount = 0;
        SepoaFormater wf = null;
        Vector multilang_id = new Vector();
    	multilang_id.addElement("MESSAGE");
        HashMap message = MessageUtil.getMessage(info,multilang_id);
        String POASRM_CONTEXT_NAME = new Configuration().getString("sepoa.context.name");
        
        try
        {
            String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
            String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
            
            String house_code 	= JSPUtil.CheckInjection(gdReq.getParam("house_code")).trim();
            if(house_code == null || "".equals(house_code)) {
            	house_code = info.getSession("HOUSE_CODE");
            }
            
            String company_code = JSPUtil.CheckInjection(gdReq.getParam("company_code")).trim();
            String type 		= JSPUtil.CheckInjection(gdReq.getParam("type")).trim();
            String pCode 		= JSPUtil.CheckInjection(gdReq.getParam("pCode")).trim();
            String pDescription = JSPUtil.CheckInjection(gdReq.getParam("pDescription")).trim();
            
            gdRes = OperateGridData.cloneResponseGridData(gdReq);
            gdRes.addParam("mode", "query");
            
            //EJB CALL
	        Object[] obj = {house_code, company_code, type, pCode, pDescription};
	    	SepoaOut value = ServiceConnector.doService(info, "CO_012", "CONNECTION","getEPCodeSearch", obj);

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
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")) {
            			gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
                	}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CHANGE_DATE")) {
            			gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					}else {
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


	//��ȸ
	public GridData getcmList(SepoaInfo info,GridData gdReq) throws Exception
	{
		GridData gdRes = new GridData();
		int rowCount = 0;
		SepoaFormater wf = null;
		Vector multilang_id = new Vector();
		multilang_id.addElement("MESSAGE");
		HashMap message = MessageUtil.getMessage(info,multilang_id);
		String POASRM_CONTEXT_NAME = new Configuration().getString("sepoa.context.name");
		
		try
		{
			String grid_col_id = JSPUtil.CheckInjection(gdReq.getParam("grid_col_id")).trim();
			String [] grid_col_ary = SepoaString.parser(grid_col_id, ",");
			
			String code 	= JSPUtil.CheckInjection(gdReq.getParam("code")).trim();
			String values = JSPUtil.CheckInjection(gdReq.getParam("values")).trim();
			
			int values_count = 0;	// �޸��� ���е� ������ ����
			//�޸��� ���еǾ�����, ���(,,)�� �ϳ��� �����ͷ� ó���ϱ� ���� ������ �������� ����. �� ��Ʈ������ ������ �迭�� ���� �迭�� �����
			for(int index = 0 ; index < values.length(); index++){
				if(values.charAt(index) == ','){
					values_count++;
				}
			}
			values_count++;	//plus 1
			
			String [] valuesArray = new String[values_count];
			int start = 0;
			for(int i = 0 ; i < values_count ; i++){
				int end = values.indexOf(",",start);
				if(end == -1){
					end = values.length();
				}
				
				
				valuesArray[i] = values.substring(start, end);
				start = end + 1;
				
			}
			//String [] valuesArray = SepoaString.parser(values, ",");
			
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			gdRes.addParam("mode", "query");
			
			//EJB CALL
			Object[] obj = {code,valuesArray};
			SepoaOut value = ServiceConnector.doService(info, "CO_012", "CONNECTION","getCodeSearch", obj);
			
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
					}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("ADD_DATE")) {
						gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					}else if(grid_col_ary[k] != null && grid_col_ary[k].equals("CHANGE_DATE")) {
						gdRes.addValue(grid_col_ary[k], SepoaString.getDateSlashFormat(wf.getValue(grid_col_ary[k], i)));
					}else {
						//gdRes.addValue(grid_col_ary[k], wf.getValue(grid_col_ary[k], i));	//��,��
						//��,�� //�÷����� ���� ����̴�.(�����޺��� ��� sql ��Ī�� ������� �ʱ� ������ �÷���� ������ ���������� �ִ´�.)
						//�׷��� MP��Ƽ�޺��� ��� �տ� selected�� �پ ��ĭ�� �и���.
						if(grid_col_ary[0].equals("selected")){
							gdRes.addValue(grid_col_ary[k], wf.getValue(i,k-1));	//��Ƽ �˾� �϶� - ��Ƽ �޺��� ��� selected�� �տ� �پ ��ĭ�� �и��� ������...
						}else{
							gdRes.addValue(grid_col_ary[k], wf.getValue(i,k));	//�̱� �˾� �϶�
						}
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
	//�׽�Ʈ
/*	public static void main(String [] args){
		String values = ",aaa,,";
		int values_count = 0;	// �޸��� ���е� ������ ����
		//�޸��� ���еǾ�����, ���(,,)�� �ϳ��� �����ͷ� ó���ϱ� ���� ������ �������� ����
		for(int index = 0 ; index < values.length(); index++){
			if(values.charAt(index) == ','){
				values_count++;
			}
		}
		values_count++;	//plus 1
		System.out.println("values_count="+values_count);
		String [] valuesArray = new String[values_count];
		int start = 0;
		for(int i = 0 ; i < values_count ; i++){
			int end = values.indexOf(",",start);
			if(end == -1){
				end = values.length();
			}
			System.out.println("start="+start);
			System.out.println("end="+end);
			valuesArray[i] = values.substring(start, end);
			start = end + 1;
			
		}
		System.out.println(Arrays.toString(valuesArray));
	}*/
}


















