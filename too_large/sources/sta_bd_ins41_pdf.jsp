<%@ page contentType = "text/html; charset=UTF-8" %>
<%@page import="com.lowagie.text.Rectangle"%>
<%@page import="com.lowagie.text.HeaderFooter"%>
<%@page import="sepoa.fw.log.Logger"%>
<%@page import="com.lowagie.text.pdf.PdfCell"%>
<%@page import="com.lowagie.text.Cell"%>
<%@page import="org.apache.commons.collections.MapUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.awt.Color"%>
<%@ page import="java.io.FileOutputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="com.lowagie.text.Document"%>
<%@ page import="com.lowagie.text.DocumentException"%>
<%@ page import="com.lowagie.text.Element"%>
<%@ page import="com.lowagie.text.Font"%>
<%@ page import="com.lowagie.text.Image"%>
<%@ page import="com.lowagie.text.PageSize"%>
<%@ page import="com.lowagie.text.Paragraph"%>
<%@ page import="com.lowagie.text.Phrase"%>
<%@ page import="com.lowagie.text.pdf.BaseFont"%>
<%@ page import="com.lowagie.text.pdf.PdfPCell"%>
<%@ page import="com.lowagie.text.pdf.PdfPTable"%>
<%@ page import="com.lowagie.text.pdf.PdfWriter"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.db.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.srv.*"%>

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%
	String co_no = JSPUtil.nullToEmpty ( JSPUtil.CheckInjection ( request.getParameter ( "co_no" ) ) ) ;
    
    Object [ ] obj = { co_no } ;
    SepoaOut value = ServiceConnector.doService ( info , "p7008" , "CONNECTION" , "getScoHeader" , obj ) ;
    
    SepoaFormater sf = new SepoaFormater ( value.result [ 0 ] ) ; //헤더데이타 조회해 오 내용 

    Object [ ] obj2 = { co_no } ;
    SepoaOut value2 = ServiceConnector.doService ( info , "p7008" , "CONNECTION" , "getScoDetail" , obj ) ;
    
    SepoaFormater sf2 = new SepoaFormater ( value2.result [ 0 ] ) ; //헤더데이타 조회해 오 내용 
    FileOutputStream fos = null;
    /*********************************************************
     * pdf 파일 생성 
     *********************************************************/
    Document document = new Document ( PageSize.A4 , 40 , 40 , 40 , 40 ) ;
    
    String FILE_PATH = CommonUtil.getConfig( "sepoa.attach.path.TEMP" ) ;
    String file_name = sf.getValue("CO_NO", 0) + "_ResultList.pdf" ;
    
    BaseFont bfKorean = BaseFont.createFont ( "HYGoThic-Medium" , "UniKS-UCS2-H" , BaseFont.NOT_EMBEDDED ) ;
    try {
    fos = new FileOutputStream ( FILE_PATH + "/" + file_name );
    PdfWriter.getInstance ( document , fos ) ;
    
    document.open ( ) ;
    String contractTitle = "" ;
    String contractSubjectTitle = "" ;
    String contractLocationTitle = "" ;
    
   	contractTitle = "납품 실적증명서" ;
    contractSubjectTitle = "공사명" ;
	contractLocationTitle = "공사장소" ;
    
    PdfPCell cell = null ;
    Paragraph text = null ;
    PdfPTable table = null ;
    float [ ] tbWidth = { 2.5f , 7.5f } ;
    float [ ] tbWidth1 = { 2.5f , 3.75f , 3.75f } ;
    float [ ] tbWidth2 = { 1.25f , 1.25f , 7.5f } ;
    float [ ] tbWidth3 = { 2.0f , 2.0f , 2.5f , 0.8f , 0.8f , 2.0f } ;
    float [ ] tbWidth4 = { 2.5f , 1.5f , 6.0f } ;
    float [ ] tbWidth5 = { 0.5f , 0.8f , 2.5f, 0.8f, 1.2f } ;
    float [ ] tbWidth6 = { 0.5f , 0.8f , 2.0f, 0.6f, 0.6f, 1.8f } ;
    float [ ] tbWidth7 = { 0.55f , 2.5f , 0.2f, 0.2f} ;
    
    table = new PdfPTable ( 4 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setWidths ( tbWidth7 ) ;
    table.setLockedWidth ( true ) ;
    
    text = new Paragraph ( "" , new Font ( bfKorean , 15 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment ( Element.ALIGN_MIDDLE ) ;
    cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
    cell.setPaddingRight ( 5f ) ;
    cell.setBorder ( 0 ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;

    text = new Paragraph ( contractTitle , new Font ( bfKorean , 15 , Font.UNDERLINE , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment ( Element.ALIGN_MIDDLE ) ;
    cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
    cell.setPaddingRight ( 5f ) ;
    cell.setBorder ( 0 ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "" , new Font ( bfKorean , 15 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment ( Element.ALIGN_MIDDLE ) ;
    cell.setHorizontalAlignment ( Element.ALIGN_RIGHT ) ;
    cell.setPaddingRight ( 5f ) ;
    cell.setFixedHeight(30);
    cell.setBorderWidth ( 0.7f ) ;
    table.addCell ( cell ) ;    
  
    text = new Paragraph ( "" , new Font ( bfKorean , 15 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment ( Element.ALIGN_MIDDLE ) ;
    cell.setHorizontalAlignment ( Element.ALIGN_RIGHT ) ;
    cell.setPaddingRight ( 5f ) ;
    cell.setFixedHeight(30);
    cell.setBorderWidth ( 0.7f ) ;
    table.addCell ( cell ) ;    
    
    document.add ( table ) ;
    
    //공백라인
    table = new PdfPTable ( 1 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setLockedWidth ( true ) ;
    text = new Paragraph ( "" , new Font ( bfKorean , 15 , Font.UNDERLINE , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBorder ( 0 ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    document.add ( table ) ;
    //공백라인
    table = new PdfPTable ( 1 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setLockedWidth ( true ) ;
    text = new Paragraph ( "" , new Font ( bfKorean , 15 , Font.UNDERLINE , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBorder ( 0 ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    document.add ( table ) ;
    
    table = new PdfPTable ( 5 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setWidths ( tbWidth5 ) ;
    table.setLockedWidth ( true ) ;
    text = new Paragraph ( "신\n\n청\n\n인" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setRowspan ( 5 ) ;
    cell.setBorderWidth ( 0.2f ) ;
    cell.setBorderWidthBottom ( 0.0f ) ;
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "회   사   명\n(상       호)" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( sf.getValue("VENDOR_NAME_LOC", 0) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( "대 표 자" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( sf.getValue("CEO_NAME_LOC", 0) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "주        소" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( sf.getValue("ADDRESS_LOC", 0) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( "전화번호" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( sf.getValue("PHONE_NO1", 0) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    
    text = new Paragraph ( "사업자번호" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    String irs_no = sf.getValue("IRS_NO", 0);
    
    text = new Paragraph ( irs_no.substring(0, 3) + "-" + irs_no.substring(3, 5) + "-" + irs_no.substring(5) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    String company_rec_no = sf.getValue("COMPANY_REC_NO", 0);
    
    text = new Paragraph ( "법인번호" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( company_rec_no.substring(0, 6) + "-" + company_rec_no.substring(6) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    						
    text = new Paragraph ( "용        도" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( sf.getValue("PURPOSE", 0) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( "제 출 처" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph (sf.getValue("PRESENT", 0) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    String iType = sf.getValue("ITYPE", 0);
    String chkStr1 = "(         )";
    String chkStr2 = "(         )";
    String chkStr3 = "(         )";
    
    if("01".equals(iType)){
    	chkStr1 = "(    O    )"; 
    	chkStr2 = "(         )"; 
    	chkStr3 = "(         )"; 
    }else if("03".equals(iType)){
    	chkStr1 = "(         )"; 
    	chkStr2 = "(    O    )"; 
    	chkStr3 = "(         )"; 
    }else if("04".equals(iType)){
    	chkStr1 = "(         )"; 
    	chkStr2 = "(         )"; 
    	chkStr3 = "(    O    )"; 
    }
    						
    text = new Paragraph ( "업 태 구 분" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( "제     조 "+chkStr1+",     공     급 "+chkStr2+",     기     타 "+chkStr3 , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setColspan(3);
    table.addCell ( cell ) ;
    
    document.add ( table ) ;    

    table = new PdfPTable ( 1 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setLockedWidth ( true ) ;
    text = new Paragraph ( "납        품        내        용" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setBorderWidth ( 0.2f ) ;
    cell.setBorderWidthBottom ( 0.0f ) ;
    table.addCell ( cell ) ;    
    
    document.add ( table ) ;   
    
    table = new PdfPTable ( 6 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setWidths ( tbWidth3 ) ;
    table.setLockedWidth ( true ) ;
    
    text = new Paragraph ( "납  품  명" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;       
    
    text = new Paragraph ( "납 품 내 용" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;       
    
    text = new Paragraph ( "납 품 일 자" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;       
    
    text = new Paragraph ( "단  위" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;       
    
    text = new Paragraph ( "수  량" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;       
    
    text = new Paragraph ( "납   품   금   액\n(부가가치세 포함)" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;     
    
    Double 	poAmt  = 0.0; 
    Double 	totAmt = 0.0;
    int 	rowCnt = 15;
    
    if(sf2 != null && sf2.getRowCount() > 0){
    		
    	for(int i = 0 ; i < sf2.getRowCount() ; i++){
    		
    		poAmt = Double.parseDouble(sf2.getValue("PO_AMT", i).toString());
    		totAmt +=poAmt;
    		
			text = new Paragraph ( sf2.getValue("SUBJECT", i) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
   	        cell = new PdfPCell ( text ) ;
   	        cell.setFixedHeight(20);
   	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
   	        cell.setHorizontalAlignment(cell.ALIGN_LEFT);
   	        table.addCell ( cell ) ;       
   	        
   	        text = new Paragraph (  sf2.getValue("ITEM_NAME", i)  , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
   	        cell = new PdfPCell ( text ) ;
   	        cell.setFixedHeight(20);
   	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
   	        cell.setHorizontalAlignment(cell.ALIGN_LEFT);
   	        table.addCell ( cell ) ;       
   	        
   	        text = new Paragraph ( sf2.getValue("CONTRACT_DATE", i), new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
   	        cell = new PdfPCell ( text ) ;
   	        cell.setFixedHeight(20);
   	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
   	        cell.setHorizontalAlignment(cell.ALIGN_CENTER);
   	        table.addCell ( cell ) ;       
   	        
   	        text = new Paragraph ( sf2.getValue("UNIT_MEASURE", i) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
   	        cell = new PdfPCell ( text ) ;
   	        cell.setFixedHeight(20);
   	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
   	        cell.setHorizontalAlignment(cell.ALIGN_CENTER);
   	        table.addCell ( cell ) ;       
   	        
   	        text = new Paragraph ( sf2.getValue("PO_CNT", i) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
   	        cell = new PdfPCell ( text ) ;
   	        cell.setFixedHeight(20);
   	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
   	        cell.setHorizontalAlignment(cell.ALIGN_CENTER);
   	        table.addCell ( cell ) ;       
   	        
   	        text = new Paragraph ( SepoaMath.SepoaNumberType(poAmt, "###,###,###,###,###,###,###")  , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
   	        cell = new PdfPCell ( text ) ;
   	        cell.setFixedHeight(20);
   	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
   	        cell.setHorizontalAlignment(cell.ALIGN_RIGHT);
   	        table.addCell ( cell ) ;      		
    	}
    	
    	rowCnt = rowCnt - sf2.getRowCount();
    	
    	if(rowCnt > 0){
    		for(int i = 0 ; i < rowCnt ; i++){
    			text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
       	        cell = new PdfPCell ( text ) ;
       	        cell.setFixedHeight(20);
       	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
       	        cell.setHorizontalAlignment(cell.ALIGN_LEFT);
       	        table.addCell ( cell ) ;       
       	        
       	        text = new Paragraph ( ""  , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
       	        cell = new PdfPCell ( text ) ;
       	        cell.setFixedHeight(20);
       	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
       	        cell.setHorizontalAlignment(cell.ALIGN_LEFT);
       	        table.addCell ( cell ) ;       
       	        
       	        text = new Paragraph ( "", new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
       	        cell = new PdfPCell ( text ) ;
       	        cell.setFixedHeight(20);
       	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
       	        cell.setHorizontalAlignment(cell.ALIGN_CENTER);
       	        table.addCell ( cell ) ;       
       	        
       	        text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
       	        cell = new PdfPCell ( text ) ;
       	        cell.setFixedHeight(20);
       	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
       	        cell.setHorizontalAlignment(cell.ALIGN_CENTER);
       	        table.addCell ( cell ) ;       
       	        
       	        text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
       	        cell = new PdfPCell ( text ) ;
       	        cell.setFixedHeight(20);
       	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
       	        cell.setHorizontalAlignment(cell.ALIGN_CENTER);
       	        table.addCell ( cell ) ;       
       	        
       	        text = new Paragraph ( ""  , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
       	        cell = new PdfPCell ( text ) ;
       	        cell.setFixedHeight(20);
       	        cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
       	        cell.setHorizontalAlignment(cell.ALIGN_RIGHT);
       	        table.addCell ( cell ) ; 
    		}
    	}
    }
    
    text = new Paragraph ( "합            계" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setColspan(2);
    table.addCell ( cell ) ;         
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;         
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;         
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;         
    
    text = new Paragraph ( SepoaMath.SepoaNumberType(totAmt, "###,###,###,###,###,###,###") , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_RIGHT);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    table.addCell ( cell ) ;         
    
    document.add ( table ) ;   
    
    
    table = new PdfPTable ( 6 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setWidths ( tbWidth6 ) ;
    table.setLockedWidth ( true ) ;
    text = new Paragraph ( "증명서\n\n발급기관" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setRowspan ( 8 ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "위 사실의 내용이 틀림이 없음을 확인함." , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setBorderWidthBottom( 0.0f ) ;
    cell.setColspan(5);
    
    table.addCell ( cell ) ;
    text = new Paragraph ( SepoaDate.getYear() + "년   "+SepoaDate.getMonth()+"월   "+SepoaDate.getDay()+"일"  , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(20);
    cell.setHorizontalAlignment(cell.ALIGN_RIGHT);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setBorderWidthTop( 0.0f ) ;
    cell.setColspan(5);
    
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "발 급 기 관" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setRowspan(2);
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(15);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setRowspan(2);
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "전화번호" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setColspan(2);
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "팩스번호" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setBorderWidth ( 0.2f ) ;
    cell.setColspan(2);
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(15);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    						
    text = new Paragraph ( "발급기관주소" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setFixedHeight(20);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setColspan(4);
    table.addCell ( cell ) ;
    
    
    text = new Paragraph ( "발급부서" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setRowspan(2);
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setRowspan(2);
    table.addCell ( cell ) ;
    						
    text = new Paragraph ( "발   급\n담당자" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setRowspan(2);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "직위" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    cell.setFixedHeight(15);
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;    
    
    text = new Paragraph ( "성명" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setBorderWidth ( 0.2f ) ;
    cell.setFixedHeight(15);
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setFixedHeight(15);
    cell.setColspan(2);
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_CENTER);
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    document.add ( table ) ;
    
    table = new PdfPTable ( 1 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setLockedWidth ( true ) ;
    text = new Paragraph ( "※ 납품 실적금액 증빙을 위해 전자세금계산서 필수 첨부\n\n※ 진위여부 확인을 위하여 증명서 발급기관 정보는 필수 기재되어야 실적인정됨." , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment(cell.ALIGN_MIDDLE);
    cell.setHorizontalAlignment(cell.ALIGN_LEFT);
    cell.setBorderWidth ( 0.0f ) ;
    table.addCell ( cell ) ;    
    
    document.add ( table ) ;
    
    document.close ( ) ;
    } catch ( Exception e ) { response.sendRedirect ( POASRM_CONTEXT_NAME + "/errorPage/system_error.jsp" ) ;     
    } finally { try { if(fos != null){fos.close();} } catch (Exception e){}  }
    InputStream in = null ;
    OutputStream os = null ;
    try {
        
        File file = new File ( FILE_PATH + "/" + file_name ) ;
        in = new FileInputStream ( file ) ;
        
        out.clear ( ) ;
        pageContext.pushBody ( ) ;
        response.reset ( ) ;
        response.setContentType ( "application/smnet" ) ;
        response.setHeader ( "Content-Type" , "application/smnet; charset=UTF-8" ) ;
        response.setHeader ( "Content-Disposition" , "attachment; filename=" + file_name + "\"" ) ;
        response.setHeader ( "Content-Transfer-Encoding" , "binary" ) ;
        response.setHeader ( "Content-Length" , "" + file.length ( ) ) ;
        
        os = response.getOutputStream ( ) ;
        
        byte b[] = new byte [ ( int ) file.length ( ) ] ;
        int leng = 0 ;
        while ( ( leng = in.read ( b ) ) > 0 ) {
            os.write ( b , 0 , leng ) ;
            os.flush ( ) ;
        }
        
    } catch ( Exception e ) {
        
        response.sendRedirect ( POASRM_CONTEXT_NAME + "/errorPage/system_error.jsp" ) ;
    } finally {
        if ( in != null )
            try {
                in.close ( ) ;
            } catch ( Exception e ) {
            }
        if ( os != null )
            try {
                os.close ( ) ;
            } catch ( Exception e ) {
            }
    }
    
    File delFile = new File ( FILE_PATH + "/" + file_name ) ;
    delFile.delete ( ) ;
%>