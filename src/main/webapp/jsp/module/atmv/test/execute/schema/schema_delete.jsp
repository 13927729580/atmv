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

	String[] schema_ids = HandleRequest.get_strings("schema_id");
	if (schema_ids != null) {
		for (int i = 0; i < schema_ids.length; i++) {
			String sqlv = DealDatabase.getDeleteSql("t_funtest_schema", "schema_id='" + schema_ids[i] + "'");
			ProjectDatabase.edit_data(sqlv);
		}
	}
	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
