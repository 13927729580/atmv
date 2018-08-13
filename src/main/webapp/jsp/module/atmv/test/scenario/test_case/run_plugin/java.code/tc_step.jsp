<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript" src="<%=HandleRequest.get_path()%>/plugin/codemirror/mode/clike/clike.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#view_data").click(function() {
			view_data();
			return false;
		});
		var editor = CodeMirror.fromTextArea(document.getElementById("code"), {
			mode : "text/x-java",
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
	function view_data() {
		post_submit("query_data", "tc_step_list.jsp", "_self");
	}
</script>
</head>
<%
	String loginuser_id = HandleSession.get_string("loginuser_id");
	if (loginuser_id.length() <= 0) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String tc_id = HandleRequest.get_string("tc_id");
	String req_sql = "select a.* from t_funtest_tc a where 1=1 and a.tc_id='" + tc_id + "'";
	DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);
	String fun_codev = HandleDatabase.get_string(dtm_02, 0, "fun_code");
	String tc_codev = HandleDatabase.get_string(dtm_02, 0, "tc_code");
	String tc_pathv = HandleDatabase.get_string(dtm_02, 0, "tc_path");
	String tc_summaryv = HandleDatabase.get_string(dtm_02, 0, "tc_summary");
	String run_pluginv = HandleDatabase.get_string(dtm_02, 0, "run_plugin");
	String expect_resultv = HandleDatabase.get_string(dtm_02, 0, "expect_result");
	String path = ProjectUdc.get_udc_field("tc_plugin", run_pluginv, "memo") + "\\fun_" + fun_codev + "\\TestCase_" + tc_codev + ".java";
	File tc = DealFile.getFileByPath(path);
	String script = DealFile.readln(tc);

	String req_select = "testcase,script";
	String req_view = "测试用例,测试脚本";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "测试用例脚本";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type="hidden" name="tc_id" value="<%=tc_id%>" />
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #cccccc; border-right: solid 1px #cccccc; border-top: solid 1px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 1px #cccccc;">
						<button class="btn btn-xs btn-default btn-me" disabled="disabled">脚本模式</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; width: 100%; top: 35px; z-index: 1;">
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
						if (selects[j].trim().equals("testcase")) {
							out.println("<td align='left'>");
							String tc_detailv = "(" + fun_codev + "." + tc_codev + ")";
							tc_detailv = tc_detailv + " " + tc_pathv + ": " + tc_summaryv + ". ";
							String tc_expectv = "预期结果：" + expect_resultv;
							out.println("<div name='" + selects[j].trim() + "'>" + tc_detailv + "\n" + tc_expectv + "</div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("script")) {
							out.println("<td align='left'>");
							out.println("<div><textarea id='code' name='" + selects[j].trim() + "' cols='250' rows='35'>" + script + "</textarea></div>");
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
