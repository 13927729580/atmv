<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jspf/header.jspf"%>
<%
	String attach_path = ProjectParam.get_param("attach_path") + DealFile.getSplit() + "upload";
	String attach_url = ProjectParam.get_param("attach_url") + "/upload";
	HandleFile.upload_file(attach_path, attach_url, request);
	response.setContentType("text/html; charset=UTF-8");
	out.println("操作成功！");
%>
