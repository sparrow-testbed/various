package sepoa.svc.admin;

import java.io.File;

import org.apache.commons.lang.StringUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.SepoaServiceException;
import sepoa.fw.util.DBUtil ;
import sepoa.fw.util.SepoaFormater;

public class AD_3123 extends SepoaService {

	public AD_3123(String opt, SepoaInfo info) throws SepoaServiceException {
		super(opt, info);
		setVersion("1.0.0");
	}

	/**
	 * 파일 고유 데이터를 추출
	 * 
	 * @param sepoaIn
	 * @return
	 * @throws Exception
	 */
	public SepoaOut fileCRC(String cont_no, String cont_gl_seq, SepoaInfo info) {
		try {
			String rtn = null;
			setStatus(1);
			setFlag(true);

			Configuration configuration = new Configuration();

			StringBuffer crc = new StringBuffer();
			if (StringUtils.isNotBlank(cont_no) && StringUtils.isNotBlank(cont_gl_seq)) {

				ConnectionContext ctx = getConnectionContext();
				StringBuffer sb = new StringBuffer();
				// SFILE테이블로부터 해당 attach_no의 파일 정보들을 가져온다.
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				sm.removeAllValue();
				sb.delete(0, sb.length());
                sb.append ( "SELECT ATTACH_NO2" + DBUtil.getAndSeparator()+ "''','''" + DBUtil.getAndSeparator()+ "ATTACH_NO3" + DBUtil.getAndSeparator()+ "''','''" + DBUtil.getAndSeparator()+ "ATTACH_NO4 ATTACH FROM SCTGL                          \n" ) ;
                sb.append ( "WHERE CONT_NUMBER = '" + cont_no + "' AND CONT_GL_SEQ = '" + cont_gl_seq + "' AND DEL_FLAG != '" + sepoa.fw.util.CommonUtil.Flag.Yes.getValue() + "'	 	\n" ) ;
				
				SepoaFormater attach_sf = new SepoaFormater(sm.doSelect(sb.toString()));
				
				sm.removeAllValue();
				sb.delete(0, sb.length());
				sb.append("SELECT * FROM SFILE WHERE DOC_NO IN ('"+ attach_sf.getValue("ATTACH", 0).replace(",", "','") +"')	\n");
				sb.append("ORDER BY DOC_NO,DOC_SEQ																				\n");
				rtn = sm.doSelect(sb.toString());
				SepoaFormater sf = new SepoaFormater(rtn);
				String type = null;
				// 각각의 파일 정보에 대해 파일 체크섬정보를 가져온다.
				for (int i = 0; i < sf.getRowCount(); i++) {
					// 파일 타입, 파일 타입에 따라 첨부파일 디렉토리가 다르므로..
					type = sf.getValue("TYPE", i);
					// 첨부파일 디렉토리
					String down_root = configuration.get("sepoa.attach.path.download");
					// 실제 첨부파일이 존재하는 디렉토리
					String att_file = configuration.get("sepoa.attach.view."+ type);
					File dirFile = new File(down_root + att_file);
					// 첨부파일의 디렉토리내 첨부파일을 가져온다.(DES_FILE_NAME: 서버내 실제 물리 파일명)
					File file  =new File(dirFile, sf.getValue("DES_FILE_NAME",i));
					// 파일의 체크섬 사이의 Delemeter를 ||로 하여 연결
					crc.append(FileCheck.crc(file)).append("#");
				}
			}

			setValue(crc.toString());
			setMessage("Attach Read_________________Success");
		} catch (Exception e) {
			
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}
		/*try {
			String rtn = null;
			setStatus(1);
			setFlag(true);

			Configuration configuration = new Configuration();

			StringBuffer crc = new StringBuffer();
			if (StringUtils.isNotBlank(attach_no)) {
				// 첨부파일 디렉토리
				String down_root = configuration
						.get("sepoa.attach.path.download");

				ConnectionContext ctx = getConnectionContext();
				StringBuffer sb = new StringBuffer();

				// SFILE테이블로부터 해당 attach_no의 파일 정보들을 가져온다.
				ParamSql sm = new ParamSql(info.getSession("ID"), this, ctx);
				sb.append("SELECT * 					\n");
				sb.append("  FROM sfile 				\n");
				sb.append(sm.addSelectString(" WHERE DOC_NO = ? 	\n"));
				sm.addStringParameter(attach_no);
				sb.append(" ORDER BY DOC_NO,DOC_SEQ		");
				rtn = sm.doSelect(sb.toString());
				SepoaFormater sf = new SepoaFormater(rtn);
				String type = null;
				// 각각의 파일 정보에 대해 파일 체크섬정보를 가져온다.
				for (int i = 0; i < sf.getRowCount(); i++) {
					// 파일 타입, 파일 타입에 따라 첨부파일 디렉토리가 다르므로..
					type = sf.getValue("TYPE", i);
					// 실제 첨부파일이 존재하는 디렉토리
					String att_file = configuration.get("sepoa.attach.view."
							+ type);
					File dirFile = new File(down_root + att_file);
					// 첨부파일의 디렉토리내 첨부파일을 가져온다.(DES_FILE_NAME: 서버내 실제 물리 파일명)
					File file = new File(dirFile, sf.getValue("DES_FILE_NAME",
							i));
					// 파일의 체크섬 사이의 Delemeter를 ||로 하여 연결
					crc.append(FileCheck.crc(file)).append("||");
				}
			}

			setValue(crc.toString());
			setMessage("Attach Read_________________Success");
		} catch (Exception e) {
			e.printStackTrace();
			setStatus(0);
			setFlag(false);
			setMessage(e.getMessage());
			Logger.err.println(info.getSession("ID"), this, e.getMessage());
		}*/

		return getSepoaOut();
	}

}
