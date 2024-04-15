<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<% String WISEHUB_PROCESS_ID="MA_005";%>

<%
	String user_id          		= info.getSession("ID");
	String user_name_loc    		= info.getSession("NAME_LOC");
	String user_name_eng    		= info.getSession("NAME_ENG");
	String user_dept        		= info.getSession("DEPARTMENT");
	String company_code     		= info.getSession("COMPANY_CODE");
	String house_code       		= info.getSession("HOUSE_CODE");
	 
	String HOUSE_CODE			= house_code;
	String ITEM_NO				= JSPUtil.nullToEmpty(request.getParameter("item_no")			  );
	String REQ_ITEM_NO			= JSPUtil.nullToEmpty(request.getParameter("req_item_no")			  );
	String OLD_ITEM_NO			= JSPUtil.nullToEmpty(request.getParameter("old_item_no")			  );
	String DESCRIPTION_LOC		= JSPUtil.nullToEmpty(request.getParameter("description_loc")			  );
	String MAKER_FLAG        	= JSPUtil.nullToEmpty(request.getParameter("maker_flag")		  );
	String MAKER_CODE   		= JSPUtil.nullToEmpty(request.getParameter("maker_code")  );
	String MAKER_NAME           = JSPUtil.nullToEmpty(request.getParameter("maker_name")          );
	String MAKER_ITEM_NO		= JSPUtil.nullToEmpty(request.getParameter("maker_item_no")           );
	String ATTACH_COUNT			= JSPUtil.nullToEmpty(request.getParameter("attach_count")               );
	String Z_ITEM_DESC			= JSPUtil.nullToEmpty(request.getParameter("z_item_desc")               );
	String REMARK				= JSPUtil.nullToEmpty(request.getParameter("remark")               );
	String ATTACH_NO			= JSPUtil.nullToEmpty(request.getParameter("attach_no")               );
	
	/* 추가 항목 */
	String MTART				= JSPUtil.nullToEmpty(request.getParameter("mtart")               );
	String MATKL				= JSPUtil.nullToEmpty(request.getParameter("matkl")               );
	String ITEM_GROUP			= JSPUtil.nullToEmpty(request.getParameter("item_group")               );
	String TAXKM				= JSPUtil.nullToEmpty(request.getParameter("taxkm")               );
	String BKLAS				= JSPUtil.nullToEmpty(request.getParameter("bklas")               );
	String KTGRM				= JSPUtil.nullToEmpty(request.getParameter("ktgrm")               );

	String MATERIAL_TYPE		= JSPUtil.nullToEmpty(request.getParameter("material_type")           );
	String MATERIAL_CTRL_TYPE	= JSPUtil.nullToEmpty(request.getParameter("material_ctrl_type")           );
	String MATERIAL_CLASS1		= JSPUtil.nullToEmpty(request.getParameter("material_class1")           );
	String MATERIAL_CLASS2		= JSPUtil.nullToEmpty(request.getParameter("material_class2")         ); 
	String ITEM_ABBREVIATION	= JSPUtil.nullToEmpty(request.getParameter("item_abbreviation")            );
	String BASIC_UNIT			= JSPUtil.nullToEmpty(request.getParameter("basic_unit")               );
	String SPECIFICATION		= JSPUtil.nullToEmpty(request.getParameter("specification")             );
	String APP_TAX_CODE			= JSPUtil.nullToEmpty(request.getParameter("taxkm")          			);
	String ITEM_BLOCK_FLAG		= JSPUtil.nullToEmpty(request.getParameter("item_block_flag")          );
	String USEDFLAG     		= JSPUtil.nullToEmpty(request.getParameter("usedflag")          );
	String MODEL_FLAG           = JSPUtil.nullToEmpty(request.getParameter("model_flag")          );
	String MODEL_NO				= JSPUtil.nullToEmpty(request.getParameter("model_no")             );
	String REQ_USER_ID			= JSPUtil.nullToEmpty(request.getParameter("req_user_id")                 );
	String ADD_USER_ID        	= JSPUtil.nullToEmpty(request.getParameter("add_user_id")       );
	String ADD_USER_NAME_LOC	= JSPUtil.nullToEmpty(request.getParameter("add_user_name_loc")       );
	String CHANGE_USER_ID		= JSPUtil.nullToEmpty(request.getParameter("change_user_id")               );
	String CHANGE_USER_NAME_LOC	= JSPUtil.nullToEmpty(request.getParameter("change_user_name_loc")             );
	String MAKE_AMT_CODE    	= JSPUtil.nullToEmpty(request.getParameter("make_amt_code")             );
	
	String WID = JSPUtil.nullToEmpty(request.getParameter("WID")             );
	String HGT= JSPUtil.nullToEmpty(request.getParameter("HGT")             );
	
	

	if (USEDFLAG.equals("") || USEDFLAG == null){
		USEDFLAG = "N";
	}
		String HeaderData[][] = new String[1][];
        String Data[]         = { 
        						 DESCRIPTION_LOC      
								 ,MAKER_NAME          
								 ,MAKER_CODE      
						         ,MODEL_NO
								 ,MATERIAL_TYPE       
								 ,MATERIAL_CTRL_TYPE
								 ,MATERIAL_CLASS1
								 ,MATERIAL_CLASS2
								 ,BASIC_UNIT
								 ,SPECIFICATION
							     ,APP_TAX_CODE
							     ,Z_ITEM_DESC							     
							     ,USEDFLAG 
							     ,MAKER_FLAG
							     ,MODEL_FLAG 
							     ,ITEM_ABBREVIATION  
							     ,MTART
							     ,MATKL
							     ,ITEM_GROUP
							     ,TAXKM
							     ,KTGRM
							     ,MAKE_AMT_CODE
							     ,WID
							     ,HGT
							    };

        HeaderData[0]   = Data;


        Object[] obj = {OLD_ITEM_NO,  ITEM_NO, REMARK, ATTACH_NO, HeaderData };
        SepoaOut value = ServiceConnector.doService(info, "t0002", "TRANSACTION", "confirm_getUpdate", obj);
 %>

<html>
<head>
<title>우리은행 전자구매시스템</title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<Script language="javascript">

function Init()
{
	parent.doSave("<%=value.message%>", "<%=value.status%>");
}

</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
