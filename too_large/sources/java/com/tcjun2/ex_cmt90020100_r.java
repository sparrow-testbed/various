/* TOBE 2017-07-01 책임자승인목록  수신 그리드 EX */

package com.tcJun2;

import java.io.*;
import java.util.*;

import com.tcLib.pvUtil;

public class Ex_CMT90020100_R { 
	
    public  String   R_COUNT         = "";
	public  String	 R_CODE          = "";
	public  String   E_MESSAGE       = "";
	
	@SuppressWarnings("unchecked")
	public 	List list_cmt90020100_r;
	private LIST_CMT90020100_R cmt90020100_r  = new LIST_CMT90020100_R();
	
    public static String PGMID = "Ex_CMT90020100_R";
    public String sThread = "";
    public String logname = "";
    

    public Ex_CMT90020100_R()
    {
    	
    }    
    public void log(String name,String msg) {
    	sThread = msg+" ";
    	logname = name;
    	log();
    }
    public void log() {
    	
    	pvUtil.msglog(logname, sThread+PGMID +" +-------------------------------------------------" );
        pvUtil.msglog(logname, sThread+PGMID +" + R_COUNT      = ["+R_COUNT   +"]"  );		
        pvUtil.msglog(logname, sThread+PGMID +" + R_CODE       = ["+R_CODE    +"]"  );	
        pvUtil.msglog(logname, sThread+PGMID +" + E_MESSAGE    = ["+E_MESSAGE +"]"  );		
        pvUtil.msglog(logname, sThread+PGMID +" +-------------------------------------------------" );
        
    	for(int i = 0; i < list_cmt90020100_r.size(); i++) {
    		cmt90020100_r = (LIST_CMT90020100_R) list_cmt90020100_r.get(i);
    		cmt90020100_r.log(logname,i,sThread);		   		
    	}
    }

}