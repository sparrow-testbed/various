package sepoa.fw.util;

import sepoa.fw.util.SepoaListBox;

import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

public class SepoaCombo
{
	String s_FieldSeperator;
	String s_LineSeperator;
	String[][] combo;

	public SepoaCombo()
	{
		s_FieldSeperator = "\t";
		s_LineSeperator = "\n";
		combo = null;
	}

	public String[][] getCombo(HttpServletRequest ws_req, String s_ID, String s_Args, String s_addItems) throws Exception
	{
		return getCombo(ws_req, s_ID, s_Args, s_FieldSeperator, s_LineSeperator, s_addItems, false);
	}

	public String[][] getCombo(HttpServletRequest ws_req, String s_ID, String s_Args, String s_addItems, boolean b_reverse) throws Exception
	{
		return getCombo(ws_req, s_ID, s_Args, s_FieldSeperator, s_LineSeperator, s_addItems, b_reverse);
	}

	public String[][] getCombo(HttpServletRequest ws_req, String s_ID, String s_Args, String s_FieldSeperator, String s_LineSeperator, String s_addItems, boolean b_reverse) throws Exception
	{
		this.s_LineSeperator = s_LineSeperator;
		this.s_FieldSeperator = s_FieldSeperator;
		s_addItems = replaceMsgSeperator(s_addItems, "#", "@");

		SepoaListBox LB = new SepoaListBox();
		String lb = LB.Table_ListBox(ws_req, s_ID, s_Args, s_FieldSeperator, s_LineSeperator);
		lb = s_addItems + lb;

		StringTokenizer st_fields = new StringTokenizer(lb, s_LineSeperator, false);
		Vector v = new Vector();

		for (; st_fields.hasMoreElements();
				v.addElement(st_fields.nextToken().trim()))
		{
			;
		}

		String[] sta_rows = new String[v.size()];
		v.copyInto(sta_rows);
		combo = new String[v.size()][2];

		for (int j = 0; j < sta_rows.length; j++)
		{
			st_fields = new StringTokenizer(sta_rows[j], s_FieldSeperator, false);

			if (! b_reverse)
			{
				combo[j][0] = st_fields.nextToken().trim();
				combo[j][1] = st_fields.nextToken().trim();
			}
			else
			{
				combo[j][0] = st_fields.nextToken().trim();
				combo[j][1] = st_fields.nextToken().trim();
			}
		}

		return combo;
	}

	public String[][] getCombo() throws Exception
	{
		if (combo == null)
		{
			return null;
		}

		String[][] r_combo = new String[combo.length][combo[0].length];

		for (int i = 0; i < combo.length; i++)
		{
			for (int j = 0; j < combo[i].length; j++)
			{
				r_combo[i][j] = combo[i][j];
			}
		}

		return r_combo;
	}

	public int getIndex(String st_name, String st_type)
	{
		if (st_type.equals("text_match"))
		{
			for (int j = 0; j < combo.length; j++)
			{
				if (combo[j][0].equals(st_name))
				{
					return j;
				}
			}
		}
		else
		{
			for (int j = 0; j < combo.length; j++)
			{
				if (combo[j][1].equals(st_name))
				{
					return j;
				}
			}
		}

		return 0;
	}

	public int getIndex(String st_name)
	{
		return getIndex(st_name, "code_match");
	}

	private String replaceMsgSeperator(String st_src, String st_field, String st_line)
	{
		if (st_src == null)
		{
			return "";
		}
		else
		{
			String st_msg = st_src.replace(st_field.charAt(0), s_FieldSeperator.charAt(0)).replace(st_line.charAt(0), s_LineSeperator.charAt(0));

			return st_msg;
		}
	}
}
