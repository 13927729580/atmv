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
	//String browser = req.getHeader("User-Agent");
	//if (!browser.contains("Firefox") && !browser.contains("Chrome")) {
	//HandleResponse.redirect(HandleRequest.get_path()+"/jsp/message.jsp?message_code=2006");
	//}
	ProjectLog.add_log();

	String loginuser_code = HandleRequest.get_string("loginuser_code");
	String loginuser_pwd = HandleRequest.get_string("loginuser_pwd");
	DefaultTableModel user = HandleUser.verify_pwd(loginuser_code, loginuser_pwd);
	if (user.getRowCount() == 1) {
		String user_id = HandleDatabase.get_string(user, 0, "user_id");
		String user_code = HandleDatabase.get_string(user, 0, "user_code");
		String user_name = HandleDatabase.get_string(user, 0, "user_name");
		String user_email = HandleDatabase.get_string(user, 0, "email");
		String user_logo = HandleDatabase.get_string(user, 0, "user_logo");
		String user_style = HandleDatabase.get_string(user, 0, "user_style");

		HandleSession.set_object("loginuser_id", user_id);
		HandleSession.set_object("loginuser_code", user_code);
		HandleSession.set_object("loginuser_name", user_name);
		HandleSession.set_object("loginuser_email", user_email);
		HandleSession.set_object("loginuser_logo", user_logo);
		HandleSession.set_object("loginuser_style", user_style);
		HandleSession.set_object("loginuser_roles", HandleUser.get_user_roles(user_id));
		HandleSession.set_object("loginuser_menus", ProjectUser.get_user_menus(user_id));
		HandleSession.set_object("loginuser_links", ProjectUser.get_user_links(user_id));
		HandleResponse.redirect(HandleRequest.get_path() + "/index.jsp");
	} else {
		HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=2001");
	}
%>
</html>
