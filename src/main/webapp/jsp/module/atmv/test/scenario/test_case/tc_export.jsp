<%@ page language="java" contentType="vnd.ms-excel; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/jspf/header.jspf"%>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String fun_code = HandleRequest.get_string("fun_code");
	String req_sql = "select b.fun_name,b.fun_code as fun_codev,c.fun_name as parent_name,a.* from t_funtest_tc a inner join t_funtest_fun b on b.fun_code=a.fun_code inner join t_funtest_fun c on c.fun_id=b.parent_id where a.tc_type='case'";
	if (fun_code.length() > 0) {
		req_sql = req_sql + " and a.fun_code='" + fun_code + "'";
	}
	req_sql = req_sql + " order by a.tc_code asc";
	String req_select = "fun_codev,tc_code,tc_level,tc_path,tc_summary,detail_step,expect_result,last_status,run_plugin,tester,developer";
	String req_view = "功能编码,用例编码,用例级别,用例路径,用例摘要,详细步骤,预期结果,状态,执行插件,测试人员,开发人员";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");

	DefaultTableModel dtm_02 = ProjectDatabase.query_data(req_sql);
	DefaultTableModel tablemodel = new DefaultTableModel();
	tablemodel.setColumnIdentifiers(views);
	int data_total = dtm_02.getRowCount();
	for (int i = 0; i < data_total; i++) {
		String[] row_values = new String[selects.length];
		for (int j = 0; j < selects.length; j++) {
			if (selects[j].trim().equals("tc_level")) {
				row_values[j] = ProjectUdc.get_udc_value("tc_level", HandleDatabase.get_string(dtm_02, i, selects[j].trim()));
				continue;
			}
			if (selects[j].trim().equals("last_status")) {
				row_values[j] = ProjectUdc.get_udc_value("tc_status", HandleDatabase.get_string(dtm_02, i, selects[j].trim()));
				continue;
			}
			if (selects[j].trim().equals("run_plugin")) {
				row_values[j] = ProjectUdc.get_udc_value("tc_plugin", HandleDatabase.get_string(dtm_02, i, selects[j].trim()));
				continue;
			}
			if (selects[j].trim().equals("tester")) {
				row_values[j] = HandleUser.get_user_value("user_code", HandleDatabase.get_string(dtm_02, i, selects[j].trim()), "user_name");
				continue;
			}
			if (selects[j].trim().equals("developer")) {
				row_values[j] = HandleUser.get_user_value("user_code", HandleDatabase.get_string(dtm_02, i, selects[j].trim()), "user_name");
				continue;
			}
			row_values[j] = HandleDatabase.get_string(dtm_02, i, selects[j].trim());
		}
		tablemodel.insertRow(i, row_values);
	}

	String file_name = "测试用例表_(" + HandleDatabase.get_string(dtm_02, 0, "parent_name") + "-" + HandleDatabase.get_string(dtm_02, 0, "fun_name") + ")_" + DealDate.getNowTimeNo() + ".xls";
	file_name = DealString.codeString(file_name, "UTF-8", "ISO_8859_1");
	HandleResponse.set_header("Content-Disposition", "attachment;filename=" + file_name);
	HandleResponse.set_content_type("application/vnd.ms-excel");
	OutputStream os = HandleResponse.get_file();
	DealOffice.saveBook("测试用例", tablemodel, os);
	out.clear();
	out = pageContext.pushBody();
%>