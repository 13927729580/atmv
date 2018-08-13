<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("[name='testcase']").click(function() {
			$("#view_detail").css("top", $(this).offset().top - 1);
			$("#view_detail").css("left", $(this).offset().left);
			$("#view_detail").css("color", $(this).css("color"));
			$("#view_detail").val($(this).text());
			$("#view_detail").show();
			$("#view_detail").focus();
		});
		$("[name='memo']").click(function() {
			$("#view_detail").css("top", $(this).offset().top - 1);
			$("#view_detail").css("left", $(this).offset().left);
			$("#view_detail").css("color", $(this).css("color"));
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
		$("#view_report").click(function() {
			view_report();
			return false;
		});
		$("#work_data").click(function() {
			work_data();
			return false;
		});
		$("#static_data").click(function() {
			static_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "log_history_list.jsp", "_self");
	}
	function view_report() {
		post_submit("query_data", "log_report_view.jsp", "_blank");
	}
	function work_data() {
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", get_path() + "/edi/update_work", "_self");
		}
	}
	function static_data() {
		post_submit("query_data", get_path() + "/jsp/module/atmv/test/result/reporter/reporter_loghistory-sum.jsp", "_self");
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
	String fun_code = HandleRequest.get_string("fun_code", "UTF-8");
	String log_result = HandleRequest.get_string("log_result", "UTF-8");
	String req_sql = "select a.* from t_funtest_log_history a where 1=1";
	if (log_id.length() > 0) {
		req_sql = req_sql + " and a.log_id='" + log_id + "'";
	}
	if (fun_code.length() > 0) {
		req_sql = req_sql + " and a.fun_code='" + fun_code + "'";
	}
	if (log_result.length() > 0) {
		req_sql = req_sql + " and a.log_result='" + log_result + "'";
	}
	req_sql = req_sql + " group by a.fun_code,a.tc_code order by a.fun_code,a.tc_code";
	String req_select = "id,row,server_name,project_code,function,testcase,memo,run_time,log_result,run_num,action";
	String req_view = "编号,序号,测试环境,所属项目,所属功能,测试用例,执行详情,耗时,执行结果,执行次数,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "测试报告明细信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="log_id" value="<%=log_id%>" />
		<textarea id='view_detail' name='view_detail' cols='65' rows='10' style='display: none; position: absolute; top: 300px; left: 300px; z-index: 999;'></textarea>
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 998;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">功能模块&nbsp; <%
 	out.println("<select name='fun_code' style='width:188px; height:20px;'>");
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
 %> 测试结果&nbsp; <%
 	out.println("<select name='log_result' style='width:55px; height:20px;'>");
 	out.println("<option value=''>--</option>");
 	DefaultTableModel udc = ProjectUdc.get_udc("log_status");
 	for (int k = 0; k < udc.getRowCount(); k++) {
 		String key = HandleDatabase.get_string(udc, k, "option_key");
 		String value = HandleDatabase.get_string(udc, k, "option_value");
 		if (key.equals(log_result)) {
 			out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
 		} else {
 			out.println("<option value='" + key + "'>" + value + "</option>");
 		}
 	}
 	out.println("</select>");
 %>
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
						<button class="btn btn-xs btn-default btn-me" id="view_report">测试报告</button>
						<button class="btn btn-xs btn-default btn-me" id="work_data">工作数据</button>
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
								if (selects[j].trim().equals("id")) {
									out.println("<td class='head'><input type='checkbox' id='check_all' onclick=\"select_all('check_all','" + selects[j].trim() + "')\"/></td>");
									continue;
								}
								if (selects[j].trim().equals("testcase")) {
									out.println("<td class='head' align='left'>" + views[j] + "</td>");
									continue;
								}
								if (selects[j].trim().equals("memo")) {
									out.println("<td class='head' align='left'>" + views[j] + "</td>");
									continue;
								}
								if (selects[j].trim().equals("run_time")) {
									out.println("<td class='head' align='right'>" + views[j] + "</td>");
									continue;
								}
								out.println("<td class='head'>" + views[j] + "</td>");
							}
							out.println("</tr>");
							int data_total = dtm_02.getRowCount();
							for (int i = 0; i < data_total; i++) {
								String fun_codev = HandleDatabase.get_string(dtm_02, i, "fun_code");
								String tc_codev = HandleDatabase.get_string(dtm_02, i, "tc_code");
								String idv = fun_codev + "." + tc_codev;
								String sql_02v = "select b.fun_name,a.* from t_funtest_tc a inner join t_funtest_fun b on b.fun_code=a.fun_code where 1=1 and b.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev
										+ "'";
								DefaultTableModel dtm_02v = ProjectDatabase.query_data(sql_02v);
								String fun_namev = "";
								if (dtm_02v.getRowCount() > 0) {
									fun_namev = HandleDatabase.get_string(dtm_02v, 0, "fun_name");
								}
								String sql_03v = "select a.* from t_funtest_log_history a where 1=1 and a.log_id='" + log_id + "' and a.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev
										+ "' order by a.firetime_start desc";
								DefaultTableModel dtm_03v = ProjectDatabase.query_data(sql_03v);
								String project_codev = HandleDatabase.get_string(dtm_03v, 0, "project_code");
								String log_resultv = HandleDatabase.get_string(dtm_03v, 0, "log_result");
								if (log_result.length() > 0 && !log_resultv.equals(log_result)) {
									continue;
								}
								String color = "#999999";
								if (log_resultv.equals("fail")) {
									color = "#ff0000";
								} else if (log_resultv.equals("pass")) {
									color = "#333333";
								}
								out.println("<tr>");
								for (int j = 0; j < selects.length; j++) {
									if (selects[j].trim().equals("id")) {
										out.println("<td><input type='checkbox' name='" + selects[j].trim() + "' value='" + idv + "'/></td>");
										continue;
									}
									if (selects[j].trim().equals("row")) {
										out.println("<td style='color:" + color + "'>" + (i + 1) + "</td>");
										continue;
									}
									if (selects[j].trim().equals("server_name")) {
										out.println("<td style='color:" + color + "'>");
										DefaultTableModel server = ProjectServer.get_server(HandleDatabase.get_string(dtm_02, i, "server_id"));
										if (server.getRowCount() == 1) {
											out.println("<div>" + HandleDatabase.get_string(server, 0, "server_name") + "</div>");
										}
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("project_code")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div>" + HandleUdc.get_udc_value("project_code", project_codev) + "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("function")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div>" + fun_namev + "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("testcase")) {
										out.println("<td align='left' style='color:" + color + "'>");
										String tc_detailv = "(" + fun_codev + "." + tc_codev + ")";
										String tc_expectv = "";
										if (dtm_02v.getRowCount() > 0) {
											tc_detailv = tc_detailv + " " + HandleDatabase.get_string(dtm_02v, 0, "tc_path") + ": " + HandleDatabase.get_string(dtm_02v, 0, "tc_summary") + ". ";
											tc_expectv = "预期结果：" + HandleDatabase.get_string(dtm_02v, 0, "expect_result");
										}
										out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:200px; height:82px; color:" + color + ";'>" + tc_detailv + "\n" + tc_expectv + "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("run_num")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div>" + dtm_03v.getRowCount() + "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("memo")) {
										out.println("<td align='left' style='color:" + color + "'>");
										out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:200px; height:82px; color:" + color + ";'>" + HandleDatabase.get_string(dtm_03v, 0, "memo")
												+ "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("run_time")) {
										out.println("<td align='right' style='color:" + color + "'>");
										String string_start = HandleDatabase.get_string(dtm_03v, 0, "firetime_start");
										String string_end = HandleDatabase.get_string(dtm_03v, 0, "firetime_end");
										TimeNumber tnv = null;
										if (string_start != null && string_end != null) {
											Date firetime_start = DealDate.parseTime2(string_start);
											Date firetime_end = DealDate.parseTime2(string_end);
											tnv = DealDate.secondCompare(firetime_start, firetime_end);
											out.println("<div>" + tnv + "</div>");
										}
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("log_result")) {
										out.println("<td style='color:" + color + "'>");
										String imagev = "running.png";
										if (log_resultv.length() > 0) {
											imagev = log_resultv + ".png";
										}
										out.println("<div><img src='" + HandleRequest.get_path() + "/plugin/common/image/" + imagev + "' style='width:32px; height:32px; vertical-align:middle;'/></div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("action")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div><a target='_blank' href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/result/log_detail/log_detail_view.jsp?log_detail_id="
												+ HandleDatabase.get_string(dtm_03v, 0, "log_detail_id") + "'>查看日志</a></div>");
										out.println("</td>");
										continue;
									}
									out.println("<td style='color:" + color + "'>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</td>");
								}
								out.println("</tr>");
							}
				%>
			</table>
		</div>
	</form>
</body>
</html>
