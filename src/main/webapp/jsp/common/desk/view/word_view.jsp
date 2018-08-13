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
	<div style="padding: 5px 1px 1px 5px;">
		<b>测试名言</b>
	</div>
	<div style="padding: 5px 1px 1px 5px;">Bill Liu: 做敏捷测试的第一步就是不要敏捷，先一步步把自动化做好，把持续集成做起来，创建更多的测试工具来提高测试效率，同时也要把质量反馈系统做起来，把dev提交代码前的质量检查做起来，把在产品中测试做起来，把测试工程师的素质提高上去……，等到这些都建立起来后，你会发现自己已经很敏捷。</div>
</body>
</html>
