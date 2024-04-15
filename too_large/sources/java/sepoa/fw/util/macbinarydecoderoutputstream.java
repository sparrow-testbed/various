package sepoa.fw.util;

import java.io.FilterOutputStream;
import java.io.IOException;
import java.io.OutputStream;

class MacBinaryDecoderOutputStream extends FilterOutputStream
{
    int bytesFiltered;
    int dataForkLength;

    public MacBinaryDecoderOutputStream(OutputStream outputstream)
    {
        super(outputstream);
        bytesFiltered = 0;
        dataForkLength = 0;
    }

    public void write(int i) throws IOException
    {
        if ((bytesFiltered <= 86) && (bytesFiltered >= 83))
        {
            int j = (86 - bytesFiltered) * 8;
            dataForkLength = dataForkLength | ((i & 0xff) << j);
        }
        else if ((bytesFiltered < (128 + dataForkLength)) && (bytesFiltered >= 128))
        {
            out.write(i);
        }

        bytesFiltered++;
    }

    public void write(byte[] abyte0) throws IOException
    {
        write(abyte0, 0, abyte0.length);
    }

    public void write(byte[] abyte0, int i, int j) throws IOException
    {
        if (bytesFiltered >= (128 + dataForkLength))
        {
            bytesFiltered += j;
        }
        else if ((bytesFiltered >= 128) && ((bytesFiltered + j) <= (128 + dataForkLength)))
        {
            out.write(abyte0, i, j);
            bytesFiltered += j;
        }
        else
        {
            for (int k = 0; k < j; k++)
            {
                write(abyte0[i + k]);
            }
        }
    }
}
