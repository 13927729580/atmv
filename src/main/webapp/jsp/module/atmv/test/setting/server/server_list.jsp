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
		$("#gen_data").click(function() {
			gen_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "server_list.jsp", "_self");
	}
	function gen_data() {
		var checked = false;
		var selvs = document.getElementsByName("server_id");
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
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", get_path() + "/edi/generate_server", "_self");
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

	String server_name = HandleRequest.get_string("server_name");
	String req_sql = "select a.* from t_env_server a where 1=1 and a.last_status='enabled'";
	if (server_name.length() > 0) {
		req_sql = req_sql + " and a.server_name like '%" + server_name + "%'";
	}
	req_sql = req_sql + " order by a.server_name asc";
	String req_select = "server_id,row,server_name,server_type,last_status,action";
	String req_view = "测试服务器编号,序号,测试服务器名称,测试服务器类型,状态,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "测试服务器信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">名称&nbsp;<input type='text' name="server_name" value="<%=server_name%>" size="20" />
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
						<button class="btn btn-xs btn-default btn-me" id="gen_data">选择</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<%
					DefaultTableModel dtm_02 = HandleDatabase.query_data(req_sql);
					out.println("<tr>");
					for (int j = 0; j < selects.length; j++) {
						if (selects[j].trim().equals("server_id")) {
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
							if (selects[j].trim().equals("server_id")) {
								out.println("<td><input type='checkbox' name='" + selects[j] + "' value='" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "'/></td>");
								continue;
							}
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("server_name")) {
								out.println("<td>");
								out.println("<div>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("server_type")) {
								out.println("<td>");
								out.println("<div>" + HandleUdc.get_udc_value("server_type", HandleDatabase.get_string(dtm_02, i, selects[j].trim())) + "</div>");
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
