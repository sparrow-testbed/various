<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp" %>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>



<%!

	public String getCellValue(HSSFCell cell) throws Exception
	{
		String result_value = "";
		BigDecimal num_dec = null;
		
		if(cell != null) {
			switch (cell.getCellType()) {
				case HSSFCell.CELL_TYPE_FORMULA :
            	    result_value = cell.getCellFormula();
                    break;
                case HSSFCell.CELL_TYPE_NUMERIC :
                	num_dec = new BigDecimal(cell.getNumericCellValue());
                    result_value = num_dec.toString();
                    break;
                case HSSFCell.CELL_TYPE_STRING :	
                    result_value = cell.getStringCellValue();
                    break;
                case HSSFCell.CELL_TYPE_BLANK :
                    result_value = "";
                    break;
                case HSSFCell.CELL_TYPE_BOOLEAN :
                    result_value = cell.getBooleanCellValue()+"";
                    break;
                case HSSFCell.CELL_TYPE_ERROR :
                    result_value = cell.getErrorCellValue()+"";
                    break;
                default :
			}
		}
		
		return result_value;
	}
%>

<%

InputStream is = null;
InputStream excel_is = null;
try{
	RequestWrapper xls_rw = new RequestWrapper(request);
	FileItem excel_item   = xls_rw.getFileItem("uploadFile");	
	POIFSFileSystem fs    = null;
	try {
		is = SepoaDrmUtils.getFileItemDecInputStream(excel_item);
		fs = new POIFSFileSystem(is);
	} catch (Exception ex) {
		excel_is = excel_item.getInputStream();
		fs = new POIFSFileSystem(excel_item.getInputStream());
	}
	
	HSSFWorkbook workbook = new HSSFWorkbook(fs);
	HSSFSheet sheet       = workbook.getSheetAt(0);
	HSSFRow row = null;
	HSSFCell cell = null;
	int cells   = 0;
	int depth = 0;
	short cell_depth = 0;
	int row_count = sheet.getPhysicalNumberOfRows();
	String[][] setData = new String[row_count-1][];
	
	
	String HOUSE_CODE      = info.getSession("HOUSE_CODE");
	String TRANSACTION_ID          = JSPUtil.nullChk(request.getParameter("transaction_id"));
	Logger.debug.println("TRANSACTION_ID=="+TRANSACTION_ID);
	
	String ITEM_NO         	= "";
	String VENDOR_CODE 		= "";
	String BASIC_UNIT    	= "";
	String VALID_FROM_DATE  = "";
	String VALID_TO_DATE    = "";
	String UNIT_PRICE       = "";
	String REMARK     		= "";
	String ADD_DATE        	= "";
	String ADD_TIME        	= "";
	String ADD_USER_ID     	= "";
	
	
	int validationColCnt		= 0;
	int validationRowCnt		= 0;
	String validationRowString	= "";            																		
    
	for(int i = 1; i < row_count; i++){
		row = sheet.getRow(i);
		cells = row.getPhysicalNumberOfCells();
		
		cell  = row.getCell(cell_depth);
		ITEM_NO		= getCellValue(cell);
		cell_depth++;
	
		cell  = row.getCell(cell_depth);
		VENDOR_CODE		= getCellValue(cell);
		cell_depth++;
		
		cell  = row.getCell(cell_depth);
		BASIC_UNIT		= getCellValue(cell);
		cell_depth++;

		cell  = row.getCell(cell_depth);
		VALID_FROM_DATE		= getCellValue(cell);
		cell_depth++;
		
		cell  = row.getCell(cell_depth);
		VALID_TO_DATE		= getCellValue(cell);
		cell_depth++;
		
		cell  = row.getCell(cell_depth);
		UNIT_PRICE		= getCellValue(cell);
		cell_depth++;
		
		cell_depth = 0;
		
		Logger.debug.println("ITEM_NO=="+ITEM_NO);
		Logger.debug.println("VENDOR_CODE=="+VENDOR_CODE);
		Logger.debug.println("BASIC_UNIT=="+BASIC_UNIT);
		Logger.debug.println("VALID_FROM_DATE=="+VALID_FROM_DATE);
		Logger.debug.println("VALID_TO_DATE=="+VALID_TO_DATE);
		Logger.debug.println("UNIT_PRICE=="+UNIT_PRICE);
		
		String[] loop_data1 =
		{
    		 ITEM_NO        
    		,VENDOR_CODE
    		,BASIC_UNIT   
    		,VALID_FROM_DATE       
    		,VALID_TO_DATE     
    		,UNIT_PRICE       
		};
		
// 		if ((BLANKET_YEAR+BLANKET_PERIOD).equals(null) || (BLANKET_YEAR+BLANKET_PERIOD).trim().length() == 0 || (BLANKET_YEAR+BLANKET_PERIOD).trim().equals("")){
// 			validationRowString += i + "행의  " ;
// 			validationRowString += "결산년월의 값을 입력해 주세요.\\n\\n";
// 		}			

		setData[depth] = loop_data1;
    	depth++;
  }

    if (validationColCnt > 0){//validation Error
%>
		<script>
			parent.doUploadModalEnd();
			alert("--엑셀파일의 필수 입력값을 입력해 주세요--\n\n<%=validationRowString%>");
		</script>
<%
	}	 
	else 
	{ 
		  Object[] obj = { setData, TRANSACTION_ID };
		  
		  SepoaOut value = ServiceConnector.doService(info, "p2004", "TRANSACTION", "setExcelSaveInfo2ItemMgt", obj);
		  
		  String msg = value.message;
		  if(msg != null) {
			  msg = msg.replaceAll("\n", "<br>");
		  }
		    
			if(value.flag)
			{
%>
				<script>
					parent.doUploadModalEnd();
					//alert("<%=msg %>");
					parent.doQuery(1);
				</script>
<%
			}
			else
			{
%>
				<script>
					parent.doUploadModalEnd();
					alert("<%=msg%>");
				</script>
<%
		}
	}
}catch(Exception e){
	//e.printStackTrace();
	Logger.debug.println("Exception : " + e.getMessage());
	%>
	<script>
		//alert("엑셀파일 오류입니다.");
		alert("<%=e.getMessage()%>")
		parent.doUploadModalEnd();
	</script>	
	<% 
	
}	finally {
		try { if(is != null){is.close();} } catch (Exception e){}
		try { if(excel_is != null){excel_is.close();} } catch (Exception e){}
}
%>	
