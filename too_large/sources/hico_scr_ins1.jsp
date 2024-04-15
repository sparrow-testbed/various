<!--
 Title:                 hico_scr_ins.jsp <p>
 Description:           SUPPLY / ADMIN /  screening value insert<p>
 Copyright:             Copyright (c) <p>
 Company:               ICOMPIA <p>
 @author                SHYI<p>
 @version
 @Comment

-->
<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	SepoaOut value_sub  = null;
	SepoaOut value_sub1 = null;
	SepoaFormater wf_sub      = null;
	SepoaFormater wf_sub1     = null;
	String work_result       = "false";
	String new_vendor_code   = "";
	String vendor_sg_refitem = "";

	String message_1   = "";
	String message     = "";

 	String buyer_house_code   = JSPUtil.CheckInjection(request.getParameter("buyer_house_code"))==null?"":JSPUtil.CheckInjection(request.getParameter("buyer_house_code"));

	//SepoaInfo info    = new SepoaInfo(buyer_house_code,"ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");

	String isSuccess = JSPUtil.CheckInjection(request.getParameter("isSuccess"))==null?"":JSPUtil.CheckInjection(request.getParameter("isSuccess"));
	String s_template_refitem = JSPUtil.CheckInjection(request.getParameter("s_template_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("s_template_refitem"));
	String c_template_refitem = JSPUtil.CheckInjection(request.getParameter("c_template_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("c_template_refitem"));

	String[] s_factor_refitem = request.getParameterValues("s_factor_refitem");
	String[] answered_seq     = request.getParameterValues("answered_seq");
	String irs_no = JSPUtil.CheckInjection(request.getParameter("irs_no"))==null?"":JSPUtil.CheckInjection(request.getParameter("irs_no"));

	String vendor_code = JSPUtil.CheckInjection(request.getParameter("vendor_code"))==null?"":JSPUtil.CheckInjection(request.getParameter("vendor_code"));
	String sg_refitem  = JSPUtil.CheckInjection(request.getParameter("sg_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_refitem"));	//소싱 그룹 구분키	
	String mode 		= JSPUtil.CheckInjection(request.getParameter("mode"))==null?"":JSPUtil.CheckInjection(request.getParameter("mode"));
	
	String popup       = JSPUtil.nullToEmpty(request.getParameter("popup"));
	

	if(!isSuccess.equals("") && s_factor_refitem != null && answered_seq != null) {
		String[][] value1 = new String[1][5];
		String[][] value2 = new String[s_factor_refitem.length][2];

		if(isSuccess.equals("true")) {	//pass
			value1[0][ 0 ]  = "P";
		} else {
			value1[0][ 0 ] = "F";	//not pass
		}

		value1[0][ 1 ]  = s_template_refitem;
		value1[0][ 2 ]  = c_template_refitem;
		value1[0][ 3 ]  = sg_refitem;
		value1[0][ 4 ]  = vendor_code;

	    for(int i=0; i < s_factor_refitem.length; i++) {
	    	value2[i][ 0 ] = s_factor_refitem[i];
	    	value2[i][ 1 ] = answered_seq[i];
		}

	    Object[] obj = { value1, value2 };

	    String alias = "s6006";
		String conType = "TRANSACTION";
		String MethodName     = "insertScrItem";
		if(popup.equals("T")){		
			MethodName     = "insertScrItem2";
		}
		
		String MethodNameSel  = "getScreenSumValue";	
		String MethodNameSgvn = "updateSgvn";	

		SepoaOut wValue        = null;
		SepoaOut wValuesgvn    = null;
		SepoaRemote remote     = null;
		SepoaRemote remoteSel  = null;
		SepoaRemote remotesgvn = null;

		String error_message = "";
		message = "저장 처리에 실패 했습니다.";
		
		//String[] args = new String[1];
		Object[] args = new Object[3];
		Object[] argsSgvn = new Object[2];
		String s_factor_refitem_sgvn = "";
		String nickName= "s6006";
		
    	try {
			remote = new SepoaRemote(alias, conType, info);
			wValue = remote.lookup(MethodName, obj);
			if (wValue.status == 1) {
				SepoaRemote remoteVendorSel  = null;
				String MethodNameVendor = "getVendorSgNumber";
				Object[] argVendor = new Object[1];
				String sVendor_sg_refitem = "";
        		
        		argVendor[0] = vendor_code;
        		remoteVendorSel = new SepoaRemote(nickName, conType, info);
		        value_sub1 = remoteVendorSel.lookup(MethodNameVendor, argVendor);
		        
		        if(value_sub1.status == 1) {
		        	wf_sub1 = new SepoaFormater(value_sub1.result[0]);
		        	for(int j=0; j < wf_sub1.getRowCount(); j++) {
			        	sVendor_sg_refitem = wf_sub1.getValue("vendor_sg_refitem", j);		          
			        }	
		        	String sum_score = "";
					String totsum_score = "";
					int isum_score   = 0;
					int tsum_score   = 0;
					for(int i=0; i < s_factor_refitem.length; i++) {
						s_factor_refitem_sgvn =  s_factor_refitem[i];
	
						//질문별 체크항목 조회
						//MethodName = "getScreenSumValue";
				        args[0] = s_factor_refitem_sgvn;
				        args[1] = s_template_refitem;
				        args[2] = sVendor_sg_refitem;
				        try {
				        	remoteSel = new SepoaRemote(nickName, conType, info);
					        value_sub = remoteSel.lookup(MethodNameSel, args);
					        if(value_sub.status == 1) {
					            wf_sub = new SepoaFormater(value_sub.result[0]);
					        }
				        } catch(SepoaServiceException wse) {
					          Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
					          Logger.debug.println(info.getSession("ID"),request,"message = " + value_sub.message);
					          Logger.debug.println(info.getSession("ID"),request,"status = " + value_sub.status);
				        } catch(Exception e) {
					          Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
					          
				        } finally {
					          try {
					        	  remoteSel.Release();
					          } catch(Exception e){}
				        }
				             
// 				        for(int j=0; j < wf_sub.getRowCount(); j++) {
// 				          sum_score = wf_sub.getValue("SUM_SCORE", j);
// 				          isum_score = Integer.parseInt(sum_score);
// 				          isum_score = isum_score;			          
// 				          vendor_sg_refitem = wf_sub.getValue("VENDOR_SG_REFITEM", j);
// 				        }		
				        tsum_score += isum_score;
					}
					totsum_score = Integer.toString(tsum_score);
					argsSgvn[0] = totsum_score;
					argsSgvn[1] = vendor_sg_refitem;
					remotesgvn = new SepoaRemote(alias, conType, info);
					wValuesgvn = remotesgvn.lookup(MethodNameSgvn, argsSgvn);
					
					/*
		            WiseStringTokenizer st = new WiseStringTokenizer(wValue.message, ",", false);
		            int cnts = st.countTokens();
	
		            if (cnts == 2) {
		            	new_vendor_code   = st.nextToken().trim();
		            	vendor_sg_refitem = st.nextToken().trim();
		            }
					*/
					if (wValuesgvn.status == 1) {
						work_result = "true";
		    			//message     = "스크리닝 결과를 등록 했습니다.";
		    			message = "저장을 완료하였습니다.";
					}
				}
    		}
    	} catch(SepoaServiceException wse) {
    		Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
			Logger.debug.println(info.getSession("ID"),request,"message = " + wValue.message);
			Logger.debug.println(info.getSession("ID"),request,"status = " + wValue.status);
			error_message += wse.getMessage();
			error_message += wValue.message;
    	} catch(Exception e) {
	    	Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    	error_message += e.getMessage();
		} finally{
			try {
				remote.Release();
			} catch(Exception e) {}
		}
	} else if (!isSuccess.equals("")) {
		String[][] value1 = new String[1][5];
		String[][] value2 = null;

		if(isSuccess.equals("true")) {	//pass
			value1[0][ 0 ]  = "P";
		} else {
			value1[0][ 0 ] = "F";	//not pass
		}

    	value1[0][ 1 ]  = s_template_refitem;
   		value1[0][ 2 ]  = c_template_refitem;
   		value1[0][ 3 ]  = sg_refitem;
   		value1[0][ 4 ]  = vendor_code;

    	Object[] obj = { value1, value2 };

    	String alias = "s6006";
		String conType = "TRANSACTION";
		String MethodName = "insertScrItem";

		SepoaOut wValue = null;
		SepoaRemote remote = null;

		String error_message = "";
		message = "저장 처리에 실패 했습니다.";

    	try {
			remote = new SepoaRemote(alias, conType, info);
			wValue = remote.lookup(MethodName, obj);

			if (wValue.status == 1) {
			/*
			
	            WiseStringTokenizer st = new WiseStringTokenizer(wValue.message, ",", false);
	            int cnts = st.countTokens();

	            if (cnts == 2) {
	            	new_vendor_code   = st.nextToken().trim();
	            	vendor_sg_refitem = st.nextToken().trim();
	            }
			*/
				work_result = "true";
    			//message = "스크리닝 결과를 등록 했습니다.";
    			message = "저장을  완료하였습니다.";
    		}
    	} catch(SepoaServiceException wse) {
    	Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
		Logger.debug.println(info.getSession("ID"),request,"message = " + wValue.message);
		Logger.debug.println(info.getSession("ID"),request,"status = " + wValue.status);
		error_message += wse.getMessage();
		error_message += wValue.message;
    	} catch(Exception e) {
	     Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	     error_message += e.getMessage();
		} finally{
			try 
			{
			  remote.Release();
			} catch(Exception e) {}
		}
	}else{	
		if("doConfirm".equals(mode)){	// 아이디신청
			Object obj[] = {
								buyer_house_code, 
								"", 
								vendor_code
        					};
        	try {		
        		SepoaOut value_doConfirm = ServiceConnector.doService(info, "p0010", "TRANSACTION", "doConfirm", obj);
	        	if (value_doConfirm.status == 1) {
	        		SepoaOut wValuesgvn    = null;
	        		SepoaOut wValuesgvn1    = null;
	        		SepoaOut wValueVssi    = null;
	        		SepoaOut wValue1    = null;
	        		SepoaRemote remoteSel  = null;
	        		SepoaRemote remoteVendorSel  = null;
	        		SepoaRemote remoteVssi  = null;
	        		SepoaRemote remotesgvn = null;
	        		SepoaRemote remotesgvn1 = null;
	        		SepoaRemote remoteInsert = null;
	        		
	        		SepoaRemote remote     = null;
	        		
	        		Object[] argVendor = new Object[1];
	        		Object[] args      = new Object[3];
	        		Object[] argsVssi  = new Object[2];
	        		Object[] argsSgvn  = new Object[2];
	        		Object[] objVssi   = new Object[1];
	        		      		
	        		String s_factor_refitem_sgvn = "";
	        		String nickName= "s6006";
	        		String alias = "s6006";
	        		String conType = "TRANSACTION";
	        		String MethodNameVendor = "getVendorSgNumber";
	        		String MethodNameSel  = "getScreenSumValue";
	        		String MethodNameVssi = "updateVssi";	
	        		String MethodNameSgvn = "updateSgvn";	
	        		String MethodNameSgvn1= "updateSgvn1";	
	        		String MethodNameInsert= "insertScrItem";	
	        		
	        		String sVendor_sg_refitem = "";
	        		
	        		argVendor[0] = vendor_code;
	        		remoteVendorSel = new SepoaRemote(nickName, conType, info);
			        value_sub1 = remoteVendorSel.lookup(MethodNameVendor, argVendor);
			        
			        if(value_sub1.status == 1) {
			        	wf_sub1 = new SepoaFormater(value_sub1.result[0]);
			        	for(int j=0; j < wf_sub1.getRowCount(); j++) {
				        	sVendor_sg_refitem = wf_sub1.getValue("vendor_sg_refitem", j);		          
				        }	
				        
				        objVssi[0] = sVendor_sg_refitem;
				        
		        	    remoteVssi = new SepoaRemote(alias, conType, info);
		        	    wValueVssi = remoteVssi.lookup(MethodNameVssi, objVssi);
		        	    
		        	    remotesgvn1 = new SepoaRemote(alias, conType, info);
		        	    wValuesgvn1 = remotesgvn1.lookup(MethodNameSgvn1, objVssi);
		        	    
		        	    String[][] value1 = new String[1][5];
		        		String[][] value2 = new String[s_factor_refitem.length][2];
						/*
		        		if(isSuccess.equals("true")) {	//pass
		        			value1[0][ 0 ]  = "P";
		        		} else {
		        			value1[0][ 0 ] = "F";	//not pass
		        		}
						*/
		        		value1[0][ 0 ]  = "P";
		        		value1[0][ 1 ]  = s_template_refitem;
		        		value1[0][ 2 ]  = c_template_refitem;
		        		value1[0][ 3 ]  = sg_refitem;
		        		value1[0][ 4 ]  = vendor_code;

		        	    for(int i=0; i < s_factor_refitem.length; i++) {
		        	    	value2[i][ 0 ] = s_factor_refitem[i];
		        	    	value2[i][ 1 ] = answered_seq[i];
		        		}

		        	    Object[] objInsert = { value1, value2 };
		        	    
		        	    remoteInsert = new SepoaRemote(alias, conType, info);
		        	    wValue1 = remoteInsert.lookup(MethodNameInsert, objInsert);
		        	    if (wValue1.status == 1) {
		        	    	argVendor[0] = vendor_code;
			        		remoteVendorSel = new SepoaRemote(nickName, conType, info);
					        value_sub1 = remoteVendorSel.lookup(MethodNameVendor, argVendor);
					        
					        wf_sub1 = new SepoaFormater(value_sub1.result[0]);
				        	for(int j=0; j < wf_sub1.getRowCount(); j++) {
					        	sVendor_sg_refitem = wf_sub1.getValue("vendor_sg_refitem", j);		          
					        }	
			        	    String sum_score = "";
							String totsum_score = "";
							int isum_score   = 0;
							int tsum_score   = 0;
							for(int m=0; m < s_factor_refitem.length; m++) {
								s_factor_refitem_sgvn =  s_factor_refitem[m];
	
								//질문별 체크항목 조회
								//MethodName = "getScreenSumValue";
						        args[0] = s_factor_refitem_sgvn;
						        args[1] = s_template_refitem;
						        args[2] = sVendor_sg_refitem;
						        
						        try {
						        	remoteSel = new SepoaRemote(nickName, conType, info);
							        value_sub = remoteSel.lookup(MethodNameSel, args);
							        if(value_sub.status == 1) {
							            wf_sub = new SepoaFormater(value_sub.result[0]);
							        }
						        } catch(SepoaServiceException wse) {
							          Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
							          Logger.debug.println(info.getSession("ID"),request,"message = " + value_sub.message);
							          Logger.debug.println(info.getSession("ID"),request,"status = " + value_sub.status);
						        } catch(Exception e) {
							          Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
							          
						        } finally {
							          try {
							        	  remoteSel.Release();
							          } catch(Exception e){}
						        }
						             
						        for(int n=0; n < wf_sub.getRowCount(); n++) {
						          sum_score = wf_sub.getValue("SUM_SCORE", n);
						          isum_score = Integer.parseInt(sum_score);
						          isum_score = isum_score;			          
						        }		
						        tsum_score += isum_score;
							}
							totsum_score = Integer.toString(tsum_score);
							argsSgvn[0] = totsum_score;
							argsSgvn[1] = sVendor_sg_refitem;
							remotesgvn = new SepoaRemote(alias, conType, info);
							wValuesgvn = remotesgvn.lookup(MethodNameSgvn, argsSgvn);
							if (wValuesgvn.status == 1) {
			        			work_result = "true";    
							}
		        	    }
			        }		        
	        	}
	        
        	}catch(Exception e){
        		
        	}finally{
        
        	}

		}else if("doModify".equals(mode)){		    // 협력업체 등록평가 수정시
			SepoaOut wValuesgvn    = null;
			SepoaRemote remoteSel  = null;
			SepoaRemote remoteVendorSel  = null;
			SepoaRemote remoteVssi  = null;
			SepoaRemote remotesgvn = null;
    		
    		Object[] args      = new Object[3];
    		Object[] argsVssi  = new Object[2];
    		Object[] argsSgvn  = new Object[2];
    		Object[] objVssi   = new Object[1];
    		      		
    		String s_factor_refitem_sgvn = "";
    		String nickName= "s6006";
    		String alias = "s6006";
    		String conType = "TRANSACTION";
    		String MethodNameSel  = "getScreenSumValue";
    		String MethodNameVssi = "modifyVssi";	
    		String MethodNameSgvn = "updateSgvn";
    		
			String MethodNameVendor = "getVendorSgNumber";
			Object[] argVendor = new Object[1];
			String sVendor_sg_refitem = "";
    		
    		argVendor[0] = vendor_code;
    		remoteVendorSel = new SepoaRemote(nickName, conType, info);
	        value_sub1 = remoteVendorSel.lookup(MethodNameVendor, argVendor);
	        
	        if(value_sub1.status == 1) {
	        	wf_sub1 = new SepoaFormater(value_sub1.result[0]);
	        	for(int j=0; j < wf_sub1.getRowCount(); j++) {
		        	sVendor_sg_refitem = wf_sub1.getValue("vendor_sg_refitem", j);		          
		        }
	        	
				String[][] value2 = new String[s_factor_refitem.length][3];

			    for(int i=0; i < s_factor_refitem.length; i++) {
			    	value2[i][ 0 ] = answered_seq[i];
			    	value2[i][ 1 ] = s_factor_refitem[i];			    	
			    	value2[i][ 2 ] = sVendor_sg_refitem;
				}

			    Object[] obj = { value2 };
	        	
	        	remoteVssi = new SepoaRemote(nickName, conType, info);
		        value_sub = remoteVssi.lookup(MethodNameVssi, obj);
		        
		        if ( value_sub.status == 1 ) {
		        	String sum_score = "";
					String totsum_score = "";
					int isum_score   = 0;
					int tsum_score   = 0;
					for(int i=0; i < s_factor_refitem.length; i++) {
						s_factor_refitem_sgvn =  s_factor_refitem[i];

						//질문별 체크항목 조회
						//MethodName = "getScreenSumValue";
				        args[0] = s_factor_refitem_sgvn;
				        args[1] = s_template_refitem;
				        args[2] = sVendor_sg_refitem;
				        try {
				        	remoteSel = new SepoaRemote(nickName, conType, info);
					        value_sub = remoteSel.lookup(MethodNameSel, args);
					        if(value_sub.status == 1) {
					            wf_sub = new SepoaFormater(value_sub.result[0]);
					        }
				        } catch(SepoaServiceException wse) {
					          Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
					          Logger.debug.println(info.getSession("ID"),request,"message = " + value_sub.message);
					          Logger.debug.println(info.getSession("ID"),request,"status = " + value_sub.status);
				        } catch(Exception e) {
					          Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
					          
				        } finally {
					          try {
					        	  remoteSel.Release();
					          } catch(Exception e){}
				        }
				             
// 				        for(int j=0; j < wf_sub.getRowCount(); j++) {
// 				          sum_score = wf_sub.getValue("SUM_SCORE", j);
// 				          isum_score = Integer.parseInt(sum_score);
// 				          isum_score = isum_score;			          
// 				          vendor_sg_refitem = wf_sub.getValue("VENDOR_SG_REFITEM", j);
// 				        }		
				        tsum_score += isum_score;
					}
					totsum_score = Integer.toString(tsum_score);
					argsSgvn[0] = totsum_score;
					argsSgvn[1] = vendor_sg_refitem;
					remotesgvn = new SepoaRemote(alias, conType, info);
					wValuesgvn = remotesgvn.lookup(MethodNameSgvn, argsSgvn);
					
					/*
		            SepoaStringTokenizer st = new SepoaStringTokenizer(wValue.message, ",", false);
		            int cnts = st.countTokens();

		            if (cnts == 2) {
		            	new_vendor_code   = st.nextToken().trim();
		            	vendor_sg_refitem = st.nextToken().trim();
		            }
					*/
					if (wValuesgvn.status == 1) {
						work_result = "true";
		    			//message     = "스크리닝 결과를 등록 했습니다.";
		    			message = "소싱정보등록을 완료하였습니다.";
					}
		        }      
	        	
			}
		}else {							// 스크린닝 항목없고 소싱그룹만 선택하고  저장시
			// isSuccess 이 "" 값일때 선택한 소싱그룹의 스크린링 리스트가 맵핑이 안되어 있는경우에는 소싱그룹만 선택한다. 이때 isSuccess = "" 이다.
			
			String[][] value1 = new String[1][5];
			String[][] value2 = null;
	
	
			value1[0][ 0 ]  = ""; // 스크린닝을 거치지 않았으므로
	    	value1[0][ 1 ]  = s_template_refitem;
	   		value1[0][ 2 ]  = c_template_refitem;
	   		value1[0][ 3 ]  = sg_refitem;
	   		value1[0][ 4 ]  = vendor_code;
	
	    	Object[] obj = { value1, null };
	
	    	String alias = "s6006";
			String conType = "TRANSACTION";
			String MethodName = "insertScrItem";
	
			SepoaOut wValue = null;
			SepoaRemote remote = null;
	
			String error_message = "";
			message = "저장에 실패하였습니다.";
	
	    	try {
				remote = new SepoaRemote(alias, conType, info);
				wValue = remote.lookup(MethodName, obj);
	
				if (wValue.status == 1) {
				/*
				
		            SepoaStringTokenizer st = new SepoaStringTokenizer(wValue.message, ",", false);
		            int cnts = st.countTokens();
	
		            if (cnts == 2) {
		            	new_vendor_code   = st.nextToken().trim();
		            	vendor_sg_refitem = st.nextToken().trim();
		            }
				*/
					work_result = "true";
	    			message = "저장하였습니다.";
	    		}
	    	} catch(SepoaServiceException wse) {
	    	Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
			Logger.debug.println(info.getSession("ID"),request,"message = " + wValue.message);
			Logger.debug.println(info.getSession("ID"),request,"status = " + wValue.status);
			error_message += wse.getMessage();
			error_message += wValue.message;
	    	} catch(Exception e) {
		     Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		     error_message += e.getMessage();
			} finally{
				try 
				{
				  remote.Release();
				} catch(Exception e) {}
			}
		
		
		}
	}
	
	if (work_result.equals("true") && isSuccess.equals("true")) {
		//message = "스크리닝을 통과했습니다.";
		message = "저장을 완료하였습니다.";
	} else {
		if("".equals(isSuccess)){
			if("doConfirm".equals(mode)){
				if("true".equals(work_result)){
					message = "아이디 신청이 완료되었습니다.\\n신청 결과는 내부결재 후 SMS로 전송 됩니다.";
				}else {
					message = "아이디신청이 실패하였습니다.";
				}		
			}else {
				if("true".equals(work_result)){
					message = "저장되었습니다.";
				}else {
					message = "저장에 실패하였습니다.";
				}		
			}
				
		}else {
			
			//message = "스크리닝을 통과하지 못하였습니다.";
			message = "소싱정보등록를 완료하였습니다.";//공급업체 소싱정보등록 탭에서 저장시 세팅하는 메세지
// 			message = "업체등록평가를 완료하였습니다.";
			
		}
		
	}
	
	
	
%>

<html>
  <head>
  <title>우리은행 전자구매시스템</title>
    <meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
    <link rel="stylesheet" href="/kr/css/body.css" type="text/css">

    <script language="javascript">
	//<!--
	function init() {
		alert("<%=message%>");
<%
	  //if (work_result.equals("true") && isSuccess.equals("true")) {
		if (work_result.equals("true")) {
			if("doConfirm".equals(mode)){
%>
			parent.parent.close();
<%				
			}else{
%>
			getScreeningList();
<%
			}
		}
%>
	}

	function getScreeningList()	{
		parent.parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','hide','m6','','show','m7','','hide','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','show','m66','','hide','m77','','hide');
		parent.parent.up.goPage('sc');
<%--	
		document.form2.target = "down"
		document.form2.method = "post";
		document.form2.action = "hico_chk_ins.jsp";
		document.form2.submit();
--%>		
	}

-->
    </script>

  </head>
<body bgcolor="#FFFFFF" text="#000000" onload="javascript:init();">
<form name="form2">
	<input type="hidden" id="buyer_house_code"  name="buyer_house_code"  value="<%=buyer_house_code%>">
	<input type="hidden" id="sg_refitem"        name="sg_refitem"        value="<%=sg_refitem%>">
	<input type="hidden" id="vendor_code"       name="vendor_code"       value="<%=vendor_code%>">
	<input type="hidden" id="vendor_sg_refitem" name="vendor_sg_refitem" value="<%=vendor_sg_refitem%>">
	<input type="hidden" id="status"            name="status"            value="5">
	<input type="hidden" id="close_btn"         name="close_btn"         value="Y">
</form>
</body>
</html>
