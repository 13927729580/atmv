package qfsoft.web.atmv.method;

import qfsoft.library.web.method.HandleParamDetail;
import qfsoft.library.web.method.HandleRequest;

public class ProjectParamDetail {

	public final static String get_param_field(String operate_ip, String param_key, String field) {
		String param_valuev = HandleParamDetail.get_param_field(ProjectParam.PROJECT_CODE, operate_ip, param_key, field);
		return param_valuev;
	}

	public final static String get_param(String operate_ip, String param_key) {
		String param_valuev = get_param_field(operate_ip, param_key, "param_value");
		return param_valuev;
	}

	public final static void set_param_field(String operate_ip, String param_key, String field, String value) {
		HandleParamDetail.set_param_field(ProjectParam.PROJECT_CODE, operate_ip, param_key, field, value);
	}

	public final static void set_param(String operate_ip, String param_key, String param_value) {
		set_param_field(operate_ip, param_key, "param_value", param_value);
	}

	public final static String get_param_field(String param_key, String field) {
		String operate_ip = HandleRequest.get_server_ip();
		String valuev = get_param_field(operate_ip, param_key, field);
		return valuev;
	}

	public final static String get_param(String param_key) {
		String operate_ip = HandleRequest.get_server_ip();
		String param_value = get_param(operate_ip, param_key);
		return param_value;
	}

	public final static void set_param_field(String param_key, String field, String value) {
		String operate_ip = HandleRequest.get_server_ip();
		set_param_field(operate_ip, param_key, field, value);
	}

	public final static void set_param(String param_key, String param_value) {
		String operate_ip = HandleRequest.get_server_ip();
		set_param(operate_ip, param_key, param_value);
	}

	public final static void init_param(String operate_ip) {
		HandleParamDetail.init_param(ProjectParam.PROJECT_CODE, operate_ip);
	}

}