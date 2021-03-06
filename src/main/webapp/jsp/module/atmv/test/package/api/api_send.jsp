<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#send_data").click(function() {
			send_data();
			return false;
		});
	});
	function send_data() {
		post_submit("query_data", "api_send_do.jsp", "_self");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String api_id = HandleRequest.get_string("api_id");
	String req_sql = "select a.* from t_funtest_api a where 1=1 and a.api_id='" + api_id + "'";
	DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);

	String req_select = "api_name,api_type,api_url,api_param";
	String req_view = "接口摘要,接口类型,接口地址,接口参数";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "接口参数信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="api_id" value="<%=api_id%>" />
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
						<button class="btn btn-xs btn-default btn-me" id="send_data">发送请求</button>
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
						if (selects[j].trim().equals("api_type")) {
							out.println("<td>");
							out.println("<select name='" + selects[j].trim() + "'>");
							DefaultTableModel udc = ProjectUdc.get_udc("api_type");
							for (int k = 0; k < udc.getRowCount(); k++) {
								String key = HandleDatabase.get_string(udc, k, "option_key");
								String value = HandleDatabase.get_string(udc, k, "option_value");
								if (key.equals(HandleDatabase.get_string(dtm_02, 0, selects[j].trim()))) {
									out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
								} else {
									out.println("<option value='" + key + "'>" + value + "</option>");
								}
							}
							out.println("</select>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("api_url")) {
							out.println("<td align='left'>");
							out.println("<textarea name='" + selects[j].trim() + "' cols='80' rows='2'>" + HandleDatabase.get_string(dtm_02, 0, selects[j].trim()) + "</textarea>");
							out.println("</td>");
							continue;
						}
						if (selects[j].trim().equals("api_param")) {
							String api_param = HandleDatabase.get_string(dtm_02, 0, "api_param");
							JSONArray params = new JSONArray(api_param);
							out.println("<td>");
							out.println("<table>");
							for (int i = 0; i < params.length(); i++) {
								JSONObject paramv = params.getJSONObject(i);
								String param_keyv = paramv.getString("key");
								String param_typev = paramv.getString("type");
								Object param_valuev = paramv.get("value");
								out.println("<tr style='height:25px;'>");
								if (param_typev.equals("json")) {
									out.println("<td>");
									out.println("<div style='height:25px;'><input type='text' name='param_key' value='" + param_keyv + "' size='15' /></div>");
									out.println("<div style='height:25px;'>" + ProjectUdc.get_udc_value("api_param", param_typev) + "</div>");
									out.println("<div style='height:200px;'><textarea name='param_value' cols='80' rows='10'>" + param_valuev + "</textarea></div>");
									out.println("</td>");
								} else {
									out.println("<td><input type='text' name='param_key' value='" + param_keyv + "' size='15' /></td>");
									out.println("<td style='padding:0px 10px 0px 10px;'>" + ProjectUdc.get_udc_value("api_param", param_typev) + "</td>");
									out.println("<td><input type='text' name='param_value' value='" + param_valuev + "' size='50' /></td>");
								}
								out.println("</tr>");

							}
							out.println("</table>");
							out.println("</td>");
							continue;
						}
						out.println("<td><input type='text' name='" + selects[j].trim() + "' value='" + HandleDatabase.get_string(dtm_02, 0, selects[j].trim()) + "' size='80' /></td>");
						out.println("</tr>");
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>
