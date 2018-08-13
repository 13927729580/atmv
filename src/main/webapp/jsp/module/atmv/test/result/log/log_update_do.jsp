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
	String loginuser_name = HandleSession.get_string("loginuser_name");
	if (loginuser_id.length() <= 0) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String log_id = HandleRequest.get_string("log_id");
	String log_result = HandleRequest.get_string("log_result");
	String firetime_start = "";
	String firetime_end = "";
	if (log_result.equals("idle")) {
		firetime_start = "";
		firetime_end = "";
	} else if (log_result.equals("running")) {
		String sqlv = "SELECT MIN(t.firetime_start) AS time_start,MAX(t.firetime_end) AS time_end FROM t_funtest_log_history t WHERE t.log_id='" + log_id + "'";
		DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
		firetime_start = HandleDatabase.get_string(dtmv, 0, "time_start");
		firetime_end = "";
	} else if (log_result.equals("fail") || log_result.equals("pass")) {
		String sqlv = "SELECT MIN(t.firetime_start) AS time_start,MAX(t.firetime_end) AS time_end FROM t_funtest_log_history t WHERE t.log_id='" + log_id + "'";
		DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
		firetime_start = HandleDatabase.get_string(dtmv, 0, "time_start");
		firetime_end = HandleDatabase.get_string(dtmv, 0, "time_end");
	}

	String req_select = "log_name,work_group,version,log_result";
	String[] selects = req_select.split(",");

	HashMap hm = new HashMap();
	for (int j = 0; j < selects.length; j++) {
		String v = DealDatabase.cvtString(HandleRequest.get_string(selects[j].trim(), "utf-8"));
		hm.put(selects[j].trim(), "'" + v + "'");
	}
	hm.put("firetime_start", "'" + firetime_start + "'");
	hm.put("firetime_end", "'" + firetime_end + "'");
	String sql = DealDatabase.getModifySql("t_funtest_log", hm, "log_id='" + log_id + "'");
	ProjectDatabase.edit_data(sql);

	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
