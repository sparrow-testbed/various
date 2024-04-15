<%
/**
 * @파일명   : 4m_mgt_hidden.jsp
 * @생성일자 : 2009. 04. 24
 * @변경이력 :
 * @프로그램 설명 : 변경점사전신고서 등록 > 조회,저장,전송,삭제,접수,반려 버튼에 대한 히든 처리
 */
%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/include_css.jsp"%>

<%
	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
	String user_type = info.getSession("USER_TYPE");
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>

<!-- META TAG 정의  -->


<%

	String mode = request.getParameter("mode");    

	String cp_number		= "";
	String material_number	= "";
	String cp_flag			= "";
	String seller_code		= "";
	String seller_name		= "";
	String cp_type			= "";
	String cp_type_name		= "";
	String description_loc	= "";
	String model			= "";
	String subject			= "";
	String cp_status		= "";
	String cp_status_name	= "";
	String ctrl_code		= "";
	String ctrl_name		= "";
	String attach_no		= "";
	String attach_count		= "";
	String app_date			= "";//승인일자
	String add_user_name	= "";
	String add_date			= "";//등록일
	String attach_no2		= "";
	String attach_count2	= "";
	String remark			= "";
	String cp_result		= "";
	String cp_result_hidden	= "";
	
	SepoaFormater sf = null;
	SepoaOut value = null;
	try {
		//조회
		if( mode.equals("query") )
		{
			cp_number = request.getParameter("cp_number"); 
			cp_status = request.getParameter("cp_status"); 
			
			Object[] obj = {cp_number,cp_status};
			
			value = ServiceConnector.doService(info, "QM_006", "CONNECTION","get4mQuery", obj);
			sf = new SepoaFormater(value.result[0]);
			
			if( sf.getRowCount() == 1 )
			{
				cp_number = sf.getValue("CP_NUMBER",0);         
				material_number = sf.getValue("material_number",0);        
				cp_flag = sf.getValue("cp_flag",0);                       
				seller_code = sf.getValue("seller_code",0);                      
				seller_name = sf.getValue("seller_name",0);   
				Logger.debug.println(sf.getValue("subject",0));                 
				subject = SepoaString.replace(sf.getValue("subject",0),"\n","<br>");   
				Logger.debug.println("subject==="+subject);                    
				attach_no = sf.getValue("attach_no",0);                       
				attach_count = sf.getValue("attach_count",0);                       
				cp_type = sf.getValue("cp_type",0);                       
				cp_type_name = sf.getValue("cp_type_name",0);                         
				description_loc = sf.getValue("description_loc",0);       
				model = sf.getValue("model",0);                         
				cp_status = sf.getValue("cp_status",0);                      
				cp_status_name = sf.getValue("cp_status_name",0);                 
	     			
				ctrl_code = sf.getValue("ctrl_code",0);
				ctrl_name = sf.getValue("ctrl_name",0);
				attach_no = sf.getValue("attach_no",0);
				app_date = sf.getValue("app_date",0);
				attach_no2 = sf.getValue("attach_no2",0);                   
				attach_count2 = sf.getValue("attach_count2",0); 
				remark = sf.getValue("remark",0);;
				add_date = sf.getValue("add_date",0);
				add_user_name = sf.getValue("add_user_name",0);
				cp_result = sf.getValue("cp_result",0);
				cp_result_hidden = sf.getValue("cp_result_hidden",0);
			}
		}
		//저장,전송
		if( mode.equals("save") || mode.equals("send") )
		{

			cp_number = request.getParameter("cp_number");	                    
			material_number = request.getParameter("material_number");         
			cp_flag = request.getParameter("cp_flag");                         
			seller_code = request.getParameter("seller_code");                 
			cp_type = request.getParameter("cp_type");                         
			description_loc = request.getParameter("description_loc");         
			model = request.getParameter("model");                             
			subject = request.getParameter("subject");                         
			cp_status = request.getParameter("cp_status_hidden");   
			
			Logger.debug.println("cp_status==="+cp_status); 
			Logger.debug.println("cp_flag==="+cp_flag);                  
			
			if( cp_status.equals("C") )//검토중에서 저장하면 검토완료로 상태변경
      		{
      			cp_status = "E";
      		}
      		else{
			
				if( cp_flag.equals("N") )//업체에서 저장시
	      			cp_status = "A";//진행상태는 등록
	      		else if( cp_flag.equals("P") )//업체에서 전송시
	      			cp_status = "B";//진행상태는 접수대기
      			
      		}
      			
	      			
			ctrl_code = request.getParameter("ctrl_code");
			attach_no = request.getParameter("attach_no");
			attach_count = request.getParameter("attach_count");
			cp_result = request.getParameter("cp_result");
			app_date = request.getParameter("app_date");
			attach_no2 = request.getParameter("attach_no2");
			remark = request.getParameter("remark");
			
			String[] args = {seller_code
							,material_number
							,cp_type
							,description_loc
							,model
							,subject
							,cp_status
							,ctrl_code
							,attach_no
							,cp_result
							,app_date
							,attach_no2
							,remark
							,cp_flag
			};
			Object[] obj = {cp_number,args};
			
			value = ServiceConnector.doService(info, "QM_006", "CONNECTION","set4mSave", obj);
		}

		//삭제
		if( mode.equals("delete") )
		{

			cp_number = request.getParameter("cp_number");
				 
			
			String[] args = {cp_number
			};
			Object[] obj = {cp_number};
			
			value = ServiceConnector.doService(info, "QM_006", "CONNECTION","set4mDelete", obj);
		}
		
		//접수
		if( mode.equals("receipt") )
		{

			cp_number = request.getParameter("cp_number");
			seller_code = request.getParameter("seller_code");
			cp_status = "C";//진행상태는 검토중                
				 
			Object[] obj = {seller_code, cp_number,cp_status};
			
			value = ServiceConnector.doService(info, "QM_006", "CONNECTION","set4mReceipt", obj);
		}
		//반려
		if( mode.equals("reject") )
		{

			seller_code = request.getParameter("seller_code");
			cp_number = request.getParameter("cp_number");
			cp_status = "D";//진행상태는 반려                
				 
			
			String[] args = {cp_number
							,cp_status
			};
			
			Object[] obj = {seller_code,cp_number,cp_status};
			
			value = ServiceConnector.doService(info, "QM_006", "CONNECTION","set4mReceipt", obj);
		}
						
		if( mode.equals("material") )
		{
			material_number = request.getParameter("material_number");
			Object[] obj = {material_number};
			
			value = ServiceConnector.doService(info, "QM_006", "CONNECTION","MtDesc", obj);
			sf = new SepoaFormater(value.result[0]);
			
			if( sf.getRowCount() > 0 ) 
				description_loc = SepoaString.replace(SepoaString.replace(SepoaString.replace(sf.getValue(0,0), "\r", ""), "\n", ""), "\"", "\\\"");
			
		}
		
		

	} catch (Exception e) {
		Logger.debug.println(e.toString());

	}



%>

<Script language="javascript">
	var status = "<%=value.status%>";

	function Init() {
	   if(status == '0') {
	    	alert("Error");
	    } 
	    else 
	    {
	    	<%
	    	if( mode.equals("query") && sf.getRowCount() == 1  )
	    	{
	    	%>	
	    		    		
	    		parent.document.forms[0].cp_number.value = "<%=cp_number%>";
				parent.document.forms[0].material_number.value = "<%=material_number%>";
				parent.document.forms[0].description_loc.value = "<%=description_loc%>";
				parent.document.forms[0].seller_code.value = "<%=seller_code%>";
				parent.document.forms[0].seller_name.value = "<%=seller_name%>";
				parent.document.forms[0].model.value = "<%=model%>";
				parent.document.forms[0].attach_no.value = "<%=attach_no%>";
				parent.document.forms[0].attach_count.value = "<%=attach_count%>";
				parent.document.forms[0].attach_no2.value = "<%=attach_no2%>";
				parent.document.forms[0].attach_count2.value = "<%=attach_count2%>";
				parent.document.forms[0].ctrl_code.value = "<%=subject%>";
				parent.document.forms[0].ctrl_code.value = "<%=ctrl_code%>";
				parent.document.forms[0].ctrl_name.value = "<%=ctrl_name%>";
				parent.document.forms[0].add_date.value = "<%=SepoaString.getDateSlashFormat(add_date)%>";
				parent.document.forms[0].add_user_name.value = "<%=add_user_name%>";				
				parent.document.forms[0].cp_result.value = "<%=cp_result%>";
				parent.document.forms[0].cp_result_hidden.value = "<%=cp_result%>";
				parent.document.forms[0].cp_type.value = "<%=cp_type%>";
				parent.document.forms[0].cp_status.value = "<%=cp_status%>";
				parent.document.forms[0].cp_status_hidden.value = "<%=cp_status%>";
				parent.document.forms[0].app_date.value = "<%=app_date%>";
				
			<%	
	    	}
	    	else if( mode.equals("query") && sf.getRowCount() == 0  )
	    	{
	    	%>
				alert("조회된 내역이 없습니다.");
				parent.document.forms[0].cp_number.value = "<%=cp_number%>";
				parent.document.forms[0].material_number.value = "<%=material_number%>";
				parent.document.forms[0].description_loc.value = "<%=description_loc%>";
				
				if( "<%=user_type%>" != "S" )
				{
					parent.document.forms[0].seller_code.value = "<%=seller_code%>";
					parent.document.forms[0].seller_name.value = "<%=seller_name%>";
				}
				
				parent.document.forms[0].model.value = "<%=model%>";
				parent.document.forms[0].attach_no.value = "<%=attach_no%>";
				parent.document.forms[0].attach_count.value = "<%=attach_count%>";
				parent.document.forms[0].attach_no2.value = "<%=attach_no2%>";
				parent.document.forms[0].attach_count2.value = "<%=attach_count2%>";
				parent.document.forms[0].subject.value = "<%=subject%>";
				parent.document.forms[0].ctrl_code.value = "<%=ctrl_code%>";
				parent.document.forms[0].ctrl_name.value = "<%=ctrl_name%>";
				parent.document.forms[0].add_date.value = "<%=SepoaString.getDateSlashFormat(add_date)%>";
				parent.document.forms[0].add_user_name.value = "<%=add_user_name%>";
				
				parent.document.forms[0].cp_result.value = "<%=cp_result%>";
				parent.document.forms[0].cp_result_hidden.value = "<%=cp_result%>";
				parent.document.forms[0].cp_type.value = "<%=cp_type%>";
				parent.document.forms[0].cp_status.value = "<%=cp_status%>";
				parent.document.forms[0].cp_status_hidden.value = "<%=cp_status%>";
				parent.document.forms[0].app_date.value = "<%=app_date%>";
	     	<%	
	    	}
	    	else if( mode.equals("save") )
	    	{
	    	%>
				alert("저장되었습니다.");				
				parent.document.forms[0].cp_number.value = "<%=value.result[0]%>";				
				parent.document.forms[0].cp_status.value = "<%=cp_status%>";
				parent.doQuery();
	     	<%	
	    	}
	    	
	    	else if( mode.equals("send") )
	    	{
	    	%>
				alert("전송되었습니다.");
				parent.document.forms[0].cp_number.value = "<%=value.result[0]%>";			
				parent.document.forms[0].cp_status.value = "<%=cp_status%>";
				parent.doQuery();
	     	<%	
	    	}
	    	else if( mode.equals("delete") )
	    	{
	    	%>
				alert("삭제되었습니다.");
				parent.close();
				parent.opener.doQuery();
	     	<%	
	    	}
	    	else if( mode.equals("receipt") )
	    	{
	    	%>
				alert("접수되었습니다.");	
				parent.document.forms[0].cp_status.value = "<%=cp_status%>";
				parent.doQuery();
	     	<%	
	    	}

	    	else if( mode.equals("reject") )
	    	{
	    	%>
				alert("반려되었습니다.");
				parent.document.forms[0].cp_status.value = "<%=cp_status%>";
				parent.doQuery();
	     	<%	
	    	}
	    		    		    	
	    	else if( mode.equals("material") )
	    	{
	    	%>	
	    		parent.document.forms[0].description_loc.value = "<%=description_loc%>";
	            	
			<%
	    	}
	    	%>
	    }
	}


</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>