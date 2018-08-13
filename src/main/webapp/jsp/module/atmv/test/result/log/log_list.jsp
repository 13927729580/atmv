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
		$("#static_data").click(function() {
			static_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "log_list.jsp", "_self");
	}
	function add_data() {
		post_submit("query_data", "log_add.jsp", "_self");
	}
	function modify_data() {
		var checked = false;
		var selvs = document.getElementsByName("log_id");
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
		post_submit("query_data", "log_update.jsp", "_self");
	}
	function delete_data() {
		var checked = false;
		var selvs = document.getElementsByName("log_id");
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
			post_submit("query_data", "log_delete.jsp", "_self");
		}
	}
	function static_data() {
		post_submit("query_data", get_path() + "/jsp/module/atmv/test/result/reporter/reporter_log-sum.jsp", "_self");
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

	String version = HandleRequest.get_string("version", "UTF-8");
	String work_group = HandleRequest.get_string("work_group", "UTF-8");
	String log_result = HandleRequest.get_string("log_result", "UTF-8");
	String req_sql = "select a.* from t_funtest_log a where 1=1";
	if (version.length() > 0) {
		req_sql = req_sql + " and a.version='" + version + "'";
	}
	if (work_group.length() > 0) {
		req_sql = req_sql + " and a.work_group='" + work_group + "'";
	}
	if (log_result.length() > 0) {
		req_sql = req_sql + " and a.log_result='" + log_result + "'";
	}
	req_sql = req_sql + " order by a.firetime_start asc";
	String req_select = "log_id,row,log_name,work_group,version,firetime,run_time,log_result,action";
	String req_view = "报告编号,序号,报告摘要,测试组,上线版本,起始时间,运行时间,结果,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "测试报告信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">测试组： <%
						DefaultTableModel work_groups = HandleUdc.get_udc("work_group.tech-test");
						out.println("<select name='work_group'>");
						out.println("<option value=''>--</option>");
						for (int k = 0; k < work_groups.getRowCount(); k++) {
							String key = HandleDatabase.get_string(work_groups, k, "option_key");
							String value = HandleDatabase.get_string(work_groups, k, "option_value");
							if (key.equals(work_group)) {
								out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
							} else {
								out.println("<option value='" + key + "'>" + value + "</option>");
							}
						}
						out.println("</select>");
					%> 上线版本&nbsp;<input type='text' name="version" value="<%=version%>" size="20" /> 测试结果： <%
						DefaultTableModel log_statuss = ProjectUdc.get_udc("log_status");
						out.println("<select name='log_result'>");
						out.println("<option value=''>--</option>");
						for (int k = 0; k < log_statuss.getRowCount(); k++) {
							String key = HandleDatabase.get_string(log_statuss, k, "option_key");
							String value = HandleDatabase.get_string(log_statuss, k, "option_value");
							if (key.equals(log_result)) {
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
						<button class="btn btn-xs btn-default btn-me" id="static_data">汇总统计</button>
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
						if (selects[j].trim().equals("log_id")) {
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
							if (selects[j].trim().equals("log_id")) {
								out.println("<td><input type='checkbox' name='" + selects[j] + "' value='" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "'/></td>");
								continue;
							}
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("work_group")) {
								out.println("<td>");
								out.println("<div>" + HandleUdc.get_udc_value("work_group.tech-test", HandleDatabase.get_string(dtm_02, i, selects[j].trim())) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("firetime")) {
								out.println("<td>");
								String firetime_startv = HandleDatabase.get_string(dtm_02, i, "firetime_start");
								String firetime_endv = HandleDatabase.get_string(dtm_02, i, "firetime_end");
								if (firetime_startv.length() > 0) {
									out.println("<div>开始: " + firetime_startv + "</div>");
								}
								if (firetime_endv.length() > 0) {
									out.println("<div>结束: " + firetime_endv + "</div>");
								}
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("run_time")) {
								out.println("<td>");
								Date firetime_start = DealDate.parseTime2(HandleDatabase.get_string(dtm_02, i, "firetime_start"));
								Date firetime_end = DealDate.parseTime2(HandleDatabase.get_string(dtm_02, i, "firetime_end"));
								TimeNumber tn = null;
								if (firetime_start != null && firetime_end != null) {
									tn = DealDate.secondCompare(firetime_start, firetime_end);
									out.println("<div>" + tn + "</div>");
								}
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("log_result")) {
								out.println("<td>");
								String log_resultv = HandleDatabase.get_string(dtm_02, i, selects[j].trim());
								String imagev = "running.png";
								if (log_resultv.length() > 0) {
									imagev = log_resultv + ".png";
								}
								out.println("<div><img src='" + HandleRequest.get_path() + "/plugin/common/image/" + imagev + "' style='width:32px; height:32px; vertical-align:middle;'/></div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("action")) {
								out.println("<td>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/result/log/log_update.jsp?log_id=" + HandleDatabase.get_string(dtm_02, i, "log_id")
										+ "' target='_self'>修改数据</a></div>");
								out.println("<div><a href='" + HandleDatabase.get_string(dtm_02, i, "report_url") + "' target='_self'>测试明细</a></div>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/result/log/log_report_view.jsp?log_id=" + HandleDatabase.get_string(dtm_02, i, "log_id")
										+ "' target='_blank'>测试报告</a></div>");
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
