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
		post_submit("query_data", "schema_update_do.jsp", "_self");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String fun_code = HandleRequest.get_string("fun_code");
	String schema_id = HandleRequest.get_string("schema_id");
	String req_sql = "select a.* from t_funtest_schema a where 1=1 and a.schema_id='" + schema_id + "'";
	String req_select = "schema_code,schema_name,tc_fun,tc_level,tc_status,tc_tester,tc_plugin,last_status,memo";
	String req_view = "方案编码,方案名称,用例功能,用例级别,用例状态,用例测试人员,用例插件,状态,备注";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "方案更新";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="fun_code" value="<%=fun_code%>" /> <input type="hidden" name="schema_id" value="<%=schema_id%>" />
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
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
						if (selects[j].trim().equals("tc_fun")) {
							out.println("<td align='left'>");
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='80' rows='4'>" + HandleDatabase.get_string(dtm_02, 0, selects[j].trim()) + "</textarea></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("last_status")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = HandleUdc.get_udc("common_status");
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
						if (selects[j].trim().equals("memo")) {
							out.println("<td align='left'>");
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='80' rows='8'>" + HandleDatabase.get_string(dtm_02, 0, selects[j].trim()) + "</textarea></div>");
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
