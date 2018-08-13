<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(function() {
		$("#query_data").click(function() {
			query_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "reporter_at-sum.jsp", "_self");
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

	String req_sql = "SELECT b.fun_name AS parent_name,a.* FROM t_funtest_fun a INNER JOIN t_funtest_fun b ON b.fun_id=a.parent_id WHERE 1=1 AND a.fun_type='node' AND a.last_status='enabled'";
	req_sql = req_sql + " ORDER BY a.fun_code ASC";
	String req_select = "row,fun_name,tester,num_design,num_develop,num_auto,num_run,rate_auto,rate_run,action";
	String req_view = "序号,测试模块,接口人,设计个数,可实现个数,已实现个数,执行个数,AT覆盖率,AT执行率,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);

	String menu_name = "自动化测试统计列表";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<%
					out.println("<tr>");
					for (int j = 0; j < selects.length; j++) {
						if (selects[j].trim().equals("fun_name")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("num_design")) {
							out.println("<td class='head' align='right'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("num_develop")) {
							out.println("<td class='head' align='right'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("num_auto")) {
							out.println("<td class='head' align='right'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("num_run")) {
							out.println("<td class='head' align='right'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("rate_auto")) {
							out.println("<td class='head' align='right'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("rate_run")) {
							out.println("<td class='head' align='right'>" + views[j] + "</td>");
							continue;
						}
						out.println("<td class='head'>" + views[j] + "</td>");
					}
					out.println("</tr>");
					int num_design = 0;
					int num_develop = 0;
					int num_auto = 0;
					int num_run = 0;
					int data_total = dtm_02.getRowCount();
					for (int i = 0; i < data_total; i++) {
						String fun_codev = HandleDatabase.get_string(dtm_02, i, "fun_code");
						int num_designv = 0;
						int num_developv = 0;
						int num_autov = 0;
						int num_runv = 0;
						out.println("<tr>");
						for (int j = 0; j < selects.length; j++) {
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("fun_name")) {
								out.println("<td align='left'>");
								String parent_namev = HandleDatabase.get_string(dtm_02, i, "parent_name");
								String fun_namev = HandleDatabase.get_string(dtm_02, i, "fun_name");
								out.println("<div>" + (parent_namev + " / " + fun_namev) + "</div>");
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
							if (selects[j].trim().equals("num_design")) {
								out.println("<td align='right'>");
								String sqlv = "SELECT COUNT(1) AS total_num FROM t_funtest_tc WHERE 1=1 AND tc_type='case' AND fun_code='" + fun_codev + "' AND last_status in ('manual','develop','auto')";
								DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
								for (int k = 0; k < dtmv.getRowCount(); k++) {
									num_designv = HandleDatabase.get_int(dtmv, k, "total_num");
								}
								out.println(num_designv);
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("num_develop")) {
								out.println("<td align='right'>");
								String sqlv = "SELECT COUNT(1) AS total_num FROM t_funtest_tc WHERE 1=1 AND tc_type='case' AND fun_code='" + fun_codev + "' AND last_status in ('develop','auto')";
								DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
								for (int k = 0; k < dtmv.getRowCount(); k++) {
									num_developv = HandleDatabase.get_int(dtmv, k, "total_num");
								}
								out.println(num_developv);
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("num_auto")) {
								out.println("<td align='right'>");
								String sqlv = "SELECT COUNT(1) AS total_num FROM t_funtest_tc WHERE 1=1 AND tc_type='case' AND fun_code='" + fun_codev + "' AND last_status='auto'";
								DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
								for (int k = 0; k < dtmv.getRowCount(); k++) {
									num_autov = HandleDatabase.get_int(dtmv, k, "total_num");
								}
								out.println(num_autov);
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("num_run")) {
								out.println("<td align='right'>");
								String sqlv = "SELECT COUNT(1) AS total_num FROM t_funtest_tc WHERE 1=1 AND tc_type='case' AND fun_code='" + fun_codev + "' AND last_status='auto' AND run_flag='1'";
								DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
								for (int k = 0; k < dtmv.getRowCount(); k++) {
									num_runv = HandleDatabase.get_int(dtmv, k, "total_num");
								}
								out.println(num_runv);
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("rate_auto")) {
								out.println("<td align='right'>");
								double ratev = 0;
								if (num_designv != 0) {
									ratev = (num_autov * 1.0 / num_designv);
								}
								out.println(DealString.decToRate(ratev, 1));
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("rate_run")) {
								out.println("<td align='right'>");
								double ratev = 0;
								if (num_designv != 0) {
									ratev = (num_runv * 1.0 / num_designv);
								}
								out.println(DealString.decToRate(ratev, 1));
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("action")) {
								out.println("<td>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/scenario/test_case/tc_list.jsp?fun_code=" + fun_codev + "' target='_self'>测试用例</a></div>");
								out.println("</td>");
								continue;
							}
							out.println("<td>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</td>");
						}
						num_design = num_design + num_designv;
						num_develop = num_develop + num_developv;
						num_auto = num_auto + num_autov;
						num_run = num_run + num_runv;
						out.println("</tr>");
					}
					out.println("<tr>");
					out.println("<td class='detail_2'>&nbsp;</td>");
					out.println("<td class='detail_2'>&nbsp;</td>");
					out.println("<td class='detail_2'>汇总数据</td>");
					out.println("<td class='detail_2' align='right'>" + num_design + "</td>");
					out.println("<td class='detail_2' align='right'>" + num_develop + "</td>");
					out.println("<td class='detail_2' align='right'>" + num_auto + "</td>");
					out.println("<td class='detail_2' align='right'>" + num_run + "</td>");
					out.println("<td class='detail_2' align='right'>");
					double rate_auto = 0;
					if (num_design != 0) {
						rate_auto = (num_auto * 1.0 / num_design);
					}
					out.println(DealString.decToRate(rate_auto, 1));
					out.println("</td>");
					out.println("<td class='detail_2' align='right'>");
					double rate_run = 0;
					if (num_design != 0) {
						rate_run = (num_run * 1.0 / num_design);
					}
					out.println(DealString.decToRate(rate_run, 1));
					out.println("</td>");
					out.println("<td class='detail_2'>&nbsp;</td>");
					out.println("</tr>");
				%>
			</table>
		</div>
	</form>
</body>
</html>
