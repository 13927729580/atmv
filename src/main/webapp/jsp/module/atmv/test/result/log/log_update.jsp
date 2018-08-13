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
		post_submit("query_data", "log_update_do.jsp", "_self");
	}
</script>
</head>
<%
	String loginuser_id = HandleSession.get_string("loginuser_id");
	if (loginuser_id.length() <= 0) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String log_id = HandleRequest.get_string("log_id");
	String req_sql = "select a.* from t_funtest_log a where 1=1 and a.log_id='" + log_id + "'";
	String req_select = "log_name,server_id,work_group,version,log_result";
	String req_view = "报告摘要,测试环境,测试工作组,版本号,结果";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "报告更新";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type="hidden" name="log_id" value="<%=log_id%>" />
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">报告ID：<%=log_id%>
						<button class="btn btn-xs btn-default btn-me" id="submit_data">提交</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<tr>
					<td class='head' width='2%' align='left'></td>
					<td class='head' width='8%' align='left'>字段名称</td>
					<td class='head' width='90%' align='left'>字段内容</td>
				</tr>
				<%
					DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);
					for (int j = 0; j < selects.length; j++) {
						int mod = j % 2 + 1;
						out.println("<tr>");
						out.println("<td align='left'></td>");
						out.println("<td align='left'>" + views[j].trim() + "</td>");
						if (selects[j].trim().equals("server_id")) {
							out.println("<td align='left'>");
							String server_idv = HandleDatabase.get_string(dtm_02, 0, "server_id");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							String sql_02v = "select a.* from t_env_server a where 1=1 order by a.server_name";
							DefaultTableModel dtm_02v = HandleDatabase.query_data(sql_02v);
							for (int k = 0; k < dtm_02v.getRowCount(); k++) {
								String id = HandleDatabase.get_string(dtm_02v, k, "server_id");
								String name = HandleDatabase.get_string(dtm_02v, k, "server_name");
								if (id.equals(server_idv)) {
									out.println("<option value='" + id + "' selected='selected'>" + name + "</option>");
								} else {
									out.println("<option value='" + id + "'>" + name + "</option>");
								}
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("work_group")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = HandleUdc.get_udc("work_group.tech-test");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String key = HandleDatabase.get_string(udc, k, "option_key");
								String value = HandleDatabase.get_string(udc, k, "option_value");
								if (key.equals(HandleDatabase.get_string(dtm_02, 0, selects[j].trim()))) {
									out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
								} else {
									out.println("<option value='" + key + "'>" + value + "</option>");
								}
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("log_result")) {
							out.println("<td align='left'>");
							String log_resultv = HandleDatabase.get_string(dtm_02, 0, "log_result");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = ProjectUdc.get_udc("log_status");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String key = HandleDatabase.get_string(udc, k, "option_key");
								String value = HandleDatabase.get_string(udc, k, "option_value");
								if (key.equals(log_resultv)) {
									out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
								} else {
									out.println("<option value='" + key + "'>" + value + "</option>");
								}
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						out.println("<td align='left'><input type='text' name='" + selects[j].trim() + "' value='" + HandleDatabase.get_string(dtm_02, 0, selects[j].trim()) + "' size='50'/></td>");
						out.println("</tr>");
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>
