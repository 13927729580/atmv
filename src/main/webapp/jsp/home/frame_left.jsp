<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("[name='menu1']").click(function() {
			restore_css_all();
			$(".menu_list1").hide();
			$(this).next(".menu_list1").show();
		});

		$("[name='menu2']").click(function() {
			restore_css_all();
			$(this).attr("class", "menu_title2_select");
			var url = $(this).attr("ref");
			go_rightup(url);
		});

		$("[name='menu2']").hover(function() {
			if ($(this).attr("class") != 'menu_title2_select') {
				$(".menu_title2_hover").attr("class", "menu_title2");
				$(this).attr("class", "menu_title2_hover");
			}
		}, function() {
			$(".menu_title2_hover").attr("class", "menu_title2");
		});

		$(".menu_list1").hide();
		$("#list_0").show();
	});

	function restore_css_all() {
		$("[name='menu1']").attr("class", "menu_title1");
		$("[name='menu2']").attr("class", "menu_title2");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}

	String menu_code = HandleRequest.get_string("menu_code");
	if (menu_code.length() <= 0) {
		DefaultTableModel menuv = ProjectMenu.get_default();
		menu_code = HandleDatabase.get_string(menuv, 0, "menu_code");
	}

	DefaultTableModel dtm_01 = ProjectMenu.get_childs(menu_code);
%>
<body id="menu_bar4">
	<div style="float: left; width: 100%; height: 100%;">
		<p style="height: 5px;"></p>
		<div class="user_side clearfix">
			<img src="<%=HandleRequest.get_path()%><%=HandleSession.get_string("loginuser_logo")%>" />
			<h5><%=HandleSession.get_string("loginuser_name")%></h5>
			<a href="<%=HandleRequest.get_path()%>/jsp/user/setting/my_update.jsp" target="frame_rightup"><i class='glyphicon glyphicon-cog'></i> 账户设置</a>
		</div>
		<p style="height: 1px;"></p>
		<%
			int pos = 0;
			for (int i = 0; i < dtm_01.getRowCount(); i++) {
				String menu_codev = HandleDatabase.get_string(dtm_01, i, "menu_code");
				String menu_namev = HandleDatabase.get_string(dtm_01, i, "menu_name");
				if (!ProjectMenu.check_menu(menu_codev)) {
					continue;
				}
				out.println("<ul name='menu1' class='menu_title1'>" + menu_namev + "</ul>");
				out.println("<div id='list_" + pos + "' class='menu_list1'>");
				DefaultTableModel dtm_data_v = ProjectMenu.get_childs(menu_codev);
				for (int j = 0; j < dtm_data_v.getRowCount(); j++) {
					String menu_codev2 = HandleDatabase.get_string(dtm_data_v, j, "menu_code");
					String menu_typev2 = HandleDatabase.get_string(dtm_data_v, j, "menu_type");
					String menu_namev2 = HandleDatabase.get_string(dtm_data_v, j, "menu_name");
					String menu_valuev2 = HandleDatabase.get_string(dtm_data_v, j, "menu_value");
					if (!ProjectMenu.check_menu(menu_codev2)) {
						continue;
					}
					String urlv = HandleRequest.get_path() + menu_valuev2;
					if (menu_typev2.equals("link")) {
						urlv = menu_valuev2;
					}
					out.println("<ul name='menu2' class='menu_title2' ref='" + urlv + "'><i class='glyphicon glyphicon-star'></i>&nbsp;&nbsp;" + menu_namev2 + "</ul>");
				}
				out.println("</div>");
				out.println("<p style='height:1px;'></p>");
				pos++;
			}
			out.println("<p style='height:25px;'></p>");
		%>
	</div>
</body>
</html>
