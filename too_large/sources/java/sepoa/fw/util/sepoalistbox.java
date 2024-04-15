package sepoa.fw.util;

import javax.servlet.http.HttpServletRequest;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.ses.SepoaSession;
import sepoa.fw.srv.SepoaOut;

public class SepoaListBox
{
    public SepoaListBox()
    {
    }

    public String ListBox(SepoaInfo sepoainfo, String s, String s1, String s2) throws Exception
    {
        Object obj = null;
        String s3 = "AD_200";
        String s4 = "CONNECTION";
        String s5 = "";
        Object[] aobj = { s };
        String[] as = null;

        if (s1.length() != 0)
        {
            SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s1, "#");
            int i = sepoastringtokenizer.countTokens();
            as = new String[i];

            for (int j = 0; j < i; j++)
            {
                as[j] = sepoastringtokenizer.nextToken();
            }
        }

        Object[] aobj1 = { s, as };
        SepoaRemote sepoaremote = null;
        SepoaRemote sepoaremote1 = null;
        SepoaOut sepoaout = null;
        Object obj1 = null;
        String s7 = "";
        s5 = "getCodeFlag";

        try
        {
            sepoaremote = new SepoaRemote(s3, s4, sepoainfo);
            sepoaout = sepoaremote.lookup(s5, aobj);
        }
        catch (Exception exception)
        {
            Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception.getMessage());
//            Logger.debug.println(sepoainfo.getSession("ID"), "message = " + sepoaout.message);
//            Logger.debug.println(sepoainfo.getSession("ID"), "status = " + sepoaout.status);
        }
        finally
        {
            if(sepoaremote != null){ sepoaremote.Release(); }
        }

        if (sepoaout != null && sepoaout.status == 1)
        {
            String s8 = "";

            try
            {
                SepoaFormater sepoaformater = new SepoaFormater(sepoaout.result[0]);
                s8 = sepoaformater.getValue("FLAG", 0);
            }
            catch (Exception exception2)
            {
            	Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception2.getMessage());
            }

            if (s8.equals("SL") || s8.equals("ML"))
            {
                String s6 = "getCodeSearch";

                try
                {
                    sepoaremote1 = new SepoaRemote(s3, s4, sepoainfo);

                    SepoaOut sepoaout1 = sepoaremote1.lookup(s6, aobj1);

                    if (sepoaout1.status == 1)
                    {
                        SepoaFormater sepoaformater1 = new SepoaFormater(sepoaout1.result[0]);

                        for (int k = 0; k < sepoaformater1.getRowCount();
                                k++)
                        {
                            if (sepoaformater1.getValue(k, 0).equals(s2))
                            {
                                s7 = s7 + "<OPTION VALUE=\"" + sepoaformater1.getValue(k, 0) + "\" selected>" + sepoaformater1.getValue(k, 1) + "</OPTION>\n";
                            }
                            else
                            {
                                s7 = s7 + "<OPTION VALUE=\"" + sepoaformater1.getValue(k, 0) + "\">" + sepoaformater1.getValue(k, 1) + "</OPTION>\n";
                            }
                        }
                    }
                }
                catch (Exception exception3)
                {
                    Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception3.getMessage());
                }
                finally
                {
                	if(sepoaremote1 != null){ sepoaremote1.Release(); }
                }
            }
        }

        return s7;
    }

    public String ListBox(HttpServletRequest httpservletrequest, String s, String s1, String s2) throws Exception
    {
        SepoaInfo sepoainfo = SepoaSession.getAllValue(httpservletrequest);
        Object obj = null;
        String s3 = "AD_200";
        String s4 = "CONNECTION";
        String s5 = "";
        Object[] aobj = { s };
        String[] as = null;

        if (s1.length() != 0)
        {
            SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s1, "#");
            int i = sepoastringtokenizer.countTokens();
            as = new String[i];

            for (int j = 0; j < i; j++)
            {
                as[j] = sepoastringtokenizer.nextToken();
            }
        }

        Object[] aobj1 = { s, as };
        SepoaRemote sepoaremote = null;
        SepoaRemote sepoaremote1 = null;
        SepoaOut sepoaout = null;
        Object obj1 = null;
        String s7 = "";
        s5 = "getCodeFlag";

        try
        {
            //            StopWatch stopwatch = new StopWatch();
            sepoaremote = new SepoaRemote(s3, s4, sepoainfo);
            //            Logger.debug.println(wiseinfo.getSession("ID"), "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
            //            Logger.debug.println(wiseinfo.getSession("ID"), "   after new wiseremote getElapsed ==> " + stopwatch.getElapsed());
            //            Logger.debug.println(wiseinfo.getSession("ID"), "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
            //
            //            StopWatch stopwatch1 = new StopWatch();
            sepoaout = sepoaremote.lookup(s5, aobj);

            //            Logger.debug.println(wiseinfo.getSession("ID"), "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
            //            Logger.debug.println(wiseinfo.getSession("ID"), "   after lookup getElapsed ==> " + stopwatch1.getElapsed());
            //            Logger.debug.println(wiseinfo.getSession("ID"), "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        }
        catch (Exception exception)
        {
        	Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception.getMessage());
        }
        finally
        {
        	if(sepoaremote != null){ sepoaremote.Release(); }
        }

        if (sepoaout != null && sepoaout.status == 1)
        {
            String s8 = "";

            try
            {
                SepoaFormater sepoaformater = new SepoaFormater(sepoaout.result[0]);
                s8 = sepoaformater.getValue("FLAG", 0);
            }
            catch (Exception exception2)
            {
            	Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception2.getMessage());
            }

            if (s8.equals("SL") || s8.equals("ML"))
            {
                String s6 = "getCodeSearch";

                try
                {
                    //                    StopWatch stopwatch2 = new StopWatch();
                    sepoaremote1 = new SepoaRemote(s3, s4, sepoainfo);

                    //                    Logger.debug.println(wiseinfo.getSession("ID"), "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                    //                    Logger.debug.println(wiseinfo.getSession("ID"), "   1 after new wiseremote getElapsed ==> " + stopwatch2.getElapsed());
                    //                    Logger.debug.println(wiseinfo.getSession("ID"), "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                    //
                    //                    StopWatch stopwatch3 = new StopWatch();
                    SepoaOut sepoaout1 = sepoaremote1.lookup(s6, aobj1);

                    //                    Logger.debug.println(wiseinfo.getSession("ID"), "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                    //                    Logger.debug.println(wiseinfo.getSession("ID"), "   1 after lookup getElapsed ==> " + stopwatch3.getElapsed());
                    //                    Logger.debug.println(wiseinfo.getSession("ID"), "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                    if (sepoaout1.status == 1)
                    {
                        SepoaFormater sepoaformater1 = new SepoaFormater(sepoaout1.result[0]);

                        for (int k = 0; k < sepoaformater1.getRowCount();
                                k++)
                        {
                            if (sepoaformater1.getValue(k, 0).equals(s2))
                            {
                                s7 = s7 + "<OPTION VALUE=" + sepoaformater1.getValue(k, 0) + " selected>" + sepoaformater1.getValue(k, 1) + "</OPTION>\n";
                            }
                            else
                            {
                                s7 = s7 + "<OPTION VALUE=" + sepoaformater1.getValue(k, 0) + ">" + sepoaformater1.getValue(k, 1) + "</OPTION>\n";
                            }
                        }
                    }
                }
                catch (Exception exception3)
                {
                    Logger.debug.println("getCode", "e = " + exception3.getMessage());
                }
                finally
                {
                	if(sepoaremote1 != null){ sepoaremote1.Release(); }
                }
            }
        }

        return s7;
    }

    public String ListBox_1(HttpServletRequest httpservletrequest, String s, String s1, String s2) throws Exception
    {
        SepoaInfo sepoainfo = SepoaSession.getAllValue(httpservletrequest);
        Object obj = null;
        String s3 = "AD_200";
        String s4 = "CONNECTION";
        String s5 = "";
        Object[] aobj = { s };
        String[] as = null;

        if (s1.length() != 0)
        {
            SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s1, "#");
            int i = sepoastringtokenizer.countTokens();
            as = new String[i];

            for (int j = 0; j < i; j++)
            {
                as[j] = sepoastringtokenizer.nextToken();
            }
        }

        Object[] aobj1 = { s, as };
        SepoaRemote sepoaremote = null;
        SepoaRemote sepoaremote1 = null;
        SepoaOut sepoaout = null;
        Object obj1 = null;
        String s7 = "";
        s5 = "getCodeFlag";

        try
        {
            sepoaremote = new SepoaRemote(s3, s4, sepoainfo);
            sepoaout = sepoaremote.lookup(s5, aobj);
        }
        catch (Exception exception)
        {
            Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception.getMessage());
        }
        finally
        {
        	if(sepoaremote != null){ sepoaremote.Release(); }
        }

        if (sepoaout != null && sepoaout.status == 1)
        {
            String s8 = "";

            try
            {
                SepoaFormater sepoaformater = new SepoaFormater(sepoaout.result[0]);
                s8 = sepoaformater.getValue("FLAG", 0);
            }
            catch (Exception exception2)
            {
            	Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception2.getMessage());
            }

            if (s8.equals("SL") || s8.equals("ML"))
            {
                String s6 = "getCodeSearch";

                try
                {
                    sepoaremote1 = new SepoaRemote(s3, s4, sepoainfo);

                    SepoaOut sepoaout1 = sepoaremote1.lookup(s6, aobj1);

                    if (sepoaout1.status == 1)
                    {
                        SepoaFormater sepoaformater1 = new SepoaFormater(sepoaout1.result[0]);

                        for (int k = 0; k < sepoaformater1.getRowCount();
                                k++)
                        {
                            if (sepoaformater1.getValue(k, 0).equals(s2))
                            {
                                s7 = s7 + "<OPTION NAME=" + sepoaformater1.getValue(k, 1) + " VALUE=" + sepoaformater1.getValue(k, 0) + " selected>" + sepoaformater1.getValue(k, 1) + "</OPTION>\n";
                            }
                            else
                            {
                                s7 = s7 + "<OPTION NAME=" + sepoaformater1.getValue(k, 1) + " VALUE=" + sepoaformater1.getValue(k, 0) + ">" + sepoaformater1.getValue(k, 1) + "</OPTION>\n";
                            }
                        }
                    }
                }
                catch (Exception exception3)
                {
                    Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception3.getMessage());
                }
                finally
                {
                	if(sepoaremote1 != null){ sepoaremote1.Release(); }
                }
            }
        }

        return s7;
    }

    public String Table_ListBox(HttpServletRequest httpservletrequest, String s, String s1, String s2, String s3) throws Exception
    {
        SepoaInfo sepoainfo = SepoaSession.getAllValue(httpservletrequest);
        Object obj = null;
        String s4 = "AD_200";
        String s5 = "CONNECTION";
        String s6 = "";
        Object[] aobj = { s };
        String[] as = null;

        if (s1.length() != 0)
        {
            SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s1, "#");
            int i = sepoastringtokenizer.countTokens();
            as = new String[i];

            for (int j = 0; j < i; j++)
            {
                as[j] = sepoastringtokenizer.nextToken();
            }
        }

        Object[] aobj1 = { s, as };
        SepoaRemote sepoaremote = null;
        SepoaRemote sepoaremote1 = null;
        SepoaOut sepoaout = null;
        Object obj1 = null;
        String s8 = "";
        s6 = "getCodeFlag";

        try
        {
            sepoaremote = new SepoaRemote(s4, s5, sepoainfo);
            sepoaout = sepoaremote.lookup(s6, aobj);
        }
        catch (Exception exception)
        {
            Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception.getMessage());
        }
        finally
        {
        	if(sepoaremote != null){ sepoaremote.Release(); }
        }

        if (sepoaout != null && sepoaout.status == 1)
        {
            String s9 = "";

            try
            {
                SepoaFormater sepoaformater = new SepoaFormater(sepoaout.result[0]);
                s9 = sepoaformater.getValue("FLAG", 0);
            }
            catch (Exception exception2)
            {
            	Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception2.getMessage());
            }

            if (s9.equals("SL") || s9.equals("ML"))
            {
                String s7 = "getCodeSearch";

                try
                {
                    sepoaremote1 = new SepoaRemote(s4, s5, sepoainfo);

                    SepoaOut sepoaout1 = sepoaremote1.lookup(s7, aobj1);

                    if (sepoaout1.status == 1)
                    {
                        SepoaFormater sepoaformater1 = new SepoaFormater(sepoaout1.result[0]);

                        for (int k = 0; k < sepoaformater1.getRowCount();
                                k++)
                        {
                            s8 = s8 + sepoaformater1.getValue(k, 0) + s2 + sepoaformater1.getValue(k, 1) + s3;
                        }
                    }
                }
                catch (Exception exception3)
                {
                    Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception3.getMessage());
                }
                finally
                {
                	if(sepoaremote1 != null){ sepoaremote1.Release(); }
                }
            }
        }

        return s8;
    }

    public String Multi_Select(HttpServletRequest httpservletrequest, String s, String s1, String s2, String s3) throws Exception
    {
        SepoaInfo sepoainfo = SepoaSession.getAllValue(httpservletrequest);
        Object obj = null;
        String s4 = "AD_200";
        String s5 = "CONNECTION";
        String s6 = "";
        Object[] aobj = { s };
        String[] as = null;

        if (s1.length() != 0)
        {
            SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s1, "#");
            int i = sepoastringtokenizer.countTokens();
            as = new String[i];

            for (int j = 0; j < i; j++)
            {
                as[j] = sepoastringtokenizer.nextToken();
            }
        }

        Object[] aobj1 = { s, as };
        SepoaRemote sepoaremote = null;
        SepoaRemote sepoaremote1 = null;
        SepoaOut sepoaout = null;
        Object obj1 = null;
        String s8 = "";
        s6 = "getCodeFlag";

        try
        {
            sepoaremote = new SepoaRemote(s4, s5, sepoainfo);
            sepoaout = sepoaremote.lookup(s6, aobj);
        }
        catch (Exception exception)
        {
            Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception.getMessage());
        }
        finally
        {
        	if(sepoaremote != null){ sepoaremote.Release(); }
        }

        if (sepoaout != null && sepoaout.status == 1)
        {
            String s9 = "";

            try
            {
                SepoaFormater sepoaformater = new SepoaFormater(sepoaout.result[0]);
                s9 = sepoaformater.getValue("FLAG", 0);
            }
            catch (Exception exception2)
            {
            	Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception2.getMessage());
            }

            if (s9.equals("SL") || s9.equals("ML"))
            {
                String s7 = "getCodeSearch";

                try
                {
                    sepoaremote1 = new SepoaRemote(s4, s5, sepoainfo);

                    SepoaOut sepoaout1 = sepoaremote1.lookup(s7, aobj1);

                    if (sepoaout1.status == 1)
                    {
                        SepoaFormater sepoaformater1 = new SepoaFormater(sepoaout1.result[0]);
                        s8 = "parent." + s2 + ".document.forms[0]." + s3 + ".options.length=" + String.valueOf(sepoaformater1.getRowCount() + 1) + "\n";

                        for (int k = 0; k < sepoaformater1.getRowCount();
                                k++)
                        {
                            s8 = s8 + "parent." + s2 + ".document.forms[0]." + s3 + ".options[" + (k + 1) + "].value='" + sepoaformater1.getValue(k, 0) + "' \n";
                            s8 = s8 + "parent." + s2 + ".document.forms[0]." + s3 + ".options[" + (k + 1) + "].text='" + sepoaformater1.getValue(k, 1) + "' \n";
                        }
                    }
                }
                catch (Exception exception3)
                {
                    Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception3.getMessage());
                }
                finally
                {
                	if(sepoaremote1 != null){ sepoaremote1.Release(); }
                }
            }
        }

        return s8;
    }

    public String Multi_Select2(HttpServletRequest httpservletrequest, String s, String s1, String s2, String s3) throws Exception
    {
        SepoaInfo sepoainfo = SepoaSession.getAllValue(httpservletrequest);
        Object obj = null;
        String s4 = "AD_200";
        String s5 = "CONNECTION";
        String s6 = "";
        Object[] aobj = { s };
        String[] as = null;

        if (s1.length() != 0)
        {
            SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s1, "#");
            int i = sepoastringtokenizer.countTokens();
            as = new String[i];

            for (int j = 0; j < i; j++)
            {
                as[j] = sepoastringtokenizer.nextToken();
            }
        }

        Object[] aobj1 = { s, as };
        SepoaRemote sepoaremote = null;
        SepoaRemote sepoaremote1 = null;
        SepoaOut sepoaout = null;
        Object obj1 = null;
        String s8 = "";
        s6 = "getCodeFlag";

        try
        {
            sepoaremote = new SepoaRemote(s4, s5, sepoainfo);
            sepoaout = sepoaremote.lookup(s6, aobj);
        }
        catch (Exception exception)
        {
            Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception.getMessage());
        }
        finally
        {
        	if(sepoaremote != null){ sepoaremote.Release(); }
        }

        if (sepoaout != null && sepoaout.status == 1)
        {
            String s9 = "";

            try
            {
                SepoaFormater sepoaformater = new SepoaFormater(sepoaout.result[0]);
                s9 = sepoaformater.getValue("FLAG", 0);
            }
            catch (Exception exception2)
            {
            	Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception2.getMessage());
            }

            if (s9.equals("SL") || s9.equals("ML"))
            {
                String s7 = "getCodeSearch";

                try
                {
                    sepoaremote1 = new SepoaRemote(s4, s5, sepoainfo);

                    SepoaOut sepoaout1 = sepoaremote1.lookup(s7, aobj1);

                    if (sepoaout1.status == 1)
                    {
                        SepoaFormater sepoaformater1 = new SepoaFormater(sepoaout1.result[0]);
                        s8 = "top.mainFrame.body." + s2 + ".document.forms[0]." + s3 + ".options.length=" + String.valueOf(sepoaformater1.getRowCount() + 1) + "\n";

                        for (int k = 0; k < sepoaformater1.getRowCount();
                                k++)
                        {
                            s8 = s8 + "top.mainFrame.body." + s2 + ".document.forms[0]." + s3 + ".options[" + (k + 1) + "].value='" + sepoaformater1.getValue(k, 0) + "' \n";
                            s8 = s8 + "top.mainFrame.body." + s2 + ".document.forms[0]." + s3 + ".options[" + (k + 1) + "].text='" + sepoaformater1.getValue(k, 1) + "' \n";
                        }
                    }
                }
                catch (Exception exception3)
                {
                    Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception3.getMessage());
                }
                finally
                {
                	if(sepoaremote1 != null){ sepoaremote1.Release(); }
                }
            }
        }

        return s8;
    }

    public String Multi_Select(HttpServletRequest httpservletrequest, String s, String s1, String s2, String s3, String s4) throws Exception
    {
        SepoaInfo sepoainfo = SepoaSession.getAllValue(httpservletrequest);
        Object obj = null;
        String s5 = "AD_200";
        String s6 = "CONNECTION";
        String s7 = "";
        Object[] aobj = { s };
        String[] as = null;

        if (s1.length() != 0)
        {
            SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s1, "#");
            int i = sepoastringtokenizer.countTokens();
            as = new String[i];

            for (int j = 0; j < i; j++)
            {
                as[j] = sepoastringtokenizer.nextToken();
            }
        }

        Object[] aobj1 = { s, as };
        SepoaRemote sepoaremote = null;
        SepoaRemote sepoaremote1 = null;
        SepoaOut sepoaout = null;
        Object obj1 = null;
        String s9 = "";
        s7 = "getCodeFlag";

        try
        {
            sepoaremote = new SepoaRemote(s5, s6, sepoainfo);
            sepoaout = sepoaremote.lookup(s7, aobj);
        }
        catch (Exception exception)
        {
            Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception.getMessage());
        }
        finally
        {
        	if(sepoaremote != null){ sepoaremote.Release(); }
        }

        if (sepoaout != null && sepoaout.status == 1)
        {
            String s10 = "";

            try
            {
                SepoaFormater sepoaformater = new SepoaFormater(sepoaout.result[0]);
                s10 = sepoaformater.getValue("FLAG", 0);
            }
            catch (Exception exception2)
            {
            	Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception2.getMessage());
            }

            if (s10.equals("SL") || s10.equals("ML"))
            {
                String s8 = "getCodeSearch";

                try
                {
                    sepoaremote1 = new SepoaRemote(s5, s6, sepoainfo);

                    SepoaOut sepoaout1 = sepoaremote1.lookup(s8, aobj1);

                    if (sepoaout1.status == 1)
                    {
                        SepoaFormater sepoaformater1 = new SepoaFormater(sepoaout1.result[0]);
                        s9 = "parent." + s2 + ".document.forms[0]." + s3 + ".options.length=" + String.valueOf(sepoaformater1.getRowCount()) + "\n";

                        for (int k = 0; k < sepoaformater1.getRowCount();
                                k++)
                        {
                            if (sepoaformater1.getValue(k, 0).equals(s4))
                            {
                                s9 = s9 + "parent." + s2 + ".document.forms[0]." + s3 + ".options[" + k + "].value='" + sepoaformater1.getValue(k, 0) + "' \n";
                                s9 = s9 + "parent." + s2 + ".document.forms[0]." + s3 + ".options[" + k + "].text='" + sepoaformater1.getValue(k, 1) + "' \n";
                                s9 = s9 + "parent." + s2 + ".document.forms[0]." + s3 + ".options[" + k + "].selected = true \n";
                            }
                            else
                            {
                                s9 = s9 + "parent." + s2 + ".document.forms[0]." + s3 + ".options[" + k + "].value='" + sepoaformater1.getValue(k, 0) + "' \n";
                                s9 = s9 + "parent." + s2 + ".document.forms[0]." + s3 + ".options[" + k + "].text='" + sepoaformater1.getValue(k, 1) + "' \n";
                            }
                        }
                    }
                }
                catch (Exception exception3)
                {
                    Logger.debug.println(sepoainfo.getSession("ID"), "e = " + exception3.getMessage());
                }
                finally
                {
                	if(sepoaremote1 != null){ sepoaremote1.Release(); }
                }
            }
        }

        return s9;
    }
}
