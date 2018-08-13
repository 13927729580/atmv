<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("[name='tc_pathv']").click(function() {
			$("#view_detail").css("top", $(this).offset().top - 1);
			$("#view_detail").css("left", $(this).offset().left);
			$("#view_detail").val($(this).text());
			$("#view_detail").show();
			$("#view_detail").focus();
		});
		$("[name='tc_summaryv']").click(function() {
			$("#view_detail").css("top", $(this).offset().top - 1);
			$("#view_detail").css("left", $(this).offset().left);
			$("#view_detail").val($(this).text());
			$("#view_detail").show();
			$("#view_detail").focus();
		});
		$("[name='detail_stepv']").click(function() {
			$("#view_detail").css("top", $(this).offset().top - 1);
			$("#view_detail").css("left", $(this).offset().left);
			$("#view_detail").val($(this).text());
			$("#view_detail").show();
			$("#view_detail").focus();
		});
		$("[name='expect_resultv']").click(function() {
			$("#view_detail").css("top", $(this).offset().top - 1);
			$("#view_detail").css("left", $(this).offset().left);
			$("#view_detail").val($(this).text());
			$("#view_detail").show();
			$("#view_detail").focus();
		});
		$("[name='view_detail']").blur(function() {
			$("#view_detail").hide();
		});

		$("#query_data").click(function() {
			query_data();
			return false;
		});
		$("#gen_data").click(function() {
			gen_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "task_detail_select.jsp", "_self");
	}
	function gen_data() {
		post_submit("query_data", get_path() + "/edi/generate_task_tc", "_self");
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
	String tc_level = HandleRequest.get_string("tc_level");
	String run_plugin = HandleRequest.get_string("run_plugin");
	String last_status = HandleRequest.get_string("last_status");
	String req_sql = "select b.fun_code,a.* from t_funtest_tc a inner join t_funtest_fun b on b.fun_code=a.fun_code where 1=1 and a.tc_type='case'";
	if (fun_code.length() > 0) {
		req_sql = req_sql + " and a.fun_code='" + fun_code + "'";
	}
	if (tc_level.length() > 0) {
		req_sql = req_sql + " and a.tc_level='" + tc_level + "'";
	}
	if (run_plugin.length() > 0) {
		req_sql = req_sql + " and a.run_plugin='" + run_plugin + "'";
	}
	if (last_status.length() > 0) {
		req_sql = req_sql + " and a.last_status='" + last_status + "'";
	}
	req_sql = req_sql + " order by a.fun_code,a.tc_code";
	String req_select = "tc_id,row,tc_code,tc_level,tc_path,tc_summary,detail_step,expect_result,tester,developer,last_status,run_plugin";
	String req_view = "用例编号,序号,用例编码,用例级别,用例路径,用例摘要,详细步骤,预期结果,测试人员,开发人员,状态,执行插件";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "用例选择";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<textarea id='view_detail' name='view_detail' cols='50' rows='10' style='display: none; position: absolute; top: 300px; left: 300px; z-index: 999;'></textarea>
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 998;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">功能模块&nbsp; <%
 	out.println("<select name='fun_code' style='width:138px; height:20px;'>");
 	out.println("<option value=''>--</option>");
 	String sql_fun = "select b.fun_name as fun_parent,a.* from t_funtest_fun a inner join t_funtest_fun b on b.fun_id=a.parent_id where b.parent_id='28bb518f-6985-11e4-8943-54dd5a29be40' order by a.fun_code asc";
 	DefaultTableModel dtm_fun = ProjectDatabase.query_data(sql_fun);
 	for (int k = 0; k < dtm_fun.getRowCount(); k++) {
 		String fun_codev = HandleDatabase.get_string(dtm_fun, k, "fun_code");
 		String fun_parentv = HandleDatabase.get_string(dtm_fun, k, "fun_parent");
 		String fun_namev = HandleDatabase.get_string(dtm_fun, k, "fun_name");
 		if (fun_codev.equals(fun_code)) {
 			out.println("<option value='" + fun_codev + "' selected='selected'>" + (fun_parentv + " / " + fun_namev) + "</option>");
 		} else {
 			out.println("<option value='" + fun_codev + "'>" + (fun_parentv + " / " + fun_namev) + "</option>");
 		}
 	}
 	out.println("</select>");
 %> 级别： <%
 	DefaultTableModel tc_levels = ProjectUdc.get_udc("tc_level");
 	out.println("<select name='tc_level'>");
 	out.println("<option value=''>--</option>");
 	for (int k = 0; k < tc_levels.getRowCount(); k++) {
 		String key = HandleDatabase.get_string(tc_levels, k, "option_key");
 		String value = HandleDatabase.get_string(tc_levels, k, "option_value");
 		if (key.equals(tc_level)) {
 			out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
 		} else {
 			out.println("<option value='" + key + "'>" + value + "</option>");
 		}
 	}
 	out.println("</select>");
 %> 执行插件： <%
 	DefaultTableModel tc_plugins = ProjectUdc.get_udc("tc_plugin");
 	out.println("<select name='run_plugin'>");
 	out.println("<option value=''>--</option>");
 	for (int k = 0; k < tc_plugins.getRowCount(); k++) {
 		String key = HandleDatabase.get_string(tc_plugins, k, "option_key");
 		String value = HandleDatabase.get_string(tc_plugins, k, "option_value");
 		if (key.equals(run_plugin)) {
 			out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
 		} else {
 			out.println("<option value='" + key + "'>" + value + "</option>");
 		}
 	}
 	out.println("</select>");
 %> 状态： <%
 	DefaultTableModel tc_statuss = ProjectUdc.get_udc("tc_status");
 	out.println("<select name='last_status'>");
 	out.println("<option value=''>--</option>");
 	for (int k = 0; k < tc_statuss.getRowCount(); k++) {
 		String key = HandleDatabase.get_string(tc_statuss, k, "option_key");
 		String value = HandleDatabase.get_string(tc_statuss, k, "option_value");
 		if (key.equals(last_status)) {
 			out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
 		} else {
 			out.println("<option value='" + key + "'>" + value + "</option>");
 		}
 	}
 	out.println("</select>");
 %>
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
						<button class="btn btn-xs btn-default btn-me" id="gen_data">生成任务</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<%
					DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);
					out.println("<tr>");
					for (int j = 0; j < selects.length; j++) {
						if (selects[j].trim().equals("tc_id")) {
							out.println("<td class='head'><input type='checkbox' id='check_all' onclick=\"select_all('check_all','" + selects[j].trim() + "')\"/></td>");
							continue;
						}
						if (selects[j].trim().equals("tc_path")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("tc_summary")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("detail_step")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("expect_result")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						out.println("<td class='head'>" + views[j] + "</td>");
					}
					out.println("</tr>");
					int data_total = dtm_02.getRowCount();
					for (int i = 0; i < data_total; i++) {
						String fun_codev = HandleDatabase.get_string(dtm_02, i, "fun_code");
						String tc_codev = HandleDatabase.get_string(dtm_02, i, "tc_code");
						String run_pluginv = HandleDatabase.get_string(dtm_02, i, "run_plugin");
						out.println("<tr>");
						for (int j = 0; j < selects.length; j++) {
							if (selects[j].trim().equals("tc_id")) {
								out.println("<td><input type='checkbox' name='" + selects[j] + "' value='" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "'/></td>");
								continue;
							}
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_code")) {
								out.println("<td>");
								out.println("<div>" + fun_codev + "</div>");
								out.println("<div>" + tc_codev + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_level")) {
								out.println("<td>");
								out.println("<div>" + ProjectUdc.get_udc_value("tc_level", HandleDatabase.get_string(dtm_02, i, selects[j].trim())) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_path")) {
								out.println("<td align='left'>");
								out.println("<div name='" + selects[j].trim() + "v' class='textarea' style='width:100px; height:38px;'>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_summary")) {
								out.println("<td align='left'>");
								out.println("<div name='" + selects[j].trim() + "v' class='textarea' style='width:100px; height:38px;'>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("detail_step")) {
								out.println("<td align='left'>");
								out.println("<div name='" + selects[j].trim() + "v' class='textarea' style='width:100px; height:38px;'>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("expect_result")) {
								out.println("<td align='left'>");
								out.println("<div name='" + selects[j].trim() + "v' class='textarea' style='width:100px; height:38px;'>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("tester")) {
								out.println("<td>");
								String tester = HandleDatabase.get_string(dtm_02, i, "tester");
								out.println("<div>" + HandleUser.get_user_value("user_code", tester, "user_name") + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("developer")) {
								out.println("<td>");
								String developer = HandleDatabase.get_string(dtm_02, i, "developer");
								out.println("<div>" + HandleUser.get_user_value("user_code", developer, "user_name") + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("last_status")) {
								out.println("<td>");
								out.println("<div>" + ProjectUdc.get_udc_value("tc_status", HandleDatabase.get_string(dtm_02, i, selects[j].trim())) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("run_plugin")) {
								out.println("<td>");
								out.println("<div>" + ProjectUdc.get_udc_value("tc_plugin", run_pluginv) + "</div>");
								out.println("</td>");
								continue;
							}
							out.println("<td>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</td>");
						}
						out.println("</tr>");
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>
