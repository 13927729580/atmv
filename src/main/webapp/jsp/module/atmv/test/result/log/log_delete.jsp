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
	String loginuser_id = HandleSession.get_string("loginuser_id");
	if (loginuser_id.length() <= 0) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String[] log_id = HandleRequest.get_strings("log_id");
	if (log_id != null) {
		for (int i = 0; i < log_id.length; i++) {
			String sqlv1 = DealDatabase.getDeleteSql("t_funtest_log", "log_id='" + log_id[i] + "'");
			ProjectDatabase.edit_data(sqlv1);
			String sqlv2 = DealDatabase.getDeleteSql("t_funtest_log_detail", "log_id='" + log_id[i] + "'");
			ProjectDatabase.edit_data(sqlv2);
		}
	}
	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
