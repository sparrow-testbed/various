package sepoa.fw.mail;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.log.Logger;
import sepoa.fw.util.FileProcess;
import sepoa.fw.util.SepoaString;

public class SimpleMailSend {

	private Configuration configuration = null;

	public String getConfig(String s)
	{
		try
		{
			Configuration configuration = new Configuration();
			s = configuration.get(s);

			return s;
		}
		catch (ConfigurationException configurationexception)
		{
			Logger.sys.println("getConfig error : " + configurationexception.getMessage());
		}
		catch (Exception exception)
		{
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}

		return null;
	}

	/**
	 * @param _subject
	 * @param _contents
	 * @return
	 * @throws Exception
	 */
	public String getSimpleMailHTML(String _subject, String _contents) throws Exception
	{
		String rtn = "";

		try
        {
			String file_name = getConfig("sepoa.mail.simple.template.path");
            String file_contents = FileProcess.fileReadByOffsetByEncoding(file_name, "UTF-8");
            String url_name = getConfig("sepoa.system.domain.name");
            String context_name = getConfig("sepoa.context.name");

            file_contents = SepoaString.replaceString(file_contents, "$URL_NAME$", url_name);
            file_contents = SepoaString.replaceString(file_contents, "$SUBJECT$", _subject);
            file_contents = SepoaString.replaceString(file_contents, "$CONTEXT_NAME$", context_name);
            file_contents = SepoaString.replaceString(file_contents, "$CONTENTS$", _contents);
            file_contents = SepoaString.replaceString(file_contents, "$DEST_URL$", "");

            rtn = file_contents;
        }
        catch (Exception e)
        {
        	
            //e.printStackTrace();
            throw new Exception(e.getMessage());
        }

        return rtn;
	}
}
