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
	ProjectLog.add_log();

	HandleSession.remove_all();
	String loginuser_code = HandleCookie.get_string("loginuser_code");
	String loginuser_pwd = HandleCookie.get_string("loginuser_pwd");
	int pos = DealNumber.getRnd(1, 5);
	String file_name = "login_" + DealString.intFormat(pos, 3) + ".png";
%>
<body>
	<div id="menu_bar2" style="position: absolute; top: 0px; left: 0px; width: 100%; height: 50px; text-align: center; line-height: 50px; font-family: Elephant; font-size: 28px; font-weight: bold;">
		<%=ProjectParam.get_title()%>
	</div>
	<div id="login_bar" style="position: absolute; top: 25%; left: 1%; width: 98%; height: 360px; border: 1px solid #cccccc; padding: 30px 0px 20px 0px;">
		<form name="login" method="post" action="login_do.jsp">
			<table width="100%">
				<tr>
					<td width="50%" height="300" align="right"><img src="<%=HandleRequest.get_path()%>/attachfile/image/login/<%=file_name%>" style="width: 400px; height: 300px; vertical-align: middle;" /></td>
					<td width="1%"></td>
					<td width="20%" align="left" style="border: 5px solid #cccccc; padding: 10px 50px 10px 50px;">
						<div style='height: 20px; font-weight: bold;'>
							<i class="glyphicon glyphicon-user"></i>&nbsp;&nbsp;用户账号
						</div>
						<div>
							<input type="text" name="loginuser_code" placeholder="用户账号/真实姓名/手机号/邮箱地址" value="<%=loginuser_code%>" style="width: 210px; height: 28px;" />
						</div>
						<div>&nbsp;</div>
						<div style='height: 20px; font-weight: bold;'>
							<i class="glyphicon glyphicon-lock"></i>&nbsp;&nbsp;登录密码
						</div>
						<div>
							<input type="password" name="loginuser_pwd" placeholder="请输入密码" value="<%=loginuser_pwd%>" style="width: 210px; height: 24px;" />
						</div>
						<div>&nbsp;</div>
						<div style='line-height: 20px;'>1.默认初始密码为：test1234</div>
						<div style='line-height: 20px;'>2.推荐使用Firefox及Chome核心的浏览器</div>
						<div style='line-height: 20px;'>
							&nbsp;>>&nbsp; <a href="<%=HandleRequest.get_path()%>/jsp/user/register/register.jsp">立即注册</a> &nbsp;>>&nbsp; <a
								href="<%=HandleRequest.get_path()%>/jsp/user/login/login_do.jsp?loginuser_code=guest&loginuser_pwd=test1234">游客进入</a>
						</div>
						<div>&nbsp;</div>
						<div>
							<input type="submit" value="登录系统" style="width: 220px; height: 30px;" />
						</div>
					</td>
					<td width="29%"></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="menu_bar2" style="position: absolute; top: 97%; left: 0px; width: 100%; height: 3%;"></div>
</body>
</html>
