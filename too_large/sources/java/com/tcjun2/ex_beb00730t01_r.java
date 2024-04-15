/* TOBE 2017-07-01 경상비 세금계산서  수신 그리드 EX */

package com.tcJun2;

import java.io.*;
import java.util.*;

import com.tcLib.pvUtil;

public class Ex_BEB00730T01_R { //implements Externalizable {
	
//    public  Ex_commHeader   comHdr   = new Ex_commHeader();
//    public  Ex_bizHeader    bizHdr   = new Ex_bizHeader();
    public  String   R_COUNT         = "";
	public  String	 R_CODE          = "";
	public  String   E_MESSAGE       = "";
	
	@SuppressWarnings("unchecked")
	public 	List list_beb00730t01_r;
	private LIST_BEB00730T01_R beb00730t01_r  = new LIST_BEB00730T01_R();
	
    public static String PGMID = "Ex_BEB00730T01_R";
    public String sThread = "";
    public String logname = "";
    

    public Ex_BEB00730T01_R()
    {
    	
    }    
//	@SuppressWarnings("unchecked")
//	public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
//		
//		
//		comHdr 			= (Ex_commHeader) in.readObject();
//		bizHdr 			= (Ex_bizHeader) in.readObject();
//		
//        MSG_DSCD        = (String) in.readObject();
//        ARRAY_CNT       = (String) in.readObject();
//        CONT_YN         = (String) in.readObject();
//        FILLER          = (String) in.readObject();
//        E_MESSAGE       = (String) in.readObject();
//        
//		list_ot0101r   	= (ArrayList) in.readObject();		
//	}

//	@SuppressWarnings("unchecked")
//	public void writeExternal(ObjectOutput out) throws IOException {
//
//		out.writeObject(comHdr);
//		out.writeObject(bizHdr);
//
//        out.writeObject(RET_CD     );	                   
//        out.writeObject(ARRAY_CNT  );                 
//        out.writeObject(E_MESSAGE   );
//        
//		out.writeObject(new ArrayList(list_ot0101r));		
//	}
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
        
    	for(int i = 0; i < list_beb00730t01_r.size(); i++) {
    		beb00730t01_r = (LIST_BEB00730T01_R) list_beb00730t01_r.get(i);
    		beb00730t01_r.log(logname,i,sThread);		   		
    	}
    }

}