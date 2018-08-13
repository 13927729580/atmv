<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
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

	String log_detail_id = HandleRequest.get_string("log_detail_id");
	String sql_02 = "select a.* from t_funtest_log_detail a where 1=1 and log_detail_id='" + log_detail_id
			+ "'";
	DefaultTableModel dtm_02 = ProjectDatabase.query_data(sql_02);
	if (dtm_02.getRowCount() == 0) {
		HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=2007");
		return;
	}
	String fun_code = HandleDatabase.get_string(dtm_02, 0, "fun_code");
	String tc_code = HandleDatabase.get_string(dtm_02, 0, "tc_code");
	int cycle_pos = HandleDatabase.get_int(dtm_02, 0, "cycle_pos");
	String log_data = HandleDatabase.get_string(dtm_02, 0, "log_data");
	String log_result = HandleDatabase.get_string(dtm_02, 0, "log_result");
	String log_detail_memo = HandleDatabase.get_string(dtm_02, 0, "memo");
	String[] params = DealString.getParams(log_data, "(", ")");
	String[] log_datas = null;
	int log_data_start = 0;
	int log_data_end = 0;
	String logfilepath = "";
	if (params.length == 3) {
		logfilepath = params[0];
		File log = DealFile.getFileByPath(logfilepath);
		log_data_start = Integer.parseInt(params[1]);
		log_data_end = Integer.parseInt(params[2]);
		if (log.exists()) {
			log_datas = DealFile.read(log);
		}
	}

	String color = "#999999";
	if (log_result.equals("running")) {
		color = "#333333";
	} else if (log_result.equals("pass")) {
		color = "#009900";
	} else if (log_result.equals("fail")) {
		color = "#ff0000";
	}

	String log_detail_tcv = fun_code + "." + tc_code;
	String sql_02v = "select a.* from t_funtest_tc a inner join t_funtest_fun b on b.fun_code=a.fun_code where 1=1 and b.fun_code='"
			+ fun_code + "' and a.tc_code='" + tc_code + "' order by a.tc_code";
	DefaultTableModel dtm_02v = ProjectDatabase.query_data(sql_02v);
	if (dtm_02v.getRowCount() > 0) {
		log_detail_tcv = log_detail_tcv + " " + HandleDatabase.get_string(dtm_02v, 0, "tc_summary")
				+ "。-> 预期结果：" + HandleDatabase.get_string(dtm_02v, 0, "expect_result");
	}
%>
<body style="background-color: #cccccc;">
	<form name="query_data" method="post">
		<div style="position: absolute; left: 1%; top: 42px; width: 98%; height: 92%; text-align: center; background-color: #cccccc;">
			<iframe id="photo_view" src="" width="100%" height="92%" frameborder="1" scrolling="auto" style="background-color: #ffffff;" security="restricted" sandbox=""></iframe>
		</div>
		<%
			out.println(
					"<textarea name='memo' style='position:absolute; left:1%; top:5px; width:98%; height:28px; overflow-x:hidden; overflow-y:auto; color:"
							+ color + ";'>");
			out.println("测试用例：" + log_detail_tcv);
			out.println("测试结果：" + log_detail_memo);
			if (log_datas != null && log_datas.length > log_data_end) {
				out.println("详细日志：");
				for (int i = log_data_start; i < log_data_end; i++) {
					out.println(log_datas[i]);
				}
			}
			out.println("</textarea>");
			out.println("<div style='position:absolute; left:1%; top:92%; width:98%; height:8%; text-align:left;'>");
			String tcpath = fun_code + "." + tc_code + "_" + cycle_pos;
			String path = logfilepath.replace(DealFile.getSplit() + "test.log", "") + DealFile.getSplit() + tcpath;
			String url = ProjectParam.get_param("attach_url") + "/funtest/temp/"
					+ DealString.getParam(logfilepath,
							DealFile.getSplit() + "funtest" + DealFile.getSplit() + "temp" + DealFile.getSplit(),
							DealFile.getSplit(), 0)
					+ "/" + tcpath;
			ArrayList<File> fs = new ArrayList<File>();
			File dir = DealFile.getFileByPath(path);
			DealFile.getFileByFolder(dir, fs);
			DealArray.sort(fs, "file_create", "asc");
			out.println("<p>日志路径：" + path + "</p>");
			out.println("<script type='text/javascript'>var size=" + fs.size()
					+ ";var names=new Array();var photos=new Array();</script>");
			for (int i = 0; i < fs.size(); i++) {
				File f = (File) fs.get(i);
				String namev = f.getName();
				String urlv = url + "/" + namev;
				out.println("<a id='posnum_" + i + "' name='posnum' href='#' onclick=\"load_photo(" + i
						+ ")\" style='padding:0px 5px 0px 5px;'>[" + DealString.intFormat(i + 1, 3) + "]</a>&nbsp;");
				out.println("<script type='text/javascript'>names[" + i + "]='第" + (i + 1) + "页: " + urlv + "';photos["
						+ i + "]='" + urlv + "';</script>");
			}
			out.println("</div>");
		%>
		<div style="position: absolute; left: 5%; top: 50%; width: 38px; height: 36px; cursor: pointer;" onclick="prev()">
			<img src='<%=HandleRequest.get_path()%>/plugin/common/image/page_prev.png' style='width: 38px; height: 38px;' />
		</div>
		<div style="position: absolute; left: 90%; top: 50%; width: 38px; height: 36px; cursor: pointer;" onclick="next()">
			<img src='<%=HandleRequest.get_path()%>/plugin/common/image/page_next.png' style='width: 38px; height: 38px;' />
		</div>
		<div style="position: absolute; left: 40%; top: 80%; width: 38px; height: 36px; cursor: pointer;" onclick="play_photo()">
			<img src='<%=HandleRequest.get_path()%>/plugin/common/image/play.png' style='width: 38px; height: 38px;' />
		</div>
		<div style="position: absolute; left: 52%; top: 80%; width: 38px; height: 36px; cursor: pointer;" onclick="stop_photo()">
			<img src='<%=HandleRequest.get_path()%>/plugin/common/image/stop.png' style='width: 38px; height: 38px;' />
		</div>
	</form>
	<script type="text/javascript">
		$(document).ready(function() {
			$("[name='memo']").focus(function() {
				$(this).css("height", "380px");
			});
			$("[name='memo']").blur(function() {
				$(this).css("height", "28px");
			});
		});

		function load_photo(n) {
			pos = n;
			var lastfix = get_lastfix(photos[pos]);
			$("#photo_view").attr("src", photos[pos]);
			for (var i = 0; i < size; i++) {
				if (i == pos) {
					$("#posnum_" + i).css("background-color", "#ff0000");
					$("#posnum_" + i).css("color", "#ffffff");
				} else {
					$("#posnum_" + i).css("background-color", "#cccccc");
					$("#posnum_" + i).css("color", "#333333");
				}
			}
		}
		function prev() {
			pos--;
			if (pos < 0) {
				pos = 0;
			}
			load_photo(pos);
		}
		function next() {
			pos++;
			if (pos >= names.length) {
				pos = names.length - 1;
			}
			load_photo(pos);
		}
		function refresh_photo() {
			pos++;
			if (pos >= names.length) {
				pos = 0;
			}
			load_photo(pos);
		}
		function play_photo() {
			job = setInterval('refresh_photo()', 500);
		}
		function stop_photo() {
			clearInterval(job);
		}
		function go_image() {
			post_submit("query_data", document.getElementById('photo_view').src, "_blank");
		}
		var pos = names.length - 1;
		var job;
		load_photo(pos);
	</script>
</body>
</html>