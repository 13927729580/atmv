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
		post_submit("query_data", "tf_add_do.jsp", "_self");
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
	String req_select = "tc_code,tc_level,tc_path,tc_summary,detail_step,expect_result,last_status,run_plugin,tester,developer,memo";
	String req_view = "用例编码,用例级别,用例路径,用例摘要,详细步骤,预期结果,状态,执行插件,测试人员,开发人员,备注";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "用例新增";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="fun_code" value="<%=fun_code%>" />
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
					for (int j = 0; j < selects.length; j++) {
						int mod = j % 2 + 1;
						out.println("<tr>");
						out.println("<td align='left'></td>");
						out.println("<td align='left'>" + views[j].trim() + "</td>");
						if (selects[j].trim().equals("tc_level")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = ProjectUdc.get_udc("tc_level");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String key = HandleDatabase.get_string(udc, k, "option_key");
								String value = HandleDatabase.get_string(udc, k, "option_value");
								out.println("<option value='" + key + "'>" + value + "</option>");
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("tc_summary")) {
							out.println("<td align='left'>");
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='80' rows='4'></textarea></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("detail_step")) {
							out.println("<td align='left'>");
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='80' rows='8'></textarea></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("expect_result")) {
							out.println("<td align='left'>");
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='80' rows='8'></textarea></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("last_status")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = ProjectUdc.get_udc("tc_status");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String key = HandleDatabase.get_string(udc, k, "option_key");
								String value = HandleDatabase.get_string(udc, k, "option_value");
								out.println("<option value='" + key + "'>" + value + "</option>");
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("run_plugin")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = ProjectUdc.get_udc("tc_plugin");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String key = HandleDatabase.get_string(udc, k, "option_key");
								String value = HandleDatabase.get_string(udc, k, "option_value");
								out.println("<option value='" + key + "'>" + value + "</option>");
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("memo")) {
							out.println("<td align='left'>");
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='80' rows='8'>{}</textarea></div>");
							out.println("</td>");
							continue;
						}
						out.println("<td align='left'><input type='text' name='" + selects[j].trim() + "' value='' size='50'/></td>");
						out.println("</tr>");
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>
