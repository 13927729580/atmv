<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#query_data").click(function() {
			query_data();
			return false;
		});
		$("#add_data").click(function() {
			add_data();
			return false;
		});
		$("#modify_data").click(function() {
			modify_data();
			return false;
		});
		$("#delete_data").click(function() {
			delete_data();
			return false;
		});
		$("#set_data").click(function() {
			set_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "object_list.jsp", "_self");
	}
	function add_data() {
		post_submit("query_data", "object_add.jsp", "_self");
	}
	function modify_data() {
		var selvs = document.getElementsByName("object_id");
		var n = 0;
		for (var i = 0; i < selvs.length; i++) {
			if (selvs[i].checked) {
				n++;
			}
		}
		if (n == 0) {
			alert("请选择要提交的内容！");
			return;
		}
		if (n > 1) {
			alert("不能选择多条内容！");
			return;
		}
		post_submit("query_data", "object_update.jsp", "_self");
	}
	function delete_data() {
		var selvs = document.getElementsByName("object_id");
		var n = 0;
		for (var i = 0; i < selvs.length; i++) {
			if (selvs[i].checked) {
				n++;
			}
		}
		if (n == 0) {
			alert("请选择要提交的内容！");
			return;
		}
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", "object_delete.jsp", "_self");
		}
	}
	function set_data() {
		var selvs = document.getElementsByName("object_id");
		var n = 0;
		for (var i = 0; i < selvs.length; i++) {
			if (selvs[i].checked) {
				n++;
			}
		}
		if (n == 0) {
			alert("请选择要提交的内容！");
			return;
		}
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", "object_set.jsp", "_self");
		}
	}
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String fun_code = HandleRequest.get_string("fun_code");
	String object_path = HandleRequest.get_string("object_path");
	String object_type = HandleRequest.get_string("object_type");
	String last_status = HandleRequest.get_string("last_status");
	String req_sql = "select a.* from t_funtest_object a where 1=1";
	if (fun_code.length() > 0) {
		req_sql = req_sql + " and a.fun_code='" + fun_code + "'";
	}
	if (object_path.length() > 0) {
		req_sql = req_sql + " and a.object_path like '%" + object_path + "%'";
	}
	if (object_type.length() > 0) {
		req_sql = req_sql + " and a.object_type='" + object_type + "'";
	}
	if (last_status.length() > 0) {
		req_sql = req_sql + " and a.last_status='" + last_status + "'";
	}
	req_sql = req_sql + " order by a.object_path asc";
	DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);

	String req_select = "object_id,row,object_path,object_name,object_type,object_value,last_status,memo,action";
	String req_view = "序号,编号,页面路径,对象名称,对象类型,对象内容,状态,备注,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "测试对象信息";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="fun_code" value="<%=fun_code%>" />
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">对象地址&nbsp;<input type='text' name="object_path" value="<%=object_path%>" size="15" /> 对象类型： <%
						DefaultTableModel object_types = ProjectUdc.get_udc("object_type");
						out.println("<select name='object_type'>");
						out.println("<option value=''>--</option>");
						for (int k = 0; k < object_types.getRowCount(); k++) {
							String key = HandleDatabase.get_string(object_types, k, "option_key");
							String value = HandleDatabase.get_string(object_types, k, "option_value");
							if (key.equals(object_type)) {
								out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
							} else {
								out.println("<option value='" + key + "'>" + value + "</option>");
							}
						}
						out.println("</select>");
					%> 状态： <%
						DefaultTableModel last_statuss = HandleUdc.get_udc("common_status");
						out.println("<select name='last_status'>");
						out.println("<option value=''>--</option>");
						for (int k = 0; k < last_statuss.getRowCount(); k++) {
							String key = HandleDatabase.get_string(last_statuss, k, "option_key");
							String value = HandleDatabase.get_string(last_statuss, k, "option_value");
							if (key.equals(last_status)) {
								out.println("<option value='" + key + "' selected='selected'>" + value + "</option>");
							} else {
								out.println("<option value='" + key + "'>" + value + "</option>");
							}
						}
						out.println("</select>");
					%>
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
						<button class="btn btn-xs btn-default btn-me" id="add_data">新增</button>
						<button class="btn btn-xs btn-default btn-me" id="modify_data">修改</button>
						<button class="btn btn-xs btn-default btn-me" id="delete_data">删除</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<%
					out.println("<tr>");
					for (int j = 0; j < selects.length; j++) {
						if (selects[j].trim().equals("object_id")) {
							out.println("<td class='head'><input type='checkbox' id='check_all' onclick=\"select_all('check_all','" + selects[j].trim() + "')\"/></td>");
							continue;
						}
						if (selects[j].trim().equals("object_path")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("object_name")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						if (selects[j].trim().equals("memo")) {
							out.println("<td class='head' align='left'>" + views[j] + "</td>");
							continue;
						}
						out.println("<td class='head'>" + views[j] + "</td>");
					}
					out.println("</tr>");
					int data_total = dtm_02.getRowCount();
					for (int i = 0; i < data_total; i++) {
						out.println("<tr>");
						for (int j = 0; j < selects.length; j++) {
							if (selects[j].trim().equals("object_id")) {
								out.println("<td><input type='checkbox' name='" + selects[j] + "' value='" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "'/></td>");
								continue;
							}
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("object_path")) {
								out.println("<td align='left'>");
								out.println("<div>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("object_type")) {
								out.println("<td>");
								out.println("<div>" + ProjectUdc.get_udc_value("object_type", HandleDatabase.get_string(dtm_02, i, selects[j].trim())) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("object_value")) {
								out.println("<td align='left'>");
								out.println("<div>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("last_status")) {
								out.println("<td>");
								out.println("<div>" + HandleUdc.get_udc_value("common_status", HandleDatabase.get_string(dtm_02, i, selects[j].trim())) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("memo")) {
								out.println("<td align='left'>");
								out.println("<div>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</div>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("action")) {
								out.println("<td>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/package/object/object_update.jsp?object_id="
										+ HandleDatabase.get_string(dtm_02, i, "object_id") + "'>修改数据</a></div>");
								out.println("</td>");
								continue;
							}
							out.println("<td>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</td>");
						}
						out.println("</tr>");
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>
