package sepoa.svc.approval.madec;

import java.io.*;

import sepoa.svc.approval.madec.CnvData;
import java.io.UnsupportedEncodingException;

public class PacketDefine  implements IFMaProp
{

	static final int HEART_BEAT = 1;


	public static int getSigid(byte[] pkt) {
		return (int)CnvData.btoi(pkt, SIGID_POS);
	}

	public static byte[] getData(byte[] pkt) {
		byte data[] = new byte[DATA_MAX_SIZE];

		System.arraycopy(pkt, DATA_POS, data, 0, DATA_MAX_SIZE);

		return data;
	}

	public static byte[] makePacket(int sigid, String data)
	{
		byte[] 	packet = new byte[PACKET_SIZE];
		int		iDataLength = 0;
		
		// �ʱ�ȭ 0x00
		CnvData.setArray(packet, 0, PACKET_SIZE, (byte)0x00);

/*
		try
		{
			byte[] bytedata = data.getBytes( "KSC5601" );
			System.arraycopy(data.getBytes(), 0, packet, DATA_POS, data.length());

			iDataLength = bytedata.length;
		}
		catch ( UnsupportedEncodingException e )
		{
		}

*/
		// PACKET�� ����
		CnvData.itob(sigid, packet, SIGID_POS);
		//System.arraycopy(data.getBytes(), 0, packet, DATA_POS, iDataLength );
		//strPacketData.getBytes(CURR_CHARSET).length
		try {
			System.arraycopy(data.getBytes("UTF-8"), 0, packet, DATA_POS, data.getBytes("UTF-8").length);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
//			e.printStackTrace();
			iDataLength = 0;
		}
		
		return packet;
	}

	public static byte[] makeDecPacket(int sigid, String pstrFileLength, int piFileLengthSize, byte[] pbytePreEncHeader, int piPreEncHeaderSize)
	{
		byte[] 	packet = new byte[PACKET_SIZE];		
		

		CnvData.setArray(packet, 0, PACKET_SIZE, (byte)0x00);


		CnvData.itob(sigid, packet, SIGID_POS);
//		try {
			System.arraycopy(pstrFileLength.getBytes(), 0, packet, DATA_POS, piFileLengthSize );
//		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		System.arraycopy(pbytePreEncHeader, 0, packet, piFileLengthSize + DATA_POS, piPreEncHeaderSize );
		
		return packet;
	}	
	
}
