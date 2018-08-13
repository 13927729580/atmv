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

	String concurrent_total = HandleRequest.get_string("concurrent_total");
	String cycle_total = HandleRequest.get_string("cycle_total");
	String tc = "";
	String[] tcs = ProjectParamDetail.get_param("localconfig_task.auto").split("\n");
	if (tcs != null) {
		for (int i = 0; i < tcs.length; i++) {
			if (tcs[i].trim().length() == 0) {
				continue;
			}
			String[] tcvs = tcs[i].trim().split(",");
			String[] codes = tcvs[0].split("\\.");
			String fun_codev = codes[0];
			String tc_codev = codes[1];
			String configv = fun_codev + "." + tc_codev + "," + concurrent_total + "," + cycle_total;
			tc = DealString.addline(tc, configv);
		}
		ProjectParamDetail.set_param("localconfig_task.auto", tc);
	}
	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
