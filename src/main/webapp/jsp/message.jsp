<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page isErrorPage="true"%>
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
	String message_code = HandleRequest.get_string("message_code");
	String summary = HandleRequest.get_string("summary");
	if (message_code.length() == 0) {
		message_code = "9999";
	}
	summary = HandleMessage.get_message(message_code);
	String memo = "";
	if (message_code.equals("9999")) {
		String status_code = String.valueOf(HandleRequest.get_attri("javax.servlet.error.status_code"));
		String message = String.valueOf(HandleRequest.get_attri("javax.servlet.error.message"));
		Exception e = (Exception) HandleRequest.get_attri("javax.servlet.error.exception");
		memo = DealString.addline(memo, "错误码：" + status_code);
		if (message.length() > 0) {
			memo = DealString.addline(memo, "错误消息：" + message);
		}
		if (e != null) {
			memo = DealString.addline(memo, "错误异常：" + DealException.getDetail(e));
		}
	}

	String menu_name = "信息提示";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
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
				out.println("<td class='detail_1' width='100%' align='left'>");
				out.println("<div style='padding: 5px 20px 5px 20px;'><b>[ " + message_code + " ]</b> " + summary + "</div>");
				if (memo.length() != 0) {
					out.println("<div style='padding: 5px 20px 5px 20px;'><textarea cols='150' rows='25'>" + memo + "</textarea></div>");
				}
				out.println("</td>");
				out.println("</tr>");
			%>
		</table>
	</div>
</body>
</html>
