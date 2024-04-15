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
		fs = new POIFSFileSystem(excel_is);
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
	String DOC_NO          = JSPUtil.nullChk(request.getParameter("detail_doc_no"));
	


	Logger.debug.println("DOC_NO===="+DOC_NO);

	Logger.debug.println("DOC_NO===="+DOC_NO);

	Logger.debug.println("DOC_NO===="+DOC_NO);
	Logger.debug.println("DOC_NO===="+DOC_NO);

// 	String ITEM_SEQ        = "";
	
	String ITEM_NO         = "";
	String DESCRIPTION_LOC = "";
	String UNIT_MEASURE    = "";
	String ITEM_QTY        = "";
	String UNIT_PRICE      = "";
	String ITEM_AMT        = "";
	String ITEM_STATUS     = "";
	String ADD_DATE        = "";
	String ADD_TIME        = "";
	String ADD_USER_ID     = "";
	
	
	int validationColCnt		= 0;
	int validationRowCnt		= 0;
	String validationRowString	= "";            																		
          
	for(int i = 1; i < row_count; i++)
	{
		row = sheet.getRow(i);
		cells = row.getPhysicalNumberOfCells();
		
		cell  = row.getCell(cell_depth);
		ITEM_NO		= getCellValue(cell);
		cell_depth++;
		/*
		cell  = row.getCell(cell_depth);
		DESCRIPTION_LOC		= getCellValue(cell);
		cell_depth++;
		
		cell  = row.getCell(cell_depth);
		UNIT_MEASURE		= getCellValue(cell);
		cell_depth++;
		*/
		cell  = row.getCell(cell_depth);
		ITEM_QTY		= getCellValue(cell);
		cell_depth++;
		
		cell  = row.getCell(cell_depth);
		UNIT_PRICE		= getCellValue(cell);
		cell_depth++;
		/*
		cell  = row.getCell(cell_depth);
		ITEM_AMT		= getCellValue(cell);
		cell_depth++;
		
		cell  = row.getCell(cell_depth);
		ITEM_STATUS		= getCellValue(cell);
		cell_depth++;
		*/
		cell_depth = 0;
		
		Logger.debug.println("ITEM_NO=="+ITEM_NO);
		Logger.debug.println("ITEM_QTY=="+ITEM_QTY);
		Logger.debug.println("UNIT_PRICE=="+UNIT_PRICE);
		
		String[] loop_data1 =
		{
    		 ITEM_NO        
    		//,DESCRIPTION_LOC
    		//,UNIT_MEASURE   
    		,ITEM_QTY       
    		,UNIT_PRICE     
    		//,ITEM_AMT       
    		//,ITEM_STATUS    
		};
		
// 		if ((BLANKET_YEAR+BLANKET_PERIOD).equals(null) || (BLANKET_YEAR+BLANKET_PERIOD).trim().length() == 0 || (BLANKET_YEAR+BLANKET_PERIOD).trim().equals("")){
// 			validationRowString += i + "행의  " ;
// 			validationRowString += "결산년월의 값을 입력해 주세요.\\n\\n";
// 		}			

// 		if (MATERIAL_NUMBER.equals(null) || MATERIAL_NUMBER.trim().length() == 0 || MATERIAL_NUMBER.trim().equals("")){
// 			validationRowString += i + "행의  " ;
// 			validationRowString += "자재 ITEM_NO의 값을 입력해 주세요.\\n\\n";
// 			validationColCnt++;
// 		}
		
// 		if (CO_ACCEPT_FLAG.equals(null) || CO_ACCEPT_FLAG.trim().length() == 0 || CO_ACCEPT_FLAG.trim().equals("")){
// 			validationRowString += i + "행의  " ;
// 			validationRowString += "징구여부의 값을 입력해 주세요.\\n\\n";
// 			validationColCnt++;
// 		}
		
// 		if (COUNTRY_OF_ORIGIN.equals(null) || COUNTRY_OF_ORIGIN.trim().length() == 0 || COUNTRY_OF_ORIGIN.trim().equals("")){
// 			validationRowString += i + "행의  " ;
// 			validationRowString += "국가의 값을 입력해 주세요.\\n\\n";
// 			validationColCnt++;
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
		  Object[] obj = { setData, HOUSE_CODE, DOC_NO };
// 		  Object[] obj = { setData, HOUSE_CODE, DOC_NO, ITEM_SEQ };
		  
		  SepoaOut value = ServiceConnector.doService(info, "p1062", "TRANSACTION", "setExcelSavePurchaseLedgerInfo", obj);
		    
			if(value.flag)
			{
%>
				<script>
					parent.doUploadModalEnd();
					alert("<%=value.message%>");
					parent.doQuery(1);
				</script>
<%
			}
			else
			{
%>
				<script>
					parent.doUploadModalEnd();
					alert("<%=value.message%>");
				</script>
<%
		}
	}
}catch(Exception e){
	//e.printStackTrace();
	Logger.debug.println("Exception : " + e.getMessage());
	%>
	<script>
		alert("엑셀파일 오류입니다.");
		parent.doUploadModalEnd();
	</script>	
	<% 
	
}	finally {
		try { if(is != null){is.close();} } catch (Exception e){}
		try { if(excel_is != null){excel_is.close();} } catch (Exception e){}
}
%>	
