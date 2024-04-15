/* TOBE 2017-07-01 온라인 OUT MSG */

package com.tcJun2;

import com.tcLib2.*;
import com.tcJun2.*;

public class OUT_MSG extends MSG_0000
{
    public  sysHeader    sysHdr        = new sysHeader();
    public  trnHeader    trnHdr        = new trnHeader();
    public  bioHeader    bioHdr        = new bioHeader();
    public  msgHeader    msgHdr        = new msgHeader();
    
    public OUT_MSG()
    {
    }

    public void setData(byte[] buff, int pos) throws pvException
    {
    }
    // euc-kr, UTF-8 ...
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
    }

    public void getData(byte[] buff, int pos) throws pvException
    {
    }
    // euc-kr, UTF-8 ...
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
    }
    
    public void set(byte[] buff, int size) throws pvException
    {
        sysHdr.setData   (buff, 0);
        trnHdr.setData   (buff, sysHdr.iTLen);
        this.setData (buff, sysHdr.iTLen + trnHdr.iTLen);
    }
    
    public void set(byte[] buff, int size, String code) throws pvException
    {
        sysHdr.setData   (buff, 0, code);
        trnHdr.setData   (buff, sysHdr.iTLen, code);
        this.setData (buff, sysHdr.iTLen + trnHdr.iTLen,code);
    }

    //TOBE 2017-07-01
    public void setR(byte[] buff, int size, String code) throws pvException
    {
        sysHdr.setData   (buff, 0, code);
        trnHdr.setData   (buff, sysHdr.iTLen, code);
        msgHdr.setData   (buff, sysHdr.iTLen + trnHdr.iTLen , code);
        this.setData (buff, sysHdr.iTLen + trnHdr.iTLen + msgHdr.iTLen ,code);
    }

    public int get(byte[] buff) throws pvException
    {
        sysHdr.getData  (buff, 0);
        trnHdr.getData  (buff, sysHdr.iTLen);       
        this.getData(buff, sysHdr.iTLen + trnHdr.iTLen);
        return sysHdr.iTLen + trnHdr.iTLen + this.iTLen;
    }
    // euc-kr, UTF-8 ...
    public int get(byte[] buff, String code) throws pvException
    {
        sysHdr.getData  (buff, 0, code);
        trnHdr.getData  (buff, sysHdr.iTLen, code);        
        this.getData(buff, sysHdr.iTLen + trnHdr.iTLen, code);
        return sysHdr.iTLen + trnHdr.iTLen + this.iTLen;
    }

    // TOBE 2017-07-01 추가 재무회계 입지대사 euc-kr, UTF-8 ...
    public int getj(byte[] buff, String code,  int iTCnt, int iTCnt_list) throws pvException
    {
        this.getData(buff, sysHdr.iTLen + trnHdr.iTLen + iTCnt, code);
        return sysHdr.iTLen + trnHdr.iTLen + iTCnt+ iTCnt_list;
    }
    
    //AS-IS : get870100S
    public int getBCB01000T02S(byte[] buff, String code, int iTCnt) throws pvException
    {
    	int rtn = 0;
        sysHdr.getData  (buff, 0, code);
        trnHdr.getData  (buff, sysHdr.iTLen, code);        
        this.getData(buff, sysHdr.iTLen + trnHdr.iTLen, code);
        rtn = sysHdr.iTLen + trnHdr.iTLen + (this.iOrgLen*iTCnt);
        return rtn;
    }
    
    //AS-IS : get870100B
    public int getBCB01000T02B(byte[] buff, String code, int iTCnt, int iBioCnt) throws pvException
    {
    	int rtn = 0;
        sysHdr.getData (buff, 0, code);
        trnHdr.getData (buff, sysHdr.iTLen, code);        
        bioHdr.getData (buff, sysHdr.iTLen + trnHdr.iTLen, code);
        this.getData   (buff, sysHdr.iTLen + trnHdr.iTLen + iBioCnt, code);
         rtn = sysHdr.iTLen + trnHdr.iTLen + iBioCnt + iTCnt;
        return rtn;
    }

    //AS-IS : get870101S
    public int getBCB01000T03S(byte[] buff, String code) throws pvException
    {
     	int rtn = 0;

        sysHdr.getData  (buff, 0, code);
        trnHdr.getData  (buff, sysHdr.iTLen, code);        
       	this.getData(buff, sysHdr.iTLen + trnHdr.iTLen, code);
       	rtn = sysHdr.iTLen + trnHdr.iTLen + this.iTLen;     	
        
        return rtn;
    }

  //AS-IS : get870101B
    public int getBCB01000T03B(byte[] buff, String code, int iBioCnt) throws pvException
    {
     	int rtn = 0;

        sysHdr.getData (buff, 0, code);
        trnHdr.getData (buff, sysHdr.iTLen, code);        
        bioHdr.getData (buff, sysHdr.iTLen + trnHdr.iTLen, code);
        this.getData   (buff, sysHdr.iTLen + trnHdr.iTLen + iBioCnt, code);
       	rtn = sysHdr.iTLen + trnHdr.iTLen + iBioCnt + this.iTLen;     	
       
        return rtn;
    }
    
  //AS-IS : get8603S
    public int getBEB00730T03S(byte[] buff, String code) throws pvException
    {
     	int rtn = 0;

        sysHdr.getData  (buff, 0, code);
        trnHdr.getData  (buff, sysHdr.iTLen, code);        
       	this.getData(buff, sysHdr.iTLen + trnHdr.iTLen, code);
       	rtn = sysHdr.iTLen + trnHdr.iTLen + this.iTLen;     	
        
        return rtn;
    }

    //AS-IS : get8603B
    public int getBEB00730T03B(byte[] buff, String code, int iBioCnt) throws pvException
    {
     	int rtn = 0;

        sysHdr.getData (buff, 0, code);
        trnHdr.getData (buff, sysHdr.iTLen, code);        
        bioHdr.getData (buff, sysHdr.iTLen + trnHdr.iTLen, code);
        this.getData   (buff, sysHdr.iTLen + trnHdr.iTLen + iBioCnt, code);
       	rtn = sysHdr.iTLen + trnHdr.iTLen + iBioCnt + this.iTLen;     	
       
        return rtn;
    }
}