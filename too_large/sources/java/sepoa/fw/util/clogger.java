package sepoa.fw.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

public class CLogger
{
    private static PrintWriter writer = null;
    private static boolean newLined = true;
    private static final Object lock = new Object();
    public static final PrintWriter syswriter = getLogger();

    private CLogger()
    {
    }

    private static PrintWriter getLogger()
    {
    	FileWriter filewriter = null;
        try
        {
            String s = "kit.log";
            File file = new File(s);
            String s1 = file.getAbsolutePath();
            
            
            
            
            

            filewriter = new FileWriter(s1, true);
            writer = new PrintWriter(new BufferedWriter(filewriter), true);
        }
        catch (Exception exception)
        {
            writer = new PrintWriter(new BufferedWriter(new OutputStreamWriter(System.out)), true);
            writer.println("Can't open kit log file : " + exception.getMessage());
            writer.println("Log will be printed into System.out");
        }
        finally{
        	if(filewriter != null){
        		try{
        			filewriter.close();
        		}
        		catch(Exception e){writer.println("Log will be printed into System.out");}
        	}
        }

        return writer;
    }

    private void println(String s)
    {
        synchronized (lock)
        {
            if (newLined)
            {
                writer.write("[" + SepoaDate.getTimeString() + "]");
            }

            writer.print(s + "<END>");
            newLined = false;
        }
    }
}
