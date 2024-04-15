<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ page 
	import   = "java.io.*"
    import   = "java.util.*"
    import   = "java.net.URLEncoder"
    import   = "java.text.*"
    import   = "org.apache.poi.hssf.usermodel.*"
    import   = "org.apache.poi.hssf.util.*"            
%>

<%
	sepoa.fw.util.SepoaFormater sf = null;
	String [] header = null;
	StringBuffer exdsb = new StringBuffer();
	OutputStream excel_outStream = null;
	try {
		String headText   = request.getParameter("headText") == null  ? "" : request.getParameter("headText");//GRID 컬럼 Description
		String grid_obj   = request.getParameter("grid_obj") == null  ? "" : request.getParameter("grid_obj");//GRID객체명
		String gridColids = request.getParameter("gridColids") == null  ? "" : request.getParameter("gridColids");//GRID 컬럼명
		
		Logger.debug.println("headText = " + headText);
		Logger.debug.println("grid_obj = " + grid_obj);
		Logger.debug.println("gridColids = " + gridColids);
		
		/***Excel Setting***/
		//Set File Name
		String file_name= "GridData";
		response.reset(); 
		response.setContentType("application/x-msdownload; charset=UTF-8");
		response.setHeader("Content-Disposition","attachment; filename="+file_name+".xls");		//excel 파일명 뒤에 _; 이 붙는 이유?
		
		//Get POI Workbook Instance
		HSSFWorkbook workbook = new HSSFWorkbook();
		
		//Set WorkSheet Name
		HSSFSheet sheet = workbook.createSheet(file_name);		

		//Define Cell Style
		//Style-1
		HSSFCellStyle cellStyle = workbook.createCellStyle();	//헤더 스타일
		cellStyle = getBorderStyle(cellStyle, "ALL");		
		cellStyle.setFillBackgroundColor(HSSFColor.AQUA.index);
		cellStyle.setFillForegroundColor(HSSFColor.AQUA.index);				
		cellStyle.setFillPattern(HSSFCellStyle.BORDER_THIN);
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);		

		HSSFCellStyle cellStyle1 = workbook.createCellStyle();	//Grid 스타일
		cellStyle1 = getBorderStyle(cellStyle1, "ALL");		
		cellStyle1.setAlignment(HSSFCellStyle.ALIGN_CENTER);		
		
		java.util.Vector grid_col_vec = null;
		String grid_col_name = "";
		String grid_ex_data  = "";
		
		//Session에 담아둔 그리드 데이타 가져오기
		if(grid_obj != null && grid_obj.trim().length() > 0 ) {
			sf = (sepoa.fw.util.SepoaFormater)request.getSession().getValue(grid_obj+"excel_data");
		} else {
			sf = (sepoa.fw.util.SepoaFormater)request.getSession().getValue("excel_data");
		}
		
		headText = sf.changeNormalString( headText );
        gridColids = sf.changeNormalString( gridColids );
		Logger.debug.println("sf.toString()"+sf.toString());
		
		if(sf != null && sf.getRowCount() > 0) {
			header = sepoa.fw.util.SepoaString.StrToArray(headText, sepoa.fw.util.CommonUtil.getConfig("sepoa.separator.field"));
			grid_col_vec = sepoa.fw.util.SepoaString.StrToVector(gridColids, sepoa.fw.util.CommonUtil.getConfig("sepoa.separator.field"));
			
			for(int j=0; j < grid_col_vec.size(); j++) {
				grid_col_name = (String)grid_col_vec.elementAt(j);
			}
			
			//Header 그리기		
			for(int i=0; i < header.length; i++) {
				if(i == 0) {
					HSSFRow row_header = sheet.createRow((short)0);	
					
					for(int j=0; j < header.length; j++) {
						HSSFCell cell_header = null;
						cell_header = row_header.createCell((short)j);
						cell_header.setCellValue(header[j]);	
						cell_header.setCellStyle(cellStyle);			
						sheet.setColumnWidth((short)j,(short) (200 * 20));			
					}
				}
			}

			//상세내용뿌리기
			for(int k=0; k < sf.getRowCount(); k++)
			{
				HSSFRow rows = sheet.createRow(k + 1);	//???
				for(int j=0; j < grid_col_vec.size(); j++) {
					//HSSFRow rows = sheet.createRow(k + 1);
					
					grid_col_name = (String)grid_col_vec.elementAt(j);
					grid_ex_data  = sf.getValue(grid_col_name, k);
					
					HSSFCell d_cell = null;
					d_cell = rows.createCell((short) j);
					d_cell.setCellValue(grid_ex_data);		
					d_cell.setCellStyle(cellStyle1);			
				}
			}
		}

		//Write File
        //out.clear();
        //out=pageContext.pushBody();
		excel_outStream = response.getOutputStream(); 
		workbook.write(excel_outStream);
	}catch( Exception ex ){
		
		
		Logger.debug.println("Error : " + ex.getMessage()  +"=>"+ ex.getStackTrace());
	}
	finally {
		if(excel_outStream != null){
			excel_outStream.close();		
		}
	}	
%>

<%!
	//스타일시트 정의
	public HSSFCellStyle getBorderStyle(HSSFCellStyle cellStyle, String locale){	
		if(locale == null || "".equals(locale) || "ALL".equals(locale)){
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			cellStyle.setBottomBorderColor(HSSFColor.BLACK.index);
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			cellStyle.setLeftBorderColor(HSSFColor.GREEN.index);
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			//cellStyle.setRightBorderColor(HSSFColor.BLUE.index);
			cellStyle.setRightBorderColor(HSSFColor.BLACK.index);
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			cellStyle.setTopBorderColor(HSSFColor.BLACK.index);		
		}else if("TOP".equals(locale)){
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			cellStyle.setTopBorderColor(HSSFColor.BLACK.index);				
		}else if("LEFT".equals(locale)){
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			cellStyle.setLeftBorderColor(HSSFColor.GREEN.index);		
		}else if("RIGHT".equals(locale)){
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			cellStyle.setRightBorderColor(HSSFColor.BLUE.index);		
		}else if("BOTTOM".equals(locale)){
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			cellStyle.setBottomBorderColor(HSSFColor.BLACK.index);		
		}	
		return cellStyle;
	}
%>
<html>
<head></head>
<body>
<script>
close();
</script>
</body>
</html>