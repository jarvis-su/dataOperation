import java.text.ParseException;

import org.apache.commons.lang.StringUtils;

import java.text.SimpleDateFormat;
import java.util.Date;

import jtrac.JtracMain;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.beans.factory.support.PropertiesBeanDefinitionReader;
import org.springframework.core.io.ClassPathResource;

import test.HelloBean;

public class Test {
	public static void main(String[] t) {
		JtracMain main = new JtracMain();
		String formatStr = "yyyy-MM-dd HH:mm:ss";
		SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
		String beginStr = "2013-06-02 19:00:00";
		String endStr = "2013-06-03 19:00:00";
		Date beginDate = new Date();
		Date endDate = new Date();
		try {
			beginDate = sdf.parse(beginStr);
			endDate = sdf.parse(endStr);

			float hours = (float) ((endDate.getTime() - beginDate.getTime()) / 1000.0 / 60.0 / 60.0);
			System.out.println(hours);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		System.out.println(sdf.format(beginDate));
		System.out.println(sdf.format(endDate));

		// Calendar c = Calendar.getInstance();
		// c.set(Calendar.HOUR_OF_DAY, 20);
		// System.out.println(sdf.format(c.getTime()));
		float te = main.calculateNonWorkingHours(beginDate, endDate);

		System.out.println(te);

//		BeanDefinitionRegistry reg = new DefaultListableBeanFactory();
//		PropertiesBeanDefinitionReader reader = new PropertiesBeanDefinitionReader(reg);
//		reader.loadBeanDefinitions(new ClassPathResource("beanConfig.properties"));
//		BeanFactory factory = (BeanFactory) reg;
//		HelloBean helloBean = (HelloBean) factory.getBean("helloBean");
//		System.out.println(helloBean.getHelloWorld());



		long seconds = 103 * 3600 + 12*63 + 44;
		System.out.println(formatDurationInSeconds(seconds));

	}


	public static String formatDurationInSeconds(long seconds) {
    	long hour =seconds/3600;
//		if(hour>99) return "99:59:59";  // MAX VALUE OF DURATION
		long minute=(seconds-hour*3600)/60;
		long second = seconds%60;
		return StringUtils.leftPad(String.valueOf(hour), 2, '0') + ":"+
			StringUtils.leftPad(String.valueOf(minute), 2, '0') + ":" + StringUtils.leftPad(String.valueOf(second), 2, '0');
    }

}
