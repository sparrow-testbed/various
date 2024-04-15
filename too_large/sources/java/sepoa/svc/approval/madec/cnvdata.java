package sepoa.svc.approval.madec;


public class CnvData implements IFMaProp
{

	public CnvData() 
	{
	}

	// converte byte to short
	public static int btos(byte[] b) 
	{
		return btos(b, 0);
	}

	static int btos(byte[] b, int fromindex) 
	{
		int result = 0;

		for ( int i = fromindex, j = 1; i < fromindex + SHORT; i++, j++ ) 
		{
			result |= ((b[i] < 0 ? 256+b[i] : b[i]) << ((SHORT-j)*8));
		}

		return result;
	}

	// converte byte to int
	public static long btoi(byte[] b) 
	{
		return btoi(b, 0);
	}

	public static long btoi(byte[] b, int fromindex) 
	{
		long result = 0;

		for ( int i = fromindex, j = 1; i < fromindex + INT; i++, j++ ) 
		{
			result |= ((b[i] < 0 ? 256+b[i] : b[i]) << ((INT-j)*8));
		}

		return result;
	}

	// converte byte to long
	public static long btol(byte[] b) 
	{
		return btol(b, 0);
	}

	public static long btol(byte[] b, int fromindex) 
	{
		long result = 0;

		for ( int i = fromindex, j = 1; i < fromindex + LONG; i++, j++ ) 
		{
			result |= ((b[i] < 0 ? 256+b[i] : b[i]) << ((LONG-j)*8));
		}

		return result;
	}

	// converte short to byte[]
	public static byte[] stob(short old) 
	{
		byte[] result = { 0, 0 };
		short shift_data = old;

		for ( int i = SHORT; i > 0; i-- ) 
		{
			result[i-1] = (byte)(shift_data & (short)0xff);
			shift_data >>= 8;
		}

		return result;
	}

	public static void stob(short old, byte[] data, int pos) 
	{
		short shift_data = old;

		data[pos+1] = (byte)(shift_data & (short)0x0ff);
		shift_data >>= 8;
		data[pos] = (byte)(shift_data & (short)0x0ff);
	}

	// converte short to byte[]
	public static byte[] itob(int old) 
	{
		byte[] result = { 0, 0, 0, 0 };
		int shift_data = old;

		for ( int i = INT; i > 0; i-- ) 
		{
			result[i-1] = (byte)(shift_data & 0xff);
			shift_data >>= 8;
		}

		return result;
	}

	public static void itob(int old, byte[] data, int pos) 
	{
		int shift_data = old;

		for ( int i = INT; i > 0; i-- ) 
		{
			data[pos+i-1] = (byte)(shift_data & 0x0ff);
			shift_data >>= 8;
		}
	}

	public static void setArray(byte[] src, int start, int end, byte ch) 
	{
		for ( int i = start; i < end; i++ )
			src[i] = ch;
	}

}
