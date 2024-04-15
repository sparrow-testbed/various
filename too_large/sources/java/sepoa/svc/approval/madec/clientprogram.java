package sepoa.svc.approval.madec;

import java.net.*;
import java.io.*;

/**
 * 
 *
 * 
 * @author  
 * @version 
 * @see      
 * @since  
 */
public class ClientProgram implements IFMaProp
{
	Socket 			mSocket;
	InputStream 	mInputStream;
	OutputStream 	mOutputStream;
	public ClientProgram() 
	{
		mSocket = null;
	}

	 /**
     * 
     * @param      
     * @return    
     * @exception  
     * @see       
     */
 	public boolean bConnection(String serverName, int port) throws IOException 
	{
		if ( mSocket != null ) 
		{
			bDisConnection();
		}

		mSocket = new Socket(serverName, port);
		if ( mSocket == null ) 
		{
			return false;
		}
		
		mInputStream = mSocket.getInputStream();
		mOutputStream = mSocket.getOutputStream();
		
		return true;
	}

	public boolean bDisConnection() 
	{
		try {
			if ( mSocket != null ) 
			{
				mInputStream.close();
				mOutputStream.close();
				mSocket.close();
				mSocket = null;
			}
		}
		catch ( IOException e ) 
		{
			return false;
		}
		
		return true;
	}

	public InputStream GetInputStream() 
	{
		return mInputStream;
	}

	public OutputStream GetOutputStream() 
	{
		return mOutputStream;
	}

	public boolean bSendPacketHeader(int SigNo) 
	{
		String data = "";

		if ( mSocket == null ) 
		{
			return false;
		}

		byte[] message = PacketDefine.makePacket(
				SigNo,
				data);						// data

		try 
		{
			mOutputStream.write(message, 0, PacketDefine.PACKET_SIZE);
		}
		catch ( Exception e ) 
		{
			return false;
		}
		
		return true;
	}
	
	public boolean bSendDecPacketHeader(byte[] pbytePacket) 
	{
		if ( mSocket == null ) 
		{
			return false;
		}
		
		try 
		{
			mOutputStream.write(pbytePacket, 0, PacketDefine.PACKET_SIZE);
		}
		catch ( Exception e ) 
		{
			return false;
		}
		
		return true;
	}	

	public boolean bSendPacketHeader(int SigNo, String data)
	{
		if ( mSocket == null )
		{
			return false;
		}

		byte[] message = PacketDefine.makePacket(
				SigNo,
				data);						// data
		try
		{
			mOutputStream.write(message, 0, PacketDefine.PACKET_SIZE);
			mOutputStream.flush();
		}
		catch ( Exception e )
		{
			return false;
		}
		
		return true;
	}
	
	public byte [] bRecvPacketHeader(int [] piSigNum) 
	{
		byte[] 		 byteRcvData 	= new byte[PacketDefine.PACKET_SIZE];
		byte[]		 byteAllRcvData = new byte[PacketDefine.PACKET_SIZE];	
		int			 iReadDataSize 	= 0;
		boolean		 bLoop = true;
		int			 iPos = 0;
		int			 iTrueFalse = 0;
		int			 iRealReadDataSize = PacketDefine.PACKET_SIZE;		
		
		try
		{
			do
			{	
				iReadDataSize = mInputStream.read( byteRcvData, 0, iRealReadDataSize );
				
				if( iReadDataSize == -1 )
				{
					bLoop = false;
					iTrueFalse = -1;
				}	
				else if( iReadDataSize <= PacketDefine.PACKET_SIZE )
				{
					System.arraycopy( byteRcvData, 0, byteAllRcvData, iPos, iReadDataSize );
					iPos = iPos + iReadDataSize;
					iRealReadDataSize = PacketDefine.PACKET_SIZE - iPos;									
				}
						
				if( iPos == PacketDefine.PACKET_SIZE )
					bLoop = false;
			} while( bLoop );
		}
		catch (Exception e) 
		{
			piSigNum[0] = 10000;
			return PacketDefine.getData( byteAllRcvData );
		}
				
		piSigNum[0] = PacketDefine.getSigid( byteAllRcvData );		
		return PacketDefine.getData( byteAllRcvData );
	}
		
	public boolean bSendRecvData( InputStream pInputStream, OutputStream pOutputStream, long plFileSize, long plEncryptFileSize )
	{
		byte[] 		 byteRcvData = new byte[MAX_ENC_SIZE];
		boolean		 bLoop = true;
		int			 iStart = 0;
		int			 iFileHeaderSize = 0;
		int			 iWant = 0;
		long		 lRemain = plFileSize;
		long		 lTotalDataSize = 0;
		int			 iRet = 0;
		
		iFileHeaderSize = (int)(plEncryptFileSize - plFileSize);
						
		if ( mSocket == null ) 
		{
			return false;
		}

		do
		{	
			if( lRemain >= MAX_ENC_SIZE )
			{
				iRet = iReadOrgStream( pInputStream, MAX_ENC_SIZE );
				if( iRet != 0 )	break;
				lRemain = lRemain - MAX_ENC_SIZE;
				iWant = MAX_ENC_SIZE;
			}
			else
			{
				iRet = iReadOrgStream( pInputStream, (int)lRemain );
				if( iRet != 0 )	break;
				iWant = (int)lRemain;	
				lRemain = 0;				
			}
			
			if( iStart == 0 )
			{
				iRet = iReadEncStream( pOutputStream, iFileHeaderSize );
				if( iRet != 0 )	break;
				iStart = 1;
			}
			
			iRet = iReadEncStream( pOutputStream, iWant );
			if( iRet != 0 )	break;

			if( lRemain == 0 )	
			{
				bLoop = false;
			}
			
			lTotalDataSize = lTotalDataSize + iWant;			
		} while( bLoop );
		
		if( iRet != 0 )
		{
			return false;
		}
		
		return true;
	}

	public boolean bSendRecvData( InputStream pInputStream, OutputStream pOutputStream, long plFileSize, long plDecryptFileSize, int piEncHeaderSize )
	{
		byte[] 		 byteRcvData = new byte[MAX_ENC_SIZE];
		boolean		 bLoop = true;
		int			 iStart = 0;
		int			 iWant = 0;
		long		 lRemain = plFileSize;
		long		 lTotalDataSize = 0;
		int			 iRet = 0;
										
		if ( mSocket == null ) 
		{
			return false;
		}

		do
		{	
			if( iStart == 0 )
			{
				iRet = iReadOrgStream( pInputStream, piEncHeaderSize );
				if( iRet != 0 )	break;
				lRemain = lRemain - piEncHeaderSize;
				iStart = 1;		
			}
			else
			{
				if( lRemain >= MAX_ENC_SIZE )
				{
					iRet = iReadOrgStream( pInputStream, MAX_ENC_SIZE );
					if( iRet != 0 )	break;
					lRemain = lRemain - MAX_ENC_SIZE;
					iWant = MAX_ENC_SIZE;
				}
				else
				{
					iRet = iReadOrgStream( pInputStream, (int)lRemain );
					if( iRet != 0 )	break;
					iWant = (int)lRemain;	
					lRemain = 0;				
				}
						
				iRet = iReadEncStream( pOutputStream, iWant );
				if( iRet != 0 )	break;
	
				if( lRemain == 0 )	
				{
					bLoop = false;
				}
			
				lTotalDataSize = lTotalDataSize + iWant;			
			}
		} while( bLoop );
		
		if( iRet != 0 )
		{
			return false;
		}
		
		return true;
	}
	
	public int iReadOrgStream( InputStream pInputStream, int piRcvDataLength ) 
	{
		byte[] 		 byteRcvData 	= new byte[piRcvDataLength];
		byte[]		 byteAllRcvData = new byte[piRcvDataLength];		
		int			 iReadDataSize 	= 0;
		boolean		 bLoop = true;
		int			 iPos = 0;
		int			 iTrueFalse = 0;
		int			 iRealReadDataSize = piRcvDataLength;		
				
		try 
		{			
			do
			{
				iReadDataSize = pInputStream.read( byteRcvData, 0, iRealReadDataSize );
				
				if( iReadDataSize == -1 )
				{
					bLoop = false;
					iTrueFalse = -1;
				}	
				else if( iReadDataSize <= iRealReadDataSize )
				{
					System.arraycopy( byteRcvData, 0, byteAllRcvData, iPos, iReadDataSize );
					iPos = iPos + iReadDataSize;
					iRealReadDataSize = piRcvDataLength - iPos;
				}
						
				if( iPos == piRcvDataLength )
				{
					mOutputStream.write(byteAllRcvData, 0, piRcvDataLength); 
					mOutputStream.flush();
					bLoop = false;
				}
			} while( bLoop );
		}
		catch (Exception e) 
		{
			return -1;
		}
		
		if( iTrueFalse != 0 ) return iTrueFalse;
					
		return 	0;
	}		
		
	public int iReadEncStream( OutputStream pOutputStream, int piRcvDataLength ) 
	{
		byte[] 		 byteRcvData 	= new byte[piRcvDataLength];
		byte[]		 byteAllRcvData = new byte[piRcvDataLength];	
		int			 iReadDataSize 	= 0;
		boolean		 bLoop = true;
		int			 iPos = 0;
		int			 iTrueFalse = 0;
		int			 iRealReadDataSize = piRcvDataLength;						

		try 
		{			
			do
			{	
				iReadDataSize = mInputStream.read( byteRcvData, 0, iRealReadDataSize );
				
				if( iReadDataSize == -1 )
				{
					bLoop = false;
					iTrueFalse = -1;
				}	
				else if( iReadDataSize <= piRcvDataLength )
				{
					System.arraycopy( byteRcvData, 0, byteAllRcvData, iPos, iReadDataSize );
					iPos = iPos + iReadDataSize;
					iRealReadDataSize = piRcvDataLength - iPos;									
				}
						
				if( iPos == piRcvDataLength )
				{
					pOutputStream.write( byteAllRcvData, 0, piRcvDataLength );	
					pOutputStream.flush();
					bLoop = false;
				}
			} while( bLoop );
		}
		catch (Exception e) 
		{
			return -1;
		}

		if( iTrueFalse != 0 ) return iTrueFalse;
				
		return 	0;
	}		

	public byte[] byteReadOrgStream( InputStream pInputStream, int piRcvDataLength ) 
	{
		byte[] 		 byteRcvData 	= new byte[piRcvDataLength];
		byte[]		 byteAllRcvData = new byte[piRcvDataLength];		
		int			 iReadDataSize 	= 0;
		boolean		 bLoop = true;
		int			 iPos = 0;
		int			 iTrueFalse = 0;
		int			 iRealReadDataSize = piRcvDataLength;		
				
		try 
		{			
			do
			{
				iReadDataSize = pInputStream.read( byteRcvData, 0, iRealReadDataSize );
				//System.out.println("iReadDataSize = " + iReadDataSize);
				
				if( iReadDataSize == -1 )
				{
					bLoop = false;
					iTrueFalse = -1;
				}	
				else if( iReadDataSize <= iRealReadDataSize )
				{
					System.arraycopy( byteRcvData, 0, byteAllRcvData, iPos, iReadDataSize );
					iPos = iPos + iReadDataSize;
					iRealReadDataSize = piRcvDataLength - iPos;
				}
				//System.out.println("iPos = " + iPos);		
				if( iPos == piRcvDataLength )
				{
					bLoop = false;
				}
			} while( bLoop );
			//System.out.println("------------------------------");		
		}
		catch (Exception e) 
		{
			bLoop = false;
		}
							
		return 	byteAllRcvData;
	}	
	
	public boolean sendPacket(int SigNo) {
		String data = "";

		if ( mSocket == null ) {
			return false;
		}

		byte[] message = PacketDefine.makePacket(
				SigNo,
				data);						// data

		try {
			mOutputStream.write(message, 0, PacketDefine.PACKET_SIZE);
		}
		catch ( Exception e ) {
			return false;
		}
		return true;
	}
	
	public boolean sendPacket(int SigNo, String data)
	{
		if ( mSocket == null ) {
			return false;
		}

		byte[] message = PacketDefine.makePacket(
				SigNo,
				data);						// data
		try
		{
			mOutputStream.write(message, 0, PacketDefine.PACKET_SIZE);
		}
		catch ( Exception e )
		{
			return false;
		}
		return true;
	}
	
	public byte [] receivePacket(int [] piSigNum) {
		byte[] msg = new byte[PacketDefine.PACKET_SIZE];
		boolean whileFlag = true;
		int nbytes;
		int read_size = PacketDefine.DATA_MAX_SIZE;
		byte buffer[] = new byte[PacketDefine.PACKET_SIZE];
		int pos = 0;

		while ( whileFlag ) {
			try {
				CnvData.setArray(msg, 0, PacketDefine.PACKET_SIZE, (byte)0x00);
				nbytes = mInputStream.read(msg, 0, read_size);

				if ( nbytes < PacketDefine.PACKET_SIZE ) {
					if ( nbytes < 0 ) {
						whileFlag = false;	// End
						continue;
					}
					else {

						System.arraycopy(msg, 0, buffer, pos, nbytes);
						pos += nbytes;
						read_size = PacketDefine.PACKET_SIZE - nbytes;

						if ( pos == PacketDefine.PACKET_SIZE ) {
							System.arraycopy(buffer, 0, msg, 0, PacketDefine.PACKET_SIZE);
							pos = 0;
							read_size = PacketDefine.PACKET_SIZE;
						}
						else
							continue;
					}
				}
			}
			catch (Exception e) {
				continue;
			}

			whileFlag = false;	
		}

		piSigNum[0] = PacketDefine.getSigid(msg);
		return PacketDefine.getData( msg );
	}
	
		
}

