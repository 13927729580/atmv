<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#query_data").click(function() {
			post_submit("query_data", "reporter_log-sum.jsp", "_self");
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

	JSONArray keys = new JSONArray();
	JSONArray values = new JSONArray();
	String req_sql = "SELECT a.* FROM t_funtest_log a WHERE 1=1 ORDER BY a.firetime_start";
	DefaultTableModel dtm_data = ProjectDatabase.query_data(req_sql);
	for (int i = 0; i < dtm_data.getRowCount(); i++) {
		String log_idv = HandleDatabase.get_string(dtm_data, i, "log_id");
		String log_namev = HandleDatabase.get_string(dtm_data, i, "log_name");
		keys.put(i, log_namev);
		String req_sqlv1 = "SELECT a.* FROM t_funtest_fun a WHERE 1=1 AND a.fun_type='node' ORDER BY a.fun_code";
		DefaultTableModel dtm_datav1 = ProjectDatabase.query_data(req_sqlv1);
		for (int j = 0; j < dtm_datav1.getRowCount(); j++) {
			String fun_codev = HandleDatabase.get_string(dtm_datav1, j, "fun_code");
			String fun_namev = HandleDatabase.get_string(dtm_datav1, j, "fun_name");
			keys.put(i, log_namev);
			JSONObject jsonv = new JSONObject();
			jsonv.put("name", fun_namev);
			JSONArray datavs = new JSONArray();
			String req_sqlv2 = "SELECT COUNT(1) AS total_num FROM t_funtest_log_history a WHERE 1=1 AND a.fun_code='"
					+ fun_codev + "'";
			DefaultTableModel dtm_datav2 = ProjectDatabase.query_data(req_sqlv2);
			for (int k = 0; k < dtm_datav2.getRowCount(); k++) {
				int total_num = HandleDatabase.get_int(dtm_datav2, k, "total_num");
				datavs.put(k, total_num);
			}
			jsonv.put("data", datavs);
			values.put(j, jsonv);
		}
	}

	String menu_name = "自动化测试报告汇总统计";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
						<button class="btn btn-xs btn-default btn-me" id="query_data">查询</button>
					</td>
				</tr>
			</table>
		</div>
		<div id="container" style="float: left; position: relative; width: 100%; top: 35px; z-index: 1;"></div>
	</form>
	<script type="text/javascript">
		var chart = Highcharts.chart('container', {
			chart : {
				type : 'column'
			},
			title : {
				text : '自动化测试报告汇总统计'
			},
			subtitle : {
				text : '数据来源: 自动化测试管理节点'
			},
			xAxis : {
				categories :
	<%=keys.toString()%>
		,
				crosshair : true
			},
			yAxis : {
				min : 0,
				title : {
					text : '数量 (个)'
				}
			},
			tooltip : {
				headerFormat : '<span style="font-size:10px">{point.key}</span><table>',
				pointFormat : '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.0f}</b></td></tr>',
				footerFormat : '</table>',
				shared : true,
				useHTML : true
			},
			plotOptions : {
				column : {
					borderWidth : 0
				}
			},
			series :
	<%=values.toString()%>
		});
	</script>
</body>
</html>
