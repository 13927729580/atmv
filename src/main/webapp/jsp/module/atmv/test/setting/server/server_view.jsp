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
	});
	function reload_data() {
		post_submit("query_data", "server_list.jsp", "_self");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String req_select = "memo,param_value";
	String req_view = "测试服务器,配置详情";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String server_id = ProjectServer.get_server_setting("server_id");
	String sql = "select a.* from t_env_server a where 1=1 and a.server_id='" + server_id + "'";
	DefaultTableModel dtm = HandleDatabase.query_data(sql);
	String server_name = "";
	if (dtm.getRowCount() == 1) {
		server_name = HandleDatabase.get_string(dtm, 0, "server_name");
	}

	String menu_name = "测试服务器信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
						<button class="btn btn-xs btn-default btn-me" id="reload_data">重新选择</button>
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
						if (selects[j].trim().equals("memo")) {
							out.println("<td align='left'>");
							out.println("<div>" + server_name + "</div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("param_value")) {
							out.println("<td align='left'>");
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='100' rows='20'>" + ProjectParamDetail.get_param("localconfig_server") + "</textarea></div>");
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
