<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#query_data").click(function() {
			post_submit("query_data", "reporter_loghistory-sum.jsp", "_self");
			return false;
		});
	});
</script>
</head>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path()
		+ "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String log_id = HandleRequest.get_string("log_id");
	String sum_type = HandleRequest.get_string("sum_type");
	if (sum_type.length() == 0) {
		sum_type = "测试功能";
	}

	JSONArray keys = new JSONArray();
	JSONArray values = new JSONArray();
	if (sum_type.equals("测试功能")) {
		String req_sql = "SELECT a.fun_code AS static_name,COUNT(1) AS total_num FROM t_funtest_log_history a WHERE 1=1 AND a.log_id='"
		+ log_id + "' GROUP BY a.fun_code";
		DefaultTableModel dtm_data = ProjectDatabase.query_data(req_sql);
		for (int i = 0; i < dtm_data.getRowCount(); i++) {
	DefaultTableModel fun = ProjectCase.get_fun(DealTable.getString(dtm_data, i, "static_name"));
	String static_name = HandleDatabase.get_string(fun, 0, "fun_name");
	int total_num = HandleDatabase.get_int(dtm_data, i, "total_num");
	keys.put(i, static_name);
	values.put(i, total_num);
		}
	} else if (sum_type.equals("测试结果")) {
		String req_sql = "SELECT a.log_result AS static_name,COUNT(1) AS total_num FROM t_funtest_log_history a WHERE 1=1 AND a.log_id='"
		+ log_id + "' GROUP BY a.log_result";
		DefaultTableModel dtm_data = ProjectDatabase.query_data(req_sql);
		for (int i = 0; i < dtm_data.getRowCount(); i++) {
	String static_name = ProjectUdc.get_udc_value("log_status",
			DealTable.getString(dtm_data, i, "static_name"));
	int total_num = HandleDatabase.get_int(dtm_data, i, "total_num");
	keys.put(i, static_name);
	values.put(i, total_num);
		}
	}

	String menu_name = "自动化测试日志汇总统计";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type='hidden' name="log_id" value="<%=log_id%>" />
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">汇总类型&nbsp; <%
 	out.println("<select name='sum_type'>");
 	String[] options1 = new String[]{"测试功能", "测试结果"};
 	for (int k = 0; k < options1.length; k++) {
 		if (options1[k].equals(sum_type)) {
 			out.println("<option value='" + options1[k] + "' selected='selected'>" + options1[k] + "</option>");
 		} else {
 			out.println("<option value='" + options1[k] + "'>" + options1[k] + "</option>");
 		}
 	}
 	out.println("</select>");
 %>
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
					</td>
				</tr>
			</table>
		</div>
		<div id="container" style="float: left; position: relative; width: 100%; top: 35px; z-index: 1;"></div>
	</form>
	<script type="text/javascript">
		var chart = new Highcharts.Chart('container', {
			chart : {
				type : 'column'
			},
			title : {
				text : '自动化测试日志汇总统计',
				x : -20
			},
			subtitle : {
				text : '测试执行',
				x : -20
			},
			xAxis : {
				categories :
	<%=keys.toString()%>
		},
			yAxis : {
				title : {
					text : '数量 (个)'
				},
				plotLines : [ {
					value : 0,
					width : 1,
					color : '#808080'
				} ]
			},
			tooltip : {
				valueSuffix : '个'
			},
			legend : {
				layout : 'vertical',
				align : 'right',
				verticalAlign : 'middle',
				borderWidth : 0
			},
			plotOptions : {
				column : {
					pointPadding : 0.2,
					borderWidth : 0,
					dataLabels : {
						enabled : true
					}
				}
			},
			series : [ {
				name : '数量',
				data :
	<%=values.toString()%>
		} ]
		});
	</script>
</body>
</html>
