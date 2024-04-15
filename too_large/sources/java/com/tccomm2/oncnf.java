package com.tcComm2;

public class ONCNF 
{
	public static final int D_OK                        =  0;
    public static final int D_ERR                       = -1;
    public static final int D_TMOUT                     = -2;
    public static final int D_ECODE                     = -3;
    public static final int D_ENETWORK                  = -4;
    public static final int D_EFORMAT                   = -5;
        
    public static 		String TXDATE 					= "";
 
    public static       String      DRIVER          	= "";
    public static       String      CONNECTION      	= "";
    public static       String      DBNAME          	= "";
    public static       String      DBID            	= "";
    public static       String      DBPWD           	= ""; 
    
    public static       String      LOGDIR              = "/app/eps_src/Poa-Package/sepoalog";
    
    public static       int         THREAD_IN_COUNT    	= 0;
    public static       int         THREAD_OUT_COUNT    = 0;
    public static 		int 		SVR_OUT_PORT 		= 0;
    
    
    public static 		String 		TCP_BANK_ADDRESS 	= "";
    public static 		int 		TCP_BANK_PORT 	    = 0;
    
    public static       int         TCP_BUFSIZE         = 0;
    
    public static       String      BNK_LANG_CODE       = "EUC-KR";
    public static       String      WMS_LANG_CODE       = "";
    
    public static       String      LOGNAME             = "IF";
        
       
}
