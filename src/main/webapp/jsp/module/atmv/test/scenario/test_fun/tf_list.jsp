<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#query_data").click(function() {
			query_data();
			return false;
		});
		$("#add_data").click(function() {
			add_data();
			return false;
		});
		$("#modify_data").click(function() {
			modify_data();
			return false;
		});
		$("#delete_data").click(function() {
			delete_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "tf_list.jsp", "_self");
	}
	function add_data() {
		post_submit("query_data", "tf_add.jsp", "_self");
	}
	function modify_data() {
		var selvs = document.getElementsByName("tc_id");
		var n = 0;
		for (var i = 0; i < selvs.length; i++) {
			if (selvs[i].checked) {
				n++;
			}
		}
		if (n == 0) {
			alert("请选择要提交的内容！");
			return;
		}
		if (n > 1) {
			alert("不能选择多条内容！");
			return;
		}
		post_submit("query_data", "tf_update.jsp", "_self");
	}
	function delete_data() {
		var selvs = document.getElementsByName("tc_id");
		var n = 0;
		for (var i = 0; i < selvs.length; i++) {
			if (selvs[i].checked) {
				n++;
			}
		}
		if (n == 0) {
			alert("请选择要提交的内容！");
			return;
		}
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", "tf_delete.jsp", "_self");
		}
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
	String tc_summary = HandleRequest.get_string("tc_summary");
	String tc_status = HandleRequest.get_string("tc_status");
	String req_sql = "select a.* from t_funtest_tc a where tc_type='fun'";
	if (fun_code.length() > 0) {
		req_sql = req_sql + " and a.fun_code='" + fun_code + "'";
	}
	if (tc_summary.length() > 0) {
		req_sql = req_sql + " and a.tc_summary like '%" + tc_summary + "%'";
	}
	if (tc_status.length() > 0) {
		req_sql = req_sql + " and a.last_status='" + tc_status + "'";
	}
	req_sql = req_sql + " order by a.tc_code asc";
	String req_select = "tc_id,row,tc_code,tc_path,tc_summary,run_plugin,action";
	String req_view = "序号,编号,功能编码,功能路径,功能摘要,执行插件,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");
	DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);

	String menu_name = "测试功能信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="fun_code" value="<%=fun_code%>" />
		<textarea id='view_detail' name='view_detail' cols='80' rows='10' style='display: none; position: absolute; top: 300px; left: 300px; z-index: 999;'></textarea>
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 998;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">功能摘要&nbsp;<input type='text' name="tc_summary" value="<%=tc_summary%>" size="20" /> 状态： <%
						DefaultTableModel tc_statuss = HandleUdc.get_udc("common_status");
						out.println("<select name='tc_status'>");
						out.println("<option value=''>--</option>");
						for (int k = 0; k < tc_statuss.getRowCount(); k++) {
							String key = HandleDatabase.get_string(tc_statuss, k, "option_key");
							String value = HandleDatabase.get_string(tc_statuss, k, "option_value");
							if (key.equals(tc_status)) {
								out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
							} else {
								out.println("<option value='" + key + "'>" + value + "</option>");
							}
						}
						out.println("</select>");
					%>
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
						<button class="btn btn-xs btn-default btn-me" id="add_data">新增</button>
						<button class="btn btn-xs btn-default btn-me" id="modify_data">修改</button>
						<button class="btn btn-xs btn-default btn-me" id="delete_data">删除</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<%
					out.println("<tr>");
					for (int j = 0; j < selects.length; j++) {
						if (selects[j].trim().equals("tc_id")) {
							out.println("<td class='head'><input type='checkbox' id='check_all' onclick=\"select_all('check_all','" + selects[j].trim() + "')\"/></td>");
							continue;
						}
						if (selects[j].trim().equals("tc_code")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("tc_summary")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						out.println("<td class='head'>" + views[j] + "</td>");
					}
					out.println("</tr>");
					int data_total = dtm_02.getRowCount();
					for (int i = 0; i < data_total; i++) {
						String tc_idv = HandleDatabase.get_string(dtm_02, i, "tc_id");
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
								out.println("<div>" + (fun_codev + "." + tc_codev) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_summary")) {
								out.println("<td align='left'>");
								out.println("<div>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("run_plugin")) {
								out.println("<td>");
								out.println("<div>" + ProjectUdc.get_udc_value("tc_plugin", run_pluginv) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("action")) {
								out.println("<td>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/scenario/test_fun/tf_update.jsp?tc_id=" + tc_idv + "'>修改数据</a></div>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/scenario/test_case/run_plugin/" + run_pluginv + "/tc_step.jsp?tc_id=" + tc_idv
										+ "' target='_blank'>测试步骤</a></div>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/scenario/test_fun/tf_gen.jsp?tc_id=" + tc_idv + "'>功能构造</a></div>");
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
