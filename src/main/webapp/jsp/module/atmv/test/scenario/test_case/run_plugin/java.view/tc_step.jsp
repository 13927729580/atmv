<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<%
	DefaultTableModel base = ProjectCase.get_action("base");
	String[] base_keys = new String[base.getRowCount()];
	String[] base_values = new String[base.getRowCount()];
	for (int i = 0; i < base.getRowCount(); i++) {
		base_keys[i] = DealTable.getString(base, i, "action_code");
		base_values[i] = DealTable.getString(base, i, "action_name");
	}
	DefaultTableModel selenium = ProjectCase.get_action("selenium");
	String[] selenium_keys = new String[selenium.getRowCount()];
	String[] selenium_values = new String[selenium.getRowCount()];
	for (int i = 0; i < selenium.getRowCount(); i++) {
		selenium_keys[i] = DealTable.getString(selenium, i, "action_code");
		selenium_values[i] = DealTable.getString(selenium, i, "action_name");
	}
	DefaultTableModel http = ProjectCase.get_action("http");
	String[] http_keys = new String[http.getRowCount()];
	String[] http_values = new String[http.getRowCount()];
	for (int i = 0; i < http.getRowCount(); i++) {
		http_keys[i] = DealTable.getString(http, i, "action_code");
		http_values[i] = DealTable.getString(http, i, "action_name");
	}
%>
<script type="text/javascript">
$(document).ready(function(){
	$("[name='action_type']").change(function(){
		if($(this).val()==''){
			var id_action_code=$(this).attr("id").replace("action_type","action_code");
			$("#"+id_action_code).empty();
		}
		var id_action_code=$(this).attr("id").replace("action_type","action_code");
		$("#"+id_action_code).empty();
		var keys="<%=DealString.concat(base_keys, ",")%>".split(",");
		var values="<%=DealString.concat(base_values, ",")%>".split(",");
		if($(this).val()=='base'){
			keys="<%=DealString.concat(base_keys, ",")%>".split(",");
			values="<%=DealString.concat(base_values, ",")%>".split(",");
		}
		if($(this).val()=='selenium'){
			keys="<%=DealString.concat(selenium_keys, ",")%>".split(",");
			values="<%=DealString.concat(selenium_values, ",")%>".split(",");
		}
		if($(this).val()=='http'){
			keys="<%=DealString.concat(http_keys, ",")%>".split(",");
			values="<%=DealString.concat(http_values, ",")%>".split(",");
			}
			for (var i = 0; i < keys.length; i++) {
				$("#" + id_action_code).append("<option value='"+keys[i]+"'>" + values[i] + "</option>");
			}
			var id_action_type = $(this).attr("id");
			var id_step_key = id_action_type.replace("action_type", "step_key");
			var id_step_data = id_action_type.replace("action_type", "step_data");
			$("#" + id_step_key).val("");
			//$("#" + id_step_data).empty();
		});

		$("[name='step_data']").click(function() {
			var id_step_data = $(this).attr("id");
			var id_step_id = id_step_data.replace("step_data", "step_id");
			var id_action_type = id_step_data.replace("step_data", "action_type");
			var id_action_code = id_step_data.replace("step_data", "action_code");
			var id_last_status = id_step_data.replace("step_data", "last_status");
			var name_step_data = id_step_data.replace("step_data", "frame_data");
			var step_id = $("#" + id_step_id).val();
			var action_type = $("#" + id_action_type).val();
			var action_code = $("#" + id_action_code).val();
			var last_status = $("#" + id_last_status).val();
			$("#" + name_step_data).attr("src", "tc_step_data.jsp?step_id=" + step_id + "&action_type=" + action_type + "&action_code=" + action_code + "&last_status=" + last_status);
			return false;
		});

		$("[name='step_add']").click(function() {
			var tc_id = $("[name='tc_id']").val();
			var id_step_add = $(this).attr("id");
			var id_step_id = id_step_add.replace("step_add", "step_id");
			var id_seq = id_step_add.replace("step_add", "seq");
			var step_id = $("#" + id_step_id).val();
			var seq = $("#" + id_seq).val();
			post_submit("query_data", "tc_step_add.jsp?tc_id=" + tc_id + "&seq=" + seq, "_self");
			return false;
		});

		$("[name='step_delete']").click(function() {
			var tc_id = $("[name='tc_id']").val();
			var id_step_delete = $(this).attr("id");
			var id_seq = id_step_delete.replace("step_delete", "seq");
			var id_step_id = id_step_delete.replace("step_delete", "step_id");
			var seq = $("#" + id_seq).val();
			var step_id = $("#" + id_step_id).val();
			post_submit("query_data", "tc_step_delete.jsp?tc_id=" + tc_id + "&seq=" + seq + "&step_id=" + step_id, "_self");
			return false;
		});

		$("#script_data").click(function() {
			script_data();
			return false;
		});
	});
	function script_data() {
		post_submit("query_data", "tc_step_java.jsp", "_self");
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String tc_id = HandleRequest.get_string("tc_id");
	String req_sql = "select a.* from t_funtest_tc_step a where 1=1";
	if (tc_id.length() > 0) {
		req_sql = req_sql + " and a.tc_id='" + tc_id + "'";
	}
	req_sql = req_sql + " order by a.seq asc";
	String req_select = "step_id,row,action_code,step_data,action";
	String req_view = "步骤编号,序号,步骤动作,步骤数据,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);
	if (dtm_02.getRowCount() == 0) {
		HandleResponse.redirect(HandleRequest.get_path() + "/jsp/module/atmv/test/scenario/test_case/run_plugin/java.view/tc_step_add.jsp?tc_id=" + tc_id + "&seq=0");
	}

	String menu_name = "步骤信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="tc_id" value="<%=tc_id%>" />
		<textarea id='view_detail' name='view_detail' cols='80' rows='10' style='display: none; position: absolute; top: 300px; left: 300px; z-index: 999;'></textarea>
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 998;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
						<%
							String sql_tc = "select a.* from t_funtest_tc a where a.tc_id='" + tc_id + "'";
							DefaultTableModel dtm_tc = ProjectDatabase.query_data(sql_tc);
							if (dtm_tc.getRowCount() == 1) {
								String fun_codev = HandleDatabase.get_string(dtm_tc, 0, "fun_code");
								String tc_codev = HandleDatabase.get_string(dtm_tc, 0, "tc_code");
								String tc_summaryv = HandleDatabase.get_string(dtm_tc, 0, "tc_summary");
								out.println("测试用例：" + fun_codev + "." + tc_codev + " " + tc_summaryv);
							}
						%>
						<button class="btn btn-xs btn-default btn-me" disabled="disabled">视图模式</button>
						<button class="btn btn-xs btn-default btn-me" id="script_data">脚本模式</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<%
					out.println("<tr>");
					for (int j = 0; j < selects.length; j++) {
						if (selects[j].trim().equals("step_id")) {
							out.println("<td class='head'><input type='checkbox' id='check_all' onclick=\"select_all('check_all','" + selects[j].trim() + "')\"/></td>");
							continue;
						}
						if (selects[j].trim().equals("action_code")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("step_data")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						out.println("<td class='head'>" + views[j] + "</td>");
					}
					out.println("</tr>");
					int data_total = dtm_02.getRowCount();
					for (int i = 0; i < data_total; i++) {
						String step_idv = HandleDatabase.get_string(dtm_02, i, "tc_step_id");
						String action_typev = HandleDatabase.get_string(dtm_02, i, "action_type");
						String action_codev = HandleDatabase.get_string(dtm_02, i, "action_code");
						String last_statusv = HandleDatabase.get_string(dtm_02, i, "last_status");
						out.println("<input type='hidden' id='seq_" + i + "' name='seq' value='" + HandleDatabase.get_string(dtm_02, i, "seq") + "'/>");
						out.println("<tr>");
						for (int j = 0; j < selects.length; j++) {
							if (selects[j].trim().equals("step_id")) {
								out.println("<td><input type='checkbox' id='step_id_" + i + "' name='" + selects[j] + "' value='" + step_idv + "'/></td>");
								continue;
							}
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("action_code")) {
								out.println("<td align='left'>");
								out.println("<span>");
								out.println("<div style='height:25px;'><select id='action_type_" + i + "' name='action_type' style='width:120px;'>");
								out.println("<option value=''>--</option>");
								DefaultTableModel action_type = ProjectUdc.get_udc("action_type");
								for (int k = 0; k < action_type.getRowCount(); k++) {
									String key = HandleDatabase.get_string(action_type, k, "option_key");
									String value = HandleDatabase.get_string(action_type, k, "option_value");
									if (key.equals(action_typev)) {
										out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
									} else {
										out.println("<option value='" + key + "'>" + value + "</option>");
									}
								}
								out.println("</select></div>");
								out.println("<div style='height:25px;'><select id='action_code_" + i + "' name='action_code' style='width:120px;'>");
								out.println("<option value=''>--</option>");
								DefaultTableModel dtm_step = null;
								if (action_typev.equals("base")) {
									dtm_step = base;
								} else if (action_typev.equals("selenium")) {
									dtm_step = selenium;

								} else if (action_typev.equals("http")) {
									dtm_step = http;
								}
								if (dtm_step != null) {
									for (int k = 0; k < dtm_step.getRowCount(); k++) {
										String key = HandleDatabase.get_string(dtm_step, k, "action_code");
										String value = HandleDatabase.get_string(dtm_step, k, "action_name");
										if (key.equals(action_codev)) {
											out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
										} else {
											out.println("<option value='" + key + "'>" + value + "</option>");
										}
									}
								}
								out.println("</select></div>");
								out.println("<div style='height:25px;'><select id='last_status_" + i + "' name='last_status' style='width:120px;'>");
								DefaultTableModel udc = HandleUdc.get_udc("common_status");
								for (int k = 0; k < udc.getRowCount(); k++) {
									String key = HandleDatabase.get_string(udc, k, "option_key");
									String value = HandleDatabase.get_string(udc, k, "option_value");
									if (key.equals(last_statusv)) {
										out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
									} else {
										out.println("<option value='" + key + "'>" + value + "</option>");
									}
								}
								out.println("</select></div>");
								out.println("</span>");
								out.println("<span>");
								out.println("<button id='step_data_" + i + "' name='step_data' class='btn btn-xs btn-default btn-me' style='width:120px; height:20px;'>测试数据</button>");
								out.println("</span>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("step_data")) {
								out.println("<td align='left'>");
								out.println("<div><iframe id='frame_data_" + i + "' name='step_data_" + i + "' src='" + HandleRequest.get_path()
										+ "/jsp/module/atmv/test/scenario/test_case/run_plugin/java.view/tc_step_data.jsp?step_id=" + step_idv + "&action_type=" + action_typev + "&action_code=" + action_codev + "&last_status="
										+ last_statusv + "' frameborder='0' style='width:620px; height:102px;'></iframe></div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("action")) {
								out.println("<td>");
								out.println("<div><a id='step_add_" + i + "' name='step_add' href='#'>新增步骤</a></div>");
								out.println("<div><a id='step_delete_" + i + "' name='step_delete' href='#'>删除步骤</a></div>");
								out.println("</td>");
								continue;
							}
							out.println("<td>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</td>");
						}
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>
