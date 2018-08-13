<%@ page language="java" contentType="vnd.ms-excel; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/jspf/header.jspf"%>
<%
	if (!HandleUser.check_login()) {
		out.println("<script language='javascript'>top.location.href='" + HandleRequest.get_path() + "/jsp/user/login/login.jsp';</script>");
		return;
	}
	ProjectLog.add_log();

	String attach_path = ProjectParamDetail.get_param("localconfig_attachpath");
	ArrayList items = HandleRequest.get_items(attach_path);
	InputStream is = HandleRequest.get_file(items, "upload_file");

	String req_select = "fun_code,tc_code,tc_level,tc_path,tc_summary,detail_step,expect_result,last_status,run_plugin,tester,developer";
	String req_view = "功能编码,用例编码,用例级别,用例路径,用例摘要,详细步骤,预期结果,状态,执行插件,测试人员,开发人员";
	String[] selects = req_select.split(",");
	String[] views = req_view.split(",");
	DefaultTableModel dtm = DealOffice.getTable(is, "测试用例");
	for (int i = 0; i < dtm.getRowCount(); i++) {
		String fun_code = HandleDatabase.get_string(dtm, i, "功能编码");
		String tc_code = HandleDatabase.get_string(dtm, i, "用例编码");
		if (fun_code.length() <= 0 || fun_code.length() <= 0) {
			continue;
		}
		HashMap hm = new HashMap();
		for (int j = 0; j < selects.length; j++) {
			if (selects[j].trim().equals("tc_level")) {
				hm.put(selects[j].trim(), "'" + ProjectUdc.get_udc_key("tc_level", HandleDatabase.get_string(dtm, i, views[j].trim())) + "'");
				continue;
			}
			if (selects[j].trim().equals("last_status")) {
				hm.put(selects[j].trim(), "'" + ProjectUdc.get_udc_key("tc_status", HandleDatabase.get_string(dtm, i, views[j].trim())) + "'");
				continue;
			}
			if (selects[j].trim().equals("run_plugin")) {
				hm.put(selects[j].trim(), "'" + ProjectUdc.get_udc_key("tc_plugin", HandleDatabase.get_string(dtm, i, views[j].trim())) + "'");
				continue;
			}
			if (selects[j].trim().equals("tester")) {
				hm.put(selects[j].trim(), "'" + HandleUser.get_user_value("user_name", HandleDatabase.get_string(dtm, i, views[j].trim()), "user_code") + "'");
				continue;
			}
			if (selects[j].trim().equals("developer")) {
				hm.put(selects[j].trim(), "'" + HandleUser.get_user_value("user_name", HandleDatabase.get_string(dtm, i, views[j].trim()), "user_code") + "'");
				continue;
			}
			hm.put(selects[j].trim(), "'" + DealDatabase.cvtString(HandleDatabase.get_string(dtm, i, views[j].trim())) + "'");
		}
		String sqlv1 = "SELECT * FROM t_funtest_tc WHERE fun_code='" + fun_code + "' AND tc_code='" + tc_code + "'";
		DefaultTableModel dtmv1 = ProjectDatabase.query_data(sqlv1);
		if (dtmv1.getRowCount() > 0) {
			String sqlv2 = DealDatabase.getModifySql("t_funtest_tc", hm, "fun_code='" + fun_code + "' AND tc_code='" + tc_code + "'");
			ProjectDatabase.edit_data(sqlv2);
		} else {
			hm.put("tc_id", "UUID()");
			hm.put("tc_type", "'case'");
			hm.put("memo", "'{}'");
			String sqlv2 = DealDatabase.getAddSql("t_funtest_tc", hm);
			ProjectDatabase.edit_data(sqlv2);
		}
	}

	HandleResponse.redirect(HandleRequest.get_path() + "/jsp/message.jsp?message_code=1001");
%>