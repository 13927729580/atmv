package qfsoft.web.atmv.method;

import javax.swing.table.DefaultTableModel;

import qfsoft.library.web.method.HandleUdc;
import qfsoft.library.web.method.HandleVerify;

public class ProjectUdc {

	public final static DefaultTableModel get_udc(String udc_code) {
		boolean is_ok = HandleVerify.check();
		if (!is_ok) {
			return null;
		}
		DefaultTableModel dtm = HandleUdc.get_udc(ProjectParam.PROJECT_CODE, udc_code);
		return dtm;
	}

	public final static String get_udc_field(String udc_code, String field_name1, String field_value1, String field_name2) {
		boolean is_ok = HandleVerify.check();
		if (!is_ok) {
			return null;
		}
		String value = HandleUdc.get_udc_field(ProjectParam.PROJECT_CODE, udc_code, field_name1, field_value1, field_name2);
		return value;
	}

	public final static String get_udc_field(String udc_code, String option_key, String field_name) {
		boolean is_ok = HandleVerify.check();
		if (!is_ok) {
			return null;
		}
		String value = get_udc_field(udc_code, "option_key", option_key, field_name);
		return value;
	}

	public final static String get_udc_key(String udc_code, String option_value) {
		boolean is_ok = HandleVerify.check();
		if (!is_ok) {
			return null;
		}
		String value = get_udc_field(udc_code, "option_value", option_value, "option_key");
		return value;
	}

	public final static String get_udc_value(String udc_code, String option_key) {
		boolean is_ok = HandleVerify.check();
		if (!is_ok) {
			return null;
		}
		String value = get_udc_field(udc_code, "option_key", option_key, "option_value");
		return value;
	}

	public final static void set_udc_field(String udc_code, String field_name1, String field_value1, String field_name2, String field_value2) {
		boolean is_ok = HandleVerify.check();
		if (!is_ok) {
			return;
		}
		HandleUdc.set_udc_field(ProjectParam.PROJECT_CODE, udc_code, field_name1, field_value1, field_name2, field_value2);
	}

	public final static void set_udc_field(String udc_code, String option_key, String field_name, String field_value) {
		boolean is_ok = HandleVerify.check();
		if (!is_ok) {
			return;
		}
		set_udc_field(udc_code, "option_key", option_key, field_name, field_value);
	}

}