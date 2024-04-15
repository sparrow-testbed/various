<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_contract_miri_view"; //리포트명
StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_011");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	String user_name = info.getSession("NAME_LOC");
	String to_day = SepoaDate.getShortDateString();
	
	String cont_no	     = JSPUtil.nullToEmpty(request.getParameter("cont_no")).trim();
	String ele_cont_flag = JSPUtil.nullToEmpty(request.getParameter("ele_cont_flag")); // 전자계약서작성여부 ( Y : 전자계약 , N : 오프라인계약 )
	String cont_gl_seq   = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq")).trim();
	String cont_form_no  = JSPUtil.nullToEmpty(request.getParameter("cont_form_no")).trim();
	String flag  		 = JSPUtil.nullToEmpty(request.getParameter("flag"));
	
	Object[] obj         = { cont_no ,cont_form_no, flag, cont_gl_seq };
	SepoaOut value       = ServiceConnector.doService(info, "CT_001", "CONNECTION","getContractSelect", obj);
	SepoaFormater wf     = new SepoaFormater(value.result[0]);

	String CONT_CONTENT  = wf.getValue("CONTENT", 0);
	
	// 첫번째 쿼리
	Object[] obj1 = {cont_no, cont_gl_seq};
	SepoaOut value1 = ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractContNoSelect", obj1);
	SepoaFormater wf2 = new SepoaFormater(value1.result[0]);
	
	String in_val_cont_gubun				= ""; // 계약구분
	
	String in_val_cont_no					= ""; // 계약번호
	String in_val_subject					= ""; // 계약명
	//String in_val_seller_name				= ""; // 업체명
	
	String in_val_cont_from					= ""; // 계약기간-from
	String in_val_cont_to					= ""; // 계약기간-to	
	String in_val_delv_place				= ""; // 납품장소
	
	String in_val_cont_amt					= ""; // 계약금액
	String in_val_cont_supply               = ""; // 공급가액	
	String in_val_cont_vat                  = ""; // 부가세	
	
	String in_val_cont_supply_ko            = ""; // 공급가액	한글
	
	String in_val_cont_vat_ko               = ""; // 부가세한글
	String in_val_delay_charge		        = ""; // 지체상금율
	
	String in_val_cont_amt_to_ko			= ""; // 계약금한글
	String in_val_cont_danga                = ""; // 계약단가
	String in_val_ttl_item_qty				= ""; // 계약수량	
	
	String in_val_cont_assure_percent		= ""; // 계약보증금-%
	String in_val_cont_assure_amt			= ""; // 계약보증금액
	String in_val_cont_assure_amt_to_ko		= ""; // 계약보증금한글
	
	String in_val_fault_ins_percent			= ""; // 하자보증금-%
	String in_val_fault_ins_amt				= ""; // 하자보증금액
	String in_val_fault_ins_amt_to_ko		= ""; // 하자보증금한글
	
	String in_val_fault_ins_term			= ""; // 하자보증기간
	String in_val_pay_div_flag				= ""; // 지급횟수
	String in_val_cont_add_date             = ""; // 계약일자
	
	String in_val_rd_date            		= ""; // 납품기한
	String in_val_item_type            		= ""; // 물품종류
	
	String in_val_bfchg_cont_from        = "";  //변경전-계약기간-from
	String in_val_bfchg_cont_to            = "";  //변경전-계약기간-to
	String in_val_bfchg_cont_amt         = "";  //변경전-계약금액
	String in_val_bfchg_cont_amt_to_ko = "";  //변경전-계약금액한글
	String in_val_cont_var_amt              = ""; //계약금액증감액
	String in_val_cont_var_amt_to_ko     = ""; //계약금액증감액한글
		
	// 빈박스
	
	
	String in_attach_no						= ""; // 첨부파일		
	String seller_code                      = ""; // 업체코드
	String add_tax_flag                     = ""; // 부가세포함(Y)/면세(N)
	
	
	int in_val_fault_ins_term_year          = 0; // 하자보증기간 년
	int in_val_fault_ins_term_month         = 0; // 하자보증기간 월
	
    if(wf2.getRowCount() > 0) {
    	add_tax_flag					= JSPUtil.nullToEmpty(wf2.getValue("ADD_TAX_FLAG",0));                 // 부가세포함(Y)/면세(N)    	
    	Logger.sys.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  add_tax_flag = " + add_tax_flag);
    
    	in_val_cont_gubun				= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_GUBUN",0));            // 계약구분
    	in_val_cont_no					= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_NO",0));               // 계약번호
    	in_val_subject					= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_SUBJECT",0));               // 계약명
    	//in_val_seller_name				= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_SELLER_NAME",0));           // 업체명

		in_val_cont_from				= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_FROM",0));             // 계약기간(from)
    	in_val_cont_to					= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_TO",0));               // 계약기간(to)	
    	in_val_delv_place				= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_DELV_PLACE",0));            // 납품장소
    	
    	in_val_cont_amt					= JSPUtil.nullToRef(wf2.getValue("IN_VAL_CONT_AMT",0), "0");              // 계약금액
    	if( "Y".equals( add_tax_flag ) ){
    		in_val_cont_supply          = "" + (long)Math.round( Double.parseDouble(in_val_cont_amt) / 1.1 );             // 공급가액
    		in_val_cont_vat             = "" + (long)( Double.parseDouble(in_val_cont_amt) - Double.parseDouble(in_val_cont_supply) ); // 부가세
    	}else{
    		in_val_cont_supply          = in_val_cont_amt;
    		in_val_cont_vat             = "0";
    	}
    	
		// 공급가액	한글
		// 부가세한글
	    in_val_delay_charge		        = JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_DELAY_CHARGE",0));          // 지체상금율
    	
    	// 계약금한글 
    	in_val_ttl_item_qty 			= JSPUtil.nullToRef(wf2.getValue("IN_VAL_TTL_ITEM_QTY",0),"1");          // 계약수량
    	
    	in_val_cont_danga               = SepoaMath.SepoaNumberType( ""+( Double.parseDouble(in_val_cont_amt) / Double.parseDouble(in_val_ttl_item_qty) ) , "###,###,###,###,###,###,###"); // 계약단가
    	
    	in_val_cont_assure_percent		= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_ASSURE_PERCENT",0));   // 계약보증금-%
    	in_val_cont_assure_amt			= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_ASSURE_AMT",0));       // 계약보증금액
    	// 계약보증금한글
    	
    	in_val_fault_ins_percent		= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_FAULT_INS_PERCENT",0));     // 하자보증금-%
    	in_val_fault_ins_amt			= JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_FAULT_INS_AMT",0));		   // 하자보증금액
    	// 하자보증금한글
    	
    	in_val_fault_ins_term			= JSPUtil.nullToRef(wf2.getValue("IN_VAL_FAULT_INS_TERM",0),"0");		   // 하자보증기간
    	in_val_fault_ins_term_year      = ( Integer.parseInt( in_val_fault_ins_term ) / 12 ); // 하자보증기간 년
    	in_val_fault_ins_term_month     = ( Integer.parseInt( in_val_fault_ins_term ) % 12 ); // 하자보증기간 월    
    	// 지급횟수
    	in_val_cont_add_date            = JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_CONT_ADD_DATE",0));		   // 계약일자
    	
    	in_attach_no					= JSPUtil.nullToEmpty(wf2.getValue("ATTACH_NO",0));                    // 첨부파일
    	seller_code						= JSPUtil.nullToEmpty(wf2.getValue("seller_code",0));                  // 업체코드    	
    	in_val_item_type				= JSPUtil.nullToEmpty(wf2.getValue("ITEM_TYPE",0));// 물품종류    	
    	in_val_rd_date					= JSPUtil.nullToEmpty(wf2.getValue("RD_DATE",0));// 납품기한   	
    	
    	in_val_pay_div_flag           = JSPUtil.nullToEmpty(wf2.getValue("IN_VAL_PAY_DIV_FLAG",0));// 대금지급횟수
	}
	
	// 2번째 쿼리
    //Object[] obj00 = {"W100", cont_gl_seq};//BUYER 정보
	//value1	= ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractContNoSelect", obj00);
	SepoaFormater wf3		= new SepoaFormater(value1.result[1]);
	
	String in_val_buyer_name_loc		= ""; // 공급받는자-상호
	String in_val_buyer_irs_no				= ""; // 공급받는자-사업자번호
	String in_val_buyer_address_loc			= ""; // 공급받는자-주소
	String in_val_buyer_sign_person_name	= ""; // 공급받는자-계약담당자
	
	if(wf3.getRowCount() > 0) {
    	in_val_buyer_name_loc			= JSPUtil.nullToEmpty(wf3.getValue("IN_VAL_BUYER_NAME_LOC",0));
    	in_val_buyer_irs_no				= JSPUtil.nullToEmpty(wf3.getValue("IN_VAL_BUYER_IRS_NO",0));
    	in_val_buyer_sign_person_name	= JSPUtil.nullToEmpty(wf3.getValue("IN_VAL_BUYER_SIGN_PERSON_NAME",0));
		in_val_buyer_address_loc		= JSPUtil.nullToEmpty(wf3.getValue("IN_VAL_BUYER_ADDRESS_LOC",0));
		
		//if(in_val_buyer_irs_no.length() == 10) {
	    //	in_val_buyer_irs_no				= in_val_buyer_irs_no.replaceAll("-","");
	    //	in_val_buyer_irs_no				= in_val_buyer_irs_no.substring(0,3) + "-" + in_val_buyer_irs_no.substring(3,5) + "-" + in_val_buyer_irs_no.substring(5,10);
    	//}
    }
    
    //Object[] obj01 = {seller_code, cont_gl_seq};//업체코드 넣으세요.... 쿼리는 CONT_NO로 되어 있지만.. 업체정보가져오는거다!!!!!!!
	//value1	= ServiceConnector.doService(info, "CT_021", "CONNECTION","getContractContNoSelect", obj01);
	SepoaFormater wf4		= new SepoaFormater(value1.result[2]);

	String in_val_seller_name				= ""; // 공급자-상호
	String in_val_seller_irs_no				= ""; // 공급자-사업자번호
	String in_val_seller_address_loc		= ""; // 공급자-주소
	String in_val_seller_sign_person_name	= ""; // 공급자-계약담당자
	
	String in_val_bank_code              = ""; // 공급자-거래은행     
	String in_val_bank_acct               = ""; // 공급자-계좌번호 
	String in_val_depositor_name       = ""; // 공급자-예금주	
    if(wf4.getRowCount() > 0) {
    	in_val_seller_name				= JSPUtil.nullToEmpty(wf4.getValue("IN_VAL_SELLER_NAME",0));
    	in_val_seller_irs_no			= JSPUtil.nullToEmpty(wf4.getValue("IN_VAL_SELLER_IRS_NO",0));    	
    	in_val_seller_address_loc		= JSPUtil.nullToEmpty(wf4.getValue("IN_VAL_SELLER_ADDRESS_LOC",0));    	
    	in_val_seller_sign_person_name	= JSPUtil.nullToEmpty(wf4.getValue("IN_VAL_SELLER_SIGN_PERSON_NAME",0));

    	in_val_bank_code              = JSPUtil.nullToEmpty(wf4.getValue("IN_VAL_BANK_CODE",0)); // 공급자-거래은행     
		in_val_bank_acct               = JSPUtil.nullToEmpty(wf4.getValue("IN_VAL_BANK_ACCT",0)); // 공급자-계좌번호 
		in_val_depositor_name       = JSPUtil.nullToEmpty(wf4.getValue("IN_VAL_DEPOSITOR_NAME",0)); // 공급자-예금주				
    	//if(in_val_seller_irs_no.length() == 10) {
	    //	in_val_seller_irs_no			= in_val_seller_irs_no.replaceAll("-","");
	    //	in_val_seller_irs_no			= in_val_seller_irs_no.substring(0,3) + "-" + in_val_seller_irs_no.substring(3,5) + "-" + in_val_seller_irs_no.substring(5,10);
    	//}
    }
	
    if(!cont_gl_seq.equals("001")){
    	SepoaFormater wf5		= new SepoaFormater(value1.result[3]);
    	if(wf5.getRowCount() > 0) {
    		in_val_bfchg_cont_from        = JSPUtil.nullToEmpty(wf5.getValue("IN_VAL_CONT_FROM",0));  //변경전-계약기간-from
        	in_val_bfchg_cont_to            = JSPUtil.nullToEmpty(wf5.getValue("IN_VAL_CONT_TO",0));  //변경전-계약기간-to
        	in_val_bfchg_cont_amt         = JSPUtil.nullToEmpty(wf5.getValue("IN_VAL_CONT_AMT",0));  //변경전-계약금액
        	in_val_bfchg_cont_amt_to_ko = "";  //변경전-계약금액한글
        	
        	if(Double.parseDouble(in_val_cont_amt) > Double.parseDouble(in_val_bfchg_cont_amt)){
        		in_val_cont_var_amt = "" + (int)( Double.parseDouble(in_val_cont_amt) - Double.parseDouble(in_val_bfchg_cont_amt) );
        	}else{
        		in_val_cont_var_amt = "" + (int)( Double.parseDouble(in_val_bfchg_cont_amt) - Double.parseDouble(in_val_cont_amt) );
        	}
        	in_val_cont_var_amt_to_ko     = ""; //계약금액증감액한글
    	}
    }

    String font_type = "바탕";
    
    if(in_val_cont_gubun.equals("시설"))  font_type = "굴림";
    
    
    if(in_val_cont_no.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약번호 name=in_val_cont_no>"   ,	 "<font size=3 face="+font_type+" color=black>"+in_val_cont_no+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약번호 name=in_val_cont_no>"   ,	 "" );
   	if(in_val_subject.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약명 name=in_val_subject>"     , "<font size=3 face="+font_type+" color=black>"+in_val_subject+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약명 name=in_val_subject>"     , "" );    	
   	if(in_val_seller_name.length()				> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=업체명 name=in_val_seller_name>" , "<font size=3 face="+font_type+" color=black>"+in_val_seller_name+"</font>" );
  	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=업체명 name=in_val_seller_name>" , "" );
 																								
   	if(in_val_cont_from.length()				> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약기간-from name=in_val_cont_from>" , "<font size=3 face="+font_type+" color=black>"+in_val_cont_from+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약기간-from name=in_val_cont_from>" , "" );
   																								
   	if(in_val_cont_to.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약기간-to name=in_val_cont_to>"     , "<font size=3 face="+font_type+" color=black>"+in_val_cont_to+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약기간-to name=in_val_cont_to>"     ,	 "" ); 
   	if(in_val_delv_place.length()				> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=납품장소 name=in_val_delv_place>"      , "<font size=3 face="+font_type+" color=black>"+in_val_delv_place+"</font>" );
  	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=납품장소 name=in_val_delv_place>"      , "" );
    
   	if(in_val_cont_amt.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약금액 name=in_val_cont_amt>"    , "<font size=3 face="+font_type+" color=black>"+SepoaMath.SepoaNumberType(in_val_cont_amt, "###,###,###,###,###,###,###")+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약금액 name=in_val_cont_amt>"    , "");    
    if(in_val_cont_supply.length()				> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급가액 name=in_val_cont_supply>" , "<font size=3 face="+font_type+" color=black>"+SepoaMath.SepoaNumberType(in_val_cont_supply, "###,###,###,###,###,###,###")+"</font>" );
   	else										   		CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급가액 name=in_val_cont_supply>" , "");
    if(in_val_cont_vat.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=부가세 name=in_val_cont_vat>"      , "<font size=3 face="+font_type+" color=black>"+SepoaMath.SepoaNumberType(in_val_cont_vat, "###,###,###,###,###,###,###")+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=부가세 name=in_val_cont_vat>"      , "");

   	if(in_val_cont_supply.length()				> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급가액한글 name=in_val_cont_supply_ko>" , "<font size=3 face="+font_type+" color=black>"+getHanStr(in_val_cont_supply)+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급가액한글 name=in_val_cont_supply_ko>" , "");    
    if(in_val_cont_vat.length()				    > 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=부가세한글 name=in_val_cont_vat_ko>"      , "<font size=3 face="+font_type+" color=black>"+getHanStr(in_val_cont_vat)+"</font>" );
   	else										   		CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=부가세한글 name=in_val_cont_vat_ko>"      , "");
    if(in_val_delay_charge.length()				> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=지체상금율 name=in_val_delay_charge>"     , "<font size=3 face="+font_type+" color=black>"+in_val_delay_charge+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=지체상금율 name=in_val_delay_charge>"     , "");
 
    if(in_val_cont_amt.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약금액한글 name=in_val_cont_amt_to_ko>" , "<font size=3 face="+font_type+" color=black>"+getHanStr(in_val_cont_amt)+"</font>");//wgw
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약금액한글 name=in_val_cont_amt_to_ko>" ,  "" );   
   	if(in_val_cont_danga.length()				> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약단가 name=in_val_cont_danga>"       , "<font size=3 face="+font_type+" color=black>"+in_val_cont_danga+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약단가 name=in_val_cont_danga>"       , "");    
   	if(in_val_ttl_item_qty.length()				> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약수량 name=in_val_ttl_item_qty>"     , "<font size=3 face="+font_type+" color=black>"+in_val_ttl_item_qty+"</font>" );
  	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약수량 name=in_val_ttl_item_qty>"     , "");    	   
    
   	if(in_val_cont_assure_percent.length()	    > 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약보증금-% name=in_val_cont_assure_percent>"   , "<font size=3 face="+font_type+" color=black>"+in_val_cont_assure_percent+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약보증금-% name=in_val_cont_assure_percent>"   , "" );
   	if(in_val_cont_assure_amt.length()			> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약보증금액 name=in_val_cont_assure_amt>"        , "<font size=3 face="+font_type+" color=black>"+SepoaMath.SepoaNumberType(in_val_cont_assure_amt, "###,###,###,###,###,###,###")+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약보증금액 name=in_val_cont_assure_amt>"        ,	"" );
   	if(in_val_cont_assure_amt.length()			> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약보증금한글 name=in_val_cont_assure_amt_to_ko>" , "<font size=3 face="+font_type+" color=black>"+getHanStr(in_val_cont_assure_amt)+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약보증금한글 name=in_val_cont_assure_amt_to_ko>" , "" );    
    
   	if(in_val_fault_ins_percent.length()		> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=하자보증금-% name=in_val_fault_ins_percent>"   , "<font size=3 face="+font_type+" color=black>"+in_val_fault_ins_percent+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=하자보증금-% name=in_val_fault_ins_percent>"   , "" );
   	if(in_val_fault_ins_amt.length()			> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=하자보증금액 name=in_val_fault_ins_amt>"         , "<font size=3 face="+font_type+" color=black>"+SepoaMath.SepoaNumberType(in_val_fault_ins_amt, "###,###,###,###,###,###,###")+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=하자보증금액 name=in_val_fault_ins_amt>"         , "" );
   	if(in_val_fault_ins_amt.length()			> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=하자보증금한글 name=in_val_fault_ins_amt_to_ko>" , "<font size=3 face="+font_type+" color=black>"+getHanStr(in_val_fault_ins_amt)+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=하자보증금한글 name=in_val_fault_ins_amt_to_ko>" , "" );    
    
    if(in_val_fault_ins_term.length()			> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=하자보증기간 name=in_val_fault_ins_term>" , "<font size=3 face="+font_type+" color=black>"+in_val_fault_ins_term_year+"년 "+in_val_fault_ins_term_month+"개월</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=하자보증기간 name=in_val_fault_ins_term>" , "" );   
    if(in_val_cont_add_date.length()			> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약일자 name=in_val_cont_add_date>"     , "<font size=3 face="+font_type+" color=black>"+in_val_cont_add_date+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약일자 name=in_val_cont_add_date>"     , "<span id=in_val_cont_add_date></span>" );   


   	if(in_val_buyer_name_loc.length()	> 0)			CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급받는자-상호 name=in_val_buyer_name_loc>"       , "<font size=3 face="+font_type+" color=black>"+in_val_buyer_name_loc+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급받는자-상호 name=in_val_buyer_name_loc>"       , "" ); 
   	if(in_val_buyer_address_loc.length()		> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급받는자-주소 name=in_val_buyer_address_loc>"           , "<font size=3 face="+font_type+" color=black>"+in_val_buyer_address_loc+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급받는자-주소 name=in_val_buyer_address_loc>"           , "" );      
   	if(in_val_buyer_sign_person_name.length()	> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급받는자-계약담당자 name=in_val_buyer_sign_person_name>" , "<font size=3 face="+font_type+" color=black>"+in_val_buyer_sign_person_name+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급받는자-계약담당자 name=in_val_buyer_sign_person_name>" , "" );

   	if(in_val_seller_name.length()		> 0)			CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-상호 name=in_val_seller_name>"           , "<font size=3 face="+font_type+" color=black>"+in_val_seller_name+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-상호 name=in_val_seller_name>"           , "" );   	
   	if(in_val_seller_address_loc.length()		> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-주소 name=in_val_seller_address_loc>"           , "<font size=3 face="+font_type+" color=black>"+in_val_seller_address_loc+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-주소 name=in_val_seller_address_loc>"           , "" );   	
   	if(in_val_seller_sign_person_name.length()	> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-계약담당자 name=in_val_seller_sign_person_name>" ,	"<font size=3 face="+font_type+" color=black>"+in_val_seller_sign_person_name+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-계약담당자 name=in_val_seller_sign_person_name>" ,	"" );
    if(in_val_seller_irs_no.length()	> 0)			CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-사업자번호 name=in_val_seller_irs_no>" ,	"<font size=3 face="+font_type+" color=black>"+in_val_seller_irs_no+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-사업자번호 name=in_val_seller_irs_no>" ,	"" );
    if(in_val_buyer_irs_no.length()	> 0)				CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급받는자-사업자번호 name=in_val_buyer_irs_no>" ,	"<font size=3 face="+font_type+" color=black>"+in_val_buyer_irs_no+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급받는자-사업자번호 name=in_val_buyer_irs_no>" ,	"" );
    if(in_val_rd_date.length()	> 0)					CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=납품기한 name=in_val_rd_date>" ,	"<font size=3 face="+font_type+" color=black>"+in_val_rd_date+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=납품기한 name=in_val_rd_date>" ,	"" );
    if(in_val_item_type.length()	> 0)				CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=물품종류 name=in_val_item_type>" ,	"<font size=3 face="+font_type+" color=black>"+in_val_item_type+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=물품종류 name=in_val_item_type>" ,	"" );
    
    if(in_val_bank_code.length()	> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-거래은행 name=in_val_bank_code>" , "<font size=3 face="+font_type+" color=black>"+in_val_bank_code+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-거래은행 name=in_val_bank_code>" , "" );
    if(in_val_bank_acct.length()	> 0)	    CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-계좌번호 name=in_val_bank_acct>" , "<font size=3 face="+font_type+" color=black>"+in_val_bank_acct+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-계좌번호 name=in_val_bank_acct>" , "" );
    if(in_val_depositor_name.length()	> 0)	    CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-예금주 name=in_val_depositor_name>" , "<font size=3 face="+font_type+" color=black>"+in_val_depositor_name+"</font>" );
   	else												        CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=공급자-예금주 name=in_val_depositor_name>" , "" );

    if(in_val_bfchg_cont_from.length()				> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=변경전-계약기간-from name=in_val_bfchg_cont_from>" , "<font size=3 face="+font_type+" color=black>"+in_val_bfchg_cont_from+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=변경전-계약기간-from name=in_val_bfchg_cont_from>" , "" );
   	if(in_val_bfchg_cont_to.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=변경전-계약기간-to name=in_val_bfchg_cont_to>"     , "<font size=3 face="+font_type+" color=black>"+in_val_bfchg_cont_to+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=변경전-계약기간-to name=in_val_bfchg_cont_to>"     ,	 "" ); 
    if(in_val_bfchg_cont_amt.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=변경전-계약금액 name=in_val_bfchg_cont_amt>"    , "<font size=3 face="+font_type+" color=black>"+SepoaMath.SepoaNumberType(in_val_bfchg_cont_amt, "###,###,###,###,###,###,###")+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=변경전-계약금액 name=in_val_bfchg_cont_amt>"    , "");    
    if(in_val_bfchg_cont_amt.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=변경전-계약금액한글 name=in_val_bfchg_cont_amt_to_ko>" , "<font size=3 face="+font_type+" color=black>"+getHanStr(in_val_bfchg_cont_amt)+"</font>");//wgw
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=변경전-계약금액한글 name=in_val_bfchg_cont_amt_to_ko>" ,  "" );   
    if(in_val_cont_var_amt.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약금액증감액 name=in_val_cont_var_amt>"    , "<font size=3 face="+font_type+" color=black>"+SepoaMath.SepoaNumberType(in_val_cont_var_amt, "###,###,###,###,###,###,###")+"</font>" );
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약금액증감액 name=in_val_cont_var_amt>"    , "");    
    if(in_val_cont_var_amt.length()					> 0)	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약금액증감액한글 name=in_val_cont_var_amt_to_ko>" , "<font size=3 face="+font_type+" color=black>"+getHanStr(in_val_cont_var_amt)+"</font>");//wgw
   	else												CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=계약금액증감액한글 name=in_val_cont_var_amt_to_ko>" ,  "" );   
    
    if(in_val_pay_div_flag.length()	> 0)	    CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=지급횟수 name=in_val_pay_div_flag>" , "<font size=3 face="+font_type+" color=black>"+in_val_pay_div_flag+"</font>" );
   	else  CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=지급횟수 name=in_val_pay_div_flag>" , "" );
    	    	
   	// 지급횟수
    // CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=지급횟수"       , "<font size=3 face="+font_type+" color=black>" );
    //	CONT_CONTENT = CONT_CONTENT.replaceAll(" name=in_val_pay_div_flag>" , "</font>");
   	  	   		
    // 빈박스	
   	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=빈박스 name=in_val_1>"   , "<font size=3 face="+font_type+" color=black>");
//    	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value=빈박스>"   , "<font size=3 face="+font_type+" color=black>");
//    	CONT_CONTENT = CONT_CONTENT.replaceAll(" name=in_val_1>"      , "</font>");

//     CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT value="       , "<font size=3 face="+font_type+" color=black>" );
    
//    	CONT_CONTENT = CONT_CONTENT.replaceAll(" name=in_val_pay_div_flag>" , "</font>");;
//    	CONT_CONTENT = CONT_CONTENT.replaceAll(" name=in_val_1>" , "</font>");
   	
//    	CONT_CONTENT = CONT_CONTENT.replaceAll("<INPUT" , "");

	Logger.debug.println("==================== CONT_CONTENT START ====================");
	Logger.debug.println(CONT_CONTENT);
	Logger.debug.println("==================== CONT_CONTENT END   ====================");
  	
  	Object[] obj02   = {cont_no, in_attach_no,ele_cont_flag, cont_gl_seq , CONT_CONTENT ,cont_form_no};
	SepoaOut value2  = ServiceConnector.doService(info, "CT_021", "TRANSACTION","setContractMakeSave", obj02);   
  	
  	String screen_id="CT_011";
	Configuration conf = new Configuration();
	String domain = conf.getString("sepoa.system.domain.name");
	
	
	
//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
//contractstatus	//계약상태
//_rptData.append(_RF);
//CONT_NO	
//_rptData.append(_RF);
//CONT_GL_SEQ	
//_rptData.append(_RF);
//SUBJECT
//_rptData.append(_RD);
_rptData.append("<html>");
_rptData.append("<head>");
_rptData.append("</head>");
_rptData.append("<body>");
_rptData.append(CONT_CONTENT);////////////////////////////////////////////////////////////////////////////////////////
_rptData.append("</body>");
_rptData.append("</html>");
//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////		  	
%> 

<%!
public static String getHanStr(String number){

	  StringBuffer sb = new StringBuffer();

	  String[] numArr = {"","일","이","삼","사","오","육","칠","팔","구"};

	  // 16자리 어레이로 만들기
	  try{
	   int len = number.length();

	   if(len > 16){
	    throw new Exception("자릿수가 초과했습니다");
	   }

	   int[] snum = new int[16];

	   for(int i = (snum.length-(len)); i< snum.length; i++){

	    int k = i - (snum.length-len);
	    
	    String a = String.valueOf(number.charAt(k));
	    snum[i] = Integer.parseInt(a);
	   
	   }
	   
	  
	   for(int j=0; j<4; j++){

	    int k = (j*4);

	    if(snum[k]+snum[k+1]+snum[k+2]+snum[k+3] >0){

	     if(snum[k] >0){
	      sb.append(numArr[snum[k]]).append("천");
	     }
	     if(snum[k+1] >0){
	      sb.append(numArr[snum[k+1]]).append("백");
	     }
	     if(snum[k+2] >0){
	      sb.append(numArr[snum[k+2]]).append("십");
	     }
	     if(snum[k+3] >0){
	      sb.append(numArr[snum[k+3]]);
	     }

	     switch(j){
	      case 0 : sb.append("조"); break;
	      case 1 : sb.append("억"); break;
	      case 2 : sb.append("만"); break;
	      //case 3 : sb.append("원"); break;                   
	     }

	    }

	   }

	   return sb.toString();
	  
	  }catch(NumberFormatException e){
	   return "";
	  }catch(Exception e){
	   return "";
	  }
	 }
	 
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<SCRIPT language=javascript src="../include/attestation/TSToolkitConfig.js"></script>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<script language="javascript">
	var viewYN = "N";
	function help(){
		var url = "<%=domain%>/help/<%=screen_id%>.htm";
		var toolbar = 'no';
        var menubar = 'no';
        var status = 'yes';
        var scrollbars = 'yes';
        var resizable = 'yes';
        var title = "Help";
        var left = "100";
        var top = "100";
        var width = "800";
        var height = "600";
        var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        code_search.focus();

	}
	
	function init() {
	}
	
	function doRowSelect(cont_form_no, dont_form_no) {
		var params = "";
	    params += "&cont_form_no=" + encodeUrl(cont_form_no);
	    params += "&dont_form_no=" + encodeUrl(dont_form_no);
	    
		
		popUpOpen("document_form_regist_update.jsp?pagemove=Y&popup_flag=true&input_flag=U&flag=Y" + params, 'DONT_FORM_NAME', '800', '600');
	}
	
	function setContractSave() {
	//	var cont_pass = document.form.content.value;
	//document.form.content.value = encodeUrl(cont_pass);
		if(viewYN == "N"){
			alert("미리보기 후 전자계약을 생성하세요.");
			return;
		}
		
		if (confirm("전자계약을 생성 하시겠습니까?")) {
			document.form.method = "POST";
			document.form.action = "contract_make_insert_save.jsp";
			document.form.submit();
		}
	}
	
	function setAttach(attach_key, arrAttrach, attach_count) {
//		document.form.in_attach_no.value = attach_key;
//		document.form.in_attach_cnt.value = attach_count;
	}
	
	function goPage() {
		location.href = "contract_create_list.jsp";
	}
	
	function filePop(){
   		var w_dim  = new Array(2);
		    w_dim  = ToCenter(400, 640);
		var w_top  = w_dim[0];
		var w_left = w_dim[1];
   		
   		var TYPE       = "NOT";
   		var attach_key = document.form.in_attach_no.value;
		var view_type  = "";
		var rowId      = "";
		
   		win = window.open("<%=POASRM_CONTEXT_NAME%>/sepoafw/file/file_attach.jsp?rowId="+rowId+"&type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=620, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
	}
	
    function setAttach(attach_key, arrAttrach, rowId, attach_count){
		document.form.in_attach_no.value  = attach_key;
		document.form.in_attach_cnt.value = attach_count;
    }
    
    <%-- ClipReport4 리포터 호출 스크립트 --%>
    function clipPrint(rptAprvData,approvalCnt) {
    	viewYN = "N";
    	//alert(document.form.rptData.value);
    	if(typeof(rptAprvData) != "undefined"){
    		document.form.rptAprvUsed.value = "Y";
    		document.form.rptAprvCnt.value = approvalCnt;
    		document.form.rptAprv.value = rptAprvData;
        }
        var url = "/ClipReport4/ClipViewer.jsp";
    	//url = url + "?BID_TYPE=" + bid_type;	
        var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
    	document.form.method = "post";
    	document.form.action = url;
    	document.form.target = cwin.name;
    	document.form.submit(); 
    	cwin.focus();
    	cwin.opener = self;
    	viewYN = "Y";
    }
    </Script>
</Script>

<style>
.scroll {
	scrollbar-face-color: #E5E5E5;
	scrollbar-shadow-color: #E5E5E5;
	scrollbar-highlight-color: #E5E5E5;
	scrollbar-3dlight-color: #ffffff;
	scrollbar-darkshadow-color: #ffffff;
	scrollbar-track-color: #F8F8F8;
	scrollbar-arrow-color: #ffffff;
}

</style>

</head>

<body leftmargin="15" topmargin="6" onload="init()">
<s:header>
<script language="javascript" src="../include/attestation/TSToolkitObject.js"></script>
<form id="form" name="form">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot").replaceAll("\\\\", "￦")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>
<input type="hidden" id="cont_no"      	name="cont_no"        	value="<%=cont_no%>">
<input type="hidden" id="cont_gl_seq"  	name="cont_gl_seq"   	value="<%=cont_gl_seq%>">
<input type="hidden" id="ele_cont_flag"	name="ele_cont_flag"  	value="<%=ele_cont_flag%>">
<input type="hidden" id="cont_form_no" 	name="cont_form_no"  	value="<%=cont_form_no%>">

<%

thisWindowPopupFlag = "true";
thisWindowPopupScreenName = "계약서작성";
//thisWindowPopupScreenName = "계약서작성"+in_val_cont_vat.length(); 
 
	//String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	//if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>

<%@ include file="/include/sepoa_milestone.jsp"%>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table> 

<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td style="padding:5 5 5 0" align="right">
			<TABLE cellpadding="2" cellspacing="0">
				<TR>
					<td><script language="javascript">btn("javascript:clipPrint()","미리보기")</script></td>
			  		<td><script language="javascript">btn("javascript:setContractSave()","계약생성")</script></td>
			  	  	<td><script language="javascript">btn("javascript:goPage()","목록")</script></td>
			  	</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>    	

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table> 	


<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
				    		<tr>
		        				<td class="data_td" width="100%" style="height: 500px;" colspan="2" >
		       		       			<%-- div style="width:100%; height:100%; overflow-x;scroll; overflow-y:scroll; word-break:break-all; " --%>
		       		    				<%=CONT_CONTENT%>
		       		       			<%-- /div --%>
		        				</td>
	        	    		</tr>  
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>	        	    		
							<tr>
								<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>							
								<td class="data_td" >
									<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="15%">
<script language="javascript">
function setAttach(attach_key, arrAttrach, rowid, attach_count) {
	document.getElementById("in_attach_no").value = attach_key;
	document.getElementById("attach_no_count").value = attach_count;
}

btn("javascript:attach_file(document.getElementById('in_attach_no').value, 'TEMP');", "파일등록");
</script>
											</td>
											<td>
												<input type="text" size="3" readOnly class="input_empty" value="0" name="attach_no_count" id="attach_no_count"/>
												<input type="hidden" value="" name="in_attach_no" id="in_attach_no">
											</td>
										</tr>
									</table>
								</td>
				    		</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</s:header>
<s:footer/>
</body>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>