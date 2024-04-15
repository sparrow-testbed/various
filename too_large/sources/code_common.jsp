<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.db.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.msg.*" %>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%!
    //ListBox를 띄우기 위한 메소드.
    //Parameter code : ICOMCODE에 등록된 CODE

    public String ListBox(HttpServletRequest req, String code, String param, String selected) throws Exception
    {
        sepoa.fw.ses.SepoaInfo info1 = sepoa.fw.ses.SepoaSession.getAllValue(req);
        SepoaFormater wf = null;

        String  LB_nickName = "CO_012";
        String  LB_conType = "CONNECTION";
        String  LB_methodName = "getCodeFlag";

            Object[] LB_obj_flag = {code};
            String[] values =  null;

            if(param.length() != 0) {
             SepoaStringTokenizer st_column = new SepoaStringTokenizer(param,"#");
             int st_count = st_column.countTokens();

                values = new String[st_count];
                for (int i=0; i<st_count; i++) {
                values[i] = st_column.nextToken();
                }
        }

            Object[] LB_obj_result = {code, values};

        SepoaRemote  LB_wr_flag = null;
        SepoaRemote  LB_wr_result = null;
        SepoaOut  LB_flag = null;
        SepoaOut  LB_result = null;

        String rtn = ""; //return value

        //Flag정보조회

        try {
             LB_wr_flag = new SepoaRemote( LB_nickName,  LB_conType, info1);

             LB_flag = LB_wr_flag.lookup(LB_methodName, LB_obj_flag);
            } catch(Exception e) {
                Logger.debug.println(info1.getSession("ID"),"e = " + e.getMessage());
                Logger.debug.println(info1.getSession("ID"),"message = " + LB_flag.message);
                Logger.debug.println(info1.getSession("ID"),"status = " + LB_flag.status);
        } finally {
            LB_wr_flag.Release();
        }

            if (LB_flag.status == 1) {
                //Flag값을 가져온다. SP(SingleListBox)/MP(MultiListBox)
                String type = "";
                try {
                        wf = new SepoaFormater(LB_flag.result[0]);
                        type = wf.getValue("FLAG",0);
                } catch (Exception e) {}

                //type이 ListBox 인것만 결과값을 리턴한다.
                if (type.equals("SL") || type.equals("ML"))  {
                    LB_methodName = "getCodeSearch";
                   try {
                            LB_wr_result = new SepoaRemote(LB_nickName,  LB_conType, info1);
                            LB_result = LB_wr_result.lookup(LB_methodName, LB_obj_result);
                            if (LB_result.status == 1) {
                                wf = new SepoaFormater(LB_result.result[0]);
                                    for(int i=0; i<wf.getRowCount(); i++) {
                                        if (wf.getValue(i,0).equals(selected)) {
                                            rtn += "<OPTION VALUE=\""+wf.getValue(i,0)+"\" selected>"+wf.getValue(i,1)+"</OPTION>\n";
                                        }	else {
                                            rtn += "<OPTION VALUE=\""+wf.getValue(i,0)+"\">"+wf.getValue(i,1)+"</OPTION>\n";
                                        }
                                    }//for Row갯수만큼...
                             }// if  result 성공

                    }catch(Exception e) {
                        Logger.debug.println(info1.getSession("ID"),"e = " + e.getMessage());
                    } finally {
                        LB_wr_result.Release();
                    }
                }//if	ListBox type인것만..
            }//if	flag 성공

//            Logger.debug.println("cjerp111", this, "))))))) rtn ======> " + rtn);

            return rtn;
        }

///////////////////////////////////////////////////////////////////////////////
    //새로운 사용자 등록시...
    public String ListBox(sepoa.fw.ses.SepoaInfo info1, String code, String param, String selected) throws Exception
    {
        SepoaFormater wf = null;

        String  LB_nickName = "CO_012";
        String  LB_conType = "CONNECTION";
        String  LB_methodName = "getCodeFlag";

       Object[] LB_obj_flag = {code};
       String[] values =  null;

       if(param.length() != 0) {
             SepoaStringTokenizer st_column = new SepoaStringTokenizer(param,"#");
             int st_count = st_column.countTokens();

           values = new String[st_count];
           for (int i=0; i<st_count; i++) {
                values[i] = st_column.nextToken();
           }
       }

       Object[] LB_obj_result = {code, values};

        SepoaRemote  LB_wr_flag = null;
        SepoaRemote  LB_wr_result = null;

        SepoaOut  LB_flag = null;
        SepoaOut  LB_result = null;

        String rtn = "";
 
       try {
                 LB_wr_flag = new SepoaRemote( LB_nickName,  LB_conType, info1);
                 LB_flag = LB_wr_flag.lookup(LB_methodName, LB_obj_flag);
            } catch(Exception e) {
                Logger.debug.println(info1.getSession("ID"),"e = " + e.getMessage());
                Logger.debug.println(info1.getSession("ID"),"message = " + LB_flag.message);
                Logger.debug.println(info1.getSession("ID"),"status = " + LB_flag.status);
            } finally {
                LB_wr_flag.Release();
            }

            if (LB_flag.status == 1) {
                //Flag값을 가져온다. SP(SingleListBox)/MP(MultiListBox)
                String type = "";
                try {
                        wf = new SepoaFormater(LB_flag.result[0]);
                        type = wf.getValue("FLAG",0);
                } catch (Exception e) {}

                //type이 ListBox 인것만 결과값을 리턴한다.
                if (type.equals("SL") || type.equals("ML"))  {
                    LB_methodName = "getCodeSearch";
                   try {
                            LB_wr_result = new SepoaRemote(LB_nickName,  LB_conType, info1);
                            LB_result = LB_wr_result.lookup(LB_methodName, LB_obj_result);
                            if (LB_result.status == 1) {
                                wf = new SepoaFormater(LB_result.result[0]);
                                    for(int i=0; i<wf.getRowCount(); i++) {
                                        if (wf.getValue(i,0).equals(selected)) {
                                            rtn += "<OPTION VALUE="+wf.getValue(i,0)+" selected>"+wf.getValue(i,1)+"</OPTION>\n";
                                        }	else {
                                            rtn += "<OPTION VALUE="+wf.getValue(i,0)+">"+wf.getValue(i,1)+"</OPTION>\n";
                                        }
                                    }//for Row갯수만큼...
                             }// if  result 성공

                    }catch(Exception e) {
                        Logger.debug.println(info1.getSession("ID"),"e = " + e.getMessage());
                    } finally {
                        LB_wr_result.Release();
                    }
                }//if	ListBox type인것만..
            }//if	flag 성공

            return rtn;
        }





////////////////////////////////////////////////////////////////////////////////
    public String Table_ListBox(HttpServletRequest req, String code, String param) throws Exception
    {
        sepoa.fw.ses.SepoaInfo info1 = sepoa.fw.ses.SepoaSession.getAllValue(req);
        SepoaFormater wf = null;

        String  LB_nickName = "CO_012";
        String  LB_conType = "CONNECTION";
        String  LB_methodName = "getCodeFlag";

       Object[] LB_obj_flag = {code};
       String[] values =  null;

       if(param.length() != 0) {
             SepoaStringTokenizer st_column = new SepoaStringTokenizer(param,"#");
             int st_count = st_column.countTokens();

           values = new String[st_count];
           for (int i=0; i<st_count; i++) {
                values[i] = st_column.nextToken();
           }
       }

       Object[] LB_obj_result = {code, values};

        SepoaRemote  LB_wr_flag = null;
        SepoaRemote  LB_wr_result = null;

        SepoaOut  LB_flag = null;
        SepoaOut  LB_result = null;

        String rtn = ""; //return value

       try {
                 LB_wr_flag = new SepoaRemote( LB_nickName,  LB_conType, info1);
                 LB_flag = LB_wr_flag.lookup(LB_methodName, LB_obj_flag);
            } catch(Exception e) {
                Logger.debug.println(info1.getSession("ID"),"e = " + e.getMessage());
            } finally {
                LB_wr_flag.Release();
            }

            if (LB_flag.status == 1) {
                //Flag값을 가져온다. SP(SingleListBox)/MP(MultiListBox)
                String type = "";
                try {
                        wf = new SepoaFormater(LB_flag.result[0]);
                        type = wf.getValue("FLAG",0);
                } catch (Exception e) {}

                //type이 ListBox 인것만 결과값을 리턴한다.
                if (type.equals("SL") || type.equals("ML"))  {
                    LB_methodName = "getCodeSearch";
                   try {
                            LB_wr_result = new SepoaRemote(LB_nickName,  LB_conType, info1);
                            LB_result = LB_wr_result.lookup(LB_methodName, LB_obj_result);
                            if (LB_result.status == 1) {
                                wf = new SepoaFormater(LB_result.result[0]);
                                    for(int i=0; i<wf.getRowCount(); i++) {
                                        rtn += wf.getValue(i,0)+"#"+wf.getValue(i,1)+"@";
                                    }//for Row갯수만큼...
                             }// if  result 성공
                    }catch(Exception e) {
                        Logger.debug.println(info1.getSession("ID"),"e = " + e.getMessage());
                    } finally {
                        LB_wr_result.Release();
                    }
                }//if	ListBox type인것만..
            }//if	flag 성공
            return rtn;
        }

/*
	여러코드에 대해 DB작업을 한번만 할 수 있게 하는 버전
	커넥션을 세번만 맺기 때문에 많은 속도 향상을 볼 수 있습니다.
	1. 플래그 조회는 SL, ML(리스트박스 타입)인지를 검사하는 역할을 한다.
	플래그는 in 으로 해서 한번만 쿼리해서 다 가져온다.
	SELECT FLAG, TEXT5, CODE
	WHERE TYPE = 'S000' AND CODE IN ('"+code+"')
	sql실행시에 순서대로 가져오지 않는다는 점에 유의한다.
	플래그가 하나라도 리스트박스가 아닌것이 있다면  null을 반환한다.

	2. 코드에 해당하는 SQL문 조회
	SELECT TEXT4
	FROM ICOMCODE
	WHERE HOUSE_CODE = '"+house_code+"' AND TYPE = 'S000' AND CODE ='"+code+"'

	3. SQL 실행결과 반환



*/
public String[] ListBoxArr(HttpServletRequest req, String[] code, String[] param, String[] selected) throws Exception
{
	String[] rtn = null;

	String nickName = "CO_012";
	String methodType = "CONNECTION";

	sepoa.fw.ses.SepoaInfo info1 = sepoa.fw.ses.SepoaSession.getAllValue(req);

	SepoaFormater wf = null;
	String flag_sqlin = "";
	int iCodeCount = code.length;

	for(int i=0;i<iCodeCount;i++)
	{
		if(i==(iCodeCount-1))
		{
			flag_sqlin = flag_sqlin + "'" + code[i] + "'";
			break;
		}

		flag_sqlin = flag_sqlin + "'" + code[i] + "',";
	}

	Object[] LB_obj_flag = {flag_sqlin};
	SepoaOut LB_flag = ServiceConnector.doService(info1, nickName, methodType,"getCodeFlagArr", LB_obj_flag);
	int iFlagStatus = LB_flag.status;

	if(iFlagStatus != 1)
		return rtn;

	wf = new SepoaFormater(LB_flag.result[0]);
	String[] TEMP_FLAG     = wf.getValue("FLAG");
	for(int i=0;i<TEMP_FLAG.length;i++)
	{
		Logger.debug.println(info1.getSession("ID"), this, "temp_flag="+TEMP_FLAG[i]);
		if(!(TEMP_FLAG[i].equals("SL") || TEMP_FLAG[i].equals("ML")) )
			return rtn;

	}

	Object[] LB_obj_result = {code, param};
	SepoaOut LB_result = ServiceConnector.doService(info1, nickName, methodType,"getCodeSearchArr", LB_obj_result);
	if (LB_result.status != 1)
		return rtn;

	int iResultCount = LB_result.result.length;
	if(iCodeCount != iResultCount)
	{
		return rtn;
	}


	rtn = new String[iResultCount];

	for(int i=0;i<iCodeCount;i++)
	{
		wf = new SepoaFormater(LB_result.result[i]);
		rtn[i] = "";
		selected[i] = JSPUtil.nullToEmpty(selected[i]);

		for(int j=0;j<wf.getRowCount();j++)
		{
			if (wf.getValue(j,0).equals(selected[i]))
			{
				rtn[i] += "<OPTION VALUE=\""+wf.getValue(j,0)+"\" selected>"+wf.getValue(j,1)+"</OPTION>\n";
			}
			else
			{
				rtn[i] += "<OPTION VALUE=\""+wf.getValue(j,0)+"\">"+wf.getValue(j,1)+"</OPTION>\n";
			}
		}
	}


	return rtn;
}
%>

<!-- Code Serach START (JavaScript here)-->
<Script language="javascript">
<!--
        //Code_Search POPUP을 띄운다.
        function Code_Search(url, title, left, top, width, height) {
             if (title == '') title = 'Code_Search';
            if (left == '') left = 50;
            if (top == '') top = 100;
            if (width == '') width = 540;
            if (height == '') height = 500;


            //화면 가운데로 배치
            var dim = new Array(2);

             dim = ToCenter(height,width);
             top = dim[0];
             left = dim[1];

            var toolbar = 'no';
            var menubar = 'no';
            var status = 'yes';
            var scrollbars = 'no';
            var resizable = 'no';
            var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
            code_search.focus();
        }

        function ToCenter(height,width) {

            var outx = screen.height;
            var outy = screen.width;
            var x = (outx - height)/2;
            var y = (outy - width)/2;
            dim = new Array(2);
            dim[0] = x;
            dim[1] = y;

            return  dim;
        }


//-->
</Script>
