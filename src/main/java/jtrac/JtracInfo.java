package jtrac;

import java.util.List;

public class JtracInfo {
	String ticketId;
	List<JtracDetail> records;
	
	public String getTicketId() {
		return ticketId;
	}
	public void setTicketId(String ticketId) {
		this.ticketId = ticketId;
	}
	public List<JtracDetail> getRecords() {
		return records;
	}
	public void setRecords(List<JtracDetail> records) {
		this.records = records;
	}

}
