/* TOBE 2017-07-01 자본예산 BS처리 수신 */

package com.tcJun2;

import com.tcLib2.*;

//AS-IS : IF_OT870100R
public class IF_BCB01000T02_R extends OUT_MSG {

	
	public String DAT_KDCD                  = "";   //데이타헤더부 : (문자3)  데이터종류코드	       
	public String DAT_LEN                   = "";   //데이타헤더부 : (숫자7)  데이터길이	   
	public String OUP_TLM_LEN             	= "";  	//1.출력전문길이(N6 )
	public String SLIP_NO                 	= "";  	//2.전표번호    (S16)
	public String TLR_NO                  	= "";  	//3.텔러번호    (S4 )
	public String TRN_SRNO                	= "";  	//4.거래일련번호(N8 )
	public String CUS_NM                  	= "";  	//5.고객명      (S50)
	public String TRN_LOG_KEY_VAL         	= "";  	//6.거래로그키값(S56)
	
	public static String PGMID = "IF_BCB01000T02_R";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
    		"DAT_KDCD",  
    		"DAT_LEN",  
    		"OUP_TLM_LEN",  
    		"SLIP_NO",  
    		"TLR_NO",  
    		"TRN_SRNO",  
    		"CUS_NM",  
    		"TRN_LOG_KEY_VAL",      			  
        };

    private int[] iLen = {3,7,6,16,4,8,50,56,};    
    
   
    public IF_BCB01000T02_R()
    {
        iTLen = 150;
    }
    
    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;
		
        DAT_KDCD             		    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        DAT_LEN              		    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        OUP_TLM_LEN             		= getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        SLIP_NO                 		= getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TLR_NO                  		= getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_SRNO                		= getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CUS_NM                  		= getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_LOG_KEY_VAL         		= getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;       
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD             		    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;	   	
        DAT_LEN             		    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        OUP_TLM_LEN               		= getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;	   	
        SLIP_NO                 		= getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;	   	
        TLR_NO                  		= getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;	   	
        TRN_SRNO                		= getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;	   	
        CUS_NM                  		= getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;	   	
        TRN_LOG_KEY_VAL         		= getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;	   	        	   	
    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, DAT_KDCD                  ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, DAT_LEN                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, OUP_TLM_LEN               ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, SLIP_NO                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TLR_NO                    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_SRNO                  ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, CUS_NM                    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_LOG_KEY_VAL           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;            
    }
    
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
        objToArry(buff, pos, DAT_LEN                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
        objToArry(buff, pos, OUP_TLM_LEN               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
        objToArry(buff, pos, SLIP_NO                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
        objToArry(buff, pos, TLR_NO                    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
        objToArry(buff, pos, TRN_SRNO                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
        objToArry(buff, pos, CUS_NM                    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
        objToArry(buff, pos, TRN_LOG_KEY_VAL           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;          
    }
    
    public void log(String name,String msg) {
    	sThread = msg;
    	logname = name;
    	log();
    }
    public void log() {
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD                                = "+DAT_KDCD            		                   ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN                                 = "+DAT_LEN             		                   );     	
    	pvUtil.msglog(logname, sThread+PGMID+" + OUP_TLM_LEN                             = "+OUP_TLM_LEN            		               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + SLIP_NO                                 = "+SLIP_NO                		               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + TLR_NO                                  = "+TLR_NO                 		               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + TRN_SRNO                                = "+TRN_SRNO               		               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + CUS_NM                                  = "+CUS_NM                 		               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + TRN_LOG_KEY_VAL                         = "+TRN_LOG_KEY_VAL        		               );    	 
    }
    public void print() {
    }
}
