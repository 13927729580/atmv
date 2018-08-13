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

	String log_id = HandleDatabase.get_uuid();
	String req_select = "log_name,work_group,version";
	String[] selects = req_select.split(",");

	HashMap hm = new HashMap();
	for (int j = 0; j < selects.length; j++) {
		String v = DealDatabase.cvtString(HandleRequest.get_string(selects[j].trim(), "utf-8"));
		hm.put(selects[j].trim(), "'" + v + "'");
	}
	hm.put("log_id", "'" + log_id + "'");
	hm.put("log_result", "'idle'");
	hm.put("report_url", "'log_history_list.jsp?log_id=" + log_id + "'");
	String sql = DealDatabase.getAddSql("t_funtest_log", hm);
	ProjectDatabase.edit_data(sql);
	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001&summary=lod_id='" + log_id + "'.");
%>
</html>
