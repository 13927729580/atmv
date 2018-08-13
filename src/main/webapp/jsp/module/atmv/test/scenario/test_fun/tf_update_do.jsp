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
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String tc_id = HandleRequest.get_string("tc_id");
	String req_select = "tc_code,tc_level,tc_path,tc_summary,detail_step,expect_result,last_status,run_plugin,tester,developer,memo";
	String[] selects = req_select.split(",");

	HashMap hm = new HashMap();
	for (int j = 0; j < selects.length; j++) {
		String v = DealDatabase.cvtString(HandleRequest.get_string(selects[j].trim()));
		hm.put(selects[j].trim(), "'" + v + "'");
	}
	String sql = DealDatabase.getModifySql("t_funtest_tc", hm, "tc_id='" + tc_id + "'");
	ProjectDatabase.edit_data(sql);
	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>
</html>
