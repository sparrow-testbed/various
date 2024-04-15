package sepoa.svl.util;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.SepoaDataMapper;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class SepoaAjax extends HttpServlet
{
    private String USER_ENCODING;

    public SepoaAjax()
    {
    	Logger.debug.println();
    }

    public void init()
    {
    	Logger.debug.println();
    }

    public void destory()
    {
    	Logger.debug.println();   
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
    {
        
        doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException
    {
	    SepoaOut value = null;
	    SepoaInfo info = SepoaSession.getAllValue(req);

        try {
	        USER_ENCODING = sepoa.fw.util.CommonUtil.getConfig("sepoa.encodingset");
	        res.setContentType("application/xml;charset=" + USER_ENCODING);
	        GridData gdReq = OperateGridData.parse( req, res );
	
	        Logger.debug.println(info.getSession("ID"), this, "doPost start!!");
	        
	        Map data = SepoaDataMapper.getData(info, gdReq);
	
	        //[R101806291967] [2018-07-27] 2018년 우리은행 전자금융기반시설 취약점 분석평가 취약점 조치 요청(전자구매시스템 추가)
	    	// - SQL에서 의미를 가지는 특수 문자(', %, !, --, # 등)가 포함되어 있을 경우 빈공백으로 대체 
//	        String nickName = sepoa.fw.util.CommonUtil.nullToEmpty(req.getParameter("nickName"));
//	        String conType = sepoa.fw.util.CommonUtil.nullToEmpty(req.getParameter("conType"));
//	        String methodName = sepoa.fw.util.CommonUtil.nullToEmpty(req.getParameter("methodName"));
	        String nickName = com.icompia.util.CommonUtil.nullToEmpty2(req.getParameter("nickName"));
	        String conType = com.icompia.util.CommonUtil.nullToEmpty2(req.getParameter("conType"));
	        String methodName = com.icompia.util.CommonUtil.nullToEmpty2(req.getParameter("methodName"));
	        
	        Logger.debug.println(info.getSession("ID"), this, "nickName=" + nickName);
	        Logger.debug.println(info.getSession("ID"), this, "conType=" + conType);
	        Logger.debug.println(info.getSession("ID"), this, "methodName=" + methodName);
	
	        value = ServiceConnector.doService(info, nickName, conType, methodName, new Object[]{ data });
        } catch (Exception e) {
        	
        	Logger.err.println(e);
        	value = new SepoaOut();
        	value.status = 0;
        	value.message = e.getMessage();
        	value.result = new String[]{""};
        }
        String xmlString = getWiseOutXML(value);
        Logger.debug.println(info.getSession("ID"), this, "xml result= " + xmlString);
        res.getWriter().write(xmlString);
        res.getWriter().flush();
    }

    private String getWiseOutXML(SepoaOut value)
    {
        StringBuffer xmlsb = new StringBuffer();
        xmlsb.append("<?xml version=\"1.0\" encoding=\"" + USER_ENCODING + "\"?>\r\n");
        xmlsb.append("<SepoaOut>\r\n");
        xmlsb.append("<status>");
        xmlsb.append(value.status);
        xmlsb.append("</status>\r\n");
        xmlsb.append("<message>");
        xmlsb.append(value.message);
        xmlsb.append("</message>\r\n");

        if( value.result != null && !"".equals( value.result )) {
            for (int i = 0; i < value.result.length; i++)
            {
                xmlsb.append("<result><![CDATA[");
                xmlsb.append(value.result[i]);
                xmlsb.append("]]></result>\r\n");
                
            }
        }

        xmlsb.append("</SepoaOut>\r\n");

        return xmlsb.toString();
    }
}