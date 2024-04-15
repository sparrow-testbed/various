/* TOBE 2017-07-01 경상비 세금계산서 조회 수신 그리드  */

package com.tcJun2;

import com.tcLib2.*;

//AS-IS : LIST_OT8601R
public class LIST_BEB00730T01_R { //implements Externalizable {

	public String	 INQ_NO                  = "";   //1.  N5      조회번호                
	public String	 NTS_BILL_APV_NO         = "";   //2.  S24     국세청계산서승인번호          
	public String	 BGT_BRCD                = "";   //3.  S6      예산점코드               
	public String	 EVDCD_ISSU_DT  	     = "";   //4.  S8      증빙서발행일자             
	public String	 TXBIL_RGS_DT            = "";   //5.  S8      (세금)계산서등록일자         
	public String	 TXBIL_RGS_SRNO          = "";   //6.  N5      (세금)계산서등록일련번호        	
	public String	 BGT_EXU_AM              = "";   //7.  D15     예산집행금액              
	public String	 SPL_AM                  = "";   //8.  D15     공급금액                
	public String	 EVDCD_TAXM              = "";   //9.  D15     증빙서세액               
	public String	 EVDCD_DAT_DSCD          = "";   //10. S1      증빙서데이터구분코드          
	public String	 XPN_PAY_RSN_TXT         = "";   //11. S100    지경비지급사유내용           
	
	public static String PGMID = "LIST_BEB00730T01_R";
    public String sThread = "";
    public String logname = "";

    private int[] iLen = {5,24,6,8,8,5,15,15,15,1,100,};
	public LIST_BEB00730T01_R() {}
	
//	public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
//		
//		INQ_SRNO        = (String) in.readObject();
//		TAA_APV_NO      = (String) in.readObject();
//		RGS_BRCD        = (String) in.readObject();
//		RGS_DT          = (String) in.readObject();
//		RGS_SRNO        = (String) in.readObject();
//		RGS_DSCD        = (String) in.readObject();
//		
//	}
//	public void writeExternal(ObjectOutput out) throws IOException {
//		
//		out.writeObject(INQ_SRNO      );
//		out.writeObject(TAA_APV_NO    );
//		out.writeObject(RGS_BRCD      );
//		out.writeObject(RGS_DT        );
//		out.writeObject(RGS_SRNO      );
//		out.writeObject(RGS_DSCD      );
//	}
	
    public void log(String name,int i, String msg) {
    	sThread = msg;
    	logname = name;
    	log(i);
    }
   
    public void log(int j) {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" "+j+" +-------------------------------------------------" );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + INQ_NO            = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],INQ_NO            )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + NTS_BILL_APV_NO   = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],NTS_BILL_APV_NO   )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + BGT_BRCD          = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],BGT_BRCD          )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + EVDCD_ISSU_DT     = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],EVDCD_ISSU_DT     )+"]" );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + TXBIL_RGS_DT      = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],TXBIL_RGS_DT      )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + TXBIL_RGS_SRNO    = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],TXBIL_RGS_SRNO    )+"]" );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + BGT_EXU_AM        = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],BGT_EXU_AM        )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + SPL_AM            = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],SPL_AM            )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + EVDCD_TAXM        = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],EVDCD_TAXM        )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + EVDCD_DAT_DSCD    = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],EVDCD_DAT_DSCD    )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + XPN_PAY_RSN_TXT   = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],XPN_PAY_RSN_TXT   )+"]" );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" +-------------------------------------------------" );
    }   	
}