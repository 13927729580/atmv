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
		$("#modify_data").click(function() {
			modify_data();
			return false;
		});
		$("#restore_data").click(function() {
			restore_data();
			return false;
		});
		$("#reload_data").click(function() {
			reload_data();
			return false;
		});
	});
	function query_data() {
		post_submit("query_data", "param_detail_list.jsp", "_self");
	}
	function modify_data() {
		var checked = false;
		var selvs = document.getElementsByName("param_detail_id");
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
		post_submit("query_data", "param_detail_update.jsp", "_self");
	}
	function restore_data() {
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", "param_detail_restore.jsp", "_self");
		}
	}
	function reload_data() {
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("query_data", "param_detail_reload.jsp", "_self");
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

	String operate_ip = HandleRequest.get_server_ip();
	String param_key = HandleRequest.get_string("param_key");
	String param_value = HandleRequest.get_string("param_value");
	String req_sql = "select a.* from t_sys_param_detail a where 1=1 and project_code='" + ProjectParam.PROJECT_CODE + "' and a.operate_ip='" + operate_ip + "'";
	if (param_key.length() > 0) {
		req_sql = req_sql + " and a.param_key like '%" + param_key + "%'";
	}
	if (param_value.length() > 0) {
		req_sql = req_sql + " and a.param_value like '%" + param_value + "%'";
	}
	req_sql = req_sql + " order by a.seq asc";
	DefaultTableModel dtm_02 = HandleDatabase.query_data(req_sql);

	String req_select = "param_detail_id,row,operate_ip,param_key,param_value,last_status,seq,memo,action";
	String req_view = "参数编号,序号,操作IP,参数键,参数值,状态,顺序号,备注,操作";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	String menu_name = "参数列表";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">参数key&nbsp;<input type='text' name="param_key" value="<%=param_key%>" size="20" /> 参数value&nbsp;<input type='text'
						name="param_value" value="<%=param_value%>" size="20" />
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
						<button class="btn btn-xs btn-default btn-me" id="modify_data">修改</button>
						<button class="btn btn-xs btn-default btn-me" id="restore_data">恢复</button>
						<button class="btn btn-xs btn-default btn-me" id="reload_data">重载</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<%
					out.println("<tr>");
					for (int j = 0; j < selects.length; j++) {
						if (selects[j].trim().equals("param_detail_id")) {
							out.println("<td class='head'><input type='checkbox' id='check_all' onclick=\"select_all('check_all','" + selects[j].trim() + "')\"/></td>");
							continue;
						}
						if (selects[j].trim().equals("param_value")) {
							out.println("<td class='head' align='left'>" + views[j].trim() + "</td>");
							continue;
						}
						if (selects[j].trim().equals("memo")) {
							out.println("<td class='head' align='left'>" + views[j].trim() + "</td>");
							continue;
						}
						out.println("<td class='head'>" + views[j] + "</td>");
					}
					out.println("</tr>");
					int data_total = dtm_02.getRowCount();
					for (int i = 0; i < data_total; i++) {
						out.println("<tr>");
						for (int j = 0; j < selects.length; j++) {
							if (selects[j].trim().equals("param_detail_id")) {
								out.println("<td><input type='checkbox' name='" + selects[j] + "' value='" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "'/></td>");
								continue;
							}
							if (selects[j].trim().equals("row")) {
								out.println("<td>" + (i + 1) + "</td>");
								continue;
							}
							if (selects[j].trim().equals("param_key")) {
								out.println("<td align='left'>");
								out.println("<textarea cols='30' rows='3'>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</textarea>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("param_value")) {
								out.println("<td align='left'>");
								out.println("<textarea cols='60' rows='3'>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</textarea>");
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
								out.println("<textarea cols='20' rows='3'>" + HandleDatabase.get_string(dtm_02, i, selects[j].trim()) + "</textarea>");
								out.println("</td>");
								continue;
							}
							if (selects[j].trim().equals("action")) {
								out.println("<td>");
								out.println("<div><a href='" + HandleRequest.get_path() + "/jsp/module/atmv/test/setting/param_detail/param_detail_update.jsp?param_detail_id="
										+ HandleDatabase.get_string(dtm_02, i, "param_detail_id") + "'>修改数据</a></div>");
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
