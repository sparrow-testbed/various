package com.tcComm2;

import java.net.ServerSocket;
import java.net.Socket;
import java.sql.*;

public class INCNF
{
    public Connection     	CONN     	= null;
    public int      		TXDATE     	=  0; 
    public int      		TXTIME      =  0;  
    public String   		EventCode   = "";
    public Socket 			clntSock 	= null;
    public ServerSocket		servSock    = null;
    public long             Seq_no      =  0;
    public long             Pre_Seq_no  =  0;
    public long             Pre_no      =  0;
    public String           Req_date    = "";
    public String           sThreadName = "";
    public String           logname     = "";
    public String           svr_address = "";
    public int 				svr_port    = 0;

	
}