
package sepoa.fw.util;

import java.io.*;
import java.util.*;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;

public class SepoaUpload
{

    public SepoaUpload(HttpServletRequest httpservletrequest, String s)
        throws IOException
    {
        this(httpservletrequest, s, "unknown", 0x100000);
    }

    public SepoaUpload(HttpServletRequest httpservletrequest, String s, String s1, int i)
        throws IOException
    {
        parameters = new Hashtable();
        files = new Hashtable();
        if(httpservletrequest == null)
            throw new IllegalArgumentException("request cannot be null");
        if(s == null)
            throw new IllegalArgumentException("saveDirectory cannot be null");
        if(i <= 0)
            throw new IllegalArgumentException("maxPostSize must be positive");
        req = httpservletrequest;
        dir = new File(s);
        Seq_no = 0;
        FileUniqName = s1;
        maxSize = i;
        if(!dir.isDirectory())
            throw new IllegalArgumentException("Not a directory: " + s);
        if(!dir.canWrite())
        {
            throw new IllegalArgumentException("Not writable: " + s);
        } else
        {
            readRequest();
            return;
        }
    }

    public SepoaUpload(ServletRequest servletrequest, String s)
        throws IOException
    {
        this((HttpServletRequest)servletrequest, s);
    }

    public SepoaUpload(ServletRequest servletrequest, String s, String s1, int i)
        throws IOException
    {
        this((HttpServletRequest)servletrequest, s, s1, i);
    }

    public String Next_UniqName()
    {
        return FileUniqName + "_" + SepoaMath.SepoaNumberType(++Seq_no, "00");
    }

    public Enumeration getParameterNames()
    {
        return parameters.keys();
    }

    public Enumeration getFileNames()
    {
        return files.keys();
    }

    public String getParameter(String s)
    {
        try
        {
            Vector vector = (Vector)parameters.get(s);
            if(vector == null || vector.size() == 0)
            {
                return null;
            } else
            {
                String s1 = (String)vector.elementAt(vector.size() - 1);
                return s1;
            }
        }
        catch(Exception exception)
        {
            return null;
        }
    }

    public String[] getParameterValues(String s)
    {
        try
        {
            Vector vector = (Vector)parameters.get(s);
            if(vector == null || vector.size() == 0)
            {
                return null;
            } else
            {
                String as[] = new String[vector.size()];
                vector.copyInto(as);
                return as;
            }
        }
        catch(Exception exception)
        {
            return null;
        }
    }

    public String getFilesystemName(String s)
    {
        try
        {
            UploadedFile uploadedfile = (UploadedFile)files.get(s);
            return uploadedfile.getFilesystemName();
        }
        catch(Exception exception)
        {
            return null;
        }
    }

    public String getContentType(String s)
    {
        try
        {
            UploadedFile uploadedfile = (UploadedFile)files.get(s);
            return uploadedfile.getContentType();
        }
        catch(Exception exception)
        {
            return null;
        }
    }

    public File getFile(String s)
    {
        try
        {
            UploadedFile uploadedfile = (UploadedFile)files.get(s);
            return uploadedfile.getFile();
        }
        catch(Exception exception)
        {
            return null;
        }
    }

    public long getFileSize(String s)
    {
        try
        {
            return getFile(s).length();
        }
        catch(Exception exception)
        {
            return 0L;
        }
    }

    public String getUniqFileName(String s)
    {
        try
        {
            UploadedFile uploadedfile = (UploadedFile)files.get(s);
            return uploadedfile.getUniqFileName();
        }
        catch(Exception exception)
        {
            return null;
        }
    }

    protected void readRequest()
        throws IOException
    {
        int i = req.getContentLength();
        
        if(i > maxSize)
            throw new IOException("파일용량이 초과되었습니다. (파일용량 : " + i + ", 최대용량 :  " + maxSize + ")");
        String s = null;
        String s1 = req.getHeader("Content-Type");
        String s2 = req.getContentType();
        if(s1 == null && s2 != null)
            s = s2;
        else
        if(s2 == null && s1 != null)
            s = s1;
        else
        if(s1 != null && s2 != null)
            s = s1.length() <= s2.length() ? s2 : s1;
        if(s == null || !s.toLowerCase().startsWith("multipart/form-data"))
            throw new IOException("Posted content type isn't multipart/form-data");
        String s3 = extractBoundary(s);
        if(s3 == null)
            throw new IOException("Separation boundary was not specified");
        MultipartInputStreamHandler multipartinputstreamhandler = new MultipartInputStreamHandler(req.getInputStream(), i);
        String s4 = multipartinputstreamhandler.readLine();
        if(s4 == null)
            throw new IOException("Corrupt form data: premature ending");
        if(!s4.startsWith(s3))
            throw new IOException("Corrupt form data: no leading boundary");
        for(boolean flag = false; !flag; flag = readNextPart(multipartinputstreamhandler, s3));
    }

    protected boolean readNextPart(MultipartInputStreamHandler multipartinputstreamhandler, String s)
        throws IOException
    {
        String s1 = multipartinputstreamhandler.readLine();
        if(s1 == null)
            return true;
        if(s1.length() == 0)
            return true;
        String as[] = extractDispositionInfo(s1);
        String s3 = as[0];
        String s4 = as[1];
        String s5 = as[2];
        String s6 = as[3];
        s1 = multipartinputstreamhandler.readLine();
        if(s1 == null)
            return true;
        String s7 = extractContentType(s1);
        if(s7 != null)
        {
            String s2 = multipartinputstreamhandler.readLine();
            if(s2 == null || s2.length() > 0)
                throw new IOException("Malformed line after content type: " + s2);
        } else
        {
            s7 = "application/octet-stream";
        }
        if(s5 == null)
        {
            String s8 = readParameter(multipartinputstreamhandler, s);
            if(s8.equals(""))
                s8 = null;
            Vector vector = (Vector)parameters.get(s4);
            if(vector == null)
            {
                vector = new Vector();
                parameters.put(s4, vector);
            }
            vector.addElement(s8);
        } 
        else
        {
        	readAndSaveFile(multipartinputstreamhandler, s, s6, s7);
            if(s5.equals("unknown"))
                files.put(s4, new UploadedFile(null, null, null, null));
            else
                files.put(s4, new UploadedFile(dir.toString(), s5, s6, s7));
        }
        return false;
    }

    protected String readParameter(MultipartInputStreamHandler multipartinputstreamhandler, String s)
        throws IOException
    {
        StringBuffer stringbuffer = new StringBuffer();
        String s1;
        while((s1 = multipartinputstreamhandler.readLine()) != null)
        {
            if(s1.startsWith(s))
                break;
            stringbuffer.append(s1 + "\r\n");
        }
        if(stringbuffer.length() == 0)
        {
            return null;
        } else
        {
            stringbuffer.setLength(stringbuffer.length() - 2);
            return stringbuffer.toString();
        }
    }

    protected void readAndSaveFile(MultipartInputStreamHandler multipartinputstreamhandler, String s, String s1, String s2)
        throws IOException
    {
        OutputStream obj = null;  OutputStream os = null;
        try {
            if(s1.equals("unknown"))
                obj = new ByteArrayOutputStream();
            else
            if(s2.equals("application/x-macbinary"))
            {
//              File file = new File(dir + File.separator + s1);
                File file = new File(dir + File.separator + s1.replaceAll("\\.\\./", ""));     os = new FileOutputStream(file);
                obj = new MacBinaryDecoderOutputStream(new BufferedOutputStream(os, 8192));
            } else
            {
//              File file1 = new File(dir + File.separator + s1);
            	File file1 = new File(dir + File.separator + s1.replaceAll("\\.\\./", ""));
                obj = new BufferedOutputStream(new FileOutputStream(file1), 8192);
            }
            byte abyte0[] = new byte[0x19000];
            boolean flag = false;
            int i;
            while((i = multipartinputstreamhandler.readLine(abyte0, 0, abyte0.length)) != -1)
            {
                if(i > 2 && abyte0[0] == 45 && abyte0[1] == 45)
                {
                    String s3 = new String(abyte0, 0, i, "ISO-8859-1");
                    if(s3.startsWith(s))
                        break;
                }
                if(flag)
                {
                    obj.write(13);
                    obj.write(10);
                    flag = false;
                }
                if(i >= 2 && abyte0[i - 2] == 13 && abyte0[i - 1] == 10)
                {
                    obj.write(abyte0, 0, i - 2);
                    flag = true;
                } else
                {
                    obj.write(abyte0, 0, i);
                }
            }
            obj.flush();
        } finally { if(obj != null){ IOUtils.closeQuietly(obj); }  if(os != null){ IOUtils.closeQuietly(os); } }
    }

    private String extractBoundary(String s)
    {
        int i = s.lastIndexOf("boundary=");
        if(i == -1)
        {
            return null;
        } else
        {
            String s1 = s.substring(i + 9);
            s1 = "--" + s1;
            return s1;
        }
    }

    private String[] extractDispositionInfo(String s)
        throws IOException
    {
    	String as[] = new String[4];
        String s1 = s;
        s = s1.toLowerCase();
        int i = s.indexOf("content-disposition: ");
        int j = s.indexOf(";");
        if(i == -1 || j == -1)
            throw new IOException("Content disposition corrupt: " + s1);
        String s2 = s.substring(i + 21, j);
        if(!s2.equals("form-data"))
            throw new IOException("Invalid content disposition: " + s2);
        i = s.indexOf("name=\"", j);
        j = s.indexOf("\"", i + 7);
        if(i == -1 || j == -1)
            throw new IOException("Content disposition corrupt: " + s1);
        String s3 = s1.substring(i + 6, j);
        String s4 = null;
        String s5 = null;
        i = s.indexOf("filename=\"", j + 2);
        j = s.indexOf("\"", i + 10);
        
        if(i != -1 && j != -1)
        {
            s4 = s1.substring(i + 10, j);
            
            int k = Math.max(s4.lastIndexOf('/'), s4.lastIndexOf('\\'));
            
            if(k > -1)
            {
                s4 = s4.substring(k + 1);
                s5 = Next_UniqName();
                int l;
                if((l = s4.lastIndexOf(".")) >= 0)
                    s5 = s5 + s4.substring(l);
            }
            else
            {
            	s5 = Next_UniqName();
            	int l;
                if((l = s4.lastIndexOf(".")) >= 0)
                    s5 = s5 + s4.substring(l);
            }
            
            if(s4.equals(""))
            {
                s4 = "unknown";
                s5 = "unknown";
            }
        }
        as[0] = s2;
        as[1] = s3;
        as[2] = s4;
        as[3] = s5;
        return as;
    }

    private String extractContentType(String s)
        throws IOException
    {
        String s1 = null;
        String s2 = s;
        s = s2.toLowerCase();
        if(s.startsWith("content-type"))
        {
            int i = s.indexOf(" ");
            if(i == -1)
                throw new IOException("Content type corrupt: " + s2);
            s1 = s.substring(i + 1);
        } else
        if(s.length() != 0)
            throw new IOException("Malformed line after disposition: " + s2);
        return s1;
    }

    private static final int DEFAULT_MAX_POST_SIZE = 0x100000;
    private static final String NO_FILE = "unknown";
    private static final String UNIQ_NAME = "unknown";
    private HttpServletRequest req;
    private File dir;
    private int maxSize;
    private int Seq_no;
    private String FileUniqName;
    private Hashtable parameters;
    private Hashtable files;
}
//package sepoa.fw.util;
//
//import java.io.BufferedOutputStream;
//import java.io.ByteArrayOutputStream;
//import java.io.File;
//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.io.OutputStream;
//import java.util.Enumeration;
//import java.util.Hashtable;
//import java.util.Vector;
//
//import javax.servlet.ServletRequest;
//import javax.servlet.http.HttpServletRequest;
//
//public class SepoaUpload
//{
//    private static final int DEFAULT_MAX_POST_SIZE = 0x100000;
//    private static final String NO_FILE = "unknown";
//    private static final String UNIQ_NAME = "unknown";
//    private HttpServletRequest req;
//    private File dir;
//    private int maxSize;
//    private int Seq_no;
//    private String FileUniqName;
//    private Hashtable parameters;
//    private Hashtable files;
//
//    public SepoaUpload(HttpServletRequest httpservletrequest, String s) throws IOException
//    {
//        this(httpservletrequest, s, "unknown", 0x100000);
//    }
//
//    public SepoaUpload(HttpServletRequest httpservletrequest, String s, String s1, int i) throws IOException
//    {
//        parameters = new Hashtable();
//        files = new Hashtable();
//
//        if (httpservletrequest == null)
//        {
//            throw new IllegalArgumentException("request cannot be null");
//        }
//
//        if (s == null)
//        {
//            throw new IllegalArgumentException("saveDirectory cannot be null");
//        }
//
//        if (i <= 0)
//        {
//            throw new IllegalArgumentException("maxPostSize must be positive");
//        }
//
//        req = httpservletrequest;
//        dir = new File(s);
//        Seq_no = 0;
//        FileUniqName = s1;
//        maxSize = i;
//
//        if (! dir.isDirectory())
//        {
//            throw new IllegalArgumentException("Not a directory: " + s);
//        }
//
//        if (! dir.canWrite())
//        {
//            throw new IllegalArgumentException("Not writable: " + s);
//        }
//        else
//        {
//            readRequest();
//
//            return;
//        }
//    }
//
//    public SepoaUpload(ServletRequest servletrequest, String s) throws IOException
//    {
//        this((HttpServletRequest) servletrequest, s);
//    }
//
//    public SepoaUpload(ServletRequest servletrequest, String s, String s1, int i) throws IOException
//    {
//        this((HttpServletRequest) servletrequest, s, s1, i);
//    }
//
//    public String Next_UniqName()
//    {
//        return FileUniqName + "_" + SepoaMath.SepoaNumberType(++Seq_no, "00");
//    }
//
//    public Enumeration getParameterNames()
//    {
//        return parameters.keys();
//    }
//
//    public Enumeration getFileNames()
//    {
//        return files.keys();
//    }
//
//    public String getParameter(String s)
//    {
//        try
//        {
//            Vector vector = (Vector) parameters.get(s);
//
//            if ((vector == null) || (vector.size() == 0))
//            {
//                return null;
//            }
//            else
//            {
//                String s1 = (String) vector.elementAt(vector.size() - 1);
//
//                return s1;
//            }
//        }
//        catch (Exception exception)
//        {
//            return null;
//        }
//    }
//
//    public String[] getParameterValues(String s)
//    {
//        try
//        {
//            Vector vector = (Vector) parameters.get(s);
//
//            if ((vector == null) || (vector.size() == 0))
//            {
//                return null;
//            }
//            else
//            {
//                String[] as = new String[vector.size()];
//                vector.copyInto(as);
//
//                return as;
//            }
//        }
//        catch (Exception exception)
//        {
//            return null;
//        }
//    }
//
//    public String getFilesystemName(String s)
//    {
//        try
//        {
//            UploadedFile uploadedfile = (UploadedFile) files.get(s);
//
//            return uploadedfile.getFilesystemName();
//        }
//        catch (Exception exception)
//        {
//            return null;
//        }
//    }
//
//    public String getContentType(String s)
//    {
//        try
//        {
//            UploadedFile uploadedfile = (UploadedFile) files.get(s);
//
//            return uploadedfile.getContentType();
//        }
//        catch (Exception exception)
//        {
//            return null;
//        }
//    }
//
//    public File getFile(String s)
//    {
//        try
//        {
//            UploadedFile uploadedfile = (UploadedFile) files.get(s);
//
//            return uploadedfile.getFile();
//        }
//        catch (Exception exception)
//        {
//            return null;
//        }
//    }
//
//    public long getFileSize(String s)
//    {
//        try
//        {
//            return getFile(s).length();
//        }
//        catch (Exception exception)
//        {
//            return 0L;
//        }
//    }
//
//    public String getUniqFileName(String s)
//    {
//        try
//        {
//            UploadedFile uploadedfile = (UploadedFile) files.get(s);
//
//            return uploadedfile.getUniqFileName();
//        }
//        catch (Exception exception)
//        {
//            return null;
//        }
//    }
//
//    protected void readRequest() throws IOException
//    {
//        int i = req.getContentLength();
//
//        if (i > maxSize)
//        {
//            throw new IOException("Posted content length of " + i + " exceeds limit of " + maxSize);
//        }
//
//        String s = null;
//        String s1 = req.getHeader("Content-Type");
//        String s2 = req.getContentType();
//
//        if ((s1 == null) && (s2 != null))
//        {
//            s = s2;
//        }
//        else if ((s2 == null) && (s1 != null))
//        {
//            s = s1;
//        }
//        else if ((s1 != null) && (s2 != null))
//        {
//            s = (s1.length() <= s2.length()) ? s2 : s1;
//        }
//
//        if ((s == null) || ! s.toLowerCase().startsWith("multipart/form-data"))
//        {
//            throw new IOException("Posted content type isn't multipart/form-data");
//        }
//
//        String s3 = extractBoundary(s);
//
//        if (s3 == null)
//        {
//            throw new IOException("Separation boundary was not specified");
//        }
//
//        MultipartInputStreamHandler multipartinputstreamhandler = new MultipartInputStreamHandler(req.getInputStream(), i);
//        String s4 = multipartinputstreamhandler.readLine();
//
//        if (s4 == null)
//        {
//            throw new IOException("Corrupt form data: premature ending");
//        }
//
//        if (! s4.startsWith(s3))
//        {
//            throw new IOException("Corrupt form data: no leading boundary");
//        }
//
//        for (boolean flag = false; ! flag;
//                flag = readNextPart(multipartinputstreamhandler, s3))
//        {
//            ;
//        }
//    }
//
//    protected boolean readNextPart(MultipartInputStreamHandler multipartinputstreamhandler, String s) throws IOException
//    {
//        String s1 = multipartinputstreamhandler.readLine();
//
//        if (s1 == null)
//        {
//            return true;
//        }
//
//        if (s1.length() == 0)
//        {
//            return true;
//        }
//
//        String[] as = extractDispositionInfo(s1);
//        String s3 = as[0];
//        String s4 = as[1];
//        String s5 = as[2];
//        String s6 = as[3];
//        s1 = multipartinputstreamhandler.readLine();
//
//        if (s1 == null)
//        {
//            return true;
//        }
//
//        String s7 = extractContentType(s1);
//
//        if (s7 != null)
//        {
//            String s2 = multipartinputstreamhandler.readLine();
//
//            if ((s2 == null) || (s2.length() > 0))
//            {
//                throw new IOException("Malformed line after content type: " + s2);
//            }
//        }
//        else
//        {
//            s7 = "application/octet-stream";
//        }
//
//        if (s5 == null)
//        {
//            String s8 = readParameter(multipartinputstreamhandler, s);
//
//            if (s8.equals(""))
//            {
//                s8 = null;
//            }
//
//            Vector vector = (Vector) parameters.get(s4);
//
//            if (vector == null)
//            {
//                vector = new Vector();
//                parameters.put(s4, vector);
//            }
//
//            vector.addElement(s8);
//        }
//        else
//        {
//            readAndSaveFile(multipartinputstreamhandler, s, s6, s7);
//
//            if (s5.equals("unknown"))
//            {
//                files.put(s4, new UploadedFile(null, null, null, null));
//            }
//            else
//            {
//                files.put(s4, new UploadedFile(dir.toString(), s5, s6, s7));
//            }
//        }
//
//        return false;
//    }
//
//    protected String readParameter(MultipartInputStreamHandler multipartinputstreamhandler, String s) throws IOException
//    {
//        StringBuffer stringbuffer = new StringBuffer();
//        String s1;
//
//        while ((s1 = multipartinputstreamhandler.readLine()) != null)
//        {
//            if (s1.startsWith(s))
//            {
//                break;
//            }
//
//            stringbuffer.append(s1 + "\r\n");
//        }
//
//        if (stringbuffer.length() == 0)
//        {
//            return null;
//        }
//        else
//        {
//            stringbuffer.setLength(stringbuffer.length() - 2);
//
//            return stringbuffer.toString();
//        }
//    }
//
//    protected void readAndSaveFile(MultipartInputStreamHandler multipartinputstreamhandler, String s, String s1, String s2) throws IOException
//    {
//        Object obj = null;
//
//        if (s1.equals("unknown"))
//        {
//            obj = new ByteArrayOutputStream();
//        }
//        else if (s2.equals("application/x-macbinary"))
//        {
//            File file = new File(dir + File.separator + s1);
//            obj = new MacBinaryDecoderOutputStream(new BufferedOutputStream(new FileOutputStream(file), 8192));
//        }
//        else
//        {
//            File file1 = new File(dir + File.separator + s1);
//            obj = new BufferedOutputStream(new FileOutputStream(file1), 8192);
//        }
//
//        byte[] abyte0 = new byte[0x19000];
//        boolean flag = false;
//        int i;
//
//        while ((i = multipartinputstreamhandler.readLine(abyte0, 0, abyte0.length)) != -1)
//        {
//            if ((i > 2) && (abyte0[0] == 45) && (abyte0[1] == 45))
//            {
//                String s3 = new String(abyte0, 0, i, "ISO-8859-1");
//
//                if (s3.startsWith(s))
//                {
//                    break;
//                }
//            }
//
//            if (flag)
//            {
//                ((OutputStream) (obj)).write(13);
//                ((OutputStream) (obj)).write(10);
//                flag = false;
//            }
//
//            if ((i >= 2) && (abyte0[i - 2] == 13) && (abyte0[i - 1] == 10))
//            {
//                ((OutputStream) (obj)).write(abyte0, 0, i - 2);
//                flag = true;
//            }
//            else
//            {
//                ((OutputStream) (obj)).write(abyte0, 0, i);
//            }
//        }
//
//        ((OutputStream) (obj)).flush();
//        ((OutputStream) (obj)).close();
//    }
//
//    private String extractBoundary(String s)
//    {
//        int i = s.lastIndexOf("boundary=");
//
//        if (i == -1)
//        {
//            return null;
//        }
//        else
//        {
//            String s1 = s.substring(i + 9);
//            s1 = "--" + s1;
//
//            return s1;
//        }
//    }
//
//    private String[] extractDispositionInfo(String s) throws IOException
//    {
//        String[] as = new String[4];
//        String s1 = s;
//        s = s1.toLowerCase();
//
//        int i = s.indexOf("content-disposition: ");
//        int j = s.indexOf(";");
//
//        if ((i == -1) || (j == -1))
//        {
//            throw new IOException("Content disposition corrupt: " + s1);
//        }
//
//        String s2 = s.substring(i + 21, j);
//
//        if (! s2.equals("form-data"))
//        {
//            throw new IOException("Invalid content disposition: " + s2);
//        }
//
//        i = s.indexOf("name=\"", j);
//        j = s.indexOf("\"", i + 7);
//
//        if ((i == -1) || (j == -1))
//        {
//            throw new IOException("Content disposition corrupt: " + s1);
//        }
//
//        String s3 = s1.substring(i + 6, j);
//        String s4 = null;
//        String s5 = null;
//        i = s.indexOf("filename=\"", j + 2);
//        j = s.indexOf("\"", i + 10);
//
//        if ((i != -1) && (j != -1))
//        {
//            s4 = s1.substring(i + 10, j);
//
//            int k = Math.max(s4.lastIndexOf(47), s4.lastIndexOf(92));
//
//            if (k > -1)
//            {
//                s4 = s4.substring(k + 1);
//                s5 = Next_UniqName();
//
//                int l;
//
//                if ((l = s4.lastIndexOf(".")) >= 0)
//                {
//                    s5 = s5 + s4.substring(l);
//                }
//            }
//
//            if (s4.equals(""))
//            {
//                s4 = "unknown";
//                s5 = "unknown";
//            }
//        }
//
//        as[0] = s2;
//        as[1] = s3;
//        as[2] = s4;
//        as[3] = s5;
//
//        return as;
//    }
//
//    private String extractContentType(String s) throws IOException
//    {
//        String s1 = null;
//        String s2 = s;
//        s = s2.toLowerCase();
//
//        if (s.startsWith("content-type"))
//        {
//            int i = s.indexOf(" ");
//
//            if (i == -1)
//            {
//                throw new IOException("Content type corrupt: " + s2);
//            }
//
//            s1 = s.substring(i + 1);
//        }
//        else if (s.length() != 0)
//        {
//            throw new IOException("Malformed line after disposition: " + s2);
//        }
//
//        return s1;
//    }
//}
