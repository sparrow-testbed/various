package sepoa.svc.approval.madec;

import java.io.*;
import java.util.*;

public class PropertyManager extends Properties implements IFMaProp
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -5606845283435081359L;

	final private String DEFAULTS = "/etc/" + PROP_FILE_NAME;
	
	public PropertyManager() throws IOException
	{
	}
	
	public void read() throws IOException
	{
		read(DEFAULTS);
	}
	
	public void read(String filename) throws IOException
	{
		File f = new File(filename);
		load(new FileInputStream(f.getAbsolutePath()));
	}
	
	public void set(String keys, String value)
	{
		setProperty(keys, value);
	}
	
	public String get(String keys)
	{
		return String.valueOf(getProperty(keys));
	}
	
	public void write()  throws IOException
	{
		write(DEFAULTS);
	}
	
	public void write(String filename)  throws IOException
	{
		store(new FileOutputStream(filename), "");
	}
	
	private void print(String keys, String value)
	{
//		System.out.println(keys + "=" + value);
		int rtn = 0;
	}
	
	public void print()
	{
		this.list(System.out);
	}
}
