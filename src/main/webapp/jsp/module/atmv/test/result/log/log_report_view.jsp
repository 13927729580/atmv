<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	KindEditor.ready(function(K) {
		var editor = K.create('#richtext1', {
			allowFileManager : true,
			cssPath : get_path() + '/plugin/kindeditor/plugins/code/prettify.css',
			uploadJson : get_path() + '/plugin/kindeditor/jsp/upload_json.jsp',
			fileManagerJson : get_path() + '/plugin/kindeditor/jsp/file_manager_json.jsp',
			resizeType : 1,
			allowPreviewEmoticons : false,
			allowImageUpload : true,
			afterUpload : function() {
				this.sync();
			},
			afterBlur : function() {
				this.sync();
			}
		});
	});

	$(document).ready(function() {
		$("#send_data").click(function() {
			send_data();
			return false;
		});
	});

	function send_data() {
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", "log_report_send.jsp", "_self");
		}
	}
</script>
</head>
<%
	String loginuser_id = HandleSession.get_string("loginuser_id");
	if (loginuser_id.length() <= 0) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String log_id = HandleRequest.get_string("log_id");
	String sql_01 = "SELECT a.* FROM t_funtest_log a WHERE 1=1 AND a.log_id='" + log_id + "'";
	DefaultTableModel dtm_01 = ProjectDatabase.query_data(sql_01);
	String version = HandleDatabase.get_string(dtm_01, 0, "version");
	String subject = version + "版本迭代上线回归自动化测试执行报告_" + DealDate.getNowTimeStr();
	String context = ProjectResult.gen_report(log_id);
	String req_select = "userto,usercc,subject,context,memo";
	String req_view = "发送列表,抄送列表,邮件主题,邮件内容,温馨提示";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "测试报告预览";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type="hidden" name="log_id" value="<%=log_id%>" />
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
						<button class="btn btn-xs btn-default btn-me" id="send_data">发送邮件</button>
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
						if (selects[j].trim().equals("userto")) {
							out.println("<td align='left'>");
							String userto = ProjectParam.get_param("reporter_userto");
							String loginuser_email = HandleSession.get_string("loginuser_email");
							if (!userto.contains(loginuser_email)) {
								userto = userto + loginuser_email + ";";
							}
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='180' rows='1'>" + userto + "</textarea></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("usercc")) {
							out.println("<td align='left'>");
							String usercc = ProjectParam.get_param("reporter_usercc");
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='180' rows='1'>" + usercc + "</textarea></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("subject")) {
							out.println("<td align='left'>");
							out.println("<div><textarea name='" + selects[j].trim() + "' cols='180' rows='1'>" + subject + "</textarea></div>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("context")) {
							out.println("<td align='left'>");
							out.println("<textarea id='richtext1' name='" + selects[j].trim() + "' cols='180' rows='22'>" + context + "</textarea>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("memo")) {
							out.println("<td align='left'>");
							out.println("<div style='color:#ff0000; font-weight:bold;'>");
							out.println("<p>当前版本自动化回归测试信息汇总，请测试人员查收。</p>");
							out.println("</div>");
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
