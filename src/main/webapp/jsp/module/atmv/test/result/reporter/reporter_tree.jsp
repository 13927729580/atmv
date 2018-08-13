<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#divlist").jstree().bind("activate_node.jstree", function(e, data) {
			var v = $('#' + data.node.id);
			if (v.attr('type') == 'menu') {
				data.instance.toggle_node(data.node);
			} else if (v.attr('type') == 'node') {
				var url = v.attr('ref');
				$("#data_view").attr("src", url);
			}
		});
	});
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();
%>
<body>
	<div id="divlist" class="jstree" style="position: absolute; left; top: 1px; left: 0.1%; width: 15%; height: 99%; overflow: hidden; border: 1px solid #999999;">
		<ul>
			<%
				out.println("<li type='menu' data-jstree='{\"opened\":true}'>报表信息<ul>");
				String sql_01 = "select a.* from t_funtest_reporter a inner join t_funtest_reporter b on b.reporter_id=a.parent_id where 1=1 and b.parent_id is null order by a.seq";
				DefaultTableModel dtm_01 = ProjectDatabase.query_data(sql_01);
				for (int i = 0; i < dtm_01.getRowCount(); i++) {
					String reporter_idv = HandleDatabase.get_string(dtm_01, i, "reporter_id");
					String reporter_namev = HandleDatabase.get_string(dtm_01, i, "reporter_name");
					out.println("<li type='menu' data-jstree='{\"opened\":" + (i == 0) + "}'>" + reporter_namev + "<ul>");
					String sql_02 = "select a.* from t_funtest_reporter a where 1=1 and a.parent_id='" + reporter_idv + "' order by a.reporter_code";
					DefaultTableModel dtm_02 = ProjectDatabase.query_data(sql_02);
					for (int j = 0; j < dtm_02.getRowCount(); j++) {
						String reporter_idvv = HandleDatabase.get_string(dtm_02, j, "reporter_id");
						String reporter_namevv = HandleDatabase.get_string(dtm_02, j, "reporter_name");
						String reporter_valuevv = HandleDatabase.get_string(dtm_02, j, "reporter_value");
						out.println("<li type='node' data-jstree='{\"icon\":\"jstree-file\"}' ref='" + HandleRequest.get_path() + reporter_valuevv + "'>" + reporter_namevv + "</li>");
					}
					out.println("</ul></li>");
				}
				out.println("</ul></li>");
			%>
		</ul>
	</div>
	<iframe id="data_view" frameborder="0" style="position: absolute; float: right; top: 0%; left: 15.4%; width: 84%; height: 100%; overflow: auto; overflow-y: hidden;" />
</body>
</html>
