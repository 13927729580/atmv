package qfsoft.web.atmv.edi;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.table.DefaultTableModel;

import qfsoft.library.common.method.DealDatabase;
import qfsoft.library.web.method.HandleRequest;
import qfsoft.library.web.method.HandleResponse;
import qfsoft.web.atmv.method.ProjectDatabase;
import qfsoft.web.atmv.method.ProjectLog;
import qfsoft.web.atmv.method.ProjectParam;
import qfsoft.web.atmv.method.ProjectParamDetail;
import qfsoft.web.atmv.test.ProjectServer;

@WebServlet("/edi/generate_manual")
public class GenerateManual extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		ProjectLog.add_log();
		String operate_ip = HandleRequest.get_server_ip();
		String tc = ProjectParamDetail.get_param("localconfig_task.manual");
		String[] tcs = tc.split("\n");
		int data_total = tcs.length;
		for (int i = 0; i < data_total; i++) {
			if (tcs[i].trim().length() == 0) {
				continue;
			}
			String[] tcvs = tcs[i].split(",");
			if (tcvs.length != 3) {
				continue;
			}
			String[] codes = tcvs[0].split("\\.");
			if (codes.length != 2) {
				continue;
			}
			String fun_codev = codes[0];
			String tc_codev = codes[1];
			String sql_fun = "select a.* from t_funtest_log_detail a where a.operate_ip='" + operate_ip + "' and a.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev + "'";
			DefaultTableModel dtm_log = ProjectDatabase.query_data(sql_fun);
			if (dtm_log.getRowCount() == 0) {
				HashMap hmv = new HashMap();
				hmv.put("log_detail_id", "UUID()");
				hmv.put("server_id", "'" + ProjectServer.get_server_setting("server_id") + "'");
				hmv.put("project_code", "'" + ProjectParam.PROJECT_CODE + "'");
				hmv.put("operate_ip", "'" + operate_ip + "'");
				hmv.put("fun_code", "'" + fun_codev + "'");
				hmv.put("tc_code", "'" + tc_codev + "'");
				hmv.put("tc_type", "'case'");
				hmv.put("run_plugin", "'manual'");
				hmv.put("cycle_pos", "'0'");
				hmv.put("log_result", "'idle'");
				String sqlv = DealDatabase.getAddSql("t_funtest_log_detail", hmv);
				ProjectDatabase.edit_data(sqlv);
			}
		}
		HandleResponse.redirect(HandleRequest.get_path() + "/jsp/module/atmv/test/execute/task_detail/log_detail_manual.jsp");
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
