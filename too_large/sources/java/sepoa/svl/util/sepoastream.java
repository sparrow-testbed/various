package sepoa.svl.util;

import sepoa.fw.cfg.*;
import sepoa.fw.log.Logger;
import sepoa.fw.log.LoggerWriter;
import sepoa.fw.util.*;
import sepoa.svl.util.*;
import xlib.cmc.*;
import java.io.*;
import java.util.*;
import java.util.regex.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SepoaStream
{
	HttpServletRequest req;
	HttpServletResponse res;
	ObjectInputStream in;
	PrintWriter out;
	SepoaMessage wm;
	SepoaFormater wf;
	String ids_data;
	String[] userObj;
	StringBuffer recsb = null;
	SepoaFormater sf_excel;
	String parameter = null;
	Vector rec_vec = null;
	String begin_del = "<";
	String end_del   = ">";
	String slash_del = "/";
	String menu_flag = "";
	private String row_del;
    private String col_del;
	boolean status = true;
	int data_cnt = 1;
	String excel_zip_str= "";

	// RowsMerge ��õ� ���
	HashMap rows_merge_map = null;
	HashMap merge_skip_map = null;
	Iterator it = null;
	Vector key_vec = null;
	Vector merge_sb = null;
	String key_name = "";
	int group_merge_cnt = 0;
	
	StringBuffer exdsb;

	public SepoaStream(HttpServletRequest req, HttpServletResponse res) throws IOException, Exception
	{
		this.req = req;
		this.res = res;

		req.setCharacterEncoding("UTF-8");
		res.setContentType("text/xml;charset=UTF-8");
		menu_flag = req.getParameter("mode") == null ? "" : req.getParameter("mode");
		
		recsb = new StringBuffer();
    	exdsb = new StringBuffer();
    	row_del = sepoa.fw.util.CommonUtil.getConfig("sepoa.separator.line");
        col_del = sepoa.fw.util.CommonUtil.getConfig("sepoa.separator.field");
        
        recsb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		rec_vec = new Vector();
    	
		read();
		
    	if(wm.status == 1) {
    		recsb.append("<data>");
    	} else {
    		recsb.append("<rows>");
    	}
	}

	public void addValue(String column, String value) throws Exception
	{
		addValue(column, value, "");
	}

	public void addValue(String column, String value, String tooltip) throws Exception
	{
		addValue(column, value, tooltip, 0);
	}

	public void addValue(String column, String value, String tooltip, int index) throws Exception
	{
		if(rec_vec.size() == 0 || rec_vec.contains(column)) {
			if(rec_vec.size() == 0) {
				rec_vec.addElement(column);
				recsb.append("<row id=\""+data_cnt+"\"> ");
			} else {
				data_cnt++;
				recsb.append("</row>");
				recsb.append("<row id=\""+data_cnt+"\"> ");
				exdsb.append(row_del);
			}
		}

		String data = value;
		//data = data.replaceAll("<", "&lt;");
		//data = data.replaceAll(">", "&gt;");
		//data = data.replaceAll("&", "&amp;");

		recsb.append(begin_del + "cell " + end_del + "<![CDATA[" + data + "]]>" + begin_del + slash_del + "cell" + end_del);
		exdsb.append(data+col_del);
	}

	public void addRowSpanValue(String column, String value) throws Exception
	{
		if(rec_vec.size() == 0 || rec_vec.contains(column)) {
			if(rec_vec.size() == 0) {
				rec_vec.addElement(column);
				recsb.append("<row id=\""+data_cnt+"\"> ");
			} else {
				data_cnt++;
				recsb.append("</row>");
				recsb.append("<row id=\""+data_cnt+"\"> ");
				exdsb.append(row_del);
			}
		}

		String data = value;
		
		String compare_str = "";
		String next_compare_str = "";
		Vector new_merge_vec = null;
		int    find_idx = 0;
		
		//data = data.replaceAll("<", "&lt;");
		//data = data.replaceAll(">", "&gt;");
		//data = data.replaceAll("&", "&amp;");
		
		if(rows_merge_map.containsKey(column)) {
			group_merge_cnt = 0;
			new_merge_vec = new Vector();
			merge_sb = (Vector)rows_merge_map.get(column);
			
			for(int k=0; k < merge_sb.size(); k++) 
			{
				compare_str = (String)merge_sb.elementAt(k);
				if(compare_str.equals(value) && (k==0 || (find_idx+1) == k)) {
					group_merge_cnt++;
					next_compare_str = compare_str;
					find_idx = k;
				} else {
					new_merge_vec.addElement(compare_str);
				}
			}

			if(group_merge_cnt > 0) {
				rows_merge_map.put(column, new_merge_vec);
			}
			
			if(group_merge_cnt > 0) {
				recsb.append(begin_del + "cell rowspan=\""+group_merge_cnt+"\" " + end_del + "<![CDATA[" + data + "]]>" + begin_del + slash_del + "cell" + end_del);
			} else {
				recsb.append(begin_del + "cell " + end_del + "<![CDATA[" + data + "]]>" + begin_del + slash_del + "cell" + end_del);
			}
		} else {
			recsb.append(begin_del + "cell " + end_del + "<![CDATA[" + data + "]]>" + begin_del + slash_del + "cell" + end_del);
		}
		
		exdsb.append(data+col_del);
	}

	public int getMergeGroupCont(StringBuffer matcher_sb, String pattern)
	{
		int group_cnt = 0;
		Matcher mc = Pattern.compile(pattern).matcher(matcher_sb.toString());

        while(mc.find()) {
        	group_cnt++;
        }

        return group_cnt;
    }

	public void setRowsMergeMap(HashMap map)
	{
		this.rows_merge_map = map;

		if(rows_merge_map.size() > 0) {
			merge_skip_map = new HashMap();
			it = rows_merge_map.keySet().iterator();
			while(it.hasNext()) {
				key_name = (String)it.next();
				key_vec = new Vector();
				merge_skip_map.put(key_name, key_vec);
			}
		}
	}

	public String getMessage()
	{
		return wm.message;
	}

	public String getParam(String name)
	{
		return JSPUtil.paramCheck((String) wm.param.get(name));
	}

	public String getParameter(String name)
	{
		return JSPUtil.paramCheck((String) wm.param.get(name));
	}

	public HttpServletRequest getRequest()
	{
		return req;
	}

	public HttpServletResponse getResponse()
	{
		return res;
	}

	public int getStatus()
	{
		return wm.status;
	}

	public String getConfig(String value)
	{
		Config conf;

		try
		{
			conf = new Configuration();
			value = conf.get(value);
		}
		catch (ConfigurationException e)
		{
			Logger.debug.println();
		}

		return value;
	}

	public SepoaFormater getSepoaFormater() throws Exception
	{
		if (ids_data == null)
		{
			return null;
		}
		else
		{
			return getSepoaFormater(ids_data);
		}
	}

	public SepoaFormater getSepoaFormater(String value) throws Exception
	{
		try
		{
			wf = new SepoaFormater(value, getConfig("sepoa.separator.field"), getConfig("sepoa.separator.line"));
		}
		catch (Exception e)
		{
			Logger.debug.println();
		}

		return wf;
	}

	private void read() throws IOException, Exception
	{
		String param_type = req.getParameter("param_type");
		SepoaStringTokenizer st = null;
		String[] col_names  = null;
		String[] row_depths = null;
		Iterator it = null;
		Object obj = null;
		int col_depth = 0;
		int row_depth = 0;
		Enumeration param_en = req.getParameterNames();
		wm = new SepoaMessage();
		wm.param = new Hashtable();
		wm.data_flag = false;
		wm.status = 0;
		wm.message = "";
		String ids_info = req.getParameter("ids")      == null ? "" : req.getParameter("ids");
		String cols_ids = req.getParameter("cols_ids") == null ? "" : req.getParameter("cols_ids");
		String grid_col_id = req.getParameter("grid_col_id") == null ? "" : req.getParameter("grid_col_id");
		String col_id   = ""; String field_data = "";
		
		if(grid_col_id != null && grid_col_id.trim().length() > 0) {
			exdsb.append(grid_col_id.replaceAll(",", col_del) + col_del + row_del);
		}
		
		if(ids_info != null && ids_info.trim().length() > 0 && cols_ids != null && cols_ids.trim().length() > 0) {
			wm.status = 1;

			if(cols_ids.indexOf(",") > 0) {
				ids_data = cols_ids.replaceAll(",", getConfig("sepoa.separator.field")) + getConfig("sepoa.separator.field") + getConfig("sepoa.separator.line");
			}
			
			if(ids_info.indexOf(",") > 0) {
				SepoaStringTokenizer sg_rows = new SepoaStringTokenizer(ids_info, ",");
				row_depths = new String[sg_rows.countTokens()];

				for(row_depth=0; row_depth < row_depths.length; row_depth++) {
					row_depths[row_depth] = sg_rows.nextToken();
				}
			} else {
				row_depths = new String[1];
				row_depths[0] = ids_info;
			}

			SepoaStringTokenizer sg_columns = new SepoaStringTokenizer(cols_ids, ",");
			col_names = new String[sg_columns.countTokens()];

			for(col_depth=0; col_depth < col_names.length; col_depth++) {
				col_names[col_depth] = sg_columns.nextToken();
			}

			for(row_depth = 0; row_depth < row_depths.length; row_depth++) {
				for(col_depth=0; col_depth < col_names.length; col_depth++) {
					field_data = req.getParameter(row_depths[row_depth] + "_" + col_names[col_depth]) + getConfig("sepoa.separator.field");
					//field_data = field_data.replaceAll("&lt;", "<");
					//field_data = field_data.replaceAll("&gt;", ">");
					//field_data = field_data.replaceAll("&amp;", "&");
					ids_data  += field_data;
				}
				ids_data += getConfig("sepoa.separator.line");
			}
		}

		while(param_en.hasMoreElements()) {
			parameter = (String)param_en.nextElement();
			wm.param.put(parameter, req.getParameter(parameter));
		}
	}

	public void setCode(String code)
	{
		wm.code = code;

		if("0".equals(code))
		{
			this.status = false;
		}
		else
		{
			this.status = true;
		}
	}

	public void setMessage(String message)
	{
		wm.message = message;
	}
	
	public void setExcelForMatter(SepoaFormater sf)
	{
		this.sf_excel = sf;
	}

	public void setAugument(String arg_name, String arg_value)
	{
		if(arg_value != null) {
			recsb.append("<"+arg_name+">"+arg_value+"</"+arg_name+">");
		}
	}

	public void setStatus(boolean status)
	{
		this.status = status;
	}

	public void setUserObject(String[] value)
	{
		userObj = value;
	}

	public void write() throws IOException
	{
		out = res.getWriter();
		StringReader sr_xml = null;

		try
		{
			if(wm.status == 0) {
				if(rec_vec.size() > 0) {recsb.append("</row>");}

				if(wm.message != null) {
					recsb.append("<userdata name=\"message\">"+wm.message+"</userdata>");
				} else {
					recsb.append("<userdata name=\"message\"></userdata>");
				}

				recsb.append("<userdata name=\"data_type\">doSelect</userdata>");
				recsb.append("<userdata name=\"status\">"+String.valueOf(status)+"</userdata>");

				if(userObj != null && userObj.length > 0) {
					for(int k=0; k < userObj.length; k++) {
						recsb.append("<userdata name=\""+String.valueOf(k)+"\">"+userObj[k]+"</userdata>");
					}
				}
				
				exdsb.append(row_del);
				sf_excel = new SepoaFormater(exdsb.toString());
				req.getSession().putValue("excel_data", this.sf_excel);
				recsb.append("</rows>");
	    	} else {
	    		recsb.append("<action type=\"doSaveEnd\" ");
	    		recsb.append(" data_type = \"doData\" ");
	    		recsb.append(" status = \""+String.valueOf(status)+"\" ");

	    		if(wm.message != null) {
					recsb.append(" message = \""+wm.message+"\" ");
				} else {
					recsb.append(" message = \"\" ");
				}

	    		if(req.getParameter("mode") != null) {
	    			recsb.append(" mode = \""+req.getParameter("mode")+"\" ");
	    		}

				if(userObj != null && userObj.length > 0) {
					for(int k=0; k < userObj.length; k++) {
						recsb.append(" name_"+String.valueOf(k)+" = \""+userObj[k]+"\" ");
					}
				}

				recsb.append("></action>");
	    		recsb.append("</data>");
	    	}

			sr_xml = new StringReader(recsb.toString());
            char cbuf[] = new char[1024];
            int leng = 0;

            while((leng = sr_xml.read(cbuf)) > 0) {
            	out.write(cbuf, 0, leng);
            }
		}
		catch (Exception e)
		{
			Logger.debug.println();
		} finally {
			out.flush();
        	out.close();
		}
	}
}
