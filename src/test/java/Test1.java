import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;


public class Test1 {

	public static void main(String[] args) {
		String formatStr = "yyyy-MM-dd HH:mm:ss";
		SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
		String beginStr = "2013-06-02 19:00:00";
		String endStr = "2013-06-02 19:00:00";
		Date d1 = new Date();
		Date d2 = new Date();

		try {
			d1 = sdf.parse(beginStr);
			d2 = sdf.parse(endStr);

			System.out.println(d1.equals(d2));
		} catch (ParseException e) {
			e.printStackTrace();
		}

	}

}
