<%@ page language="java" contentType="text/html; charset=euc-kr" %>   
     
<%--    
/*******************************************************************************
 ** ���α׷��� : WJOHC01.jsp
 ** ��      �� : ���(����, ��ǥ, ����)
 ** ��  ��  �� : 
 **              
 ** ��  ��  �� : �� �� ��
 ** ��  ��  �� : 2002.05.03 
 ******************************************************************************* 
 ** ��  ��  �� :
 ** ��  ��  �� :
 ** ����  ���� :
 *******************************************************************************/
--%>

<%@ page info="�ŷ�����ȸ : ���(����, ��ǥ, ����)" %>

<%@ include file="WJOGT71.jsp" %> <%-- ���� Ŭ���� --%>
<%@ include file="WJOGT21.jsp" %> <%-- ���� ���̺귯�� --%>
<%@ include file="WJOGT72.jsp" %> <%-- ���� �������� --%>

<%
	/************************************************************************************/	
	strJspStep = "���� ��������(�ʱ�ȭ)";
	strJspName = "WJOHC01.jsp";
	strJspInfo = "���(����, ��ǥ, ����)";
	INT_DEBUG_LEVEL = 10;  //���� Ŭ���� �ڼ��� ����� ��� ���...	
	/************************************************************************************/	
%>
<%  
	/************************************************************************************/	
try 
{ 
	/************************************************************************************/	
%>                     

<%@ include file="WJOGT24.jsp" %> <%-- ���۽ð� ����ϱ� --%>
<%@ include file="WJOGT25.jsp" %> <%-- �������� Ȯ���ϱ�, �������� �о���� --%>
<%@ include file="WJOGT26.jsp" %> <%-- �����ͺ��̽� ���� --%>

<%
	/************************************************************************************/	
	strJspStep = "���� ���� �� �ʱ�ȭ"; 

	if (INT_DEBUG_LEVEL >= 1) //System.out.println(strJspName + ":" + strJspStep);
	System.err.println(getCurrentDate("yyyy-MM-dd hh:mm:ss") + " >" + strJspName + ":" + strJspStep);

	strPtyGubunCd = (request.getParameter("forPtyGubunCd") == null) ? "" : request.getParameter("forPtyGubunCd");	//��±����ڵ�	
	strPftGubunCd = (request.getParameter("forPftGubunCd") == null) ? "" : request.getParameter("forPftGubunCd");	//���ı����ڵ�

	String strRequestDate = (request.getParameter("forRequestDate") == null) ? "" : request.getParameter("forRequestDate");	//��û����
	String strJumBankCd = (request.getParameter("forJumBankCd") == null) ? "" : request.getParameter("forJumBankCd");		//��û�� �����ڵ�
	String strJiJumCd = (request.getParameter("forJiJumCd") == null) ? "" : request.getParameter("forJiJumCd");				//�����ڵ�
	String strSeqNo = (request.getParameter("forSeqNo") == null) ? "" : request.getParameter("forSeqNo");					//�Ϸù�ȣ
	strPortNumber = (request.getParameter("forPortNumber") == null) ? "" : request.getParameter("forPortNumber");	//�����Ʈ��ȣ	
	String strTgQry_Date = (request.getParameter("forTgQry_Date") == null) ? "" : request.getParameter("forTgQry_Date");	//�����Ʈ��ȣ
	
	String strQryGbn = (request.getParameter("forQryGbn") == null) ? "" : request.getParameter("forQryGbn"); 				//�����ڷ�
	String strQryDay = (request.getParameter("forQryDay") == null) ? "" : request.getParameter("forQryDay"); 				//�����ڷ�, ����ڷ�
	String strQryCdt = (request.getParameter("forQryCdt") == null) ? "" : request.getParameter("forQryCdt");
	String strQryBnk = (request.getParameter("forQryBnk") == null) ? "" : request.getParameter("forQryBnk");
	String strQryBnk1 = (request.getParameter("forQryBnk1") == null) ? "" : request.getParameter("forQryBnk1");
	String strShJobGubun = (request.getParameter("forShJobGubun") == null) ? "" : request.getParameter("forShJobGubun"); 	//������Ȳ
	String strShBnkGubun = (request.getParameter("forShBnkGubun") == null) ? "" : request.getParameter("forShBnkGubun"); 	//������Ȳ
	String strShJuminNum = (request.getParameter("forShJuminNum") == null) ? "" : request.getParameter("forShJuminNum"); 	//������Ȳ
	String strShOwnerNme = (request.getParameter("forShOwnerNme") == null) ? "" : request.getParameter("forShOwnerNme"); 	//������Ȳ
	String strShGogakNum = (request.getParameter("forShGogakNum") == null) ? "" : request.getParameter("forShGogakNum"); 	//������Ȳ
	String strShAccntNum = (request.getParameter("forShAccntNum") == null) ? "" : request.getParameter("forShAccntNum"); 	//������Ȳ
	String strTbQrySelect = (request.getParameter("forTbQrySelect") == null) ? "" : request.getParameter("forTbQrySelect"); //����뺸
	
	String strSearchDate = (request.getParameter("forSearchDate") == null) ? "" : request.getParameter("forSearchDate"); 
	String strQueryDateFm = (request.getParameter("forQueryDateFm") == null) ? "" : request.getParameter("forQueryDateFm").trim();
	String strQueryDateTo = (request.getParameter("forQueryDateTo") == null) ? "" : request.getParameter("forQueryDateTo").trim();	
	
	String strReqBankCd = (request.getParameter("forReqBankCd") == null) ? "" : request.getParameter("forReqBankCd");	// ��ȸ��û �����ڵ�
	String strReqBranchCd = (request.getParameter("forReqBranchCd") == null) ? "" : request.getParameter("forReqBranchCd");	// ��ȸ��û ���� �ڵ�
	String strReqUserID = (request.getParameter("forUserID") == null) ? strUserID : request.getParameter("forUserID");	// ��û�� ID 
	String strReqDate = (request.getParameter("forReqDate") == null) ? "" : request.getParameter("forReqDate");		// ��ȸ��û����

	String strBankJj = (request.getParameter("forBankJj") == null) ? "20" : request.getParameter("forBankJj");
	String strBbUserJj = (request.getParameter("forBbUserJj") == null) ? "700" : request.getParameter("forBbUserJj");
	String strBbUserNo = (request.getParameter("forBbUserNo") == null) ? "" : request.getParameter("forBbUserNo");
	String strBbUserNm = (request.getParameter("forBbUserNm") == null) ? "" : request.getParameter("forBbUserNm");
	String strDownGbn = (request.getParameter("forDownGbn") == null) ? "" : request.getParameter("forDownGbn");
	String strTeamNm = (request.getParameter("forTeamNm") == null) ? "" : request.getParameter("forTeamNm");
	String strPermitGbn = (request.getParameter("forPermitGbn") == null) ? "1" : request.getParameter("forPermitGbn");
	String strJobGubunCd = (request.getParameter("forJobGubunCd") == null) ? "1" : request.getParameter("forJobGubunCd");	//������ ������ȸ
	
	String strFaxNum = (request.getParameter("forFaxNum ") == null) ? "" : request.getParameter("forFaxNum ");
	String strIBGbn = (request.getParameter("forIBGbn") == null) ? " " : request.getParameter("forIBGbn");	//�䱸�� ��������
	String strSearchText = (request.getParameter("forSearchText") == null) ? " " : request.getParameter("forSearchText");	//�䱸�� �˻�����
	String strSchGbn = (request.getParameter("forSchGbn") == null) ? " " : request.getParameter("forSchGbn");	//�䱸�� �˻�����
	String strSearchBlank = "";
	String strBonbuGbn = "";
	
	String strMultiCnt = (request.getParameter("forMultiCnt") == null) ? " " : request.getParameter("forMultiCnt");	//�뷮���� ���� �Ǽ�
	String strMultiVal = (request.getParameter("forMultiVal") == null) ? " " : request.getParameter("forMultiVal");	//�뷮���� ���� ����
	String strBankJumSeqVal = (request.getParameter("forBankJumSeqVal") == null) ? " " : request.getParameter("forBankJumSeqVal");	//���õ� �׸���� �Ƿ������ڵ�+�Ƿ����ڵ�+�Ϸù�ȣ�� ����,,,  2010012345678(�ϳ� ���ý� 13�ڸ�, �ΰ� ���ý� 26�ڸ�.....)
	String strQryBnkJjm = (request.getParameter("forQryBnkJjm") == null) ? " " : request.getParameter("forQryBnkJjm");	//�����ڷ���ȸ�� �˻����� ����(5�ڸ���)

	String strDmno = (request.getParameter("forDmno") == null) ? " " : request.getParameter("forDmno");	//�ܸ���ȣ
	String strTlno = (request.getParameter("forTlno") == null) ? " " : request.getParameter("forTlno");	//�ڷ���ȣ

	String strSsr_Gb = (request.getParameter("Ssr_Gb") == null) ? " " : request.getParameter("Ssr_Gb");	//�������������
	String strSoonabGb = (request.getParameter("SelectSoonabGb") == null) ? " " : request.getParameter("SelectSoonabGb");	//����Ʈ���г���
	String strMynjeGb = (request.getParameter("SelectMynjeGb") == null) ? " " : request.getParameter("SelectMynjeGb");	//�����ᰨ���ڵ�
	String strSsr_Am = (request.getParameter("forSsr_Am") == null) ? " " : request.getParameter("forSsr_Am");	//������ݾ�
  String strSucFal_gb = (request.getParameter("forSucFal_gb") == null) ? " " : request.getParameter("forSucFal_gb");	//��¼�������


/*	System.err.println("strUserBankCd  (" + strUserBankCd  + ")");		
	System.err.println("strSosokJumCd  (" + strSosokJumCd  + ")");		
	System.err.println("strSeqNo       (" + strSeqNo       + ")");		
	System.err.println("strRequestDate (" + strRequestDate + ")");		
	System.err.println("strUserID      (" + strUserID      + ")");		*/

  String strOutseqno     = "";
  String strBsccd        = "";
  String strTicticno     = "";
  String strTellerno     = "";
  String strPnt_Clss     = "";
  String strFerdu_Rsn_Cd = "";
  String strSsrssram     = "";
  String strFcst_Fee_Am  = "";
  String strTmnseqno     = "";
  String Strjobjobgb     = "";
  String strRefbnkcd     = "";
  String strRefchkno     = "";
  String strIngfdtdt     = "";
  String strIngfshdt     = "";
  String strIngcltnm     = "";
  String strDmddmdny     = "";
  String strStsstscd     = "";
  String strJmdjmdno     = "";
  String strOutouttm     = "";
  String strOutfmtgb     = "";
  String strOutrptct     = "";
  String strSumyungb     = ""; 
  String strOutoutgb     = "0";
  String strBelbrnnm     = "";
  String strBelhvbnm     = "";
 	int    iBeforeCnt      = 0;
 	String strDdu_Mb_Pnt_Am= "";
 	String strMb_Pnt_Rdu_Cd= "";
 	String strAdd_Rdu_Cd   = "";
 	String strAdd_Rdu_Am   = "";
 	String strHjmb_Pnt     = "";
 	

  String strCurrentdt    = "";
  String strRtnMsg       = "";
	int iMsglen = 0;
  String retCd           = "";
  int iPointGb = 0;
	
  strQuery1 = "{call SUOJS08 (?, ?, ?, ?, ?)}"; 
  intParCnt = 5;
  strParData[0] = "Q";
  strParData[1] = strUserBankCd;
  strParData[2] = strSosokJumCd;
  strParData[3] = strSeqNo;
  strParData[4] = strRequestDate;
  strParData[5] = strUserID;
    
    	/************************************************************************************/	
%>
    
<%@ include file="WJOGT51.jsp" %> <%-- �����ͺ��̽� ��ȸ --%>
     
<%
    
  if (rset1 != null){
      rset1.next(); 
  
      strOutseqno     = rset1.getString( 1);  /* ������� */
      strBsccd        = rset1.getString( 2);  /* BSC�ڵ�  */
      strTicticno     = rset1.getString( 3);  /* ��ǥ��ȣ */
      strTellerno     = rset1.getString( 4);  /* �ڷ���ȣ */
      strPnt_Clss     = rset1.getString( 5);  /* ������� 1:���� 2:����Ʈ */
      strFerdu_Rsn_Cd = rset1.getString( 6);  /* ������������� 0:���� 1:������� 2:�Ұ��μ����� 5:100%������� */
      strSsrssram     = rset1.getString( 7);  /* ������ݾ� */
      strFcst_Fee_Am  = rset1.getString( 8);  /* ��������   */
      strTmnseqno     = rset1.getString( 9);  /* �ܸ���ȣ   */
      Strjobjobgb     = rset1.getString(10);  /* ��������   */
      strRefbnkcd     = rset1.getString(11);  /* ���������ڵ� */
      strRefchkno     = rset1.getString(12);  /* ��°��¹�ȣ */
      strIngfdtdt     = rset1.getString(13);  /* ��ȸ����     */
      strIngfshdt     = rset1.getString(14);  /* ��ȸ����     */
      strIngcltnm     = rset1.getString(15);  /* �Ƿ���       */
      strDmddmdny     = rset1.getString(16);  /* �Ƿ��ڵ�     */
      strStsstscd     = rset1.getString(17);  /* �����ڵ� (��������Ϸ� : 10) */
      strJmdjmdno     = rset1.getString(18);  /* �����ֹι�ȣ */
      strOutouttm     = rset1.getString(19);  /* ��½ð�     */
      strOutfmtgb     = rset1.getString(20);  /* ��±���     */
      strOutrptct     = rset1.getString(21);  /* ��¸ż�     */
      strSumyungb     = rset1.getString(22);  /* ������������� */
      strOutoutgb     = rset1.getString(23);  /* ������¿ϷῩ�� */
      strBelbrnnm     = rset1.getString(24);  /* ����             */
      strBelhvbnm     = rset1.getString(25);  /* ��������ڸ�     */
    	iBeforeCnt      = Integer.parseInt(rset1.getString(26));  /* ���� ����� ��ǿ��� */
      strDdu_Mb_Pnt_Am= rset1.getString(27);  /* �������������Ʈ�ݾ� */
      strMb_Pnt_Rdu_Cd= rset1.getString(28);  /* ���������Ʈ�����ڵ� */
      strAdd_Rdu_Cd   = rset1.getString(29);  /* �߰������ڵ�      */   
      strAdd_Rdu_Am   = rset1.getString(30);  /* �߰�����ݾ�      */   
      strHjmb_Pnt     = rset1.getString(31);  /* ������������Ʈ  */   
      strCurrentdt    = getCurrentDate("yyyyMMdd");
  }
  
	if (INT_DEBUG_LEVEL >= 2) 
	{
	    System.err.println("strOutseqno     : " + strOutseqno    );		
	    System.err.println("strBsccd        : " + strBsccd       );		
	    System.err.println("strTicticno     : " + strTicticno    );		
	    System.err.println("strTellerno     : " + strTellerno    );		
	    System.err.println("strPnt_Clss     : " + strPnt_Clss    );		
	    System.err.println("strFerdu_Rsn_Cd : " + strFerdu_Rsn_Cd);		
	    System.err.println("strSsrssram     : " + strSsrssram    );		
	    System.err.println("strFcst_Fee_Am  : " + strFcst_Fee_Am );		
	    System.err.println("strTmnseqno     : " + strTmnseqno    );		
	    System.err.println("Strjobjobgb     : " + Strjobjobgb    );		
	    System.err.println("strRefbnkcd     : " + strRefbnkcd    );		
	    System.err.println("strRefchkno     : " + strRefchkno    );		
	    System.err.println("strIngfdtdt     : " + strIngfdtdt    );		
	    System.err.println("strIngfshdt     : " + strIngfshdt    );		
	    System.err.println("strIngcltnm     : " + strIngcltnm    );		
	    System.err.println("strDmddmdny     : " + strDmddmdny    );		
	    System.err.println("strStsstscd     : " + strStsstscd    );		
	    System.err.println("strJmdjmdno     : " + strJmdjmdno    );		
	    System.err.println("strOutouttm     : " + strOutouttm    );		
	    System.err.println("strOutfmtgb     : " + strOutfmtgb    );		
	    System.err.println("strOutrptct     : " + strOutrptct    );		
	    System.err.println("strSumyungb     : " + strSumyungb    );		
	    System.err.println("strOutoutgb     : " + strOutoutgb    );		      
	    System.err.println("strBelbrnnm     : " + strBelbrnnm    );		      
	    System.err.println("strBelhvbnm     : " + strBelhvbnm    );		 
	    System.err.println("iBeforeCnt      : " + iBeforeCnt     );		 
	    System.err.println("strDdu_Mb_Pnt_Am: " + strDdu_Mb_Pnt_Am);		
	    System.err.println("strMb_Pnt_Rdu_Cd: " + strMb_Pnt_Rdu_Cd);		
	    System.err.println("strAdd_Rdu_Cd   : " + strAdd_Rdu_Cd   );		
	    System.err.println("strAdd_Rdu_Am   : " + strAdd_Rdu_Am   );		
	    System.err.println("strHjmb_Pnt     : " + strHjmb_Pnt     );		

      System.err.println( getCurrentDate("yyyyMMdd"));
	    System.err.println("strPtyGubunCd   : " + strPtyGubunCd    );		
	    System.err.println("strSucFal_gb   : " + strSucFal_gb    );		
	          

	}

/* 
   1. ��ǥ���̾ƿ�
   
      1����(76)                       2����(70)                   3����(������)
   
       ȭ���ȣ         6               �����ڵ�           3
       ��������        10               ����               1
       �ŷ���          10               ���¹�ȣ          17
       ����             1               ����               1
       �ŷ��ú�         5               �����뱸��         1
       �������         6               ����               1
       ���ڵ�           5               �����ᰨ���ڵ�     3
       ����             1               ����               1
       �ܸ���ȣ         4               NET����            1
       �����ڼ���      10               ������          16 
       �ڷ���ȣ         4               å���ڹ�ȣ         8
       ����             1               �ŷ��ݾ�          17
       ��ǥ����         1               
       ����             1               
       ��ǥ��ȣ         5               
       ��������         6               
   
*/
/*
 strSumyungb = "Y";
 strFerdu_Rsn_Cd = "0";
 strPnt_Clss = "1";
*/
%>
 	<HTML>
 	<HEAD>
  <SCRIPT LANGUAGE="JavaScript">	
  function fn_sleep(msecs){
  	var start = new Date().getTime();
  	var cur = start;
  	while(cur-start<msecs){
  	   cur=new Date().getTime();
  	}
  }
  	
	function PrintPBPR()
	{
		
		var strData = "";
		var strDmno = "";
		var strTlno = "";
		var strJmno = "";
		var iGeri   = 0;

<% 
 /* �ܸ���ȣ���̰� 9���� ������ �������� ó���Ѵ� */
if (strTmnseqno.length() < 9){
     strTmnseqno = "";
}

%>

/*  ���������� ��� ����Ϸ� �Ȱ͸� �������� */
/*  ���� ��ü �����϶��� ��ǥ�߻��Ѵ�. (�������߱��Ƿڼ�,������ ����)*/		
<%	if( strSucFal_gb.equals("0") && strSumyungb.equals("Y") && strFerdu_Rsn_Cd.equals("0") && (strPnt_Clss.equals("1") || strPnt_Clss.equals("2"))){ %>

/*      �۾��� ���������� �Ϸ� �Ǿ������� �ļ��۾� �����Ѵ� */		
<%    	if(  (((strPtyGubunCd.equals("2")) || (strPtyGubunCd.equals("7"))) && strStsstscd.equals("06")) ||
             (((strPtyGubunCd.equals("1")) || (strPtyGubunCd.equals("4"))) && strStsstscd.equals("10")) ){ %>

            /* WEB���� �踮�� �߻���Ų�� (ó������ DB���� �踮 �߻������� ��Һп� ���� �����Ұ��� WEB���� ����) */
<%
		        /* ��ǥ��ȣ�� ���õǾ ������ ����ó���Ѵ� */
		        if( !strTicticno.trim().equals("")){
	               strBsccd = "����ó�������� Ȯ���ϼ���"; /* �����޼��� */
                 
	               /* ������ó�� ������Ʈ :�踮ó�� ������ �����ڷῡ �������� ������Ʈ �Ѵ�*/
	               /*strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}";       */
	               /*intParCnt = 4;                                   */
	               /*strParData[0] = "U";                             */
	               /*strParData[1] = strUserBankCd+strSosokJumCd;     */
	               /*strParData[2] = strUserID;                       */
	               /*strParData[3] = strOutseqno;                     */
	               /*strParData[4] = "U";                             */
		        
		        }else{
		             strSendString =  WVOGT04.padding("0", 1);		/* ��û ����  (0 ������ ���� , 1 ���������)  */
		             strSendString += WVOGT04.padding(strUserBankCd, 2)/* �����������ڵ�    */                                                            
		             			   + WVOGT04.padding(strSosokJumCd, 3)       /* �����������ڵ�    */                                                            
		             			   + WVOGT04.padding(strTmnseqno, 9) 		/* �ܸ���ȣ          */                                                            
		             			   + WVOGT04.padding(strUserID, 8)    	/* ������ ���       */                                                            
		             			   + WVOGT04.padding(strRefchkno, 21) 	/* ���¹�ȣ          */                                                            
		             			   + WVOGT04.padding(strSsrssram, 7) 		/* �ݾ�              */    
		             			   + WVOGT04.padding(strPnt_Clss, 1) 		/* 1:���� 2:��ü     */    
		             			   + WVOGT04.padding("1", 1) 				    /* ����1, ���2      */                                                            
		             			   + WVOGT04.padding(strJmdjmdno, 13); 	/* �ֹι�ȣ          */                                                            
                 
		             WVOGT02 sc = new WVOGT02(6000);		
		             strRtnMsg = sc.commMessage(strSendString);		

	    System.err.println("strSendString     : " + strSendString    );		 
	    System.err.println("strRtnMsg         : " + strRtnMsg     );		 

                 
		             iMsglen = strRtnMsg.length();
		             if(iMsglen > 0){
		                 retCd  = strRtnMsg.substring(0,1);
		                 
		                 /* ����ó�� �Ǿ����� */
		                 if(retCd.equals("0")){
                 
                         StringTokenizer stk = new StringTokenizer(strRtnMsg, ";"); 
                         int t = 0;
                         
                         while(stk.hasMoreTokens()){
                             t++;
                             if(t%4==1){
                                   stk.nextToken(); 
                             }else if(t%4==2){ 
	                                 strTicticno = stk.nextToken();  /* ��ǥ��ȣ */
                             }else if(t%4==3){ 
	                                 strOutouttm = stk.nextToken();  /* ��ǥ�ð� */
                             }else if (t%4==0){ 
	                                 strBsccd = stk.nextToken(); /* BSC�ڵ� */
                             } 
                         }
                         
                         /* ��ǥ��ȣ�� �����̸� ����ó�� */
             		         if( strTicticno.trim().equals("")){

	                           strBsccd = "��ǥ��ȣ ����"; /* �����޼��� */

	                           /* ������ó�� ������Ʈ :�踮ó�� ������ �����ڷῡ �������� ������Ʈ �Ѵ�*/
	                           strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	                           intParCnt = 4;
	                           strParData[0] = "U";
	                           strParData[1] = strUserBankCd+strSosokJumCd;
	                           strParData[2] = strUserID;
	                           strParData[3] = strOutseqno;
	                           strParData[4] = "U";
             		         }else{
	                           
	                           /* �̻���:�߰�����ݾ��� �����Ѵٸ� �߰����� ó�� �߻���Ų�� */
	                           if(Integer.parseInt(strAdd_Rdu_Am) > 0){
	                               
	                               strSendString =  WVOGT04.padding("1", 1);		       /* ��û ����  (0 ����Ʈ ��ȸ , 1 ����Ʈ ����, 2  ����Ʈ ���, 4 �����޼���, 5 ��������������)  */
	                               strSendString += WVOGT04.padding(strTmnseqno, 9)    /* �̳��̺����ܸ���ȣ (��ȸ�ÿ��� 20900�� ����)    */ 
	                                             +  WVOGT04.padding(strUserID, 8)      /* �̳��̺�������                                  */ 
	                                             +  WVOGT04.padding(strJmdjmdno, 13)   /* �ֹι�ȣ          */ 
	                                             +  WVOGT04.padding("1058", 4)         /* �����������ڵ�    */
	                                             +  WVOGT04.padding(strFcst_Fee_Am, 9) /* ������ݾ�(�ݵ�ÿ��ݾ�)        */ 
	                                             +  WVOGT04.padding("", 3)             /* ���������Ʈ�����ڵ�      1: ����/����, 2: ����/���� ����϶��� ���� */              
	                                             +  WVOGT04.padding("", 9)             /* �������������Ʈ          1: ����/����, 2: ����/���� ����϶��� ���� */
	                                             +  WVOGT04.padding("2", 1)            /* �������������            1: ����Ʈ���� 2: ����Ʈ�ź�                */
	                                             +  WVOGT04.padding(strAdd_Rdu_Cd, 3)  /* �߰������ڵ�              1: ����/����, 2: ����/���� ����϶��� ���� */
	                                             +  WVOGT04.padding(strAdd_Rdu_Am, 9)  /* �߰����������ݾ�        1: ����/����, 2: ����/���� ����϶��� ���� */
	                                             +  WVOGT04.padding("", 1)             /* ���͸޼�������            1: å���ڿ��� 2: �����ڿ���                */
	                                             +  WVOGT04.padding("", 8)             /* ���͸޽��������ڡ����    4: ���͸޽����϶��� ����                   */
	                                             +  WVOGT04.padding("", 8)             /* �����ڡ����              5: �����ν��϶��� ����                     */
	                                             +  WVOGT04.padding("", 9)             /* �ܸ���ȣ                  5: �����ν��϶��� ����                     */
	                                             +  WVOGT04.padding("", 669);          /* �����νĵ�����            5: �����ν��϶��� ����                     */
	                                                                                          
	                               sc = new WVOGT02(8000);		
	                               strRtnMsg = sc.commMessage(strSendString);		
                                 /* �̻���:����ó�� �����ؾ� �� */

	                           }
	                           
	                           /* ����ó�� ������Ʈ */
	                           strQuery1 = "{call SUOCK03 (?, ?, ?, ?, ?, ?, ?)}"; 
	                           intParCnt = 7;
	                           strParData[0] = "U";
	                           strParData[1] = strUserBankCd+strSosokJumCd;
	                           strParData[2] = strUserID;
	                           strParData[3] = strOutseqno;
	                           strParData[4] = strTicticno;
	                           strParData[5] = strOutouttm;
	                           strParData[6] = strBsccd;
	                           strParData[7] = "N";
	                       }
                 
		                 /* ����ó�� �Ǿ����� */
                     }else if(retCd.equals("1")){
                 
                         StringTokenizer stk = new StringTokenizer(strRtnMsg, ";"); 
                         int t = 0;
                         
                         while(stk.hasMoreTokens()){
                             t++;
                             if(t%2==1){
                                   stk.nextToken(); 
                             }else if (t%2==0){ 
	                                 strBsccd = stk.nextToken(); /* �����޼��� */
                             } 
                         }
                         
	                       /* ������ó�� ������Ʈ :�踮ó�� ������ �����ڷῡ �������� ������Ʈ �Ѵ�*/
	                       strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	                       intParCnt = 4;
	                       strParData[0] = "U";
	                       strParData[1] = strUserBankCd+strSosokJumCd;
	                       strParData[2] = strUserID;
	                       strParData[3] = strOutseqno;
	                       strParData[4] = "U";
                     }else{
                 
                         StringTokenizer stk = new StringTokenizer(strRtnMsg, ";"); 
                         int t = 0;
                         
                         while(stk.hasMoreTokens()){
                             t++;
                             if(t%2==1){
                                   stk.nextToken(); 
                             }else if (t%2==0){ 
	                                 strBsccd = stk.nextToken(); /* �����޼��� */
                             } 
                         }
                 
	                       /* ������ó�� ������Ʈ :�踮ó�� ������ �����ڷῡ �������� ������Ʈ �Ѵ�*/
	                       strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	                       intParCnt = 4;
	                       strParData[0] = "U";
	                       strParData[1] = strUserBankCd+strSosokJumCd;
	                       strParData[2] = strUserID;
	                       strParData[3] = strOutseqno;
	                       strParData[4] = "U";
                     }
                 }else{

	                  System.err.println(" �踮���Ϸα� �����������ڵ�  : " + strUserBankCd );		
	                  System.err.println(" �踮���Ϸα� �����������ڵ�  : " + strSosokJumCd );		
	                  System.err.println(" �踮���Ϸα� �ܸ���ȣ        : " + strTmnseqno   );		
	                  System.err.println(" �踮���Ϸα� ������ ���     : " + strUserID     );		
	                  System.err.println(" �踮���Ϸα� ���¹�ȣ        : " + strRefchkno   );		
	                  System.err.println(" �踮���Ϸα� �ݾ�            : " + strSsrssram   );		
	                  System.err.println(" �踮���Ϸα� 1:���� 2:��ü   : " + strPnt_Clss   );		
	                  System.err.println(" �踮���Ϸα� ����1, ���2    : " + "1"           );		
	                  System.err.println(" �踮���Ϸα� �ֹι�ȣ        : " + strJmdjmdno   );		
                 }
             }
%>               
<%@ include file="WJOGT51.jsp" %> <%-- �����ͺ��̽� ��ȸ --%>
<%
	           /* ���������� ������Ʈ �Ǿ����� �ļ��۾��� �����Ѵ� */
	           if(retCd.equals("0") && intRVal == 1){
%>            
	    	         /* �����ڵ�Ͽ��� ���� �Ǵ� */
	    	         if(OP_RegGb()==1){
	     		          /* ��ǥ��� */
             
             
	     		          if(confirm("��ǥ�� ���������Ϳ� �־��ֽð� Ȯ���� Ŭ���ϼ���")){
	     		              if(Tic_Print()==1){
	     		              	
	     		              	  fn_sleep(3000);
                        
	     		                  if(confirm("�������߱��Ƿڼ��� ��»����� �����Ͻñ� ���Ͻø� \n�������߱��Ƿڼ��� ���������Ϳ� �־��ֽð� Ȯ���� Ŭ���ϼ���")){
	     		                      Jesingo_Print();
	     		                  }
	     		              	  fn_sleep(3000);
	     		              	  
	     		                  if(confirm("�������� ����Ͻñ� ���Ͻø� \n���뿵������ ���������Ϳ� �־��ֽð� Ȯ���� Ŭ���ϼ���")){
	     		                      YoungSoo_Print();
	     		                  }
	     		              }
	     		          }
	    	         }
	    	         
	    	         /* ��ü�Ա�������� 122001 �ŷ� ȣ�� */
<%    	         if(strPnt_Clss.equals("2")){ %>
	    	             SendMQ();
<%    	         }%>
             
<%           }else{ %>
	                alert("[<%=strBsccd%>]\n\n\n���� ���� ������ �踮ó�������� �߻��߽��ϴ�.");
	             	 return;
<%           }%>

<%       }else{ %>
	     		  alert("�۾� ������ �߻��Ͽ� �߰� ������ �Ұ��մϴ�.");
	      	  return;
<%       }  %>


/*  ����Ʈ�����϶��� �������߱��Ƿڼ�,�������� ��� �����Ѵ� */
<%   }else if(strSucFal_gb.equals("0") && strSumyungb.equals("Y") && strFerdu_Rsn_Cd.equals("0") && strPnt_Clss.equals("3")){ %>

/*      �۾��� ���������� �Ϸ� �Ǿ������� �ļ��۾� �����Ѵ� */		
<%    	if(  (((strPtyGubunCd.equals("2")) || (strPtyGubunCd.equals("7"))) && strStsstscd.equals("06")) ||
             (((strPtyGubunCd.equals("1")) || (strPtyGubunCd.equals("4"))) && strStsstscd.equals("10")) ){ %>
<%	               
		        /* �ܸ���ȣ�� �������� ������ ����ó���Ѵ� */
		        if( strTmnseqno.trim().equals("")){
	               strBsccd = "�ܸ���ȣ ����"; /* �����޼��� */
                 
	               /* ������ó�� ������Ʈ :�踮ó�� ������ �����ڷῡ �������� ������Ʈ �Ѵ�*/
	               strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	               intParCnt = 4;
	               strParData[0] = "U";
	               strParData[1] = strUserBankCd+strSosokJumCd;
	               strParData[2] = strUserID;
	               strParData[3] = strOutseqno;
	               strParData[4] = "U";
	               
	               iPointGb = 1;
		         
		        }else{
	               strSendString =  WVOGT04.padding("1", 1);		        /* ��û ����  (0 ����Ʈ ��ȸ , 1 ����Ʈ ����, 2  ����Ʈ ���, 4 �����޼���, 5 ��������������)  */
	               strSendString += WVOGT04.padding(strTmnseqno, 9)     /* �̳��̺����ܸ���ȣ (��ȸ�ÿ��� 20900�� ����)    */ 
	                             +  WVOGT04.padding(strUserID, 8)       /* �̳��̺�������                                  */ 
	                             +  WVOGT04.padding(strJmdjmdno, 13)    /* �ֹι�ȣ          */ 
	                             +  WVOGT04.padding("1058", 4)          /* �����������ڵ�    */
	                             +  WVOGT04.padding(strFcst_Fee_Am, 9)  /* ������ݾ�(�ݵ�ÿ��ݾ�)        */ 
	                             +  WVOGT04.padding(strMb_Pnt_Rdu_Cd, 3)/* ���������Ʈ�����ڵ�      1: ����/����, 2: ����/���� ����϶��� ���� */              
	                             +  WVOGT04.padding(strSsrssram, 9)     /* �������������Ʈ          1: ����/����, 2: ����/���� ����϶��� ���� */
	                             +  WVOGT04.padding("1", 1)             /* �������������            1: ����Ʈ���� 2: ����Ʈ�ź�                */
	                             +  WVOGT04.padding(strAdd_Rdu_Cd, 3)   /* �߰������ڵ�              1: ����/����, 2: ����/���� ����϶��� ���� */
	                             +  WVOGT04.padding(strAdd_Rdu_Am, 9)   /* �߰����������ݾ�        1: ����/����, 2: ����/���� ����϶��� ���� */
	                             +  WVOGT04.padding("", 1)              /* ���͸޼�������            1: å���ڿ��� 2: �����ڿ���                */
	                             +  WVOGT04.padding("", 8)              /* ���͸޽��������ڡ����    4: ���͸޽����϶��� ����                   */
	                             +  WVOGT04.padding("", 8)              /* �����ڡ����              5: �����ν��϶��� ����                     */
	                             +  WVOGT04.padding("", 9)              /* �ܸ���ȣ                  5: �����ν��϶��� ����                     */
	                             +  WVOGT04.padding("", 669);           /* �����νĵ�����            5: �����ν��϶��� ����                     */
	                                                                          
	               WVOGT02 sc = new WVOGT02(8000);		
	               strRtnMsg = sc.commMessage(strSendString);		
	               
		             iMsglen = strRtnMsg.length();
		             if(iMsglen > 0){
		                 retCd  = strRtnMsg.substring(0,1);
		                 
		                 /* ����ó�� �Ǿ����� */
		                 if(retCd.equals("0")){
	               
	                       iPointGb = 0;

	                       /* ����ó�� ������Ʈ */
	                       strQuery1 = "{call SUOCK03 (?, ?, ?, ?, ?, ?, ?)}"; 
	                       intParCnt = 7;
	                       strParData[0] = "U";
	                       strParData[1] = strUserBankCd+strSosokJumCd;
	                       strParData[2] = strUserID;
	                       strParData[3] = strOutseqno;
	                       strParData[4] = "";
	                       strParData[5] = strOutouttm;
	                       strParData[6] = "";
	                       strParData[7] = "N";

                 
		                 /* ����ó�� �Ǿ����� */
                     }else{
                 
                         StringTokenizer stk = new StringTokenizer(strRtnMsg, ";"); 
                         int t = 0;
                         
                         while(stk.hasMoreTokens()){
                             t++;
                             if(t%2==1){
                                   stk.nextToken(); 
                             }else if (t%2==0){ 
	                                 strBsccd = stk.nextToken(); /* �����޼��� */
                             } 
                         }
                 
	                       /* ������ó�� ������Ʈ :�踮ó�� ������ �����ڷῡ �������� ������Ʈ �Ѵ�*/
	                       strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	                       intParCnt = 4;
	                       strParData[0] = "U";
	                       strParData[1] = strUserBankCd+strSosokJumCd;
	                       strParData[2] = strUserID;
	                       strParData[3] = strOutseqno;
	                       strParData[4] = "U";
        
        	               iPointGb = 1;

                     }
                 }else{
        	           iPointGb = 1;
                 }
             }	           
%>
<%@ include file="WJOGT51.jsp" %> <%-- �����ͺ��̽� ��ȸ --%>
<%
    	         
	           /* ���������� ������Ʈ �Ǿ����� �ļ��۾��� �����Ѵ� */
	           if(retCd.equals("0") && iPointGb ==0){ %>
	    	         /* �����ڵ�Ͽ��� ���� �Ǵ� */
	    	         if(OP_RegGb()==1){
                        
	     		           if(confirm("�������߱��Ƿڼ��� ��»����� �����Ͻñ� ���Ͻø� \n�������߱��Ƿڼ��� ���������Ϳ� �־��ֽð� Ȯ���� Ŭ���ϼ���")){
	     		               Jesingo_Print();
	     		           }
	     		           fn_sleep(3000);
	     		                  	  
	     		           if(confirm("�������� ����Ͻñ� ���Ͻø� \n���뿵������ ���������Ϳ� �־��ֽð� Ȯ���� Ŭ���ϼ���")){
	     		               YoungSoo_Print();
	     		           }
	    	         }
<%    	     }else{%>
	    	     	   alert("[<%=strBsccd%>]\n\n\n���� ���� ������ ����Ʈ���������� �߻��߽��ϴ�.");
	             	 return;
<%	         }

         }else{ %>
	     		  //alert("�۾� ������ ������ �Ұ��մϴ�.");
	      	  return;
<%       }  %>
/*  ó������̸鼭 ����������϶��� �������߱��Ƿڼ��� ��� �����Ѵ� */
<%   }else if(iBeforeCnt ==1 && strSucFal_gb.equals("0") && strSumyungb.equals("N") && !strFerdu_Rsn_Cd.equals("0")){ %>
/*      �۾��� ���������� �Ϸ� �Ǿ������� �ļ��۾� �����Ѵ� */		
<%    	if(  (((strPtyGubunCd.equals("2")) || (strPtyGubunCd.equals("7"))) && strStsstscd.equals("06")) ||
             (((strPtyGubunCd.equals("1")) || (strPtyGubunCd.equals("4"))) && strStsstscd.equals("10")) ){ %>

<%
             /* 100%��������̸� ����ݾ��� �α������ؼ� �ø��� */
             if(strFerdu_Rsn_Cd.equals("5")){

	               strSendString =  WVOGT04.padding("1", 1);		        /* ��û ����  (0 ����Ʈ ��ȸ , 1 ����Ʈ ����, 2  ����Ʈ ���, 4 �����޼���, 5 ��������������)  */
	               strSendString += WVOGT04.padding(strTmnseqno, 9)     /* �̳��̺����ܸ���ȣ (��ȸ�ÿ��� 20900�� ����)    */ 
	                             +  WVOGT04.padding(strUserID, 8)       /* �̳��̺�������                                  */ 
	                             +  WVOGT04.padding(strJmdjmdno, 13)    /* �ֹι�ȣ          */ 
	                             +  WVOGT04.padding("1058", 4)          /* �����������ڵ�    */
	                             +  WVOGT04.padding(strFcst_Fee_Am, 9)  /* ������ݾ�(�ݵ�ÿ��ݾ�)        */ 
	                             +  WVOGT04.padding("", 3)              /* ���������Ʈ�����ڵ�      1: ����/����, 2: ����/���� ����϶��� ���� */              
	                             +  WVOGT04.padding("", 9)              /* �������������Ʈ          1: ����/����, 2: ����/���� ����϶��� ���� */
	                             +  WVOGT04.padding("2", 1)             /* �������������            1: ����Ʈ���� 2: ����Ʈ�ź�                */
	                             +  WVOGT04.padding(strAdd_Rdu_Cd, 3)   /* �߰������ڵ�              1: ����/����, 2: ����/���� ����϶��� ���� */
	                             +  WVOGT04.padding(strAdd_Rdu_Am, 9)   /* �߰����������ݾ�        1: ����/����, 2: ����/���� ����϶��� ���� */
	                             +  WVOGT04.padding("", 1)              /* ���͸޼�������            1: å���ڿ��� 2: �����ڿ���                */
	                             +  WVOGT04.padding("", 8)              /* ���͸޽��������ڡ����    4: ���͸޽����϶��� ����                   */
	                             +  WVOGT04.padding("", 8)              /* �����ڡ����              5: �����ν��϶��� ����                     */
	                             +  WVOGT04.padding("", 9)              /* �ܸ���ȣ                  5: �����ν��϶��� ����                     */
	                             +  WVOGT04.padding("", 669);           /* �����νĵ�����            5: �����ν��϶��� ����                     */
                 
	               WVOGT02 sc = new WVOGT02(8000);		
	               strRtnMsg = sc.commMessage(strSendString);		
             }
%>
	    	     /* �����ڵ�Ͽ��� ���� �Ǵ� */
	    	     if(OP_RegGb()==1){
                    
	     		       if(confirm("�������߱��Ƿڼ��� ��»����� �����Ͻñ� ���Ͻø� \n�������߱��Ƿڼ��� ���������Ϳ� �־��ֽð� Ȯ���� Ŭ���ϼ���")){
	     		           Jesingo_Print();
	     		       } 
	    	     }

<%       }else{ %>
	     		  //alert("�۾� ������ ������ �Ұ��մϴ�.");
	      	  return;
<%       }  %>
<%   }  %>
	}

  /************************ ������ ��Ͽ��� Ȯ�� �Լ� *******************************/
	function OP_RegGb()
	{
      ret = WooriDeviceForOcx.OpenDevice();
      if( ret == 0 )
      {	
      	    ret = WooriDeviceForOcx.GetTerminalInfo(30);
      	    if( ret == 0 )		
      	    {
      	        msg = WooriDeviceForOcx.GetResult();
      	        
      	        var array_data = msg.split("");
                
      	        strDmno = array_data[0].substring(5,9);
      	        strTlno = array_data[2];
      	        strJmno = array_data[3];
      	        
      	        if (strTlno == ""){
      	        	  alert("�����ڵ���� �Ǿ� ���� �ʾ� ��ǥ����� �ߴܵǾ����ϴ�");
                    WooriDeviceForOcx.CloseDevice();
                    return 0;
      	        }
      	    }
      	    else
      	    {
      	    	   msg = WooriDeviceForOcx.GetErrorMsg(ret);
      	    	   alert(msg);
                 WooriDeviceForOcx.CloseDevice();
      	    	   return 0;
      	    }
      }
      WooriDeviceForOcx.CloseDevice();
      return 1;
	}
	
  /************************ ��ǥ ���� �Լ� *******************************/
	function Tic_Print()
	{

<%
      /* BSC �ڵ� �� ������ */
      String strSpace = "";
      for(int k=0 ; k < (60 - strBsccd.trim().length()) ; k++){
          strSpace = strSpace + " ";
      }

      /*  �����ڼ��� �� ������ */
      String strSpace2 = "";
      for(int j=0 ; j < (8 - strUserName.trim().length()) ; j++){
          strSpace2 = strSpace2 + " ";
      }

      /*  ���¹�ȣ - �߰� */
      String strAc_no = AccountDash(strRefbnkcd,strRefchkno);
      /*  ���¹�ȣ �� ������ */
      String strSpace3 = "";
      for(int j=0 ; j < (17 - strAc_no.trim().length()) ; j++){
          strSpace3 = strSpace3 + " ";
      }

      /*  �Ƿ��θ� �� ������ */
      String strSpace4 = "";
      for(int j=0 ; j < (16 - strIngcltnm.trim().length()) ; j++){
          strSpace4 = strSpace4 + " ";
      }

      /*  ������ݾ� , �߰� */
      String strSsrcomAm = NumberToMoney(strSsrssram);
      /*  ������ݾ� �� ������ */
      String strSpace5 = "";
      for(int j=0 ; j < (11 - strSsrcomAm.trim().length()) ; j++){
          strSpace5 = strSpace5 + " ";
      }
      strSpace5 = strSpace5 + "��";
      
      
      /* ���ݴ�ü ���� */
      String strCsDc_gb = "";
      if(strPnt_Clss.equals("1")){
          strCsDc_gb = "�����Ա�";
      }else{
          strCsDc_gb = "��ü�Ա�";
    	}


if (strTmnseqno.length() < 9){
     strTmnseqno = "         ";
}
      
%>

      strData =              "\n\n\n\n\n\n\n\n\n\n\n\n";
//    strData = strData + "\n 0        1         2         3         4         5         6";
//    strData = strData + "\n 1234567890123456789012345678901234567890123456789012345678901234567890";
      strData = strData + "\n         <%=strBsccd%><%=strSpace%><%=strTellerno%><%=strTicticno%>";
      strData = strData + "\n         652000 <%=strCsDc_gb%> <%=strCurrentdt%> <%=strOutouttm.substring(0,2)%><%=strOutouttm.substring(3,5)%> ���� <%=strUserBankCd%><%=strSosokJumCd%> <%=strTmnseqno.substring(5,9)%> <%=strUserName%><%=strSpace2%><%=strTellerno%> 1 <%=strTicticno%>";
      strData = strData + "\n             <%=strAc_no%><%=strSpace3%>        <%=strIngcltnm%><%=strSpace4%>        <%=strSpace5%><%=strSsrcomAm%>";
      strData = strData + "\n         ������ �߱޼�����<%=strSpace5%><%=strSsrcomAm%>";
      
      ret = WooriDeviceForOcx.OpenDevice();
      if( ret == 0 )
      {	
          //ret = WooriDeviceForOcx.GetAccountPrintControl();
			    //if( ret == 0 )
			    //{		
              ret = WooriDeviceForOcx.PrintPBPR(strData,2,5,12,10,51);
              if( ret != 0 )		
              {
              	alert("��ǥ��¿����� �߻��Ͽ����ϴ�. \n��Ÿ��ȸ > �����߱���ȸ���� ��ǥ ������ ó���ٶ��ϴ�.");
              	//msg = WooriDeviceForOcx.GetErrorMsg(ret);
              	//alert(msg);
               	//WooriDeviceForOcx.ReleaseAccountPrintControl();
              	WooriDeviceForOcx.CloseDevice();
              	return 0;
              }             
          //}
          //WooriDeviceForOcx.ReleaseAccountPrintControl();
      }
      WooriDeviceForOcx.CloseDevice();
      return 1;
  }

  /************************ ���Ű� ���� �Լ� *******************************/
	function Jesingo_Print()
	{
<% 
      String strTrn_No = "";
      if (strPnt_Clss.equals("3")){
          strTrn_No = "02F800";
      }else{
      	  strTrn_No = "652000";
    	}

		  strSendString =  WVOGT04.padding("1", 1);			/* ��û ����  (1 BSC��ȸ)  */
		  strSendString += WVOGT04.padding(strRefchkno, strRefchkno.trim().length()) /* ���¹�ȣ  */                                                            
		  			   + WVOGT04.padding("", 1)          
		  			   + WVOGT04.padding(strCurrentdt, 8)           /* �������  */                                                            
		  			   + WVOGT04.padding("", 1)          
		  			   + WVOGT04.padding(strUserBankCd, 2) 		      /* �����������ڵ�  */                                                            
		  			   + WVOGT04.padding(strSosokJumCd, 3) 		      /* �����ڴܸ���ȣ  */                                                            
		  			   + WVOGT04.padding("", 1)           
		  			   + WVOGT04.padding(strTrn_No, 6) 	            /* �ŷ���ȣ        */                                                            
		  			   + WVOGT04.padding("", 1)           
		  			   + WVOGT04.padding(strOutouttm.substring(0,2), 2) 	/* �ŷ��ð�          */                                                            
		  			   + WVOGT04.padding(strOutouttm.substring(3,5), 2) 	/* �ŷ��ð�          */                                                            
		  			   + WVOGT04.padding(strOutouttm.substring(6,8), 2); 	/* �ŷ��ð�          */                                                            
      
		  WVOGT02 sc = new WVOGT02(6001);		
		  strRtnMsg = sc.commMessage(strSendString);		

      /*  �����ڼ��� �� ������ */
      strSpace2 = "";
      for(int j=0 ; j < (8 - strUserName.trim().length()) ; j++){
          strSpace2 = strSpace2 + " ";
      }

      /*  ���¹�ȣ - �߰� */
      strAc_no = AccountDash(strRefbnkcd,strRefchkno);
      /*  ���¹�ȣ �� ������ */
      strSpace3 = "";
      for(int j=0 ; j < (17 - strAc_no.trim().length()) ; j++){
          strSpace3 = strSpace3 + " ";
      }

      /*  ������ݾ� , �߰� */
      strSsrcomAm = NumberToMoney(strSsrssram);
      /*  ������ݾ� �� ������ */
      strSpace5 = "";
      for(int j=0 ; j < (11 - strSsrcomAm.trim().length()) ; j++){
          strSpace5 = strSpace5 + " ";
      }
      strSpace5 = strSpace5 + "��";

      /*  ������ݾ� �� ������ */
      String strSpace6 = "";
      for(int j=0 ; j < (11 - strSsrcomAm.trim().length()) ; j++){
          strSpace6 = strSpace6 + " ";
      }
      strSpace6 = strSpace6 + "  ";
%>

      strData =              " <%=strRtnMsg%>\n\n\n\n\n\n\n\n\n\n\n\n";
//    strData = strData + "\n 0        1         2         3         4         5         6";
//    strData = strData + "\n 1234567890123456789012345678901234567890123456789012345678901234567890";
      strData = strData + "\n         <%=strTrn_No%> <%=strUserBankCd%><%=strSosokJumCd%> <%=strTmnseqno%> <%=strUserName%><%=strSpace2%> <%=strCurrentdt%>    <%=strOutouttm%>";
      strData = strData + "\n         ���¹�ȣ : <%=strAc_no%><%=strSpace3%>      �Ƿ��θ� : <%=strIngcltnm%>";
<%    if (strPnt_Clss.equals("3")){%>
          strData = strData + "\n         ������ �߱޼�����<%=strSpace6%><%=strSsrcomAm%> ����Ʈ ����";
<%    }else{%>
          strData = strData + "\n         ������ �߱޼�����<%=strSpace5%><%=strSsrcomAm%>";
<%    }%>
      strData = strData + "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
      strData = strData + "\n                                                                               ����Ȯ�δ��";
      
      ret = WooriDeviceForOcx.OpenDevice();
      if( ret == 0 )
      {	
          //ret = WooriDeviceForOcx.GetAccountPrintControl();
			    //if( ret == 0 )
			    //{		
              ret = WooriDeviceForOcx.PrintPBPR2(strData,"57",5,12,10,51);
              if( ret != 0 )		
              {
              	alert("���Ű���¿����� �߻��Ͽ����ϴ�. \n��Ÿ��ȸ > �����߱���ȸ���� ���Ű� ������ ó���ٶ��ϴ�.");
              	//msg = WooriDeviceForOcx.GetErrorMsg(ret);
              	//alert(msg);
               	//WooriDeviceForOcx.ReleaseAccountPrintControl();
              	WooriDeviceForOcx.CloseDevice();
              	return 0;
              }             
          //}
          //WooriDeviceForOcx.ReleaseAccountPrintControl();
      }
      WooriDeviceForOcx.CloseDevice();
      return 1;
  }


  /************************ ������ ���� �Լ� *******************************/
	function YoungSoo_Print()
	{
<%

      /*  �Ƿ��α��� */
      strSpace = "";
      for(int k=0 ; k < (42 - strIngcltnm.trim().length()) ; k++){
          strSpace = strSpace + " ";
      }

      /*  ���¹�ȣ���� */
      strSpace3 = "";
      for(int k=0 ; k < (45 - strAc_no.trim().length()) ; k++){
          strSpace3 = strSpace3 + " ";
      }

      /*  ������̱��� */
      strSpace5 = "";
      for(int k=0 ; k < (41 - strBelbrnnm.trim().length()) ; k++){
          strSpace5 = strSpace5 + " ";
      }


%>
      strData =              "\n\n\n";
//    strData = strData + "\n 0        1         2         3         4         5         6";
//    strData = strData + "\n 1234567890123456789012345678901234567890123456789012345678901234567890";
      strData = strData + "\n                   <%=strIngcltnm%><%=strSpace%><%=strCurrentdt.substring(0,4)%>�� <%=strCurrentdt.substring(4,6)%>�� <%=strCurrentdt.substring(6,8)%>��";
      strData = strData + "\n                   <%=strAc_no%><%=strSpace3%>������ �߱޼�����";
      strData = strData + "\n";
<%    if (strPnt_Clss.equals("3")){%>
          strData = strData + "\n       �� <%=strSsrcomAm%> ����Ʈ";
          strData = strData + "\n";
          strData = strData + "\n       �� ����Ʈ�� ���� �����մϴ�";
<%    }else{%>
          strData = strData + "\n       �� ��<%=strSsrcomAm%> ����";
          strData = strData + "\n";
          strData = strData + "\n       �� �ݾ��� ���� �����մϴ�";
<%    }%>
      strData = strData + "\n\n\n\n\n\n\n\n\n\n\n\n";
      strData = strData + "\n                        <%=strBelbrnnm%><%=strSpace5%><%=strUserName%>";
      
      ret = WooriDeviceForOcx.OpenDevice();
      if( ret == 0 )
      {	
          //ret = WooriDeviceForOcx.GetAccountPrintControl();
			    //if( ret == 0 )
			    //{		
              ret = WooriDeviceForOcx.PrintPBPR(strData,5,5,12,10,51);
              if( ret != 0 )		
              {
              	alert("��������¿����� �߻��Ͽ����ϴ�. \n��Ÿ��ȸ > �����߱���ȸ���� ������ ������ ó���ٶ��ϴ�.");
              	//msg = WooriDeviceForOcx.GetErrorMsg(ret);
              	//alert(msg);
               	//WooriDeviceForOcx.ReleaseAccountPrintControl();
              	WooriDeviceForOcx.CloseDevice();
              	return 0;
              }             
          //}
          //WooriDeviceForOcx.ReleaseAccountPrintControl();
      }
      WooriDeviceForOcx.CloseDevice();
      return 1;
  }
              
 	</script> 
 	
<script language="VBScript">

	Dim WQueue: WQueue = "gmstonbs" '����ý��� �̸� WQueue
	Dim RQueue: RQueue = "nbstogms" '����ý��� �̸� RQueue

'GWBS

	Sub window_onLoad
		Call objQueue.OpenReadQueue("", RQueue)
		
	End Sub
			
	Sub SendMQ()
		Call objQueue.Clear				' �켱������ �����͸� Ŭ�����Ѵ�

		'������� �����͸� ä���
		Call objQueue.CommonManager.AddStr("8BFC3350075F11EE90E000246E28251C034315  A1610001  122001    ", "00", "1")
    '�����ͺ��� �����͸� ä���
    Call objQueue.DataManager.AddStr  ("0003", "0", "<%=strSsrcomAm%>") 
    Call objQueue.DataManager.AddStr  ("0004", "0", "<%=strSsrcomAm%>") 


		'������ �ش� ť�� ����, ����Ѵ�.
		Call objQueue.OpenWriteQueue("", WQueue)
		Call objQueue.Send(WQueue)
	End Sub

</script>
 	
 	
 	  
 	</HEAD>     
 	<body onLoad="javascript:PrintPBPR();">
   <OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
   </OBJECT>
    <OBJECT id="objQueue"  classid="CLSID:0982F296-66BF-42DF-AD01-0BD01D0F0EE0"></OBJECT>
		<br>      
		<!--	codebase="http://10.250.19.118/ocx/WooriBank.cab#version=2,2,2,2">	
-->         	
		<br> 	</body>
 	</HTML>					
            	
<%          	
}           	
catch (IOException e)
{
	//System.err.println(strJspName + ":" + strJspStep + ":" + e.toString());
	System.err.println(getCurrentDate("yyyy-MM-dd hh:mm:ss") + " >" + strJspName + ":" + strJspStep + ":Exception:" + e.toString());		
	
	strTemp = "WJOER01.jsp"
			+ "?field_error_code=" 
			+ java.net.URLEncoder.encode(strJspName + ":" + strJspStep + ":" + "ERR_04")
			+ "&field_error_msg="
			+ java.net.URLEncoder.encode(e.toString())
			+ "&field_error_action=window.close()";		
 	response.sendRedirect(strTemp);									
}
catch (Exception e) 
{	
	//System.err.println(strJspName + ":" + strJspStep + ":" + e.toString());
	System.err.println(getCurrentDate("yyyy-MM-dd hh:mm:ss") + " >" + strJspName + ":" + strJspStep + ":Exception:" + e.toString());		
	
	strTemp = "WJOER01.jsp"
			+ "?field_error_code=" 
			+ java.net.URLEncoder.encode(strJspName + ":" + strJspStep + ":" + "ERR_05")
			+ "&field_error_msg="
			+ java.net.URLEncoder.encode(e.toString())
			+ "&field_error_action=window.close()";		
 	response.sendRedirect(strTemp);												
}
finally
{	
	strJspStep = "external block";
	
	try
	{ 	
		if (rset1 != null)
		{
			rset1.close();
		}
		
		if (stmt1 != null)
		{
			stmt1.close();
		}
		
		if (conn != null)
		{
			conn.close();
		}					
	} 
	catch (SQLException e) 
	{
		System.err.println(strJspName + ":" + strJspStep + ":" + e.toString());		

		if (conn != null)
		{
			conn.close();
		}							
		
		strTemp = "WJOER01.jsp"
				+ "?field_error_code=" 
				+ java.net.URLEncoder.encode(strJspName + ":" + strJspStep + ":" + "ERR_FINALLY")
				+ "&field_error_msg="  
				+ java.net.URLEncoder.encode(e.toString());
	 	response.sendRedirect(strTemp);			
	}
}   
%>