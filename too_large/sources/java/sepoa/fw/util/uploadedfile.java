package sepoa.fw.util;

import java.io.File;

class UploadedFile
{
    private String dir;
    private String filename;
    private String type;
    private String uniqname;

    UploadedFile(String s, String s1, String s2)
    {
        dir = s;
        filename = s1;
        type = s2;
    }

    UploadedFile(String s, String s1, String s2, String s3)
    {
        dir = s;
        filename = s1;
        type = s3;
        uniqname = s2;
    }

    public String getContentType()
    {
        return type;
    }

    public String getFilesystemName()
    {
        return filename;
    }

    public String getUniqFileName()
    {
        return uniqname;
    }

    public File getFile()
    {
        if ((dir == null) || (filename == null))
        {
            return null;
        }
        else
        {
            return new File(dir + File.separator + uniqname.replaceAll("\\.\\./", ""));
        }
    }
}
