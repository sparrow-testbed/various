package sepoa.fw.util;

import javax.servlet.*;
import java.io.*;

public class MultipartInputStreamHandler {

    ServletInputStream in;
    int totalExpected;
    int totalRead = 0;
    byte[] buf = new byte[8 * 1024];

    public MultipartInputStreamHandler(ServletInputStream in,
                                       int totalExpected) {
        this.in = in;
        this.totalExpected = totalExpected;
    }

    // Reads the next line of input.  Returns null to indicate the end
    // of stream.
    //
    public String readLine() throws IOException {
        StringBuffer sbuf = new StringBuffer();
        int result;
        String line;

        do {
            result = this.readLine(buf, 0, buf.length);  // this.readLine() does +=
            if (result != -1) {
                sbuf.append(new String(buf, 0, result, "ISO-8859-1"));
            }
        } while (result == buf.length);  // loop only if the buffer was filled

        if (sbuf.length() == 0) {
            return null;  // nothing read, must be at the end of stream
        }

        sbuf.setLength(sbuf.length() - 2);  // cut off the trailing \r\n
        return sbuf.toString();
    }

    // A pass-through to ServletInputStream.readLine() that keeps track
    // of how many bytes have been read and stops reading when the
    // Content-Length limit has been reached.
    //
    public int readLine(byte b[], int off, int len) throws IOException {
        if (totalRead >= totalExpected) {
            return -1;
        } else {
            int result = in.readLine(b, off, len);
            if (result > 0) {
                totalRead += result;
            }
            return result;
        }
    }
}

