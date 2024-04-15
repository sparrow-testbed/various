package sepoa.svl.util;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.util.DocumentUtil;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;

public class DocNumber extends HttpServlet
{
    public DocNumber()
    {
    	Logger.debug.println();
    }

    public void service()
    {
    	Logger.debug.println();
    }

    public void doGet(HttpServletRequest httpservletrequest, HttpServletResponse httpservletresponse) throws IOException, ServletException
    {
        String s = httpservletrequest.getParameter("INFO");
        String s1 = httpservletrequest.getParameter("HOUSE_CODE");
        String s2 = httpservletrequest.getParameter("DOC_TYPE");
        String s4 = httpservletrequest.getParameter("EXP_NO");
        httpservletresponse.setContentType("text/html");

        PrintWriter printwriter = httpservletresponse.getWriter();

//        System.out.println("S  --> " + s);
//        System.out.println("S1 --> " + s1);
//        System.out.println("S2 --> " + s2);
//        System.out.println("S4 --> " + s4);

        //if ((s == null) || (s1 == null) || (s2 == null))
        if ((s == null) || (s2 == null))
        {
            printwriter.println("-1");
            printwriter.println("E");
            
        }
        else
        {
            SepoaInfo sepoainfo = new SepoaInfo(s1, s);
            SepoaOut sepoaout;

            if (s4 == null)
            {
                sepoaout = DocumentUtil.getDocNumberRemote(sepoainfo, s2);
            }
            else
            {
                sepoaout = DocumentUtil.getDocNumberRemote(sepoainfo, s2, s4);
            }

            printwriter.println(sepoaout.status);
            printwriter.println(sepoaout.result[0]);
            printwriter.flush();
            printwriter.close();
        }
    }

    public void doPost(HttpServletRequest httpservletrequest1, HttpServletResponse httpservletresponse1) throws IOException, ServletException
    {
    	Logger.debug.println();
    }
}
