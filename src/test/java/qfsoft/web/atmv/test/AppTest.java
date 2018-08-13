package qfsoft.web.atmv.test;

import org.apache.commons.mail.HtmlEmail;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import qfsoft.library.common.method.DealEmail;

public class AppTest extends TestCase {

	public AppTest(String testName) {
		super(testName);
	}

	public static Test suite() {
		return new TestSuite(AppTest.class);
	}

	public void testApp() throws Exception {
		// HttpAction ha = HandleHttp.get_ha();
		// String url = "http://localhost:9080/xiaoniu_web_atev/edi/execute_data";
		// ArrayList<NameValuePair> input = new ArrayList<NameValuePair>();
		// input.add(new HttpParam("td_code", "6001$11001"));
		// input.add(new HttpParam("td_cycle", "1"));
		// input.add(new HttpParam("td_param", "{网贷账户余额:\"1000\",理财账户余额:\"1000\"}"));
		// IntString result = HandleHttp.send_post(ha, url, input);
		// System.out.println(result.key);
		// System.out.println(result.value);

		String email_server = "vm.windows";
		int email_port = 25;
		String email_user = "admin@qfsoft.tech";
		String email_pwd = "test1234";
		String email_email = "admin@qfsoft.tech";
		HtmlEmail email = DealEmail.getEmailHtml(email_server, email_port, email_user, email_pwd);
		email.setCharset("gbk");
		String userto = "test1@qfsoft.tech";
		String usercc = "test2@qfsoft.tech";
		String subject = "测试";
		String context = "测试一下~";
		DealEmail.loadEmail(email, email_email, userto, usercc, subject, context);
		DealEmail.sendEmail(email);
	}
}
