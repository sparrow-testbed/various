package sepoa.svl.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.rmi.RemoteException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaStringTokenizer;

public class SepoaAjaxCombo extends HttpServlet
{
	private static final long serialVersionUID = 1L;

	protected void processRequest(HttpServletRequest request, HttpServletResponse response, String method) throws ServletException, IOException
	{
		SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(request);
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");

		/************************************************************/
		SepoaOut wiseout = null;
		SepoaFormater wf = null;
		String result_data = "";

		String[] values = null;
		String param = JSPUtil.CheckInjection(request.getParameter("param"));
		String code = JSPUtil.CheckInjection(request.getParameter("code"));
		String selectbox_name = JSPUtil.CheckInjection(request.getParameter("selectbox_name"));
		String default_value = JSPUtil.CheckInjection(request.getParameter("default_value"));
		String vendor_flag = JSPUtil.CheckInjection(request.getParameter("vendor_flag"));

		//        System.out.println("param===========>>>> " + param);
		//        System.out.println("code===========>>>> " + code);
		//        System.out.println("selectbox_name===========>>>> " + selectbox_name);
		//        System.out.println("default_value===========>>>> " + default_value);
		if (param.length() != 0)
		{
			SepoaStringTokenizer st_column = new SepoaStringTokenizer(param, "#");
			int st_count = st_column.countTokens();

			values = new String[st_count];

			for (int i = 0; i < st_count; i++)
			{
				values[i] = st_column.nextToken();
			}
		}

		try
		{
			Configuration configuration = new Configuration();
			String field = configuration.getString("sepoa.separator.field");
			String line = configuration.getString("sepoa.separator.line");
//			System.out.println("field=>" + field);
//			System.out.println("line=>" + line);
			Object[] obj = { code, values };

//			System.out.println("vvvvvvvvvvvvvv-----------------");
//			System.out.println("param -----------------" + param);
//			System.out.println("code-----------------" + code);
//			System.out.println("Info null ---> " + (info == null ? "true;" : "false"));
//			System.out.println("Info ID ---> " + info.getSession("ID"));
//			System.out.println("vvvvvvvvvvvvvvvv-----------------");

			sepoa.fw.ses.SepoaInfo sinfo = sepoa.fw.ses.SepoaSession.getAllValue(request);

			if(info == null || info.getSession("ID").trim().length() <= 0)
			{
				HttpSession httpsession = request.getSession(true);
				String user_os_lang = (String)(httpsession.getAttribute("USER_OS_LANGUAGE")) == null ? "KO" : (String)(httpsession.getAttribute("USER_OS_LANGUAGE"));
				sinfo = new SepoaInfo("100","ID=AJAXCOMMON^@^LANGUAGE=" + user_os_lang + "^@^NAME_LOC=AJAXCOMMON^@^NAME_ENG=AJAXCOMMON^@^DEPT=ALL^@^");
				info = sinfo;
			}

			SepoaOut value = ServiceConnector.doService(info, "CO_012", "CONNECTION", "getCodeSearch", obj);
			wf = new SepoaFormater(value.result[0]); //���� Data

			if ("Y".equals(vendor_flag))
			{
				result_data = selectbox_name + field + default_value;
			}

			for (int i = 0; i < wf.getRowCount(); i++)
			{
				if ((i == 0) && ! "Y".equals(vendor_flag))
				{
					//result_data = selectbox_name + "$$$" + default_value + "@@@";
					//result_data = selectbox_name + field + default_value + line;
					result_data = selectbox_name + field + default_value + line;
				}

				if ((i == 0) && "Y".equals(vendor_flag))
				{
					result_data = result_data + line;
				}

				for (int j = 0; j < wf.getColumnCount(); j++)
				{
					if (i == (wf.getRowCount() - 1))
					{
						//result_data = result_data + wf.getValue(i, 0) + "$$$" + wf.getValue(i, 1);
						//result_data = result_data + wf.getValue(i, 0) + field + wf.getValue(i, 1);
						if (j == (wf.getColumnCount() - 1))
						{
							result_data = result_data + wf.getValue(i, j);
						}
						else
						{
							result_data = result_data + wf.getValue(i, j) + field;
						}
					}
					else
					{
						//result_data = result_data + wf.getValue(i, 0) + "$$$" + wf.getValue(i, 1) + "@@@";
						//result_data = result_data + wf.getValue(i, 0) + field + wf.getValue(i, 1) + line;
						if (j == (wf.getColumnCount() - 1))
						{
							result_data = result_data + wf.getValue(i, j) + line;
						}
						else
						{
							result_data = result_data + wf.getValue(i, j) + field;
						}
					}
				}
			}
		}
		catch (RemoteException re)
		{
			Logger.debug.println();
		}
		catch (Exception e)
		{
			Logger.debug.println();
		}

		/************************************************************/
		//System.out.println("###result_data=>" + result_data);
		String responseText = result_data;
		PrintWriter out = response.getWriter();
		out.println(responseText); //Write the response back to the browser
		out.close(); //Close the writer
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		//Process the request in method processRequest
		processRequest(request, response, "GET");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		//Process the request in method processRequest
		processRequest(request, response, "POST");
	}
}
