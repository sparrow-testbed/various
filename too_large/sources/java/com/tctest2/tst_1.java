
package com.tcTest2;

/* 현행화테스트 */

import java.io.*;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;

import com.tcComm2.ONCNF;
import com.tcLib2.I_Wms;
import com.tcLib2.pvException;
import com.tcLib2.pvUtil;



public class tst_1 {

	public static final int D_OK                        =  0;
    public static final int D_ERR                       = -1;
    public static final int D_TMOUT                     = -2;
    public static final int D_ECODE                     = -3;
    public static final int D_ENETWORK                  = -4;
    public static final int D_EFORMAT                   = -5;
    
    static final int TCP_BUFSIZE = 30720;
    
    byte[] s_data = new byte[TCP_BUFSIZE];   
    byte[] r_data = new byte[TCP_BUFSIZE];
    
    public String servAddress = "weaiapt.woorifg.com";//"weaiapp.woorifg.com";
    public int servPort = 11203;
    
    public static String   PGMID     = "1";
    
    
    public tst_1 () {    	
//        this.SEND     = new IF_OT870101S();
//        this.RECV     = new IF_OT870101R();
//        this.eRECV    = new IF_OT0000E();
//        PGMID = "OT8701";
    
    }
    
    
	public String sendMessage(String send_msg){
		int rtn = 0;
		int slen = 0;
		Socket socket = null;  InputStream in = null; OutputStream out = null;
		String resultData = "";
		try {  
			/* tcp connect */
		    socket = new Socket(servAddress, servPort);	
		    socket.setSoTimeout(1000*15);
		    /* tcp data recv */
		    in = socket.getInputStream();				    
		    /* tcp data send */
		    out = socket.getOutputStream();
		    
		    s_data = send_msg.getBytes();
		    slen = send_msg.getBytes().length;
		    
		    out.write(s_data,0,slen);     
		    //out.flush();
			    
			    
		    
			//test start 
			//System.out.println("debug:OT870101:length:"+slen);
			ByteArrayOutputStream f = new ByteArrayOutputStream(); 
			f.write(s_data,0,slen);
//			System.out.println(f.toString());
			/*byte b[] = f.toByteArray();
			for (int i=0; i<b.length; i++) { 
				System.out.print((char) b[i]); 
			} */
			//System.out.println(); 
			//test end
			
			out.flush();
			
			/*
			
			BufferedReader reader = new BufferedReader(new InputStreamReader(in));
			System.out.println("return start");		    
			System.out.println(reader.readLine()); //다시 수신해서 화면에 출력한다.
			System.out.println("return end");		    
			*/

			int rcvSize = in.read(r_data);
			if(rcvSize != -1) {
				
			    try {
			    	
			    	resultData = new String(r_data, "EUC-KR").trim();		// 한글부분을 처리하고 결과값을 받는다
			    	
			    	
                    //resultData = new String(r_data, 0, r_data.length, "EUC-KR");
			    				    	
			    	//ByteArrayOutputStream bos = new ByteArrayOutputStream(); 
			    	//bos.write(r_data);
			    			
			    	//resultData = bos.toString();
			    	
			    	
			    	//System.out.println("receive:"+bos.toString());
			    	
			    	
				} catch (Exception e) {
//					e.printStackTrace();
					rtn = -1;
				}
			}
			else {
			    return "";
			}			    
		} catch (Exception e) {
//			e.printStackTrace();
			try {
				if(socket != null){ socket.close(); }
			} catch (Exception ie) {
//				ie.printStackTrace();
				rtn = -1;
			}
			return "";
		} finally {	
			try {
				if(in != null){ in.close(); } if(out != null){ out.close(); } if(socket != null && !socket.isClosed()){ socket.close(); }
			} catch (IOException ie) {
				rtn = -1;
			}
		}
		return  resultData;				
	}		
}