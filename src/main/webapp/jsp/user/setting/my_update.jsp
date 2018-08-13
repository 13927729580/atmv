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
		$("#modify_pwd").click(function() {
			modify_pwd();
			return false;
		});
	});
	function submit_data() {
		post_submit("query_data", "my_update_do.jsp", "_self");
	}
	function modify_pwd() {
		post_submit("query_data", "my_pwd.jsp", "_self");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String loginuser_id = HandleSession.get_string("loginuser_id");
	String req_sql = "select a.* from t_sys_user a where 1=1 and a.user_id='" + loginuser_id + "'";
	String req_select = "user_code,user_name,user_pwd,gender,work_depart,work_group,role,phone,email,user_type,user_logo,user_style,last_status";
	String req_view = "用户账号,用户姓名,登录密码,性别,所属部门,所属组,所属角色,手机号码,电子邮箱,员工类型,头像,界面风格,状态";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "我的资料";
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
					DefaultTableModel dtm_02 = HandleDatabase.query_data(req_sql);
					for (int j = 0; j < selects.length; j++) {
						int mod = j % 2 + 1;
						out.println("<tr>");
						out.println("<td align='left'></td>");
						out.println("<td align='left'>" + views[j].trim() + "</td>");
						if (selects[j].trim().equals("user_code")) {
							out.println("<td align='left'>");
							out.println("<div>" + HandleDatabase.get_string(dtm_02, 0, selects[j].trim()) + "</div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("user_name")) {
							out.println("<td align='left'>");
							out.println("<div>" + HandleDatabase.get_string(dtm_02, 0, selects[j].trim()) + "</div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("user_pwd")) {
							out.println("<td align='left'>");
							out.println("<div><button id='modify_pwd'>修改密码</button></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("gender")) {
							out.println("<td align='left'>");
							out.println("<div>" + HandleUdc.get_udc_value("user_gender", HandleDatabase.get_string(dtm_02, 0, selects[j].trim())) + "</div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("work_depart")) {
							out.println("<td align='left'>");
							out.println("<div>" + HandleUdc.get_udc_value("work_depart", HandleDatabase.get_string(dtm_02, 0, selects[j].trim())) + "</div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("work_group")) {
							out.println("<td align='left'>");
							out.println(
									"<div>" + HandleUdc.get_udc_value("work_group." + HandleDatabase.get_string(dtm_02, 0, "work_depart"), HandleDatabase.get_string(dtm_02, 0, selects[j].trim())) + "</div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("role")) {
							out.println("<td align='left'>");
							DefaultTableModel roles = HandleUser.get_user_roles(loginuser_id);
							for (int k = 0; k < roles.getRowCount(); k++) {
								out.println("<input type='checkbox' id='" + selects[j].trim() + "_" + k + "' name='" + selects[j].trim() + "' value='" + HandleDatabase.get_string(roles, k, "role_id")
										+ "' checked='checked' disabled='disabled'>");
								out.println("<label for='" + selects[j].trim() + "_" + k + "' style='display:inline-block; width:120px;'>" + HandleDatabase.get_string(roles, k, "role_name") + "</label>");
							}
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("user_type")) {
							out.println("<td align='left'>");
							out.println("<div>" + HandleUdc.get_udc_value("user_type", HandleDatabase.get_string(dtm_02, 0, selects[j].trim())) + "</div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("user_logo")) {
							out.println("<td align='left'>");
							out.println("<div>");
							for (int k = 0; k < 71; k++) {
								String option_key = "/attachfile/image/user/user_" + DealString.intFormat((k + 1), 3) + ".jpg";
								if (option_key.equals(HandleDatabase.get_string(dtm_02, 0, selects[j].trim()))) {
									out.println("<input type='radio' name='" + selects[j].trim() + "' value='" + option_key + "' checked>");
								} else {
									out.println("<input type='radio' name='" + selects[j].trim() + "' value='" + option_key + "'>");
								}
								out.println("<img src='" + HandleRequest.get_path() + option_key + "' style='width:25px; height:25px;'/>");
							}
							out.println("</div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("user_style")) {
							out.println("<td align='left'>");
							out.println("<div><select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = HandleUdc.get_udc("user_style");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String option_key = HandleDatabase.get_string(udc, k, "option_key");
								String option_value = HandleDatabase.get_string(udc, k, "option_value");
								if (option_key.equals(HandleDatabase.get_string(dtm_02, 0, selects[j].trim()))) {
									out.println("<option value='" + option_key + "' selected='selected'>" + option_value + "</option>");
								} else {
									out.println("<option value='" + option_key + "'>" + option_value + "</option>");
								}
							}
							out.println("</select></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("last_status")) {
							out.println("<td align='left'>");
							out.println("<div>" + HandleUdc.get_udc_value("common_status", HandleDatabase.get_string(dtm_02, 0, selects[j].trim())) + "</div>");
							out.println("</td>");
							continue;
						}
						out.println("<td align='left'><input type='text' name='" + selects[j].trim() + "' value='" + HandleDatabase.get_string(dtm_02, 0, selects[j].trim()) + "' size='50'/></td>");
						out.println("</tr>");
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>
