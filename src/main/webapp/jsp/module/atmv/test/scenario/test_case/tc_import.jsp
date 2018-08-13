<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/jspf/header.jspf"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#import_data").click(function() {
			import_data();
			return false;
		});
	});
	function import_data() {
		var excelFile = document.getElementById("upload_file").value;
		if (excelFile == '') {
			alert("请选择需上传的文件!");
			return;
		}
		if (excelFile.indexOf('.xls') == -1) {
			alert("文件格式不正确，请选择正确的Excel文件(后缀名.xls)！");
			return;
		}
		var is_operate = confirm('是否确认操作？');
		if (is_operate) {
			post_submit("data_upload", "tc_import_do.jsp", "_self");
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

	String menu_name = "测试用例导入";
	int width = DealString.getLength(menu_name) * 7 + 30;
%>
<body onload="hidden('process_div');">
	<form name="data_upload" method="post" ENCTYPE="multipart/form-data">
		<div style="float: left; position: fixed; width: 100%; height: 30px; background: #ffffff; z-index: 999;">
			<table width="100%" align="left">
				<tr valign="middle">
					<td width="2" height="22"></td>
					<td width="<%=width%>" align="center" style="border-left: solid 1px #cccccc; border-right: solid 1px #cccccc; border-top: solid 1px #cccccc;"><div class="tab_title"><%=menu_name%></div></td>
					<td align="right" style="border-bottom: solid 2px #cccccc;">
						<button class="btn btn-xs btn-default btn-me" id="import_data">导入</button>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left; position: relative; left: 1%; width: 98%; top: 35px; z-index: 1;">
			<table width="100%" class="table table-hover">
				<tr>
					<td class='head' align="left" width="2%"></td>
					<td class='head' align="left" width="13%">字段名称</td>
					<td class='head' align="left" width="85%">字段内容</td>
				</tr>
				<tr>
					<td class='detail_1' align="left" width="2%"></td>
					<td class='detail_1' align="left" width="13%">上传文件</td>
					<td class='detail_1' align="left" width="85%"><input type="file" name="upload_file" id="upload_file" style="width: 500px;" /></td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>
