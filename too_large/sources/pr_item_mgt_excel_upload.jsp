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
	String TRANSACTION_ID  = JSPUtil.nullChk(request.getParameter("transaction_id"));
	Logger.debug.println(info.getSession("ID"), this, "########## TRANSACTION_ID : " + TRANSACTION_ID);
	
	String ITEM_NO         	  = "";
	String QTY      		  = "";
	String VENDOR_CODE 		  = "";
	String RD_DATE	    	  = "";
	String DELY_TO_ADDRESS_CD = "";
	
	
	int validationColCnt		= 0;
	int validationRowCnt		= 0;
	String validationRowString	= "";            																		
    
	for(int i = 1; i < row_count; i++){
		row = sheet.getRow(i);
		cells = row.getPhysicalNumberOfCells();
		
		cell  = row.getCell(cell_depth);
		ITEM_NO		       = getCellValue(cell);
		cell_depth++;
		
		cell  = row.getCell(cell_depth);
		QTY  		       = getCellValue(cell);
		cell_depth++;
	
		cell  = row.getCell(cell_depth);
		VENDOR_CODE		   = getCellValue(cell);
		cell_depth++;
		
		cell  = row.getCell(cell_depth);
		RD_DATE			   = getCellValue(cell);
		cell_depth++;

		cell  = row.getCell(cell_depth);
		DELY_TO_ADDRESS_CD = getCellValue(cell);
		cell_depth++;
		
		cell_depth = 0;
		
		Logger.debug.println(info.getSession("ID"), this, "########## ITEM_NO : " + ITEM_NO);
		Logger.debug.println(info.getSession("ID"), this, "########## QTY : " + QTY);
		Logger.debug.println(info.getSession("ID"), this, "########## VENDOR_CODE : " + VENDOR_CODE);
		Logger.debug.println(info.getSession("ID"), this, "########## RD_DATE : " + RD_DATE);
		Logger.debug.println(info.getSession("ID"), this, "########## DELY_TO_ADDRESS_CD : " + DELY_TO_ADDRESS_CD);
		
		String[] loop_data1 =
		{
    		 ITEM_NO        
    		,QTY
    		,VENDOR_CODE
    		,RD_DATE   
    		,DELY_TO_ADDRESS_CD       
		};
		
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
		  
		  SepoaOut value = ServiceConnector.doService(info, "p1003", "TRANSACTION", "setExcelUpload", obj);
		  
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
					parent.doSelect();
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
	Logger.debug.println(info.getSession("ID"), this, "Exception : " + e.getMessage());
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
