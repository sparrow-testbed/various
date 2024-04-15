package sepoa.fw.util;

import sepoa.fw.log.Logger;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;

public class FileProcess
{
	public static String fileReadByOffset(String filename) throws IOException
	{
		File file = null;
		BufferedReader in = null;
		StringWriter out = null;
		String contents = "";
		char[] buf = new char[1024];
		int len = 0;

		try
		{
			file = new File(filename);

			if (file.exists())
			{
				in = new BufferedReader(new FileReader(file));
				out = new StringWriter();

				while ((len = in.read(buf, 0, buf.length)) != -1)
				{
					out.write(buf, 0, len);
				}

				contents = out.toString();
			}
		}
		catch (Exception e)
		{
			if(out != null){ out.close(); }
		}
		finally{
			if(in != null){
//				try{
					in.close();
//				}
//				catch(Exception e){}
			}
		}

		return contents;
	}

	public static void copyFile(String strFrom, String strTo) throws Exception
    {
        byte[] buf = new byte[1000];
        FileInputStream fis = null;
        FileOutputStream fos = null;

        try
        {   fis = new FileInputStream(strFrom); fos = new FileOutputStream(strTo);
            int intFileSize = 0;
            int intMaxFileSize = 1000 * 10; //10Mbyte

            while (((fis.read(buf, 0, 1000)) > 0) && (intFileSize < intMaxFileSize))
            {
                fos.write(buf, 0, 1000);
                intFileSize++;
            }

            File file = new File(strFrom);

            fis.close();
            fos.close();
        }
        catch (IOException e)
        {
            
            throw e;
        }
        finally
        {
            if (fis != null)
            {
                fis.close();
            }

            if (fos != null)
            {
                fos.close();
            }
        }
    }

	/**
	 * 2008.10.22 �̴�� �ѱ� ó�� ��� �߰�
	 * @param filename
	 * @param encoding
	 * @return
	 * @throws IOException
	 */
	public static String fileReadByOffsetByEncoding(String filename, String encoding) throws IOException
	{
		File file = null;
		BufferedReader in = null;
		StringWriter out = null;
		String contents = "";
		char[] buf = new char[1024];
		int len = 0;
		FileInputStream fileinputstream = null;

		try
		{
			file = new File(filename);
			fileinputstream = new FileInputStream(file);

			if (file.exists())
			{
				in = new BufferedReader(new java.io.InputStreamReader(fileinputstream, encoding));
				out = new StringWriter();

				while ((len = in.read(buf, 0, buf.length)) != -1)
				{
					out.write(buf, 0, len);
				}

				contents = out.toString();
			}
		}
		catch (Exception e)
		{
			contents = "";
		}
		finally{
//			try{
			if(fileinputstream != null) { fileinputstream.close(); }
//			}
//			catch(Exception e){}
		}

		return contents;
	}

	public static boolean fileWrite(String filename, StringBuffer contents)
	{
		boolean rtn = true;
		FileWriter fw = null;

		try
		{
			fw = new FileWriter(filename);
			fw.write(contents.toString());
			
		}
		catch (IOException e)
		{
			
			rtn = false;
		}
		finally{
			if(fw != null){
				try {
					fw.close();
				}
				catch (IOException e) {rtn = false;}
			}
		}

		return rtn;
	}

	public static boolean fileWrite(String filename, String contents)
	{
		boolean rtn = true;
		FileWriter fw = null;

		try
		{
			fw = new FileWriter(filename);
			fw.write(contents);
			fw.close();
		}
		catch (IOException e)
		{
			
			rtn = false;
		}
		finally{
			if(fw != null){
				try{
					fw.close();
				}
				catch(Exception e){rtn = false;}
			}
		}

		return rtn;
	}

	public void fileWriteByEncoding(String filename, String contents, String encoding) throws Exception
	{
		java.io.BufferedWriter bw = null;
		
		try
		{
			bw = new java.io.BufferedWriter(new java.io.OutputStreamWriter(new java.io.FileOutputStream(new java.io.File(filename), false), encoding));
			bw.write(contents);
			bw.close();
		}
		catch (Exception e)
		{
			
			throw new Exception(e.getMessage());
		}
		finally{
			if(bw != null){
//				try{
					bw.close();
//				}
//				catch(Exception e){}
			}
		}
	}

	public StringBuffer fileReadByAll(String fileName)
	{
		StringBuffer sb = new StringBuffer();
		File fi = new File(fileName);
		BufferedReader in = null;
		FileReader fr = null;

		try
		{
			if (fi.exists())
			{
				fr = new FileReader(fi);
				in = new BufferedReader(fr);

				String aaa = "";

				while ((aaa = in.readLine()) != null)
				{
					sb.append(aaa + "\n");
				}
			}
		}
		catch (Exception e)
		{
			
			sb = null;
		}
		finally
		{
			try
			{
				if(in != null) { in.close(); }
				if(fr != null) { fr.close(); }
			}
			catch (Exception e1)
			{
				in = null;
				fr = null;
			}
		}

		return sb;
	}

    public static void deleteFile(String filename) throws Exception
    {
        File fi = new File(filename);

        try
        {
            if (fi.exists())
            {
            	fi.delete();
            }
        }
        catch (Exception e)
        {
            
            
            throw new Exception(e.getMessage());
        }
        finally
        {
        }
    }

	public void appendFile(String fileName, String Contents) throws Exception
	{
		BufferedWriter bw = null;
		try
		{
			bw = new BufferedWriter(new FileWriter(fileName, true));
			bw.write(Contents, 0, Contents.length());
		}
		catch (Exception e)
		{
			
			
			throw new Exception(e.getMessage());
		}
		finally{
			if(bw != null){
//				try{
					bw.close();
//				}
//				catch(Exception e){}
			}
		}
	}

	/**
	 * @param args
	 */
//	public static void main(String[] args)
//	{
//		// TODO Auto-generated method stub
//	}
}
