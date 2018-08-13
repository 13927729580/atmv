package qfsoft.web.atmv.method;

import qfsoft.library.web.method.HandleParam;
import qfsoft.library.web.method.HandleVerify;
import qfsoft.library.web.util.CacheList;

public class ProjectParam {

	public final static String PROJECT_CODE = CacheList.config.getProperty("project_code");

	public final static String get_param_field(String param_type, String param_key, String field) {
		String param_valuev = HandleParam.get_param_field(PROJECT_CODE, param_type, param_key, field);
		return param_valuev;
	}

	public final static String get_param_field(String param_key, String field) {
		String param_valuev = get_param_field(HandleParam.MAIN, param_key, field);
		return param_valuev;
	}

	public final static String get_param(String param_type, String param_key) {
		String param_valuev = get_param_field(param_type, param_key, "param_value");
		return param_valuev;
	}

	public final static String get_param(String param_key) {
		String param_value = get_param(HandleParam.MAIN, param_key);
		return param_value;
	}

	public final static void set_param_field(String param_type, String param_key, String field, String value) {
		HandleParam.set_param_field(PROJECT_CODE, param_type, param_key, field, value);
	}

	public final static void set_param_field(String param_key, String field, String value) {
		set_param_field(HandleParam.MAIN, param_key, field, value);
	}

	public final static void set_param(String param_type, String param_key, String param_value) {
		boolean is_ok = HandleVerify.check();
		if (!is_ok) {
			return;
		}
		set_param_field(param_type, param_key, "param_value", param_value);
	}

	public final static void set_param(String param_key, String param_value) {
		set_param(HandleParam.MAIN, param_key, param_value);
	}

	public final static String get_title() {
		return get_param("title");
	}

}