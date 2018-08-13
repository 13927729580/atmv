<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#reload_data").click(function() {
			reload_data();
			return false;
		});
		$("#submit_data").click(function() {
			submit_data();
			return false;
		});
	});
	function reload_data() {
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", get_path() + "/edi/generate_client", "_self");
		}
	}
	function submit_data() {
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", "client_config.jsp", "_self");
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

	String client_http = HandleRequest.get_string("client_http");
	String client_selenium = HandleRequest.get_string("client_selenium");
	String client_appium = HandleRequest.get_string("client_appium");

	String req_select = "client_http,client_selenium,client_appium";
	String req_view = "Http,Selenium,Appium";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "测试客户端信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
						<%
							out.println("Http <select name='client_http' style='width:128px; height:20px;'>");
							DefaultTableModel client_https = ProjectUdc.get_udc("client_http");
							for (int k = 0; k < client_https.getRowCount(); k++) {
								String key = HandleDatabase.get_string(client_https, k, "option_key");
								String value = HandleDatabase.get_string(client_https, k, "option_value");
								if (key.equals(client_selenium)) {
									out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
								} else {
									out.println("<option value='" + key + "'>" + value + "</option>");
								}
							}
							out.println("</select>");
							out.println("Selenium <select name='client_selenium' style='width:128px; height:20px;'>");
							DefaultTableModel client_seleniums = ProjectUdc.get_udc("client_selenium");
							for (int k = 0; k < client_seleniums.getRowCount(); k++) {
								String key = HandleDatabase.get_string(client_seleniums, k, "option_key");
								String value = HandleDatabase.get_string(client_seleniums, k, "option_value");
								if (key.equals(client_selenium)) {
									out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
								} else {
									out.println("<option value='" + key + "'>" + value + "</option>");
								}
							}
							out.println("</select>");
							out.println("Appium <select name='client_appium' style='width:128px; height:20px;'>");
							DefaultTableModel client_appiums = ProjectUdc.get_udc("client_appium");
							for (int k = 0; k < client_appiums.getRowCount(); k++) {
								String key = HandleDatabase.get_string(client_appiums, k, "option_key");
								String value = HandleDatabase.get_string(client_appiums, k, "option_value");
								if (key.equals(client_appium)) {
									out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
								} else {
									out.println("<option value='" + key + "'>" + value + "</option>");
								}
							}
							out.println("</select>");
						%>
						<button class="btn btn-xs btn-default btn-me" id="reload_data">更新客户端</button>
						<button class="btn btn-xs btn-default btn-me" id="submit_data">提交配置</button>
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
						if (selects[j].trim().equals("client_http")) {
							out.println("<td align='left'>");
							String client = ProjectParamDetail.get_param("localconfig_client.http");
							String client_config = ProjectParamDetail.get_param("localconfig_client.http." + client);
							out.println("<div>" + client + "</div>");
							out.println("<div style='padding:5px 0px 10px 0px;'><textarea name='localconfig_client.http." + client + "' cols='150' rows='4'>" + client_config + "</textarea></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("client_selenium")) {
							out.println("<td align='left'>");
							String client = ProjectParamDetail.get_param("localconfig_client.selenium");
							String client_config = ProjectParamDetail.get_param("localconfig_client.selenium." + client);
							out.println("<div>" + client + "</div>");
							out.println("<div style='padding:5px 0px 10px 0px;'><textarea name='localconfig_client.selenium." + client + "' cols='150' rows='4'>" + client_config + "</textarea></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("client_appium")) {
							out.println("<td align='left'>");
							String client = ProjectParamDetail.get_param("localconfig_client.appium");
							String client_config = ProjectParamDetail.get_param("localconfig_client.appium." + client);
							out.println("<div>" + client + "</div>");
							out.println("<div style='padding:5px 0px 10px 0px;'><textarea name='localconfig_client.selenium." + client + "' cols='150' rows='4'>" + client_config + "</textarea></div>");
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
