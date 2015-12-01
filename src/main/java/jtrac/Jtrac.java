package jtrac;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Jtrac {

	public static JtracInfo getAndPackJtracInfo(String ticketId) {
		JtracInfo info = new JtracInfo();
		info.setTicketId(ticketId);
		info.setRecords(getJtracDetail(ticketId));
		return info;

	}

	public static List<JtracDetail> getJtracDetail(String ticketId) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<JtracDetail> details = new ArrayList<JtracDetail>();
		try {
			Class.forName("org.sqlite.JDBC");
			conn = DriverManager
					.getConnection("jdbc:sqlite:D:/data/sqlite3/jtrac");
			String sql = "select * from info t where t.ticket_id= ? ";
			ps = conn.prepareStatement(sql);
			ps.setString(1, ticketId);
			rs = ps.executeQuery();
			while (rs.next()) {
				JtracDetail detail = new JtracDetail();
				detail.setLoggedBy(rs.getString("Logged_By"));
				detail.setStatus(rs.getString("Status"));
				detail.setAssignedTo(rs.getString("Assigned_To"));
				detail.setTimeStamp(rs.getString("Time_Stamp"));
				detail.setTjDatetime(rs.getString("TJ_datetime"));
				detail.setComment(rs.getString("Comment"));
				detail.setTicketType(rs.getString("Ticket_Type"));
				detail.setPriority(rs.getString("Priority"));
				detail.setUrgency(rs.getString("Urgency"));
				detail.setImpact(rs.getString("Impact"));
				detail.setProduct(rs.getString("Product"));
				detail.setState(rs.getString("State"));
				detail.setProgramAgency(rs.getString("Program_Agency"));
				detail.setComponent(rs.getString("Component"));
				details.add(detail);
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				ps.close();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return details;
	}

}
