<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
$(document).ready(function(){
	$("#submit_data").click(function(){
		submit_data();
		return false;
	});
});
$.fn.serializeObject = function() {
	var o = {};
	var a = this.serializeArray();
	$.each(a, function() {
		if(this.name!="tc_code"&&this.name!="tc_cycle"&&this.name!="tc_param") {
			if (o[this.name]) {
				if (!o[this.name].push) {
					o[this.name] = [ o[this.name] ];
				}
				o[this.name].push(this.value || "");
			} else {
				o[this.name] = this.value || "";
			}
		}
	});
	return o;
};
function submit_data(){
	var jsonObj = $("[name='query_data']").serializeObject();
	$("[name='tc_param']").val(JSON.stringify(jsonObj));
	post_submit("query_data","<%=ProjectParam.get_param("atev_url")%>/edi/execute_data", "_self");
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
	String req_sql = "select a.* from t_funtest_tc a where 1=1 and a.tc_id='" + tc_id + "'";
	DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);
	String fun_code = HandleDatabase.get_string(dtm_02, 0, "fun_code");
	String tc_code = HandleDatabase.get_string(dtm_02, 0, "tc_code");
	String tc_summary = HandleDatabase.get_string(dtm_02, 0, "tc_summary");
	String tc_param = HandleDatabase.get_string(dtm_02, 0, "memo");
	JSONObject form = new JSONObject(tc_param);

	String menu_name = tc_summary;
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body>
	<form name="query_data" method="post">
		<input type="hidden" name="fun_code" value="<%=fun_code%>" /> <input type="hidden" name="tc_code" value="<%=tc_code%>" /> <input type="hidden" name="tc_param" value="<%=tc_param%>" />
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="<%=width%>" height="22" align="center" style="border-left: solid 1px #ffffff; border-right: solid 2px #cccccc; border-top: solid 2px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">循环次数&nbsp;<input type='text' name="tc_cycle" value="1" size="5" />
						<button class="btn btn-xs btn-default btn-me" id="submit_data">运行数据</button>
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
					int pos = 0;
					Iterator<String> iter = form.keys();
					while (iter.hasNext()) {
						String key = iter.next();
						String value = form.getString(key);
						int mod = pos % 2 + 1;
						out.println("<tr>");
						out.println("<td align='left'></td>");
						out.println("<td align='left'>" + key + "</td>");
						out.println("<td align='left'><input type='text' name='" + key + "' value='" + value + "' size='50'/></td>");
						out.println("</tr>");
					}
				%>
			</table>
		</div>
	</form>
</body>
</html>