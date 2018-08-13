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

	String loginuser_id = HandleSession.get_string("loginuser_id");
	String loginuser_code = HandleSession.get_string("loginuser_code");
	String user_pwd1 = HandleRequest.get_string("user_pwd1");
	String user_pwd2 = HandleRequest.get_string("user_pwd2");
	String user_pwd3 = HandleRequest.get_string("user_pwd3");
	if (!user_pwd2.equals(user_pwd3)) {
		HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=2004");
		return;
	}
	if (HandleUser.verify_pwd(loginuser_code, user_pwd1).getRowCount() != 1) {
		HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=2001");
		return;
	}
	HashMap hm = new HashMap();
	hm.put("user_pwd", "MD5('" + user_pwd2 + "')");
	String sql = DealDatabase.getModifySql("t_sys_user", hm, "user_id='" + loginuser_id + "'");
	int result = HandleDatabase.edit_data(sql);
	if (result < 0) {
		HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=9999");
		return;
	}
	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
