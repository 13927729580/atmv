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

	String log_id = HandleRequest.get_string("log_id");
	String userto = HandleRequest.get_string("userto", "UTF-8");
	String usercc = HandleRequest.get_string("usercc", "UTF-8");
	String subject = HandleRequest.get_string("subject", "UTF-8");
	String context = HandleRequest.get_string("context", "UTF-8");
	HandleEmail.send_email(userto, usercc, subject, context);
	ProjectResult.update_statics(log_id);

	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
