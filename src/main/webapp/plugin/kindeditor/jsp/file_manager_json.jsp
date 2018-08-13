<%@include file="/jspf/header.jspf"%>
<%
	String attach_path = ProjectParam.get_param("attach_path") + DealFile.getSplit() + "upload";
	String attach_url = ProjectParam.get_param("attach_url") + "/upload/";
	JSONObject result = HandleFile.manage_file(attach_path, attach_url);
	response.setContentType("application/json; charset=UTF-8");
	out.println(result.toString());
%>