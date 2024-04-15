<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_008");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_008";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%

	String mode = JSPUtil.CheckInjection(request.getParameter("mode"))==null?"":JSPUtil.CheckInjection(request.getParameter("mode"));
	
	if(!mode.equals("")) {
		
		String[] itemName = request.getParameterValues("itemName");
		String[] itemScore = request.getParameterValues("itemScore");
		String ScreeningItemName = JSPUtil.CheckInjection(request.getParameter("ScreeningItemName"))==null?"":JSPUtil.CheckInjection(request.getParameter("ScreeningItemName"));
		String recommendNum = JSPUtil.CheckInjection(request.getParameter("recommendNum"))==null?"0":JSPUtil.CheckInjection(request.getParameter("recommendNum"));
		String scale = JSPUtil.CheckInjection(request.getParameter("scale"))==null?"0":JSPUtil.CheckInjection(request.getParameter("scale"));
		String s_factor_refitem = JSPUtil.CheckInjection(request.getParameter("s_factor_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("s_factor_refitem"));
		int scaleCnt = Integer.parseInt(scale);
		
		String[][] param1 = null;			
		String[][] param2 = null;			
		String param3 = null;
		
		String nickName= "SR_008";
		String conType = "TRANSACTION";
		
		String MethodName = "";
		Object[] obj = null;
		
		if(mode.trim().equals("update")) {	
			
			param1 = new String[1][1];		
			param2 = new String[scaleCnt][3];	
			
			param1[0][0] = ScreeningItemName;	
			//param1[0][1] = recommendNum;	선택항목 설정 사용안함 (2012-06-05)		 
			
			for(int i=0; i < scaleCnt; i++) {
				param2[i][0] = itemName[i];	
				param2[i][1] = itemScore[i];
				param2[i][2] = String.valueOf(i+1);	
			}
			param3 = s_factor_refitem;
			
			MethodName = "setScrUpdate";
			obj = new Object[3];
			obj[0] = param1;
			obj[1] = param2;
			obj[2] = param3;
			
		}else if(mode.trim().equals("delete")) {
			
			MethodName = "setScrDelete";
			obj = new Object[1];
			obj[0] = s_factor_refitem;
			
		}else if(mode.trim().equals("insert")) {	
			
			param1 = new String[1][2];
			param2 = new String[scaleCnt][3];	
			
			param1[0][0] = ScreeningItemName;	
			param1[0][1] = scale;			
		//	param1[0][2] = recommendNum;	선택항목 설정 사용안함 (2012-06-05)	
			
			for(int i=0; i < scaleCnt; i++) {
				param2[i][0] = itemName[i];	
				param2[i][1] = itemScore[i];
				param2[i][2] = String.valueOf(i+1);	
			}
			
			MethodName = "setScrInsert";
			obj = new Object[2];
			obj[0] = param1;
			obj[1] = param2;
		}
		
		SepoaOut value = null; 
		SepoaRemote ws = null;
		
		try {
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
		}catch(SepoaServiceException wse) {
			Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
			Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
		}catch(Exception e) {
		    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		    
		}finally{
			try{
				ws.Release();
			}catch(Exception e){}
		}
%>
	<%if(value.message == null){%>
		<%if(mode.equals("delete")) {%>
			<script>alert('삭제 되었습니다.');</script>
			<script>parent.onRefresh();</script>
		<%}else{%>
			<script>alert('등록 되었습니다.');</script>
			<script>parent.goRef();</script>
		<%}%>
	<%}else{%>
		<%if(mode.equals("delete")) {%>
			<script>alert('삭제실패.');</script>
			<script>parent.onRefresh();</script>
		<%}else{%>
			<script>alert('등록에 실패했습니다.');</script>
			<script>parent.goRef();</script>
			
		<%}%>
	<%}%>

<%
	}
%>
	




