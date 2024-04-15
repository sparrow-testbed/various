/* TOBE 2017-07-01 경상비 세금계산서 조회 송신 */

package com.tcJun2;

import com.tcLib2.*;

//AS-IS : IF_OT8601S
public class IF_BEB00730T01_S extends OUT_MSG {
	
	public String    DAT_KDCD           = ""; //데이타헤더부 : (문자3)  데이터종류코드	       
	public String    DAT_LEN            = ""; //데이타헤더부 : (숫자7)  데이터길이	   
	public String	 TLM_DSCD           = ""; //1. S3    전문구분코드           
	public String	 INQ_STA_NO         = ""; //2. N5    조회시작번호           
	public String	 INQ_END_NO         = ""; //3. N5    조회종료번호           
	public String	 SPLPE_BZNO         = ""; //4. S10   공급자사업자등록번호       
	public String	 SUPPE_BZNO         = ""; //5. S10   공급받는자사업자등록번호     
	public String	 INQ_BAS_DT         = ""; //6. S8    조회기준일자           
	
    public static String PGMID = "IF_BEB00730T01_S";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
    		"DAT_KDCD",
    		"DAT_LEN",    		
    		"TLM_DSCD  ",
    		"INQ_STA_NO",
    		"INQ_END_NO",
    		"SPLPE_BZNO",
    		"SUPPE_BZNO",
    		"INQ_BAS_DT",    		    	
    };
    
    private int[] iLen = {3,7,3,5,5,10,10,8,};
    
    public IF_BEB00730T01_S()
    {
        iTLen = 51;
    }
    
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        
        TLM_DSCD      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        INQ_STA_NO    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        INQ_END_NO    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SPLPE_BZNO    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		SUPPE_BZNO    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		INQ_BAS_DT    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		     	
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD  	  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN   	  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        
        objToArry(buff, pos, TLM_DSCD  	  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, INQ_STA_NO	  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, INQ_END_NO	  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPLPE_BZNO   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, SUPPE_BZNO   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, INQ_BAS_DT   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
                
    }
    
    public void log(String name,String msg) {
    	sThread = msg+" ";
    	logname = name;
    	log();
    }
    public void log() {
    	int i = 0;
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    	pvUtil.msglog(logname, sThread+PGMID+" + IMHD     = ("+pvUtil.getNum(iLen[i], 4)+")[" + pvUtil.getFormat(iLen[i++],DAT_KDCD  )     +"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + IMHD     = ("+pvUtil.getNum(iLen[i], 4)+")[" + pvUtil.getFormat(iLen[i++],DAT_LEN   )     +"]");
    	
    	pvUtil.msglog(logname, sThread+PGMID+" + IMHD     = ("+pvUtil.getNum(iLen[i], 4)+")[" + pvUtil.getFormat(iLen[i++],TLM_DSCD  )     +"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + IMHD     = ("+pvUtil.getNum(iLen[i], 4)+")[" + pvUtil.getFormat(iLen[i++],INQ_STA_NO)     +"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + IMHD     = ("+pvUtil.getNum(iLen[i], 4)+")[" + pvUtil.getFormat(iLen[i++],INQ_END_NO)     +"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + IMHD     = ("+pvUtil.getNum(iLen[i], 4)+")[" + pvUtil.getFormat(iLen[i++],SPLPE_BZNO)     +"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + IMHD     = ("+pvUtil.getNum(iLen[i], 4)+")[" + pvUtil.getFormat(iLen[i++],SUPPE_BZNO)     +"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + IMHD     = ("+pvUtil.getNum(iLen[i], 4)+")[" + pvUtil.getFormat(iLen[i++],INQ_BAS_DT)     +"]");
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
  
}