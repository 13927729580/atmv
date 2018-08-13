<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();
%>
<frameset rows="76,*,20" frameborder="0" border="0" framespacing="1">
	<frame name="frame_up" src="<%=HandleRequest.get_path()%>/jsp/home/frame_up.jsp" scrolling="no" />
	<frameset cols="210,*" frameborder="0" border="0" framespacing="1">
		<frame name="frame_left" src="<%=HandleRequest.get_path()%>/jsp/home/frame_left.jsp" scrolling="no" />
		<frameset id="content" rows="100%,0%" frameborder="0" border="0" framespacing="1">
			<frame name="frame_rightup" src="<%=HandleRequest.get_path()%>/jsp/home/frame_rightup.jsp" />
			<frame name="frame_rightdown" src="<%=HandleRequest.get_path()%>/jsp/home/frame_rightdown.jsp" />
		</frameset>
	</frameset>
	<frame name="frame_down" src="<%=HandleRequest.get_path()%>/jsp/home/frame_down.jsp" />
	<noframes />
</frameset>
</html>