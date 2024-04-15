package sepoa.fw.util;

public class StopWatch
{
    long start;
    long current;

    public StopWatch()
    {
        start = 0L;
        current = 0L;
        reset();
    }

    public long getElapsed()
    {
        long l = System.currentTimeMillis();
        long l1 = l - current;
        current = l;

        return l1;
    }

    public long getTotalElapsed()
    {
        current = System.currentTimeMillis();

        return current - start;
    }

    public void reset()
    {
        start = System.currentTimeMillis();
        current = start;
    }
}
