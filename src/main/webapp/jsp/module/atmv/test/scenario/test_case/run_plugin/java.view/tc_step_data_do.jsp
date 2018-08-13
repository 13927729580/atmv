<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
	});
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String step_id = HandleRequest.get_string("step_id");
	String action_type = HandleRequest.get_string("action_type");
	String action_code = HandleRequest.get_string("action_code");
	String action_key = HandleRequest.get_string("action_key");
	String last_status = HandleRequest.get_string("last_status");

	String[] action_keys = null;
	if (action_key.length() > 0) {
		action_keys = action_key.split(",");
	}

	JSONObject json = new JSONObject();
	if (action_keys != null) {
		for (int k = 0; k < action_keys.length; k++) {
			String keyv = action_keys[k];
			String valuev = HandleRequest.get_string("action_value." + keyv);
			json.put(keyv, valuev);
		}
	}
	String action_value = json.toString();

	HashMap hmv2 = new HashMap();
	hmv2.put("action_key", "'" + action_key + "'");
	hmv2.put("action_value", "'" + DealDatabase.cvtString(action_value) + "'");
	hmv2.put("last_status", "'" + last_status + "'");
	String sqlv2 = DealDatabase.getModifySql("t_funtest_tc_step", hmv2, "tc_step_id='" + step_id + "'");
	ProjectDatabase.edit_data(sqlv2);

	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/module/atmv/test/scenario/test_case/run_plugin/java.view/tc_step_data.jsp?step_id=" + step_id + "&action_type=" + action_type
			+ "&action_code=" + action_code + "&last_status=" + last_status);
%>
</html>
