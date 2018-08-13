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

	String client_selenium = ProjectParamDetail.get_param("localconfig_client.selenium");
	String client_http = ProjectParamDetail.get_param("localconfig_client.http");
	String client_selenium_config = HandleRequest.get_string("localconfig_client.selenium." + client_selenium);
	String client_http_config = HandleRequest.get_string("localconfig_client.http." + client_http);
	ProjectParamDetail.set_param("localconfig_client.selenium." + client_selenium, client_selenium_config);
	ProjectParamDetail.set_param("localconfig_client.http." + client_http, client_http_config);

	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
