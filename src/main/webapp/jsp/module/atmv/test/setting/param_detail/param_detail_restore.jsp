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

	String operate_ip = HandleRequest.get_server_ip();
	String[] param_detail_id = HandleRequest.get_strings("param_detail_id");
	if (param_detail_id != null) {
		for (int i = 0; i < param_detail_id.length; i++) {
			String sqlv = DealDatabase.getDeleteSql("t_sys_param_detail", "project_code='" + ProjectParam.PROJECT_CODE + "' and param_detail_id='" + param_detail_id[i] + "'");
			HandleDatabase.edit_data(sqlv);
		}
		ProjectParamDetail.init_param(operate_ip);
	}
	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
