package sepoa.svl.util;

import java.io.Serializable;
import java.util.Hashtable;
import java.util.Vector;

public class SepoaMessage
    implements Serializable
{

    public SepoaMessage()
    {
        isNextPage = false;
    }

    private static final long serialVersionUID = 0xb6c8c9708fffcd6cL;
    public boolean data_flag;
    public Hashtable param;
    public int status;
    public String classname;
    public String code;
    public String message;
    public int lparam;
    public boolean isNextPage;
    public String system_start_row;
    public String system_end_row;
    public Vector header;
    public Vector header_type;
}