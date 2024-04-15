package com.tcLib2;

import java.util.*;
import java.io.*;
import java.text.*;

import org.w3c.tidy.Out;

import com.tcComm2.ONCNF;

public class pvUtil
{
    public static String logTime()
    {    
        return getDate()+"/"+getTime() + " ";
    }
    public static String getDate()
    {
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        return date.format(new Date());
    }

    public static String getTime()
    {
        SimpleDateFormat time = new SimpleDateFormat("HHmmss");
        return time.format(new Date());
    }
    public static String getFormat(int i,String type,String value) {
    	String str,rs;
    	if("9".equals(type)){
    		str = "%"+String.format("%ds",i);
    	}
    	else {
    		str = "%"+String.format("-%ds",i);
    	}
    	rs = String.format(str,value );
    	return rs;
    }
    
    public static String getFormat(int i,String value) {
    	String str,rs;

  		str = "%"+String.format("-%ds",i);
    	rs = String.format(str,value );
    	return rs;
    }
    public static String getNum(int i,int j) {
    	String str,rs;

  		str = "%0"+String.format("%dd",j);
    	rs = String.format(str,i );
    	return rs;
    } 

    /*----------------------------------
     * msglog ...
     *----------------------------------*/
    public static synchronized void msglog(String fileName, String sLog)
    {
       String sDate = getDate();
       fileName = fileName+".log."+sDate;
        sLog = logTime() + sLog;
        File logDir = new File(ONCNF.LOGDIR);
        if(!logDir.exists()) {
        	logDir.mkdirs();
        	//System.out.println(pvUtil.logTime()+"log directory created !!.."+ONCNF.LOGDIR);
        }
        BufferedWriter out = null;
       try
        {
            out = new BufferedWriter(new FileWriter(ONCNF.LOGDIR+fileName, true));
            out.write(sLog);
            out.newLine();
        }
        catch(IOException ie)
        {
            //System.out.println(pvUtil.logTime()+"log write error !!.."+ONCNF.LOGDIR+fileName);
        	sDate = getDate();
        }
        finally {
        	try {
				if(out != null){ out.close(); }
			} catch (IOException e) {
				sDate = getDate();
			}
        
        }
    }
    
    /*-----------------------
     *  ���ϵ���Ÿ �߰� RECV() ...
     *-----------------------*/   
	public static int Socket_AddRecv(InputStream in, byte[] r_data, int pos, int totalRecvSize) {
		int rlen = 0;			
		byte[] rbuff = new byte[totalRecvSize];
		
		while(pos < totalRecvSize) {

			try {
				rlen = in.read(rbuff);
				//System.out.println(pvUtil.logTime()+" : Socket_AddRecv rlen =" +rlen);
				if(rlen > 0) {
					System.arraycopy(rbuff, 0, r_data, pos, rlen);
					pos += rlen;
				}
				else {
					break;
				}

			} catch (IOException e) {

				//System.out.println(pvUtil.logTime()+" :0200: Socket_AddRecv.read() IOException !!!.."+e.getMessage());
				break;
			}
		}				
		return (pos);
	}
    /*-----------------------
     *  ���ϵ���Ÿ �߰� RECV() ...
     *-----------------------*/   
	public static int Socket_AddRecv2(InputStream in, byte[] r_data, int pos, int totalRecvSize) {
		int rlen = 0;			
		byte[] rbuff = new byte[totalRecvSize];
		
		while(pos < totalRecvSize) {

			try {
				rlen = in.read(rbuff,0,totalRecvSize-pos);
				//System.out.println(pvUtil.logTime()+" : Socket_AddRecv rlen =" +rlen);
				if(rlen > 0) {
					System.arraycopy(rbuff, 0, r_data, pos, rlen);
					pos += rlen;
				}
				else {
					break;
				}

			} catch (IOException e) {

				//System.out.println(pvUtil.logTime()+" :0200: Socket_AddRecv.read() IOException !!!.."+e.getMessage());
				break;
			}
		}				
		return (pos);
	}	
	/*-------------------------
	 *  �ð����� ��� �Լ� (���� :��)
	 *------------------------*/
	public static long diff_getTime(String start, String end) {

		Calendar cal01 = Calendar.getInstance();
	
		Calendar cal02 = Calendar.getInstance();
		
		try {
	
			cal01.set(
		
					Integer.parseInt(start.substring(0,4)), 
				
					Integer.parseInt(start.substring(4,6)), 
				
					Integer.parseInt(start.substring(6,8)), 
				
					Integer.parseInt(start.substring(8,10)), 
				
					Integer.parseInt(start.substring(10,12)), 
				
					Integer.parseInt(start.substring(12,14))
		
			);
	
			cal02.set(
		
					Integer.parseInt(end.substring(0,4)), 
				
					Integer.parseInt(end.substring(4,6)), 
				
					Integer.parseInt(end.substring(6,8)), 
				
					Integer.parseInt(end.substring(8,10)), 
				
					Integer.parseInt(end.substring(10,12)), 
				
					Integer.parseInt(end.substring(12,14))
		
			);
		}
		catch(Exception e) {
			
			return -1;
		}
		
		long time = (cal02.getTime().getTime() - cal01.getTime().getTime())/1000;
		return time;
	} 
}
