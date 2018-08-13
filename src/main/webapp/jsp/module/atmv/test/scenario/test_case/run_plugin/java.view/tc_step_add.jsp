<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#submit_data").click(function() {
			submit_data();
			return false;
		});
	});
	function submit_data() {
		post_submit("query_data", "tc_step_add_do.jsp", "_self");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String tc_id = HandleRequest.get_string("tc_id");
	int seq = HandleRequest.get_int("seq");

	HashMap hmv1 = new HashMap();
	hmv1.put("seq", "seq+1");
	String sqlv1 = DealDatabase.getModifySql("t_funtest_tc_step", hmv1, "tc_id='" + tc_id + "' and seq>" + seq);
	ProjectDatabase.edit_data(sqlv1);

	HashMap hmv2 = new HashMap();
	hmv2.put("tc_step_id", "UUID()");
	hmv2.put("tc_id", "'" + tc_id + "'");
	hmv2.put("last_status", "'enabled'");
	hmv2.put("seq", "'" + (seq + 1) + "'");
	String sqlv2 = DealDatabase.getAddSql("t_funtest_tc_step", hmv2);
	ProjectDatabase.edit_data(sqlv2);

	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/module/atmv/test/scenario/test_case/run_plugin/java.view/tc_step.jsp?tc_id=" + tc_id);
%>
</html>
