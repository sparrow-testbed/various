package sepoa.svl.util;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import sepoa.fw.cfg.*;
import sepoa.fw.log.Logger;
import sepoa.fw.log.LoggerWriter;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;

public class SepoaServlet extends HttpServlet
{

    public SepoaServlet()
    {
    	Logger.debug.println();
    }

    public final String stackTrace(Throwable throwable)
    {
        String s = null;
        try
        {
            ByteArrayOutputStream bytearrayoutputstream = new ByteArrayOutputStream();
            throwable.printStackTrace(new PrintWriter(bytearrayoutputstream, true));
            s = bytearrayoutputstream.toString();
        }
        catch(Exception exception) { Logger.debug.println();}
        return s;
    }

    public void doData(SepoaStream sepoastream)
        throws Exception
    {
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest httpservletrequest, HttpServletResponse httpservletresponse)
        throws IOException, ServletException
    {
    	doPost(httpservletrequest, httpservletresponse);
    }

    public void doPost(HttpServletRequest httpservletrequest, HttpServletResponse httpservletresponse)
        throws IOException, ServletException
    {
    	SepoaStream sepoastream = null;
        SepoaInfo sepoainfo = null;
        try
        {
            sepoainfo = SepoaSession.getAllValue(httpservletrequest);
            sepoastream = new SepoaStream(httpservletrequest, httpservletresponse);
            if(sepoastream.getStatus() == 0) {
                doQuery(sepoastream);
            }
            if(sepoastream.getStatus() == 1) {
                doData(sepoastream);
            }
        }
        catch(Exception exception)
        {
            
                
            Logger.debug.println(sepoainfo.getSession("ID"), this, stackTrace(exception));
            if(sepoastream != null){sepoastream.setMessage("\uC54C\uC218\uC5C6\uB294 \uC5D0\uB7EC\uAC00 \uBC1C\uC0DD\uD558\uC600\uC2B5\uB2C8\uB2E4.");
                                    sepoastream.write(); }
        }
    }

    public void doQuery(SepoaStream sepoastream)
        throws Exception
    {
    	Logger.debug.println();
    }

    public static int max_view_count;

    static
    {
        try
        {
            Configuration configuration = new Configuration();
            max_view_count = configuration.getInt("sepoa.view.rowcount");
        }
        catch(ConfigurationException configurationexception)
        {
        	Logger.debug.println(); 
        }
        catch(Exception exception)
        {
        	Logger.debug.println();
        }
    }
}