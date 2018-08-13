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
		post_submit("query_data", "tc_step_data_do.jsp", "_self");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String step_id = HandleRequest.get_string("step_id");
	String action_type = HandleRequest.get_string("action_type");
	String action_code = HandleRequest.get_string("action_code");
	String last_status = HandleRequest.get_string("last_status");

	if (action_type.length() == 0 || action_code.length() == 0) {
		HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=2007");
		return;
	}

	HashMap hmv1 = new HashMap();
	hmv1.put("action_type", "'" + action_type + "'");
	hmv1.put("action_code", "'" + action_code + "'");
	hmv1.put("last_status", "'" + last_status + "'");
	String sqlv2 = DealDatabase.getModifySql("t_funtest_tc_step", hmv1, "tc_step_id='" + step_id + "'");
	ProjectDatabase.edit_data(sqlv2);

	String action_key = ProjectCase.get_action_key(action_type, action_code);
	String req_sql = "select a.* from t_funtest_tc_step a where 1=1 and a.tc_step_id='" + step_id + "'";
	DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);
	String action_typev = HandleDatabase.get_string(dtm_02, 0, "action_type");
	String action_codev = HandleDatabase.get_string(dtm_02, 0, "action_code");
	String action_keyv = HandleDatabase.get_string(dtm_02, 0, "action_key");
	String action_valuev = HandleDatabase.get_string(dtm_02, 0, "action_value");
	String last_statusv = HandleDatabase.get_string(dtm_02, 0, "last_status");
	if (!action_typev.equals(action_type)) {
		action_typev = action_type;
	}
	if (!action_codev.equals(action_code)) {
		action_codev = action_code;
	}
	if (!action_keyv.equals(action_key)) {
		action_keyv = action_key;
	}
	String[] action_keyvs = null;
	if (action_keyv.length() > 0) {
		action_keyvs = action_keyv.split(",");
	}
	JSONObject json = null;
	if (action_valuev.length() > 0) {
		json = new JSONObject(action_valuev);
	}
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="step_id" value="<%=step_id%>" /> <input type="hidden" name="action_type" value="<%=action_type%>" /> <input type='hidden' name="action_code" value="<%=action_code%>" />
		<input type='hidden' name="action_key" value="<%=action_keyv%>" /> <input type='hidden' name="last_status" value="<%=last_statusv%>" />
		<div style="float: left; position: relative; top: 0px; z-index: 1;">
			<%
				if (action_keyvs == null) {
					out.println("<p>此步骤不需要任何数据</p>");
				} else {
					out.println("<table width='100%'>");
					out.println("<tr>");
					for (int j = 0; j < action_keyvs.length; j++) {
						out.println("<td align='left'><b>" + action_keyvs[j] + "</b></td>");
					}
					out.println("</tr>");
					for (int i = 0; i < 1; i++) {
						out.println("<tr>");
						for (int j = 0; j < action_keyvs.length; j++) {
							String valuev = "";
							int length = 12;
							if (json != null && json.has(action_keyvs[j])) {
								valuev = String.valueOf(json.get(action_keyvs[j]));
							}
							out.println("<td  style='padding:0px 2px 0px 2px;' align='left'>");
							out.println("<textarea name='action_value." + action_keyvs[j] + "' cols='15' rows='2'>" + valuev + "</textarea>");
							out.println("</td>");
						}
						out.println("</tr>");
					}
					out.println("</table>");
					out.println("<p style='height:5px;'></p>");
					out.println("<button id='submit_data' class='btn btn-xs btn-default btn-me'>提交</button>");
				}
			%>
		</div>
	</form>
</body>
</html>
