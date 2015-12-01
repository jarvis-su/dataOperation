package utils;

import java.util.Calendar;
import java.util.Date;

public class DateUtil {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	public static Date truncDate(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.set(Calendar.HOUR_OF_DAY, 0);
		c.set(Calendar.MINUTE, 0);
		c.set(Calendar.SECOND, 0);
		c.set(Calendar.MILLISECOND, 0);
		return c.getTime();
	}

	public static Date addDays(Date date, int count) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(java.util.Calendar.DAY_OF_MONTH, count);
		return c.getTime();
	}



}
