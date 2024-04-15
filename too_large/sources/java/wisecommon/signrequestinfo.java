package wisecommon;

import sepoa.fw.log.Logger;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaStringTokenizer;

public class SignRequestInfo
{

    public SignRequestInfo()
    {
        HouseCode = "";
        CompanyCode = "";
        Dept = "";
        DocType = "";
        DocNo = "";
        DocSeq = "0";
        ReqUserId = "";
        ReqEmpNo = "";
        ShipperType = "";
        CtrlCode = "";
        ItemCount = 0;
        Cur = "";
        TotalAmt = 0.0D;
        TotalAmtEx = 0.0D;
        AccountCode = "";
        UrgentFlag = "";
        SignRemark = " ";
        ReqDate = "";
        ReqTime = "";
        OperatingCode = "";
        DocName = "";
        AutoManualFlag = "";
        StrategyType = "";
        SignUserID = "";
        SignEmpNo = "";
        SignString = "";
        SignStatus = "";
        Sign_path_data = (String[][])null;
        Logger.debug.println("LEEPLE", this, "_____contructor--------------");
        ReqDate = SepoaDate.getShortDateString();
        ReqTime = SepoaDate.getShortTimeString();
        user_trm_no = "";		
    }

    public String getHouseCode()
    {
        return HouseCode;
    }

    public String getCompanyCode()
    {
        return CompanyCode;
    }

    public String getDept()
    {
        return Dept;
    }

    public String getDocType()
    {
        return DocType;
    }

    public String getDocNo()
    {
        return DocNo;
    }

    public String getDocSeq()
    {
        return DocSeq;
    }

    public String getReqUserId()
    {
        return ReqUserId;
    }

    public String getReqEmpNo()
    {
        return ReqEmpNo;
    }

    public String getShipperType()
    {
        return ShipperType;
    }

    public String getCtrlCode()
    {
        return CtrlCode;
    }

    public int getItemCount()
    {
        return ItemCount;
    }

    public String getCur()
    {
        return Cur;
    }

    public double getTotalAmt()
    {
        return TotalAmt;
    }

    public double getTotalAmtEx()
    {
        return TotalAmtEx;
    }

    public String getAccountCode()
    {
        return AccountCode;
    }

    public String getUrgentFlag()
    {
        return UrgentFlag;
    }

    public String getSignRemark()
    {
        return SignRemark;
    }

    public String getDocName()
    {
        return DocName;
    }

    public String getReqDate()
    {
        return ReqDate;
    }

    public String getReqTime()
    {
        return ReqTime;
    }

    public String getAutoManualFlag()
    {
        return AutoManualFlag;
    }

    public String getStrategyType()
    {
        return StrategyType;
    }

    public String getSignUserID()
    {
        return SignUserID;
    }

    public String getSignEmpNo()
    {
        return SignEmpNo;
    }

    public String getSignStatus()
    {
        return SignStatus;
    }

    public String getOperatingCode()
    {
        return OperatingCode;
    }

    public String[][] getSign_Path()
    {
        return Sign_path_data;
    }

    public String getAttachFile()
    {
        return attachFile;
    }

    public void setHouseCode(String s)
    {
        HouseCode = s;
    }

    public void setCompanyCode(String s)
    {
        CompanyCode = s;
    }

    public void setDept(String s)
    {
        Dept = s;
    }

    public void setDocType(String s)
    {
        DocType = s;
    }

    public void setDocNo(String s)
    {
        DocNo = s;
    }

    public void setDocSeq(String s)
    {
        DocSeq = s;
    }

    public void setReqUserId(String s)
    {
        ReqUserId = s;
    }

    public void setReqEmpNo(String s)
    {
        ReqEmpNo = s;
    }

    public void setShipperType(String s)
    {
        ShipperType = s;
    }

    public void setCtrlCode(String s)
    {
        CtrlCode = s;
    }

    public void setItemCount(int i)
    {
        ItemCount = i;
    }

    public void setCur(String s)
    {
        Cur = s;
    }

    public void setTotalAmt(double d)
    {
        TotalAmt = d;
    }

    public void setTotalAmtEx(double d)
    {
        TotalAmtEx = d;
    }

    public void setUrgentFlag(String s)
    {
        UrgentFlag = s;
    }

    public void setSignUserId(String s)
    {
        SignUserID = s;
    }

    public void setSignRemark(String s)
    {
        SignRemark = s;
    }

    public void setDocName(String s)
    {
        DocName = s;
    }

    public void setAutoManualFlag(String s)
    {
        AutoManualFlag = s;
    }

    public void setOperatingCode(String s)
    {
        OperatingCode = s;
    }

    public void setSignString(String s)
    {
        Logger.debug.println("LEEPLE", this, "SignString======" + s);
        SepoaStringTokenizer Sepoastringtokenizer = new SepoaStringTokenizer(s, "|||", false);
        int i = Sepoastringtokenizer.countTokens();
        String as[] = new String[i];
        int j = 0;
        int k = 0;
        for(; j < i; j++)
        {
            String s1 = Sepoastringtokenizer.nextToken();
            SepoaStringTokenizer Sepoastringtokenizer1 = new SepoaStringTokenizer(s1, "===", false);
            int l = Sepoastringtokenizer1.countTokens();
            String s2 = "";
            if(l == 2)
            {
                Sepoastringtokenizer1.nextToken();
                s2 = Sepoastringtokenizer1.nextToken();
            }
            as[k++] = s2;
        }

        String as1[][] = (String[][])(String[][])null;
        Logger.debug.println("LEEPLE", this, "param.length======" + as.length);
        if(as.length == 7)
        {
            SepoaStringTokenizer Sepoastringtokenizer2 = new SepoaStringTokenizer(as[6], "$", false);
            int i1 = Sepoastringtokenizer2.countTokens();
            for(int j1 = 0; j1 < i1; j1++)
            {
                String s3 = Sepoastringtokenizer2.nextToken();
                SepoaStringTokenizer Sepoastringtokenizer3 = new SepoaStringTokenizer(s3, "#", false);
                int k1 = Sepoastringtokenizer3.countTokens();
                if(j1 == 0)
                    as1 = new String[i1][k1];
                for(int l1 = 0; l1 < k1; l1++)
                    as1[j1][l1] = Sepoastringtokenizer3.nextToken().trim();

            }

        }
        setUrgentFlag(as[0]);
        setSignUserId(as[1]);
        setSignRemark(as[2]);
        setAutoManualFlag(as[3]);
        setStrategyType(as[4]);
        setAttachFile(as[5]); //20008-12-26 Attach file �߰�
        setSign_Path(as1);
      
        Logger.debug.println("LEEPLE", this, "^^add_sign_request^^^^param[4]^^strategy==" + as[4]);
    }

    public void setSignStatus(String s)
    {
        SignStatus = s;
    }

    public void setAccountCode(String s)
    {
        AccountCode = s;
    }

    public void setStrategyType(String s)
    {
        StrategyType = s;
    }

    public void setSign_Path(String as[][])
    {
        Sign_path_data = as;
    }

    public void setAttachFile(String s)
    {
        attachFile = s;
    }

    private String HouseCode;
    private String CompanyCode;
    private String Dept;
    private String DocType;
    private String DocNo;
    private String DocSeq;
    private String ReqUserId;
    private String ReqEmpNo;
    private String ShipperType;
    private String CtrlCode;
    private int ItemCount;
    private String Cur;
    private double TotalAmt;
    private double TotalAmtEx;
    private String AccountCode;
    private String UrgentFlag;
    private String SignRemark;
    private String ReqDate;
    private String ReqTime;
    private String OperatingCode;
    private String DocName;
    private String AutoManualFlag;
    private String StrategyType;
    private String SignUserID;
    private String SignEmpNo;
    private String SignString;
    private String SignStatus;
    private String attachFile;
    private String Sign_path_data[][];
    
   //단말정보 시작//////////////////////////////////////////////////
  	private String user_trm_no;
  	
  	public void setUser_trm_no(String s) { user_trm_no = s; }
  	
  	public String getUser_trm_no() { return user_trm_no;     }
  	//단말정보 끝////////////////////////////////////////////////////
}
