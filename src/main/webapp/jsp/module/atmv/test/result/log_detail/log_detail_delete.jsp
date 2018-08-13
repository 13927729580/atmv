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
	String[] log_detail_ids = HandleRequest.get_strings("log_detail_id");
	String[] ids = HandleRequest.get_strings("id");
	if (log_detail_ids != null) {
		for (int j = 0; j < log_detail_ids.length; j++) {
			String log_detail_idv = log_detail_ids[j];
			String sqlv = DealDatabase.getDeleteSql("t_funtest_log_detail", "log_detail_id='" + log_detail_idv + "'");
			ProjectDatabase.edit_data(sqlv);
		}
	}
	if (ids != null) {
		for (int i = 0; i < ids.length; i++) {
			String fun_codev = ids[i].split("\\.")[0];
			String tc_codev = ids[i].split("\\.")[1];
			String sqlv1 = "SELECT t.* FROM t_funtest_log_detail t WHERE 1=1 and t.operate_ip='" + operate_ip + "' and t.fun_code='" + fun_codev + "' AND t.tc_code='" + tc_codev + "'";
			DefaultTableModel dtmv1 = ProjectDatabase.query_data(sqlv1);
			for (int j = 0; j < dtmv1.getRowCount(); j++) {
				String log_detail_idv = HandleDatabase.get_string(dtmv1, j, "log_detail_id");
				String sqlv = DealDatabase.getDeleteSql("t_funtest_log_detail", "log_detail_id='" + log_detail_idv + "'");
				ProjectDatabase.edit_data(sqlv);
			}
		}
	}

	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
