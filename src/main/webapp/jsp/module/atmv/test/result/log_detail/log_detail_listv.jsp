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

		$("#delete_data").click(function() {
			delete_data();
			return false;
		});

		$("#gen_data").click(function() {
			gen_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "log_detail_listv.jsp", "_self");
	}

	function delete_data() {
		var selvs = document.getElementsByName("log_detail_id");
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
			post_submit("query_data", "log_detail_delete.jsp", "_self");
		}
	}

	function gen_data() {
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", get_path() + "/edi/generate_task_log", "_self");
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

	String operate_ip = HandleRequest.get_server_ip();
	String fun_code = HandleRequest.get_string("fun_code");
	String tc_code = HandleRequest.get_string("tc_code");
	String log_result = HandleRequest.get_string("log_result");
	String req_sql = "select a.* from t_funtest_log_detail a where 1=1 and a.operate_ip='" + operate_ip + "'";
	if (fun_code.length() > 0) {
		req_sql = req_sql + " and a.fun_code='" + fun_code + "'";
	}
	if (tc_code.length() > 0) {
		req_sql = req_sql + " and a.tc_code='" + tc_code + "'";
	}
	if (log_result.length() > 0) {
		req_sql = req_sql + " and a.log_result='" + log_result + "'";
	}
	req_sql = req_sql + " order by a.firetime_start desc";
	String req_select = "log_detail_id,row,server_name,project_code,function,testcase,run_plugin,memo,firetime,run_time,log_result,action";
	String req_view = "日志编号,序号,测试环境,所属项目,所属功能,测试用例,执行插件,执行详情,执行时间,耗时,执行结果,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "执行结果明细信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="fun_code" value="<%=fun_code%>" /> <input type='hidden' name="tc_code" value="<%=tc_code%>" />
		<textarea id='view_detail' name='view_detail' cols='80' rows='10' style='display: none; position: absolute; top: 300px; left: 300px; z-index: 999;'></textarea>
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 998;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">测试结果&nbsp; <%
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
						<button class="btn btn-xs btn-default btn-me" id="delete_data">清除</button>
						<button class="btn btn-xs btn-default btn-me" id="gen_data">生成</button>
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
								if (selects[j].trim().equals("log_detail_id")) {
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
								String log_detail_idv = HandleDatabase.get_string(dtm_02, i, "log_detail_id");
								String project_codev = HandleDatabase.get_string(dtm_02, i, "project_code");
								String fun_codev = HandleDatabase.get_string(dtm_02, i, "fun_code");
								String tc_codev = HandleDatabase.get_string(dtm_02, i, "tc_code");
								String log_resultv = HandleDatabase.get_string(dtm_02, i, "log_result");
								String idv = fun_codev + "." + tc_codev;
								String sql_02v = "select b.fun_name,a.* from t_funtest_tc a inner join t_funtest_fun b on b.fun_code=a.fun_code where 1=1 and b.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev
										+ "'";
								DefaultTableModel dtm_02v = ProjectDatabase.query_data(sql_02v);
								String fun_namev = "";
								if (dtm_02v.getRowCount() > 0) {
									fun_namev = HandleDatabase.get_string(dtm_02v, 0, "fun_name");
								}
								String color = "#999999";
								if (log_resultv.equals("fail")) {
									color = "#ff0000";
								} else if (log_resultv.equals("pass")) {
									color = "#333333";
								}
								out.println("<tr>");
								for (int j = 0; j < selects.length; j++) {
									if (selects[j].trim().equals("log_detail_id")) {
										out.println("<td><input type='checkbox' name='" + selects[j].trim() + "' value='" + log_detail_idv + "'/></td>");
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
											out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:120px; height:60px; color:" + color + ";'>"
													+ HandleDatabase.get_string(server, 0, "server_name") + "</div>");
										}
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("project_code")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:120px; height:60px; color:" + color + ";'>"
												+ HandleUdc.get_udc_value("project_code", project_codev) + "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("function")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:120px; height:60px; color:" + color + ";'>" + fun_namev + "</div>");
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
										out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:180px; height:60px; color:" + color + ";'>" + tc_detailv + "\n" + tc_expectv + "</textarea>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("run_plugin")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div>" + ProjectUdc.get_udc_value("tc_plugin", HandleDatabase.get_string(dtm_02, i, selects[j].trim())) + "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("memo")) {
										out.println("<td align='left' style='color:" + color + "'>");
										out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:180px; height:60px; color:" + color + ";'>" + HandleDatabase.get_string(dtm_02, i, "memo")
												+ "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("firetime")) {
										out.println("<td style='color:" + color + "'>");
										out.println("<div>开始：" + HandleDatabase.get_string(dtm_02, i, "firetime_start") + "</div>");
										out.println("<div>结束：" + HandleDatabase.get_string(dtm_02, i, "firetime_end") + "</div>");
										out.println("</td>");
										continue;
									}
									if (selects[j].trim().equals("run_time")) {
										out.println("<td align='right' style='color:" + color + "'>");
										String string_start = HandleDatabase.get_string(dtm_02, i, "firetime_start");
										String string_end = HandleDatabase.get_string(dtm_02, i, "firetime_end");
										TimeNumber tnv = null;
										if (string_start.length() > 0 && string_end.length() > 0) {
											Date firetime_start = DealDate.parseTime2(string_start);
											Date firetime_end = DealDate.parseTime2(string_end);
											tnv = DealDate.secondCompare(firetime_start, firetime_end);
										}
										out.println("<div>" + tnv + "</div>");
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
												+ HandleDatabase.get_string(dtm_02, i, "log_detail_id") + "'>查看日志</a></div>");
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
