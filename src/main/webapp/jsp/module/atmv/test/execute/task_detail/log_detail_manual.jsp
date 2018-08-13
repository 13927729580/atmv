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
		$("[name='record_data']").click(function() {
			$("#record_input").css("top", 100);
			$("#record_input").css("left", 250);
			$("#record_input").show();
			$("#record_input").focus();
			$("[name='log_detail_id']").val($(this).attr("id"));
			$("[name='record_result']").val("pass");
			$("[name='record_memo']").val("预期与实际结果一致。");
			return false;
		});
		$("#query_data").click(function() {
			query_data();
			return false;
		});
		$("#submit_data").click(function() {
			submit_data();
			return false;
		});
		$("#cancel_data").click(function() {
			cancel_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "log_detail_manual.jsp", "_self");
	}
	function submit_data() {
		post_submit("query_data", get_path() + "/edi/submit_manual", "_self");
	}
	function cancel_data() {
		$("#record_input").hide();
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String operate_ip = HandleRequest.get_server_ip();
	String log_id = HandleRequest.get_string("log_id");
	String fun_code = HandleRequest.get_string("fun_code");
	String log_result = HandleRequest.get_string("log_result");
	String req_sql = "select a.* from t_funtest_log_detail a where 1=1 and a.operate_ip='" + operate_ip + "' and a.tc_type='case' and a.run_plugin='manual'";
	if (fun_code.length() > 0) {
		req_sql = req_sql + " and a.fun_code='" + fun_code + "'";
	}
	if (log_result.length() > 0) {
		req_sql = req_sql + " and a.log_result='" + log_result + "'";
	}
	req_sql = req_sql + " group by a.fun_code,a.tc_code order by a.fun_code,a.tc_code";
	String req_select = "id,row,server_name,project_code,function,testcase,run_plugin,memo,run_time,log_result,run_num,action";
	String req_view = "编号,序号,测试环境,所属项目,所属功能,测试用例,执行插件,执行详情,耗时,执行结果,执行次数,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "手工测试执行";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<textarea id='view_detail' name='view_detail' cols='65' rows='10' style='display: none; position: absolute; z-index: 999;'></textarea>
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">功能模块&nbsp; <%
 	out.println("<select name='fun_code' style='width:158px; height:20px;'>");
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
 	DefaultTableModel dtm_status = ProjectUdc.get_udc("log_status");
 	for (int k = 0; k < dtm_status.getRowCount(); k++) {
 		String key = HandleDatabase.get_string(dtm_status, k, "option_key");
 		String value = HandleDatabase.get_string(dtm_status, k, "option_value");
 		if (key.equals(log_result)) {
 			out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
 		} else {
 			out.println("<option value='" + key + "'>" + value + "</option>");
 		}
 	}
 	out.println("</select>");
 %>
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
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
								String sql_03v = "select a.* from t_funtest_log_detail a where 1=1 and a.operate_ip='" + operate_ip + "' and a.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev
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
											out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:80px; height:82px; color:" + color + ";'>"
													+ HandleDatabase.get_string(server, 0, "server_name") + "</div>");
										}
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("project_code")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:80px; height:82px; color:" + color + ";'>"
												+ HandleUdc.get_udc_value("project_code", project_codev) + "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("function")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:80px; height:82px; color:" + color + ";'>" + fun_namev + "</div>");
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
									if (selects[j].trim().equals("run_plugin")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div>" + ProjectUdc.get_udc_value("tc_plugin", HandleDatabase.get_string(dtm_02, i, selects[j].trim())) + "</div>");
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
										out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:100px; height:82px; color:" + color + ";'>" + HandleDatabase.get_string(dtm_03v, 0, "memo")
												+ "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("run_time")) {
										out.println("<td align='right' style='color:" + color + "'>");
										String string_start = HandleDatabase.get_string(dtm_03v, 0, "firetime_start");
										String string_end = HandleDatabase.get_string(dtm_03v, 0, "firetime_end");
										TimeNumber tnv = null;
										if (string_start.length() > 0 && string_end.length() > 0) {
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
										String log_detail_idv = HandleDatabase.get_string(dtm_02, i, "log_detail_id");
										out.println("<div><button class='btn btn-xs btn-default btn-me' id='" + log_detail_idv + "' name='record_data'>测试录入</button></div>");
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
		<div id='record_input' style='display: none; position: absolute; background-color: #ffffff; border: solid 5px #999999; width: 550px; height: 280px; padding: 20px 20px 20px 20px; z-index: 999;'>
			<%
				out.println("<input type='hidden' name='log_detail_id' />");
				out.println("<p>测试结果</p>");
				out.println("<select name='record_result' style='width:100px; height:20px;'>");
				for (int k = 0; k < dtm_status.getRowCount(); k++) {
					String key = HandleDatabase.get_string(dtm_status, k, "option_key");
					String value = HandleDatabase.get_string(dtm_status, k, "option_value");
					out.println("<option value='" + key + "'>" + value + "</option>");
				}
				out.println("</select>");
				out.println("<p style='height:10px;'></p>");
				out.println("<p>执行信息</p>");
				out.println("<textarea name='record_memo' cols='80' rows='8'>预期与实际结果一致。</textarea>");
				out.println("<p style='height:10px;'></p>");
				out.println("<button class='btn btn-xs btn-default btn-me' id='submit_data'>提交结果</button>");
				out.println("&nbsp;&nbsp;");
				out.println("<button class='btn btn-xs btn-default btn-me' id='cancel_data'>取消操作</button>");
			%>
		</div>
	</form>
</body>
</html>
