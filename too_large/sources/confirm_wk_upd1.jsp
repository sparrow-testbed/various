 
<% String WISEHUB_PROCESS_ID="t0002";%>
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	String user_id          		= info.getSession("ID");
	String user_name_loc    		= info.getSession("NAME_LOC");
	String user_name_eng    		= info.getSession("NAME_ENG");
	String user_dept        		= info.getSession("DEPARTMENT");
	String company_code     		= info.getSession("COMPANY_CODE");
	String house_code       		= info.getSession("HOUSE_CODE");
	 
	String HOUSE_CODE			= house_code;
	String ITEM_NO				= "";
	String REQ_ITEM_NO			= JSPUtil.nullToEmpty(request.getParameter("REQ_ITEM_NO")			  );
	String OLD_ITEM_NO			= JSPUtil.nullToEmpty(request.getParameter("OLD_ITEM_NO")			  );
	String DESCRIPTION_LOC		= JSPUtil.nullToEmpty(request.getParameter("DESCRIPTION_LOC")			  );
	String MAKER_FLAG        	= JSPUtil.nullToEmpty(request.getParameter("MAKER_FLAG")		  );
	String MAKER_CODE   		= JSPUtil.nullToEmpty(request.getParameter("MAKER_CODE")  );
	String MAKER_NAME           = JSPUtil.nullToEmpty(request.getParameter("MAKER_NAME")          );
	String MAKER_ITEM_NO		= JSPUtil.nullToEmpty(request.getParameter("MAKER_ITEM_NO")           );
	String ATTACH_COUNT			= JSPUtil.nullToEmpty(request.getParameter("ATTACH_COUNT")               );
	String Z_ITEM_DESC			= JSPUtil.nullToEmpty(request.getParameter("Z_ITEM_DESC")               );
	String REMARK				= JSPUtil.nullToEmpty(request.getParameter("REMARK")               );
	
	/* ÃÂÃÂÃÂ°ÃÂ¡ ÃÂÃÂÃÂ¸ÃÂ± */
	String MTART				= JSPUtil.nullToEmpty(request.getParameter("MTART")               );
	String MATKL				= JSPUtil.nullToEmpty(request.getParameter("MATKL")               );
	String ITEM_GROUP			= JSPUtil.nullToEmpty(request.getParameter("ITEM_GROUP")               );
	String TAXKM				= JSPUtil.nullToEmpty(request.getParameter("TAXKM")               );
	String BKLAS				= JSPUtil.nullToEmpty(request.getParameter("BKLAS")               );
	String KTGRM				= JSPUtil.nullToEmpty(request.getParameter("KTGRM")               );

	String MATERIAL_TYPE		= JSPUtil.nullToEmpty(request.getParameter("MATERIAL_TYPE")           );
	String MATERIAL_CTRL_TYPE	= JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CTRL_TYPE")           );
	String MATERIAL_CLASS1		= JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CLASS1")           );
	String MATERIAL_CLASS2		= JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CLASS2")         ); 
	String ITEM_ABBREVIATION	= JSPUtil.nullToEmpty(request.getParameter("ITEM_ABBREVIATION")            );
	String BASIC_UNIT			= JSPUtil.nullToEmpty(request.getParameter("BASIC_UNIT")               );	
	String SPECIFICATION		= JSPUtil.nullToEmpty(request.getParameter("SPECIFICATION")               );	
	String APP_TAX_CODE			= JSPUtil.nullToEmpty(request.getParameter("TAXKM")          );
	String ITEM_BLOCK_FLAG		= JSPUtil.nullToEmpty(request.getParameter("ITEM_BLOCK_FLAG")          );
	String MODEL_FLAG           = JSPUtil.nullToEmpty(request.getParameter("MODEL_FLAG")          ); 
	String REQ_USER_ID			= JSPUtil.nullToEmpty(request.getParameter("REQ_USER_ID")                 );
	String ADD_USER_ID        	= JSPUtil.nullToEmpty(request.getParameter("ADD_USER_ID")       );
	String ADD_USER_NAME_LOC	= JSPUtil.nullToEmpty(request.getParameter("ADD_USER_NAME_LOC")       );
	String CHANGE_USER_ID		= JSPUtil.nullToEmpty(request.getParameter("CHANGE_USER_ID")               );
	String CHANGE_USER_NAME_LOC	= JSPUtil.nullToEmpty(request.getParameter("CHANGE_USER_NAME_LOC")             );
	String isCheckedSameItemName	= JSPUtil.nullToEmpty(request.getParameter("isCheckedSameItemName")             );
	String ATTACH_NO                = JSPUtil.nullToEmpty(request.getParameter("ATTACH_NO")			);
	String MAKE_AMT_CODE    	= JSPUtil.nullToEmpty(request.getParameter("MAKE_AMT_CODE")             );
	
	String WID    = JSPUtil.nullToEmpty(request.getParameter("WID"));
	String HGT   = JSPUtil.nullToEmpty(request.getParameter("HGT"));
	
	if(MAKER_FLAG.equals("Y"))  MAKER_CODE = "380";
	                 
		String HeaderData[][] = new String[1][];
        String Data[]    = { 		   
                             DESCRIPTION_LOC                                                      
                            ,MATERIAL_TYPE       	                                           
                            ,MATERIAL_CTRL_TYPE                                                       
                            ,MATERIAL_CLASS1                                                          
                            ,MATERIAL_CLASS2                                               
                                                                                           
                            ,BASIC_UNIT                                                    
                            ,SPECIFICATION			                                           
                            ,Z_ITEM_DESC                                                      
                            ,ITEM_ABBREVIATION                                                            
                            ,""                                                      
                            ,ITEM_GROUP       		                                        
                                                                                           
                            ,""                                                          
                            ,REMARK       			                                           
			                ,MAKER_CODE   
			                ,MAKER_NAME    	                                                  
			                ,APP_TAX_CODE 		                                                       
			                ,"" 		                                        
			                                                                               
			                ,""                                                            
			                ,""
			                ,MTART
			                ,MATKL
			                ,TAXKM
			                ,BKLAS
			                ,KTGRM
			                ,ATTACH_NO
			                ,MAKE_AMT_CODE
			                ,WID
			                ,HGT
							    };                                                         
        
        HeaderData[0]   = Data; 
	        
         
  		SepoaOut 		value = null;
  		SepoaOut 		value_checkItem = null;
  		SepoaFormater 	wf_checkItem = null; 
  		
  		// ÃÂ°ÃÂ°ÃÂÃÂº ÃÂÃÂÃÂ¸ÃÂ§ ÃÂÃÂ°ÃÂ¸ÃÂ± ÃÂÃÂ¼ÃÂÃÂ©
  		if("N".equals(isCheckedSameItemName)){
  			Object[] obj = {  DESCRIPTION_LOC};
  			value_checkItem = ServiceConnector.doService(info, "t0002", "TRANSACTION","isCheckedSameItemName", obj);
  			wf_checkItem= new SepoaFormater(value_checkItem.result[0]);
  		}
  		
  		// ÃÂ½ÃÂÃÂÃÂ
  		if("Y".equals(isCheckedSameItemName) || wf_checkItem.getRowCount() == 0 ){ // ÃÂ°ÃÂ°ÃÂÃÂº ÃÂÃÂ°ÃÂ¸ÃÂ±ÃÂ¸ÃÂ­ÃÂÃÂ ÃÂ¾ÃÂ¸ÃÂ°ÃÂÃÂ³ÃÂª, ÃÂ°ÃÂ°ÃÂÃÂº ÃÂÃÂ°ÃÂ¸ÃÂ±ÃÂ¸ÃÂ­ÃÂÃÂ ÃÂÃÂÃÂ¾ÃÂ®ÃÂµÃÂµ ÃÂ½ÃÂÃÂÃÂÃÂÃÂÃÂ°ÃÂÃÂ´ÃÂÃÂ°ÃÂ­ ÃÂÃÂÃÂÃÂ»ÃÂ¾ÃÂ¾
  			Object[] obj = {  REQ_ITEM_NO, MATERIAL_TYPE, HeaderData};
  			value = ServiceConnector.doService(info, "t0002", "TRANSACTION","real_setInsert", obj);
  		}
%>


<html>
<head>
<title>ì°ë¦¬ìí ì ìêµ¬ë§¤ìì¤í</title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<Script language="javascript">

function Init(){
<%
	if("N".equals(isCheckedSameItemName) && wf_checkItem.getRowCount() > 0){
		String itemNo         = wf_checkItem.getValue("ITEM_NO", 0);
		String descriptionLoc = wf_checkItem.getValue("DESCRIPTION_LOC", 0);
		int    rowCount       = wf_checkItem.getRowCount();
%>	
	parent.AfterCheckedSameItem("<%=itemNo%>", "<%=descriptionLoc %>", <%=rowCount%>);
<%
	}
	else{
%>	
	parent.doSave("<%=value.message%>", "<%=value.status%>");
<%
	}	
%>
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
