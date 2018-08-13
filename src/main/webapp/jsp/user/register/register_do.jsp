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
	ProjectLog.add_log();

	String user_pwd = HandleRequest.get_string("user_pwd");
	String gender = HandleRequest.get_string("gender");
	String user_style = "blue";
	if (gender.equals("female")) {
		user_style = "pink";
	}
	String req_select = "user_code,user_name,work_depart,work_group,gender,phone,email,user_type";
	String[] selects = req_select.split(",");

	HashMap hm = new HashMap();
	for (int j = 0; j < selects.length; j++) {
		String v = DealDatabase.cvtString(HandleRequest.get_string(selects[j].trim()));
		hm.put(selects[j].trim(), "'" + v + "'");
	}
	hm.put("user_id", "UUID()");
	hm.put("user_pwd", "MD5('" + user_pwd + "')");
	hm.put("user_style", "'" + user_style + "'");
	hm.put("last_status", "'disabled'");
	String sql = DealDatabase.getAddSql("t_sys_user", hm);
	HandleDatabase.edit_data(sql);

	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1002");
%>
</html>
