<%@page import="com.lowagie.text.Rectangle"%>
<%@page import="com.lowagie.text.HeaderFooter"%>
<%@page import="sepoa.fw.log.Logger"%>
<%@page import="com.lowagie.text.pdf.PdfCell"%>
<%@page import="com.lowagie.text.Cell"%>
<%@page import="org.apache.commons.collections.MapUtils"%>
<%@ page contentType="text/html; charset=UTF-8"%>
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
<%!private boolean getContractViewFlag ( String contType , String types ) {
    
        //계약번호 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
        boolean typesFalg = true ;
        //System.out.println ( "contType : " + contType + " / " + "types : " + types + " / indexOf : " + types.indexOf ( contType ) ) ;
        try {
            if ( types.indexOf ( contType ) != -1 ) {
                typesFalg = false ;
            }
        } catch ( Exception e ) {
            
        }
        return typesFalg ;
    }
    
    private String getKoreanDate ( String setDate ) {
    
        String getDate = "" ;
        try {
            getDate += setDate.substring ( 0 , 4 ) + "년 " ;
            getDate += setDate.substring ( 4 , 6 ) + "월 " ;
            getDate += setDate.substring ( 6 , 8 ) + "일 " ;
        } catch ( Exception e ) {
            
            Logger.debug.print ( "날짜 형식이 잘못되었습니다 ( 숫자 8자리로 들어와야 합니다. )" ) ;
        }
        return getDate ;
    }
    private String formatNumberPrice(String num) {
		return SepoaMath.SepoaNumberType(num,
				"#,###,###,###,###,###,###,###,###.###");
	}%>
<%
    Configuration hub_configuration = new Configuration ( ) ;
    String encoding_status = hub_configuration.getString ( "sepoa.database.encoding" ) ;
    String fieldSeparator = hub_configuration.getString ( "sepoa.separator.field" ) ;
    Enumeration enumeration = request.getParameterNames ( ) ;
    HashMap < String , String > hashMap = new HashMap < String , String > ( ) ;
    String sepoaQueryString = "" ;
    while ( enumeration.hasMoreElements ( ) ) {
        String name_temp = ( String ) enumeration.nextElement ( ) ;
        String value_temp = JSPUtil.nullToEmpty ( JSPUtil.CheckInjection ( request.getParameter ( name_temp ) ) ) ;
        hashMap.put ( name_temp , value_temp ) ;
        sepoaQueryString += name_temp + "=" + value_temp + "&" ;
    }
    sepoa.fw.ses.SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue ( request ) ;
    Config conf = new Configuration ( ) ;
    // 파라미터 설정 
    String POASRM_CONTEXT_NAME = conf.get ( "sepoa.context.name" ) ;
    String POASRM_DOMAIN_NAME = conf.get ( "sepoa.system.domain.name" ) ;
    
    String to_date = SepoaString.getDateSlashFormat ( SepoaDate.getShortDateString ( ) ) ;
    
    //Dthmlx Grid 전역변수들..
    String screen_id = "CT_001" ;
    String grid_obj = "GridObj" ;
    
    Object [ ] obj = { hashMap } ;
    SepoaOut value = ServiceConnector.doService ( info , "CT_001" , "CONNECTION" , "getContractDeaitl" , obj ) ;
    HashMap < String , String > headerHm = new HashMap < String , String > ( ) ;
    
    SepoaFormater headerSf = new SepoaFormater ( value.result [ 0 ] ) ; //헤더데이타 조회해 오 내용 
    for ( int i = 0 ; i < headerSf.getColumnCount ( ) ; i ++ ) { //조회해온 내용을 포문을 돌려 headerHm(해쉬맵)에 저장한다
        headerHm.put ( headerSf.getColumnNames ( ) [ i ] , headerSf.getValue ( headerSf.getColumnNames ( ) [ i ] , 0 ).trim ( ) ) ;
    }
    FileOutputStream fos = null;
    /*********************************************************
     * pdf 파일 생성 
     *********************************************************/
    Document document = new Document ( PageSize.A4 , 40 , 40 , 40 , 40 ) ;
    
    String FILE_PATH = conf.get ( "sepoa.attach.path.TEMP" ) ;
    String file_name = MapUtils.getString ( headerHm , "CONT_NUMBER" ) + "_" + MapUtils.getString ( headerHm , "CONT_GL_SEQ" ) + "Contract.pdf" ;
    //BaseFont bfKorean = BaseFont.createFont ( fontUrl , BaseFont.IDENTITY_H , BaseFont.EMBEDDED ) ;
    BaseFont bfKorean = BaseFont.createFont ( "HYGoThic-Medium" , "UniKS-UCS2-H" , BaseFont.NOT_EMBEDDED ) ;
    try {
    fos = new FileOutputStream ( FILE_PATH + "/" + file_name );
    PdfWriter.getInstance ( document , fos ) ;
    
    document.open ( ) ;
    String contractTitle = "" ;
    String contractSubjectTitle = "" ;
    String contractLocationTitle = "" ;
    if ( "1".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" ) ) ) {
        contractTitle = "공사도급 계약서" ;
        contractSubjectTitle = "공사명" ;
        contractLocationTitle = "공사장소" ;
    } else if ( "2".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" ) ) ) {
        contractTitle = "물품공급 계약서" ;
        contractSubjectTitle = "구매신청명" ;
        contractLocationTitle = "납품장소" ;
    } else if ( "3".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" ) ) ) {
        contractTitle = "용역 계약서" ;
        contractSubjectTitle = "용역명" ;
        contractLocationTitle = "용역장소" ;
    } else if ( "4".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" ) ) ) {
        contractTitle = "유지보수 계약서" ;
        contractSubjectTitle = "계약명" ;
        contractLocationTitle = "유지보수장소" ;
    } else if ( "5".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" ) ) ) {
        contractTitle = "단가계약서(일반/용역)" ;
        contractSubjectTitle = "공사(용역)명" ;
        contractLocationTitle = "공사(용역)장소" ;
    } else if ( "6".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" ) ) ) {
        contractTitle = "단가계약서(물품)" ;
        contractSubjectTitle = "구매신청명" ;
        contractLocationTitle = "납품장소" ;
    } else if ( "7".equals ( MapUtils.getString ( headerHm , "CONT_TYPE" ) ) ) {
        contractTitle = "계약서" ;
        contractSubjectTitle = "계약명" ;
        contractLocationTitle = "납품장소" ;
    }
    
    PdfPCell cell = null ;
    Paragraph text = null ;
    PdfPTable table = null ;
    float [ ] tbWidth = { 2.5f , 7.5f } ;
    float [ ] tbWidth1 = { 2.5f , 3.75f , 3.75f } ;
    float [ ] tbWidth2 = { 1.25f , 1.25f , 7.5f } ;
    float [ ] tbWidth3 = { 2.5f , 3.5f , 0.5f , 1.0f , 1.2f , 1.3f } ;
    float [ ] tbWidth4 = { 2.5f , 1.5f , 6.0f } ;
    
    table = new PdfPTable ( 1 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setLockedWidth ( true ) ;
    text = new Paragraph ( contractTitle , new Font ( bfKorean , 15 , Font.UNDERLINE , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setVerticalAlignment ( Element.ALIGN_MIDDLE ) ;
    cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
    cell.setPaddingRight ( 5f ) ;
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
    
    //계약서종류
    table = new PdfPTable ( 2 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setWidths ( tbWidth ) ;
    table.setLockedWidth ( true ) ;
    text = new Paragraph ( "계약서종류" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( contractTitle , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    document.add ( table ) ;
    
    //계약번호
    table = new PdfPTable ( 2 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setWidths ( tbWidth ) ;
    table.setLockedWidth ( true ) ;
    text = new Paragraph ( "계약번호" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    text = new Paragraph ( MapUtils.getString ( headerHm , "CONT_NUMBER" ) + " " + MapUtils.getString ( headerHm , "CONT_GL_SEQ" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    document.add ( table ) ;
    
    // 프로젝트명 
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "7" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        if ( "".equals ( MapUtils.getString ( headerHm , "PJ_NAME" ).trim ( ) ) ) {
            headerHm.put ( "PJ_NAME" , MapUtils.getString ( headerHm , "SUBJECT" ) ) ;
        }
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "프로젝트명" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "PJ_NAME" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 구매신청명 / 공사명 / 용역명 / 계약명  
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( contractSubjectTitle , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "SUBJECT" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 계약체결일 
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "계약체결일" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( getKoreanDate ( MapUtils.getString ( headerHm , "CONT_DATE" ) ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 계약기간 
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "계약기간" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( getKoreanDate ( MapUtils.getString ( headerHm , "CONT_FROM" ) ) + "~ " + getKoreanDate ( MapUtils.getString ( headerHm , "CONT_TO" ) ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 구매자(갑) 
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 3 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth1 ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "업체명" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "BUYER_COMPANY_NAME" ) + " 구매자(갑)" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "SELLER_COMPANY_NAME" ) + " 공급자(을)" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 사업자번호(갑) 
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 3 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth1 ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "사업자번호" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "BUYER_COMPANY_IRS_NO" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "SELLER_COMPANY_IRS_NO" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 주소
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 3 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth1 ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "주소" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setVerticalAlignment ( Element.ALIGN_MIDDLE ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setRowspan ( 3 ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( MapUtils.getString ( headerHm , "BUYER_COMPANY_ZIP_CODE1" ) + " - " + MapUtils.getString ( headerHm , "BUYER_COMPANY_ZIP_CODE2" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthBottom ( 0.0f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "SELLER_COMPANY_ZIP_CODE1" ) + " - " + MapUtils.getString ( headerHm , "SELLER_COMPANY_ZIP_CODE2" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthBottom ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( MapUtils.getString ( headerHm , "BUYER_COMPANY_ADDR1" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthBottom ( 0.0f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "SELLER_COMPANY_ADDR1" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthBottom ( 0.0f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( MapUtils.getString ( headerHm , "BUYER_COMPANY_ADDR2" ) + " " , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "SELLER_COMPANY_ADDR2" ) + " " , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 대표이사
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 3 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth1 ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "대표이사" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "BUYER_COMPANY_CEO_NAME" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "SELLER_COMPANY_CEO_NAME" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 대표이사 서명
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 3 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth1 ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "대표이사 서명" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "SELLER_APP_SUCCESS" ) + " " , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 255 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "BUYER_APP_SUCCESS" ) + " " , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 255 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 공사장소 / 납품장소 / 용역장소 / 유지보수장소 / 공사(용역)장소
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "7" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( contractLocationTitle , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "LOCATION" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 계약금액(VAT 포함)
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "5" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        if ( "KRW".equals ( MapUtils.getString ( headerHm , "CUR" , "" ) ) ) {
            table = new PdfPTable ( 3 ) ;
            table.setWidths ( tbWidth1 ) ;
        } else {
            table = new PdfPTable ( 2 ) ;
            table.setWidths ( tbWidth ) ;
        }
        table.setTotalWidth ( 580f ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "계약금액(VAT 포함)" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( "( " + MapUtils.getString ( headerHm , "CUR" , "" ) + " " + formatNumberPrice ( MapUtils.getString ( headerHm , "CONT_TTL_AMT" , "" ) ) + " )" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        if ( "KRW".equals ( MapUtils.getString ( headerHm , "CUR" , "" ) ) ) {
            text = new Paragraph ( "金 " + MapUtils.getString ( headerHm , "CONT_TTL_AMT_TEXT" ) + " " , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
            cell = new PdfPCell ( text ) ;
            cell.setBorderWidth ( 0.2f ) ;
            table.addCell ( cell ) ;
        }
        document.add ( table ) ;
    }
    
    // 계약금액(VAT 별도)
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "57" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        if ( "KRW".equals ( MapUtils.getString ( headerHm , "CUR" , "" ) ) ) {
            table = new PdfPTable ( 3 ) ;
            table.setWidths ( tbWidth1 ) ;
        } else {
            table = new PdfPTable ( 2 ) ;
            table.setWidths ( tbWidth ) ;
        }
        table.setTotalWidth ( 580f ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "계약금액(VAT 별도)" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( "( " + MapUtils.getString ( headerHm , "CUR" , "" ) + " " + formatNumberPrice ( MapUtils.getString ( headerHm , "CONT_AMT" , "" ) ) + " )" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        if ( "KRW".equals ( MapUtils.getString ( headerHm , "CUR" , "" ) ) ) {
            text = new Paragraph ( "金 " + MapUtils.getString ( headerHm , "CONT_AMT_TEXT" ) + " " , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
            cell = new PdfPCell ( text ) ;
            cell.setBorderWidth ( 0.2f ) ;
            table.addCell ( cell ) ;
        }
        document.add ( table ) ;
    }
    
    // 부가가치세
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "57" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        if ( "KRW".equals ( MapUtils.getString ( headerHm , "CUR" , "" ) ) ) {
            table = new PdfPTable ( 3 ) ;
            table.setWidths ( tbWidth1 ) ;
        } else {
            table = new PdfPTable ( 2 ) ;
            table.setWidths ( tbWidth ) ;
        }
        table.setTotalWidth ( 580f ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "부가가치세" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( "( " + MapUtils.getString ( headerHm , "CUR" , "" ) + " " + formatNumberPrice ( MapUtils.getString ( headerHm , "CONT_VAT" , "" ) ) + " )" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        if ( "KRW".equals ( MapUtils.getString ( headerHm , "CUR" , "" ) ) ) {
            text = new Paragraph ( "金 " + MapUtils.getString ( headerHm , "CONT_VAT_TEXT" ) + " " , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
            cell = new PdfPCell ( text ) ;
            cell.setBorderWidth ( 0.2f ) ;
            table.addCell ( cell ) ;
        }
        document.add ( table ) ;
    }
    
    // 대금지급방법
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "57" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "대금지급방법" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "PAY_TERMS_TEXT" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 대금정산조건
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "5" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "대금정산조건" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "PAY_TERMS_DATE" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 지불조건상세
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "124567" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 3 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth4 ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "지불조건상세" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setRowspan ( 3 ) ;
        table.addCell ( cell ) ;
        String temp1 = "" ;
        String temp2 = "" ;
        
        if ( !"".equals ( MapUtils.getString ( headerHm , "FIRST_AMT_RATIO" ) ) ) {
            temp1 = MapUtils.getString ( headerHm , "FIRST_AMT_RATIO" ) + " % " ;
        } else {
            temp1 = "0 % " ;
        }
        if ( !"".equals ( MapUtils.getString ( headerHm , "FIRST_AMT_TIME" ) ) ) {
            temp2 = "( " + MapUtils.getString ( headerHm , "FIRST_AMT_TIME" ) + " )" ;
        }
        text = new Paragraph ( "선급(계약)금 " + temp1 , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_RIGHT ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthRight ( 0.0f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( temp2 , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthLeft ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        if ( !"".equals ( MapUtils.getString ( headerHm , "SECOND_AMT_RATIO_01" ) ) ) {
            temp1 = MapUtils.getString ( headerHm , "SECOND_AMT_RATIO_01" ) + " % " ;
        } else {
            temp1 = "0 % " ;
        }
        if ( !"".equals ( MapUtils.getString ( headerHm , "SECOND_AMT_TIME_01" ) ) ) {
            temp2 = "( " + MapUtils.getString ( headerHm , "SECOND_AMT_TIME_01" ) + " )" ;
        }
        text = new Paragraph ( "중    도    금 " + temp1 , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_RIGHT ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthRight ( 0.0f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( temp2 , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthLeft ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        if ( !"".equals ( MapUtils.getString ( headerHm , "THIRD_AMT_RATIO" ) ) ) {
            temp1 = MapUtils.getString ( headerHm , "THIRD_AMT_RATIO" ) + " % " ;
        } else {
            temp1 = "0 % " ;
        }
        if ( !"".equals ( MapUtils.getString ( headerHm , "THIRD_AMT_TIME" ) ) ) {
            temp2 = "( " + MapUtils.getString ( headerHm , "THIRD_AMT_TIME" ) + " )" ;
        }
        text = new Paragraph ( "잔           금 " + temp1 , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_RIGHT ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthRight ( 0.0f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( temp2 , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthLeft ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        document.add ( table ) ;
    }
    
    // 지불조건상세
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "123567" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "지불조건상세" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "PAY_TERMS_SPEC" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 정기(예방)점검주기
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "123567" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "정기(예방)점검주기" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "PERIOD_CHECK" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 납기일
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "457" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "납기일" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( getKoreanDate ( MapUtils.getString ( headerHm , "RD_DATE" ) ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 선급금지급 보증금율
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "1234567" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "선급금지급 보증금율" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "PRE_INS_PERCENT_TEXT" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 지체상금
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "47" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "지체상금" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "DELAY_PRICE" ) + " / 1000 ( 지연일수 1일당 총계약금액의)" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 계약이행보증금율
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "7" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "계약이행 보증금율" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( "계약금액의 " + MapUtils.getString ( headerHm , "CONT_INS_PERCENT" ) + " %" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 선급금지급 보증금율
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "12567" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "선급금지급 보증금율" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "PRE_INS_PERCENT_TEXT" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 지체상금 ( 유지보수 )
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "12567" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "지체상금" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setRowspan ( 2 ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( "1. " + MapUtils.getString ( headerHm , "DELAY_DATE2" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( "2. " + MapUtils.getString ( headerHm , "DELAY_REMARK2" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 하자이행
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "47" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 3 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth2 ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "하자이행" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setRowspan ( 3 ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthBottom ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "보증금율" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( "계약금액의 " + MapUtils.getString ( headerHm , "FAULT_INS_PERCENT" ) + " %" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "보증기간" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "FAULT_INS_FROM" ) + " 개월" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "특이사항" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthBottom ( 0.0f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( "1. " + MapUtils.getString ( headerHm , "DELAY_DATE1" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthBottom ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        document.add ( table ) ;
    }
    
    // 특이사항 2번
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "2467" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 3 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth2 ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( " " , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( " " , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "2. " + MapUtils.getString ( headerHm , "DELAY_REMARK1" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        document.add ( table ) ;
    }
    
    // 특이사항 2번
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "13457" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 3 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth2 ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( " " , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( " " , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "2. " + MapUtils.getString ( headerHm , "DELAY_REMARK3" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setBorderWidthTop ( 0.0f ) ;
        table.addCell ( cell ) ;
        
        document.add ( table ) ;
    }
    
    // 검사방법
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "7" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "검사방법" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "CONFIRM_METHOD" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 합의관할
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "7" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "합의관할" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( "본 계약건과 분쟁발생시 (갑)과 (을)은 " + MapUtils.getString ( headerHm , "MUTUAL_DISTRICT" ) + "을 관할법원으로 한다." , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 계약대상품및 계약금액
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "13457" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 6 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth3 ) ;
        table.setLockedWidth ( true ) ;
        
        text = new Paragraph ( "계약대상품및 계약금액" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setRowspan ( 4 ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "품명" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "단위" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "수량" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "단가" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( "금액" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( MapUtils.getString ( headerHm , "DESCRIPTION1" , "" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( MapUtils.getString ( headerHm , "UNIT_MEASURE1" , "" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "ITEM_QTY1" , "" ) , "#,###,###,###,###,###,###" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "UNIT_PRICE1" , "" ) , "#,###,###,###,###,###,###" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_RIGHT ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "ITEM_AMT1" , "" ) , "#,###,###,###,###,###,###" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_RIGHT ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( MapUtils.getString ( headerHm , "DESCRIPTION2" , "" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( MapUtils.getString ( headerHm , "UNIT_MEASURE2" , "" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "ITEM_QTY2" , "" ) , "#,###,###,###,###,###,###" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "UNIT_PRICE2" , "" ) , "#,###,###,###,###,###,###" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_RIGHT ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( SepoaMath.SepoaNumberType ( MapUtils.getString ( headerHm , "ITEM_AMT2" , "" ) , "#,###,###,###,###,###,###" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_RIGHT ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( MapUtils.getString ( headerHm , "DESCRIPTION3" , "" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        
        text = new Paragraph ( " " , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setHorizontalAlignment ( Element.ALIGN_CENTER ) ;
        cell.setBorderWidth ( 0.2f ) ;
        cell.setColspan ( 4 ) ;
        table.addCell ( cell ) ;
        
        document.add ( table ) ;
    }
    
    // 부가설명
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "7" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "부가설명" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "REMARK" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    
    // 전자계약의 효력
    // 1 - 공사계약서, 2 - 물품공급계약서, 3 - 용역도급계약서, 4 - 유지보수계약서, 5 - 단가계약서(일반/용역), 6 - 물품공급계약서(단가계약), 7 - 기타계약서
    if ( getContractViewFlag ( MapUtils.getString ( headerHm , "CONT_TYPE" ) , "7" ) ) { //계약타입이 두번째 인자에 포함되면 나오지 않는다.
        table = new PdfPTable ( 2 ) ;
        table.setTotalWidth ( 580f ) ;
        table.setWidths ( tbWidth ) ;
        table.setLockedWidth ( true ) ;
        text = new Paragraph ( "전자계약의 효력" , new Font ( bfKorean , 9 , Font.BOLD , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBackgroundColor ( new Color ( 229 , 229 , 229 ) ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        text = new Paragraph ( MapUtils.getString ( headerHm , "CONTRACT_EFFECT" ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
        cell = new PdfPCell ( text ) ;
        cell.setBorderWidth ( 0.2f ) ;
        table.addCell ( cell ) ;
        document.add ( table ) ;
    }
    /* 
    table = new PdfPTable ( 3 ) ;
    table.setTotalWidth ( 580f ) ;
    table.setWidths ( tbWidth1 ) ;
    table.setLockedWidth ( true ) ;
    String img_path = "" ;
    
    img_path += POASRM_DOMAIN_NAME ;
    img_path += POASRM_CONTEXT_NAME ;
    img_path += "/images/top/contract_pdf_log.jpg" ;
    Image image = Image.getInstance ( img_path ) ;
    image.scaleToFit ( 0.1f , 0.1f ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( image ) ;
    
    text = new Paragraph ( "Page ." + ( document.getPageNumber ( ) + 1 ) , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    text = new Paragraph ( "한화 S&C 계약시스템" , new Font ( bfKorean , 9 , Font.NORMAL , new Color ( 0 , 0 , 0 ) ) ) ;
    cell = new PdfPCell ( text ) ;
    cell.setBorderWidth ( 0.2f ) ;
    table.addCell ( cell ) ;
    
    HeaderFooter footer = new HeaderFooter ( new Phrase ( "This is page: " , new Font ( bfKorean , 15 , Font.UNDERLINE , new Color ( 0 , 0 , 0 ) ) ) , true ) ;
    footer.setBorder ( Rectangle.NO_BORDER ) ;
    footer.setAlignment ( Element.ALIGN_CENTER ) ;
    document.setFooter ( footer ) ;
     */
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