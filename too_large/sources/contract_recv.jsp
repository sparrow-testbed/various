<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import="java.util.Map"%>
<%@ page import="sepoa.fw.ses.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.msg.*"%>
<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="signgate.sgic.xmlmanager.util.FileWriteUtil"%>
<%@ include file="signgate_xlinker.jsp"%>


<%@ page import="signgate.core.crypto.util.FileUtil"%>

<%
    Configuration conf = new Configuration();

    SGIxLinker xLinker = new SGIxLinker ( conf.get ( "sepoa.sgix.recvinfo.conf" ) , "recv_jsp" , true ) ;
    
    try
    {
        ServletOutputStream output = null ;
        
        String responseXml = "" ;
        
        String bond_numb_text = "" ;
        
        boolean isOK = xLinker.doRecvProcess ( request , response ) ;
        if ( !isOK ) {
            pageContext.getServletContext ( ).log ( "isOK is false" ) ;
            out.println ( "Recive API Error : [" + xLinker.getErrorCode ( ) + "] : " + xLinker.getErrorMsg ( ) ) ;
            Logger.sys.println ( "xLinker.getErrorMsg() : " + xLinker.getErrorMsg ( ) ) ;
            responseXml = xLinker.responseAck ( "SR" , xLinker.getErrorMsg ( ) , "" ) ;
            
            try {
                output = response.getOutputStream ( ) ;
                output.write ( responseXml.getBytes ( ) ) ;
                output.flush ( ) ;
                if ( output != null )
                    output.close ( ) ;
            } catch ( IOException e ) {
                
                Logger.sys.println ( "error :" + e.toString ( ) ) ;
                
                throw new Exception ( "error :" + e.toString ( ) ) ;
            }
        }
        
        String recvDocCode = xLinker.getRecvDocCode ( ) ;
        String recvXmlDoc = xLinker.getRecvXmlData ( ) ;
        if ( recvXmlDoc.equals ( "" ) ) {
            recvXmlDoc = xLinker.getDecXmlPath ( ) ;
        }
        
        XmlToData xmlToData = new XmlToData ( templates_path , recvDocCode , recvXmlDoc ) ;
        
        if ( xmlToData.getErrorCode ( ) != 0 ) {
            
            Logger.sys.println ( "xLinker.getErrorMsg() : " + xmlToData.getErrorMsg ( ) ) ;
            responseXml = xLinker.responseAck ( "SR" , xmlToData.getErrorMsg ( ) , "" ) ;
            
            try {
                output = response.getOutputStream ( ) ;
                output.write ( responseXml.getBytes ( ) ) ;
                output.flush ( ) ;
                if ( output != null )
                    output.close ( ) ;
            } catch ( IOException e ) {
                
                Logger.sys.println ( "error :" + e.toString ( ) ) ;
                
                throw new Exception ( "error :" + e.toString ( ) ) ;
            }
            
        }
        
        if ( ( recvDocCode != null ) && ( !recvDocCode.equals ( "" ) ) &&
        ( recvXmlDoc != null ) && ( !recvXmlDoc.equals ( "" ) ) )
        {
            if ( recvDocCode.equals ( "CONGUA" ) || recvDocCode.equals ( "FLRGUA" ) || recvDocCode.equals ( "PREGUA" ) ) {
                String cont_numb_text = xmlToData.getData ( "cont_numb_text" ) ;
                bond_numb_text = xmlToData.getData ( "head_refr_numb" ) ;
                String bond_penl_amnt = xmlToData.getData ( "bond_penl_amnt" ) ;
                String appl_orps_iden = xmlToData.getData ( "appl_orps_iden" ) ;
                String bond_path = xLinker.getDecXmlPath ( ) ;
                
                sepoa.fw.ses.SepoaInfo info = null ;
                info = new SepoaInfo ( "100" , "ID=HOMEPAGE^@^LANGUAGE=KO^@^NAME_LOC=CONT^@^NAME_ENG=CONT^@^DEPT=ALL^@^" ) ;

                Map < String , Object > allData = new HashMap < String , Object > ( ) ;
                HashMap < String , String > hashMap = new HashMap < String , String > ( ) ;
                hashMap.put ( "recvDocCode"    , recvDocCode    );
                hashMap.put ( "cont_number"    , cont_numb_text );
                hashMap.put ( "cont_gl_seq"    , ""             );
                hashMap.put ( "cont_numb_text" , cont_numb_text );
                hashMap.put ( "bond_numb_text" , bond_numb_text );
                hashMap.put ( "bond_penl_amnt" , bond_penl_amnt );
                hashMap.put ( "appl_orps_iden" , appl_orps_iden );
                hashMap.put ( "recvXmlDoc"     , recvXmlDoc     );
                hashMap.put ( "bond_path"      , bond_path      );
                hashMap.put ( "bondJobFalg"    , "RECVXML"      );//작업여부 ( 전송(SENDXML) / 최종응답서(FINALXML) / 보증증권 수신(RECVXML)
                allData.put ( "headerData"     , hashMap        );
                
                
                Object [ ] obj = { allData } ;
                SepoaOut value = ServiceConnector.doService ( info , "CT_001" , "CONNECTION" , "setContractBond" , obj ) ;
                
                if ( value.flag ) {
                    responseXml = xLinker.responseAck ( "SA" , value.message , bond_numb_text ) ;
                } else {
                    responseXml = xLinker.responseAck ( "SR" , value.message , bond_numb_text ) ;
                }
                
            }
        } else {
            
            responseXml = xLinker.responseAck ( "SR" , "received fail : recvDocCode is null or recvXmlDoc is null" , bond_numb_text ) ;
        }
        
        try {
            output = response.getOutputStream ( ) ;
            output.write ( responseXml.getBytes ( ) ) ;
            output.flush ( ) ;
            if ( output != null )
                output.close ( ) ;
        } catch ( IOException e ) {
            
            Logger.sys.println ( "error :" + e.toString ( ) ) ;
            
            throw new Exception ( "error :" + e.toString ( ) ) ;
        }
        
    } catch ( Exception e ) {
        
    } finally {
        
    }
%>
