<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String menu_name = "我的工作台";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
		<table width="100%" align="left">
			<tr valign="middle">
				<td width="2" height="22"></td>
				<td width="<%=width%>" align="center" style="border-left: solid 1px #cccccc; border-right: solid 1px #cccccc; border-top: solid 1px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
				<td align="right" style="border-bottom: solid 2px #cccccc;">&nbsp;</td>
			</tr>
		</table>
	</div>
	<iframe name="report_view" src="<%=HandleRequest.get_path()%>/jsp/module/atmv/test/result/reporter/reporter_logdetail-sum.jsp"
		style="position: absolute; left: 1%; top: 6%; width: 60%; height: 93%; border: #bbbbbb solid 1px;"></iframe>
	<iframe name="word_view" src="<%=HandleRequest.get_path()%>/jsp/common/desk/view/word_view.jsp" style="position: absolute; left: 62%; top: 6%; width: 37%; height: 93%; border: #bbbbbb solid 1px;"></iframe>
</body>
</html>
