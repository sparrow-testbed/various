package com.tcLib2;

import java.io.IOException;

public interface I_Wms {
	public abstract int  sendMessage(String bizCode, String servAddress, int servPort) throws IOException;
	static final int TCP_BUFSIZE = 80000; //TOBE 2017-07-01 30720 -> 80000
	public static final int D_OK                        =  0;
    public static final int D_ERR                       = -1;
    public static final int D_TMOUT                     = -2;
    public static final int D_ECODE                     = -3;
    public static final int D_ENETWORK                  = -4;
    public static final int D_EFORMAT                   = -5;
}
