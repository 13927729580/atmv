<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
$(document).ready(function(){
	$("#query_data").click(function(){
		query_data();
		return false;
	});
	$("#set_data").click(function(){
		set_data();
		return false;
	});
	$("#run_data").click(function(){
		run_data();
		return false;
	});
});
function query_data(){
	post_submit("query_data","task_detail_auto.jsp","_self");
}
function set_data(){
	post_submit("query_data","task_detail_set.jsp","_self");
}
function run_data(){
	var is_operate=confirm('是否确认操作？');
	if(is_operate){
		go_url("<%=ProjectParam.get_param("atev_url")%>/edi/execute_task");
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

	String tc = ProjectParamDetail.get_param("localconfig_task.auto");
	String fun_code = HandleRequest.get_string("fun_code");
	String req_select = "row,function,testcase,run_plugin,concurrent_total,cycle_total,action";
	String req_view = "序号,所属功能,测试用例,执行插件,并发数,循环数,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "测试任务信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
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
 %> 并发次数&nbsp;<input type='text' name="concurrent_total" value="1" size="5" /> 循环次数&nbsp;<input type='text' name="cycle_total" value="1" size="5" />
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
						<button class="btn btn-xs btn-default btn-me" id="set_data">批量设置</button>
						<button class="btn btn-xs btn-default btn-me" id="run_data">立即执行</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<%
					out.println("<tr>");
					for (int j = 0; j < selects.length; j++) {
						if (selects[j].trim().equals("testcase")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						out.println("<td class='head'>" + views[j] + "</td>");
					}
					out.println("</tr>");
					String[] tcs = tc.split("\n");
					int data_total = tcs.length;
					for (int i = 0; i < data_total; i++) {
						if (tcs[i].trim().length() == 0) {
							continue;
						}
						String[] tcvs = tcs[i].split(",");
						if (tcvs.length != 3) {
							continue;
						}
						String[] codes = tcvs[0].split("\\.");
						if (codes.length != 2) {
							continue;
						}
						String fun_codev = codes[0];
						String tc_codev = codes[1];
						if (fun_code.length() > 0 && !fun_codev.equals(fun_code)) {
							continue;
						}
						String sql_02v = "select b.fun_name,a.* from t_funtest_tc a inner join t_funtest_fun b on b.fun_code=a.fun_code where 1=1 and b.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev
								+ "' order by a.tc_code";
						DefaultTableModel dtm_02v = ProjectDatabase.query_data(sql_02v);
						out.println("<tr>");
						for (int j = 0; j < selects.length; j++) {
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("function")) {
								out.println("<td>");
								out.println("<div>" + HandleDatabase.get_string(dtm_02v, 0, "fun_name") + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("testcase")) {
								out.println("<td align='left'>");
								String tc_detailv = "(" + fun_codev + "." + tc_codev + ")";
								String tc_expectv = "";
								if (dtm_02v.getRowCount() > 0) {
									out.println("<input type='hidden' id='tc_id_" + i + "' name='" + selects[j] + "' value='" + HandleDatabase.get_string(dtm_02v, 0, "tc_id") + "'/>");
									tc_detailv = tc_detailv + " " + HandleDatabase.get_string(dtm_02v, 0, "tc_path") + ": " + HandleDatabase.get_string(dtm_02v, 0, "tc_summary") + ". ";
									tc_expectv = "预期结果：" + HandleDatabase.get_string(dtm_02v, 0, "expect_result");
								}
								out.println("<div name='" + selects[j].trim() + "' class='textarea' style='width:550px; height:55px;'>" + tc_detailv + "\n" + tc_expectv + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("run_plugin")) {
								out.println("<td>");
								out.println("<div>" + ProjectUdc.get_udc_value("tc_plugin", HandleDatabase.get_string(dtm_02v, 0, "run_plugin")) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("concurrent_total")) {
								out.println("<td>");
								out.println("<div>" + tcvs[1] + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("cycle_total")) {
								out.println("<td>");
								out.println("<div>" + tcvs[2] + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("action")) {
								out.println("<td>");
								String tc_idv = HandleDatabase.get_string(dtm_02v, 0, "tc_id");
								String run_pluginv = HandleDatabase.get_string(dtm_02v, 0, "run_plugin");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/scenario/test_case/run_plugin/" + run_pluginv + "/tc_step.jsp?tc_id=" + tc_idv
										+ "' target='_blank'>测试步骤</a></div>");
								out.println("<div><a target='_blank' href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/result/log_detail/log_detail_listv.jsp?fun_code=" + fun_codev + "&tc_code="
										+ tc_codev + "'>查看日志</a></div>");
								out.println("</td>");
								continue;
							}
							out.println("<td></td>");
						}
						out.println("</tr>");
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>
