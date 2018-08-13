<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript" src="<%=HandleRequest.get_path()%>/plugin/codemirror/mode/javascript/javascript.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#view_data").click(function() {
			view_data();
			return false;
		});
		var editor = CodeMirror.fromTextArea(document.getElementById("code"), {
			mode : "text/javascript",
			lineNumbers : true,
			theme : "eclipse",
			lineWrapping : true,
			foldGutter : true,
			gutters : [ "CodeMirror-linenumbers", "CodeMirror-foldgutter" ],
			matchBrackets : true,
		});
		editor.setSize('100%', '100%');
		editor.setOption("readOnly", true);
	});
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String api_url = HandleRequest.get_string("api_url");
	String api_type = HandleRequest.get_string("api_type");
	String[] param_keys = HandleRequest.get_strings("param_key");
	String[] param_values = HandleRequest.get_strings("param_value");
	IntString result = null;
	if (api_type.equals("http.get")) {
		result = ProjectHttp.send_get(api_url, param_keys, param_values);
	} else if (api_type.equals("http.post")) {
		result = ProjectHttp.send_post(api_url, param_keys, param_values);
	} else if (api_type.equals("http.json")) {
		result = ProjectHttp.send_json(api_url, param_keys, param_values);
	}

	String req_select = "code,result";
	String req_view = "返回码,响应内容";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "接口参数信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;"></td>
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
						if (selects[j].trim().equals("code")) {
							out.println("<td align='left'>");
							out.println("<div><input type='text' name='" + selects[j].trim() + "' value='" + result.key + "' size='50'/></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("result")) {
							out.println("<td align='left'>");
							out.println("<div><textarea id='code' name='" + selects[j].trim() + "' cols='135' rows='23'>" + result.value + "</textarea></div>");
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
