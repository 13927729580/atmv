<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#submit_data").click(function() {
			submit_data();
			return false;
		});
	});
	function submit_data() {
		var user_code = document.getElementsByName("user_code")[0];
		if (user_code.value.length == 0) {
			alert("用户账号不能为空！");
			return;
		}
		var user_name = document.getElementsByName("user_name")[0];
		if (user_name.value.length == 0) {
			alert("用户姓名不能为空！");
			return;
		}
		var user_pwd = document.getElementsByName("user_pwd")[0];
		if (user_pwd.value.length == 0) {
			alert("用户密码不能为空！");
			return;
		}
		post_submit("query_data", "register_do.jsp", "_self");
	}
</script>
</head>
<%
	ProjectLog.add_log();

	String req_select = "user_code,user_name,user_pwd,work_depart,work_group,gender,phone,email,user_type";
	String req_view = "用户账号,用户姓名,用户密码,所属部门,所属组,性别,手机号码,电子邮箱,员工类型";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "用户注册";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
						<button class="btn btn-xs btn-default btn-me" id="submit_data">提交</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<tr>
					<td class='head' width='2%' align='left'></td>
					<td class='head' width='8%' align='left'>字段名称</td>
					<td class='head' width='90%' align='left'>字段内容</td>
				</tr>
				<%
					for (int j = 0; j < selects.length; j++) {
						int mod = j % 2 + 1;
						out.println("<tr>");
						out.println("<td align='left'></td>");
						out.println("<td align='left'>" + views[j].trim() + "</td>");
						if (selects[j].trim().equals("user_pwd")) {
							out.println("<td align='left'>");
							out.println("<div><input type='password' name='" + selects[j].trim() + "' value='' size='50'/></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("work_depart")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = HandleUdc.get_udc("work_depart");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String option_key = HandleDatabase.get_string(udc, k, "option_key");
								String option_value = HandleDatabase.get_string(udc, k, "option_value");
								out.println("<option value='" + option_key + "'>" + option_value + "</option>");
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("work_group")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = HandleUdc.get_udc("work_group");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String option_key = HandleDatabase.get_string(udc, k, "option_key");
								String option_value = HandleDatabase.get_string(udc, k, "option_value");
								out.println("<option value='" + option_key + "'>" + option_value + "</option>");
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("gender")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = HandleUdc.get_udc("user_gender");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String option_key = HandleDatabase.get_string(udc, k, "option_key");
								String option_value = HandleDatabase.get_string(udc, k, "option_value");
								out.println("<option value='" + option_key + "'>" + option_value + "</option>");
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("user_type")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = HandleUdc.get_udc("user_type");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String option_key = HandleDatabase.get_string(udc, k, "option_key");
								String option_value = HandleDatabase.get_string(udc, k, "option_value");
								out.println("<option value='" + option_key + "'>" + option_value + "</option>");
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						out.println("<td align='left'><input type='text' name='" + selects[j].trim() + "' value='' size='50'/></td>");
						out.println("</tr>");
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>
