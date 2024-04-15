package sepoa.fw.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;


public class RunCommand
{
    public static String runCommand(String cmd) throws IOException
    {
        Process p = Runtime.getRuntime().exec(cmd);
        InputStream in = p.getInputStream();
        BufferedReader br = new BufferedReader(new InputStreamReader(in));
        String s = "";
        String temp = "";

        while ((temp = br.readLine()) != null)
        {
            s += (temp + "n");
        }

        br.close();
        in.close();

        return s;
    }
}
