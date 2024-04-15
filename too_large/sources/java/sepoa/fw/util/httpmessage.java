package sepoa.fw.util;

import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Properties;

import org.apache.commons.io.IOUtils;

import sepoa.fw.log.Logger;

public class HttpMessage
{
    URL servlet;
    Hashtable headers;

    public HttpMessage(URL url)
    {
        servlet = null;
        headers = null;
        servlet = url;
    }

    public InputStream sendPostMessage(Properties properties) throws IOException
    {
        String s = "";    java.io.OutputStream outputstream = null;

        if (properties != null)
        {
            s = toEncodedString(properties);
        }

        URLConnection urlconnection = servlet.openConnection();
        urlconnection.setDoInput(true);
        urlconnection.setDoOutput(true);
        urlconnection.setUseCaches(false);
        urlconnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        sendHeaders(urlconnection);
        try{
        DataOutputStream dataoutputstream = new DataOutputStream(urlconnection.getOutputStream());
        dataoutputstream.writeBytes(s);
        dataoutputstream.flush();
        dataoutputstream.close();
        }catch (IOException ioexception){ Logger.err.println("Exception e =" + ioexception.getMessage()); }finally{ if(outputstream != null){ IOUtils.closeQuietly(outputstream); } }
        return urlconnection.getInputStream();
    }

    private void sendHeaders(URLConnection urlconnection)
    {
        if (headers != null)
        {
            String s;
            String s1;

            for (Enumeration enumeration = headers.keys();
                    enumeration.hasMoreElements();
                    urlconnection.setRequestProperty(s, s1))
            {
                s = (String) enumeration.nextElement();
                s1 = (String) headers.get(s);
            }
        }
    }

    private String toEncodedString(Properties properties)
    {
        StringBuffer stringbuffer = new StringBuffer();

        for (Enumeration enumeration = properties.propertyNames();
                enumeration.hasMoreElements();)
        {
            String s = (String) enumeration.nextElement();
            String s1 = properties.getProperty(s);
            stringbuffer.append(URLEncoder.encode(s) + "=" + URLEncoder.encode(s1));

            if (enumeration.hasMoreElements())
            {
                stringbuffer.append("&");
            }
        }

        return stringbuffer.toString();
    }
}
