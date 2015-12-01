import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class FileReaderTest {

	static String fileName1 = "E:\\Document\\L3\\Tickets_NC\\TSGPRD-57413\\Dup cardholder report-0704.csv";
	static String fileName2 = "E:\\Document\\L3\\Tickets_NC\\TSGPRD-57413\\export-0704.csv";
	static String fileName3 = "E:\\Document\\L3\\Tickets_NC\\TSGPRD-57413\\test\\teee.csv";

	public static void main(String[] args) {
		String bufferLine;

		String caseId = "";
		String lastname = "";
		String cardholderInsertDate = "";
		String altIdentification = "";
		String[] tmp = null;

		BufferedReader br = null;
		BufferedWriter bwInsertFile = null;

		File file1 = new File(fileName1);

		File wInsertFile = new File(fileName3);
		if (wInsertFile.exists()) {
			wInsertFile.renameTo(new File(fileName3 + System.currentTimeMillis()));
			wInsertFile = new File(fileName3);
		}

		try {
			br = new BufferedReader(new FileReader(file1));
			bufferLine = br.readLine();
			bwInsertFile = new BufferedWriter(new FileWriter(wInsertFile, true));

			while (bufferLine != null) {
				if (bufferLine.startsWith("CASE_NBR")) {
					System.out.println("Title " + bufferLine);
				} else {
					tmp = bufferLine.split(",");
					caseId = tmp[0];
					lastname = tmp[1];
					cardholderInsertDate = tmp[5];
					altIdentification = findAltIdentification(caseId, lastname, cardholderInsertDate);

					Date date = new Date();
					// 08/29/2011 19:59:08
					SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
					date = sdf.parse(cardholderInsertDate);

					Cardholder ch = getPerson(caseId, altIdentification, date);

					String line = ch.getPersonId() + "," + ch.getCardholderId() + "," + altIdentification + "," + bufferLine;
					// System.out.println(line);

					bwInsertFile.append(line);
					bwInsertFile.newLine();
					bwInsertFile.flush();
				}
				bufferLine = br.readLine();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		} finally {
			try {
				if (br != null) {
					br.close();
				}
				if (bwInsertFile != null) {
					bwInsertFile.close();
				}
			} catch (Throwable th) {
			}
		}
	}

	public static String findAltIdentification(String caseId, String lastname, String cardholderInsertDate) {
		File file = new File(fileName2);
		BufferedReader bufferedReader = null;
		String bufferLine;
		String[] tmp = null;
		try {
			bufferedReader = new BufferedReader(new FileReader(file));
			bufferLine = bufferedReader.readLine();
			while (bufferLine != null) {
				tmp = bufferLine.split(",");
				if (caseId.equals(tmp[0]) && lastname.equals(tmp[1]) && cardholderInsertDate.equals(tmp[5])) {
					return tmp[6];
				}
				bufferLine = bufferedReader.readLine();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "";
	}

	public static Cardholder getPerson(String caseId, String altIdentification, Date insertDate) {
		Cardholder ch = new Cardholder();

		Connection c = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		String getCardholder = "SELECT CH.PERSON_ID, CH.CARDHOLDER_ID  FROM PERSON P, CARDHOLDER CH, PROGRAM_ACCESS PA, CASE C "
				+ " WHERE P.PERSON_ID = CH.PERSON_ID" + " AND CH.CARDHOLDER_ID = PA.CARDHOLDER_ID" + " AND PA.CASE_ID = C.CASE_ID" + " AND C.CASE_NBR = ? "
				+ " AND CH.INSERT_DATE = ? " + " AND TRIM(P.ALT_IDENTIFICATION) = trim(?) ";

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String url = "jdbc:oracle:thin:@10.237.89.143:1521:tj11gdb4";
			c = DriverManager.getConnection(url, "ECCNC_FULL_070413_01", "ECCNC_FULL_070413_01");
			ps = c.prepareStatement(getCardholder, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ps.setString(1, caseId);
			ps.setTimestamp(2, new java.sql.Timestamp(insertDate.getTime()));
			ps.setString(3, altIdentification);
			rs = ps.executeQuery();
			int count = 0;
			while (rs.next()) {
				ch.setPersonId(rs.getLong("PERSON_ID"));
				ch.setCardholderId(rs.getLong("CARDHOLDER_ID"));
				count++;
			}
			if (count > 1) {
				System.out.println("caseId = " + caseId + " altIdentification = " + altIdentification + " Count = " + count);
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (ps != null) {
				try {
					ps.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (c != null) {
				try {
					c.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return ch;
	}
}

class Cardholder {
	long personId;
	long cardholderId;

	public long getPersonId() {
		return personId;
	}

	public void setPersonId(long personId) {
		this.personId = personId;
	}

	public long getCardholderId() {
		return cardholderId;
	}

	public void setCardholderId(long cardholderId) {
		this.cardholderId = cardholderId;
	}

	Cardholder() {
	}
}
