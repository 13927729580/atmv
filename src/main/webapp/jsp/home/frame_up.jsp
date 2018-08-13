<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
	});
	function load_index() {
		top.location.href = get_path();
	}
	function load_module(module, url) {
		document.getElementById("module_name").innerHTML = module;
		post_submit("query_data", url, "frame_left");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}

	DefaultTableModel menuv = ProjectMenu.get_default();
%>
<body>
	<form name="query_data" method="post">
		<div id="menu_bar1" style="position: absolute; top: 0px; left: 0px; width: 100%; height: 30px;">
			<table align="left">
				<tr>
					<td width="20" height="30"></td>
					<td style='font-size: 15px; font-weight: bold;'><a href="#" onclick="load_index();"><i class="glyphicon glyphicon-home"></i>&nbsp;&nbsp;<%=ProjectParam.get_title()%></a></td>
					<td width="10"></td>
				</tr>
			</table>
			<table align="right">
				<tr>
					<td width="10" height="30"></td>
					<%
						DefaultTableModel dtm_01 = ProjectMenu.get_childs("1");
						for (int i = 0; i < dtm_01.getRowCount(); i++) {
							String menu_codev = HandleDatabase.get_string(dtm_01, i, "menu_code");
							String menu_namev = HandleDatabase.get_string(dtm_01, i, "menu_name");
							if (!ProjectMenu.check_menu(menu_codev)) {
								continue;
							}
							out.println("<td><span class='module_span' onclick=\"load_module('" + menu_namev + "','" + HandleRequest.get_path() + "/jsp/home/frame_left.jsp?menu_code=" + menu_codev
									+ "')\" style='font-size:14px; font-weight:bold;'>" + menu_namev + "</span></td>");
							out.println("<td width='10'></td>");
						}
					%>
				</tr>
			</table>
		</div>
		<div id="menu_bar2" style="position: absolute; top: 30px; left: 0px; width: 100%; height: 45px;">
			<table align="left">
				<tr>
					<td width="20" height="45"></td>
					<td style="font-family: Elephant; font-size: 22px; font-weight: bold;"><span id="module_name"><%=HandleDatabase.get_string(menuv, 0, "menu_name")%></span> 管理模块</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>
