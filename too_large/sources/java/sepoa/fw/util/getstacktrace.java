package sepoa.fw.util;

import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;

public class GetStackTrace
{
	public final String stackTrace(Throwable throwable)
	{
		String s = null;

//		try
//		{
			ByteArrayOutputStream bytearrayoutputstream = new ByteArrayOutputStream();
			throwable.printStackTrace(new PrintWriter(bytearrayoutputstream, true));
			s = bytearrayoutputstream.toString();
//		}
//		catch (Exception exception)
//		{
//			
//		}

		return s;
	}
}
