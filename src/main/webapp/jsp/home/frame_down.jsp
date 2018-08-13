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
%>
<body>
	<div id="menu_bar5" style="position: absolute; top: 0px; left: 0px; width: 100%; height: 20px;">
		<table align="left">
			<tr>
				<td width="10" height="20"></td>
				<td valign="middle"><span style="font-size: 12px; cursor: pointer;">欢迎您回来！</span></td>
			</tr>
		</table>
		<table align="right">
			<tr>
				<td width="10" height="20"></td>
				<td valign="middle"><span style="font-size: 12px; cursor: pointer;" onclick="go_rightup('<%=HandleRequest.get_path()%>/jsp/common/navigate/site_list.jsp')"><i
						class="glyphicon glyphicon-screenshot"></i>&nbsp;&nbsp;网站导航</span></td>
				<td width="5"></td>
				<td valign="middle"><span style="font-size: 12px; cursor: pointer;" onclick="go_main('<%=HandleRequest.get_path()%>/jsp/user/login/login.jsp')"><i class="glyphicon glyphicon-off"></i>&nbsp;&nbsp;退出</span></td>
				<td width="10"></td>
				<td valign="middle"><span style="font-size: 12px; cursor: pointer;"><i class="glyphicon glyphicon-exclamation-sign"></i>&nbsp;&nbsp;<%=ProjectParam.get_param("copy_right")%></span></td>
				<td width="10"></td>
			</tr>
		</table>
	</div>
</body>
</html>
