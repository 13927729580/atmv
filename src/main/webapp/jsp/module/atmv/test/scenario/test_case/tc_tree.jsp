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

	String sql_01 = "select a.* from t_funtest_fun a inner join t_funtest_fun b on b.fun_id=a.parent_id where 1=1 and b.parent_id is null order by a.seq";
	DefaultTableModel dtm_01 = ProjectDatabase.query_data(sql_01);
%>
<body>
	<div id="divlist" class="jstree" style="position: absolute; left; top: 1px; left: 0.1%; width: 15%; height: 99%; overflow: hidden; border: 1px solid #999999;">
		<ul>
			<%
				out.println("<li type='menu' data-jstree='{\"opened\":true}'>测试用例<ul>");
				for (int i = 0; i < dtm_01.getRowCount(); i++) {
					String fun_id = HandleDatabase.get_string(dtm_01, i, "fun_id");
					String fun_code = HandleDatabase.get_string(dtm_01, i, "fun_code");
					String fun_name = HandleDatabase.get_string(dtm_01, i, "fun_name");
					out.println("<li type='menu' data-jstree='{\"opened\":" + (i == 0) + "}'>" + fun_name + "<ul>");
					String sql_02 = "select a.* from t_funtest_fun a where 1=1 and a.parent_id='" + fun_id + "' order by a.seq";
					DefaultTableModel dtm_02 = ProjectDatabase.query_data(sql_02);
					for (int j = 0; j < dtm_02.getRowCount(); j++) {
						String fun_idv = HandleDatabase.get_string(dtm_02, j, "fun_id");
						String fun_codev = HandleDatabase.get_string(dtm_02, j, "fun_code");
						String fun_namev = HandleDatabase.get_string(dtm_02, j, "fun_name");
						out.println("<li type='node' data-jstree='{\"icon\":\"jstree-file\"}' ref='" + HandleRequest.get_path() + "/jsp/module/atmv/test/scenario/test_case/tc_list.jsp?fun_code=" + fun_codev
								+ "'>" + fun_namev + "</li>");
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
