<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#gen_data").click(function() {
			gen_data();
			return false;
		});
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
		post_submit("query_data", "schema_list.jsp", "_self");
	}
	function add_data() {
		post_submit("query_data", "schema_add.jsp", "_self");
	}
	function modify_data() {
		var selvs = document.getElementsByName("schema_id");
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
		post_submit("query_data", "schema_update.jsp", "_self");
	}
	function delete_data() {
		var checked = false;
		var selvs = document.getElementsByName("schema_id");
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
			post_submit("query_data", "schema_delete.jsp", "_self");
		}
	}
	function gen_data() {
		var selvs = document.getElementsByName("schema_id");
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
		post_submit("query_data", get_path() + "/edi/generate_task_schema", "_self");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String schema_name = HandleRequest.get_string("schema_name");
	String req_sql = "select a.* from t_funtest_schema a where 1=1";
	if (schema_name.length() > 0) {
		req_sql = req_sql + " and a.schema_name like '%" + schema_name + "%'";
	}
	req_sql = req_sql + " order by a.schema_name asc";
	String req_select = "schema_id,row,schema_code,schema_name,tc_fun,tc_level,tc_status,tc_tester,tc_plugin,last_status,action";
	String req_view = "测试方案编号,序号,方案编码,方案名称,用例功能,用例级别,用例状态,测试人员,执行插件,状态,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "测试方案信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">名称&nbsp;<input type='text' name="schema_name" value="<%=schema_name%>" size="20" />
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
						<button class="btn btn-xs btn-default btn-me" id="add_data">新增</button>
						<button class="btn btn-xs btn-default btn-me" id="modify_data">修改</button>
						<button class="btn btn-xs btn-default btn-me" id="delete_data">删除</button>
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
						if (selects[j].trim().equals("schema_id")) {
							out.println("<td class='head'><input type='checkbox' id='check_all' onclick=\"select_all('check_all','" + selects[j].trim() + "')\"/></td>");
							continue;
						}
						out.println("<td class='head'>" + views[j] + "</td>");
					}
					out.println("</tr>");
					int data_total = dtm_02.getRowCount();
					for (int i = 0; i < data_total; i++) {
						out.println("<tr>");
						for (int j = 0; j < selects.length; j++) {
							if (selects[j].trim().equals("schema_id")) {
								out.println("<td><input type='checkbox' name='" + selects[j] + "' value='" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "'/></td>");
								continue;
							}
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_fun")) {
								out.println("<td>");
								String v = HandleDatabase.get_string(dtm_02, i, selects[j].trim());
								if (v.length() == 0) {
									out.println("<div>ALL</div>");
								} else {
									String[] vs = v.split(",");
									for (int k = 0; k < vs.length; k++) {
										String fun_codev = vs[k];
										String sql_02v = "select b.fun_name as fun_parent,a.* from t_funtest_fun a inner join t_funtest_fun b on b.fun_id=a.parent_id where 1=1 and a.fun_code='" + fun_codev
												+ "' order by a.fun_code";
										DefaultTableModel dtm_02v = ProjectDatabase.query_data(sql_02v);
										String fun_parentv = "";
										String fun_namev = "";
										if (dtm_02v.getRowCount() > 0) {
											fun_parentv = HandleDatabase.get_string(dtm_02v, 0, "fun_parent");
											fun_namev = HandleDatabase.get_string(dtm_02v, 0, "fun_name");
										}
										out.println("<div>" + (fun_parentv + " / " + fun_namev) + "</div>");
									}
								}
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_level")) {
								out.println("<td>");
								String v = HandleDatabase.get_string(dtm_02, i, selects[j].trim());
								if (v.length() == 0) {
									out.println("<div>ALL</div>");
								} else {
									String[] vs = v.split(",");
									for (int k = 0; k < vs.length; k++) {
										out.println("<div>" + ProjectUdc.get_udc_value("tc_level", vs[k]) + "</div>");
									}
								}
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_status")) {
								out.println("<td>");
								String v = HandleDatabase.get_string(dtm_02, i, selects[j].trim());
								if (v.length() == 0) {
									out.println("<div>ALL</div>");
								} else {
									String[] vs = v.split(",");
									for (int k = 0; k < vs.length; k++) {
										out.println("<div>" + ProjectUdc.get_udc_value("tc_status", vs[k]) + "</div>");
									}
								}
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_tester")) {
								out.println("<td>");
								String v = HandleDatabase.get_string(dtm_02, i, selects[j].trim());
								if (v.length() == 0) {
									out.println("<div>ALL</div>");
								} else {
									String[] vs = v.split(",");
									for (int k = 0; k < vs.length; k++) {
										out.println("<div>" + HandleUser.get_user_value("user_code", vs[k], "user_name") + "</div>");
									}
								}
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("tc_plugin")) {
								out.println("<td>");
								String v = HandleDatabase.get_string(dtm_02, i, selects[j].trim());
								if (v.length() == 0) {
									out.println("<div>ALL</div>");
								} else {
									String[] vs = v.split(",");
									for (int k = 0; k < vs.length; k++) {
										out.println("<div>" + ProjectUdc.get_udc_value("tc_plugin", vs[k]) + "</div>");
									}
								}
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("last_status")) {
								out.println("<td>");
								out.println("<div>" + HandleUdc.get_udc_value("common_status", HandleDatabase.get_string(dtm_02, i, selects[j].trim())) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("action")) {
								out.println("<td>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/execute/schema/schema_update.jsp?schema_id="
										+ HandleDatabase.get_string(dtm_02, i, "schema_id") + "'>修改数据</a></div>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/edi/generate_task_schema?schema_code=" + HandleDatabase.get_string(dtm_02, i, "schema_code") + "'>生成任务</a></div>");
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
