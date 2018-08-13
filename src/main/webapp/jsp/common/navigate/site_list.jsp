<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
	});
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String req_sql = "select b.menu_name as menu1_name,c.menu_name as menu2_name,c.menu_code as menu2_code from t_sys_menu a inner join t_sys_menu b on b.parent_id=a.menu_id inner join t_sys_menu c on c.parent_id=b.menu_id where a.project_code='"
			+ ProjectParam.PROJECT_CODE + "' and a.menu_code='1'";
	req_sql = req_sql + " order by b.menu_code asc";
	DefaultTableModel dtm_02 = HandleDatabase.query_data(req_sql);

	String req_select = "row,menu1,menu2,page,action";
	String req_view = "序号,一级菜单,次级菜单,网站功能,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "网站导航信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">&nbsp;</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<%
					out.println("<tr>");
					for (int j = 0; j < selects.length; j++) {
						if (selects[j].trim().equals("page")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						out.println("<td class='head'>" + views[j] + "</td>");
					}
					out.println("</tr>");
					int data_total = dtm_02.getRowCount();
					for (int i = 0; i < data_total; i++) {
						String menu_codev = HandleDatabase.get_string(dtm_02, i, "menu2_code");
						if (!ProjectMenu.check_menu(menu_codev)) {
							continue;
						}
						out.println("<tr>");
						for (int j = 0; j < selects.length; j++) {
							if (selects[j].trim().equals("menu_id")) {
								out.println("<td><input type='checkbox' name='" + selects[j] + "' value='" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "'/></td>");
								continue;
							}
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("menu1")) {
								out.println("<td>");
								out.println("<div>" + HandleDatabase.get_string(dtm_02, i, "menu1_name") + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("menu2")) {
								out.println("<td>");
								out.println("<div>" + HandleDatabase.get_string(dtm_02, i, "menu2_name") + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("page")) {
								out.println("<td align='left'>");
								out.println("<div>");
								int posv = 0;
								DefaultTableModel dtm_03 = ProjectMenu.get_childs(menu_codev);
								for (int k = 0; k < dtm_03.getRowCount(); k++) {
									if (posv % 7 == 0) {
										out.println("<div>");
									}
									String menu_codevv = HandleDatabase.get_string(dtm_03, k, "menu_code");
									String menu_namevv = HandleDatabase.get_string(dtm_03, k, "menu_name");
									String menu_valuevv = HandleDatabase.get_string(dtm_03, k, "menu_value");
									if (!ProjectMenu.check_menu(menu_codevv)) {
										continue;
									}
									out.println("<a href='" + HandleRequest.get_path() + menu_valuevv + "'>" + menu_namevv + "</a><span>&nbsp;&nbsp;</span>");
									if (posv % 7 == 6) {
										out.println("<div>");
									}
									posv++;
								}
								out.println("</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("action")) {
								out.println("<td>");
								out.println("<div></div>");
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