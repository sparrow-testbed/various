/* TOBE 2017-07-01 자본예산 BS처리 송신 그리드  */

package com.tcJun2;                                                                                    
                                                                                                      
import java.util.List;                                                                                
                                                                                                      
import com.tcLib2.*;                                                                                   
//import com.wmJun.LIST_OT0101R;                                                                        

//AS-IS : LIST_OT870100S
public class LIST_BCB01000T02_S extends OUT_MSG {                                                         
                                                                                                      
                                                                                                      
	public String[] DACC_CST_DSCD;               //S1    일계조립구분코드                         
	public String[] MERE_SUMR_CD;               //S1    동부동산집계코드                         
	public String[] DACC_BRCD;               //S6    일계점코드                               
	public String[] ACC_DSCD;               //S2    계정구분코드                             
	public String[] UNI_CD;               //S2    합동코드                                 
	public String[] FND_PDCD;               //S13   펀드상품코드                                 
	public String[] BSIS_DSCD;               //S1    BS/IS구분코드                            
	public String[] ACCD;               //S11   계정과목코드                             
	public String[] ACI_DSCD;               //S2    계정과목구분코드                         
	public String[] RAP_DSCD;               //S1    입지급구분코드                           
	public String[] RAP_STCD;               //S1    입지급상태코드                           
	public String[] SLIP_SCNT;               //N6    전표매수                                 
	public String[] CSHTF_DSCD;               //S1    현금대체구분코드                         
	public String[] EXU_AM;               //D15   집행금액                                 
                             
	                                                                                              
                                                                                                      
    public static String PGMID = "LIST_BCB01000T02_S";                                                    
    public String sThread = "";                                                                       
    public String logname = "";                                                                       
                                                                                                      
    private String[] FieldNames = {                                                                   
    	"DACC_CST_DSCD",                                                                              
    	"MERE_SUMR_CD",                                                                              
    	"DACC_BRCD",                                                                              
    	"ACC_DSCD",                                                                              
    	"UNI_CD",                                                                              
    	"FND_PDCD",                                                                              
    	"BSIS_DSCD",                                                                              
    	"ACCD",                                                                              
    	"ACI_DSCD",                                                                              
    	"RAP_DSCD",                                                                              
    	"RAP_STCD",                                                                              
    	"SLIP_SCNT",                                                                              
    	"CSHTF_DSCD",                                                                              
    	"EXU_AM",                                                                              
    };
                                                                                                       
    public int[] iLen = {1,1,6,2,2,13,1,11,2,1,1,6,1,15,};                                            
                                                                                                      
    public LIST_BCB01000T02_S()                                                                           
    {                                                                                                 
    	iTLen = 63;       
    	
    }                                                                                                 
                                                                                                      
    public void setData(byte[] buff, int pos, int i) throws pvException                               
    {                                                                                                 
        //int i   = 0;                                                                                
		                                                                                      
     DACC_CST_DSCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     MERE_SUMR_CD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     DACC_BRCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     ACC_DSCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     UNI_CD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     FND_PDCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     BSIS_DSCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     ACCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     ACI_DSCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     RAP_DSCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     RAP_STCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     SLIP_SCNT[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     CSHTF_DSCD[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
     EXU_AM[i]   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;            
                                                                                                      
    }                                                                                                 
                                                                                                      
    public void setData(byte[] buff, int pos, String code, int i) throws pvException                  
    {                                                                                                 
        //int i   = 0;                                                                                
      // 아래 반복 구문                                                                               
      DACC_CST_DSCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      MERE_SUMR_CD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      DACC_BRCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      ACC_DSCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      UNI_CD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      FND_PDCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      BSIS_DSCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      ACCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      ACI_DSCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      RAP_DSCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      RAP_STCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      SLIP_SCNT[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      CSHTF_DSCD[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
      EXU_AM[i]     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;   
                                                                                                      
    }                                                                                                 
                                                                                                      
    public void getData(byte[] buff, int pos, int i) throws pvException                               
    {                                                                                                 
        //int i=0;                                                                                    
                                                                                                      
                                                                                                      
        //반복문 시작                                                                                 
        objToArry(buff, pos, DACC_CST_DSCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, MERE_SUMR_CD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, DACC_BRCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, ACC_DSCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, UNI_CD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, FND_PDCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, BSIS_DSCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, ACCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, ACI_DSCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, RAP_DSCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, RAP_STCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, SLIP_SCNT[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, CSHTF_DSCD[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
        objToArry(buff, pos, EXU_AM[i]   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;      
                                                                                                      
    }                                                                                                 
                                                                                                      
    public void getData(byte[] buff, int pos, String code, int i) throws pvException                  
    {                                                                                                 
        //int i=0;                                                                                    
                                                                                                      
                                                                                                      
        objToArry(buff, pos, DACC_CST_DSCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MERE_SUMR_CD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DACC_BRCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACC_DSCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, UNI_CD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FND_PDCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BSIS_DSCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACI_DSCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RAP_DSCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RAP_STCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SLIP_SCNT[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CSHTF_DSCD[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, EXU_AM[i]   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
                                                                                                      
    }                                                                                                 
                                                                                                      
    public void log(String name,String msg) {                                                         
    	sThread = msg;                                                                                
    	logname = name;                                                                               
    	log();                                                                                        
    }                                                                                                 
    public void log() {                                                                               
                                                                                                      
    	pvUtil.msglog(logname, sThread+PGMID+" + DACC_CST_DSCD                = "+DACC_CST_DSCD	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + MERE_SUMR_CD                 = "+MERE_SUMR_CD 	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + DACC_BRCD                    = "+DACC_BRCD    	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + ACC_DSCD                     = "+ACC_DSCD     	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + UNI_CD                       = "+UNI_CD       	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + FND_PDCD                     = "+FND_PDCD     	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + BSIS_DSCD                    = "+BSIS_DSCD    	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + ACCD                         = "+ACCD         	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + ACI_DSCD                     = "+ACI_DSCD     	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + RAP_DSCD                     = "+RAP_DSCD     	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + RAP_STCD                     = "+RAP_STCD     	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + SLIP_SCNT                    = "+SLIP_SCNT    	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + CSHTF_DSCD                   = "+CSHTF_DSCD   	               );     
    	pvUtil.msglog(logname, sThread+PGMID+" + EXU_AM                       = "+EXU_AM       	               );     
                                                                                                      
    	                                                                                              
//    	System.out.println( sThread+PGMID+" +------------------------------------------");            
    }                                                                                                 
    public void print() {                                                                             
                                                                                                      
//    	System.out.println( sThread+PGMID+" + DACC_CST_DSCD                = "+DACC_CST_DSCD	               );     
//    	System.out.println( sThread+PGMID+" + MERE_SUMR_CD                 = "+MERE_SUMR_CD 	               );     
//    	System.out.println( sThread+PGMID+" + DACC_BRCD                    = "+DACC_BRCD    	               );     
//    	System.out.println( sThread+PGMID+" + ACC_DSCD                     = "+ACC_DSCD     	               );     
//    	System.out.println( sThread+PGMID+" + UNI_CD                       = "+UNI_CD       	               );     
//    	System.out.println( sThread+PGMID+" + FND_PDCD                     = "+FND_PDCD       	               );     
//    	System.out.println( sThread+PGMID+" + BSIS_DSCD                    = "+BSIS_DSCD    	               );     
//    	System.out.println( sThread+PGMID+" + ACCD                         = "+ACCD         	               );     
//    	System.out.println( sThread+PGMID+" + ACI_DSCD                     = "+ACI_DSCD     	               );     
//    	System.out.println( sThread+PGMID+" + RAP_DSCD                     = "+RAP_DSCD     	               );     
//    	System.out.println( sThread+PGMID+" + RAP_STCD                     = "+RAP_STCD     	               );     
//    	System.out.println( sThread+PGMID+" + SLIP_SCNT                    = "+SLIP_SCNT    	               );     
//    	System.out.println( sThread+PGMID+" + CSHTF_DSCD                   = "+CSHTF_DSCD   	               );     
//    	System.out.println( sThread+PGMID+" + EXU_AM                       = "+EXU_AM       	               );     
//    	                                                                                              
//    	System.out.println( sThread+PGMID+" +-----------------------------------------");             
                                                                                                      
    }                                                                                                 
}