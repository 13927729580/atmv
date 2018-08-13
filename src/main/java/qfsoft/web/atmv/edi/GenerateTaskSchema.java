package qfsoft.web.atmv.edi;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.table.DefaultTableModel;

import qfsoft.library.common.method.DealString;
import qfsoft.library.web.method.HandleDatabase;
import qfsoft.library.web.method.HandleRequest;
import qfsoft.web.atmv.method.ProjectDatabase;
import qfsoft.web.atmv.method.ProjectLog;
import qfsoft.web.atmv.method.ProjectParamDetail;

@WebServlet("/edi/generate_task_schema")
public class GenerateTaskSchema extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter writer = response.getWriter();
		ProjectLog.add_log();
		String schema_code = HandleRequest.get_string("schema_code");
		if (schema_code.length() > 0) {
			String tc_auto = "";
			String tc_manual = "";
			String sqlv = "select a.* from t_funtest_tc a inner join t_funtest_fun b on b.fun_code=a.fun_code where 1=1 and a.tc_type='case'";
			String sqlv1 = "select * from t_funtest_schema a where a.schema_code='" + schema_code + "'";
			DefaultTableModel dtmv1 = ProjectDatabase.query_data(sqlv1);
			String tc_fun = HandleDatabase.get_string(dtmv1, 0, "tc_fun");
			if (tc_fun.length() > 0) {
				String[] tc_funvs = tc_fun.split(",");
				for (int k = 0; k < tc_funvs.length; k++) {
					tc_funvs[k] = "'" + tc_funvs[k] + "'";
				}
				sqlv = sqlv + " and a.fun_code in (" + DealString.getArrayStr(tc_funvs, ",") + ")";
			}
			String tc_level = HandleDatabase.get_string(dtmv1, 0, "tc_level");
			if (tc_level.length() > 0) {
				String[] tc_levelvs = tc_level.split(",");
				for (int k = 0; k < tc_levelvs.length; k++) {
					tc_levelvs[k] = "'" + tc_levelvs[k] + "'";
				}
				sqlv = sqlv + " and a.tc_level in (" + DealString.getArrayStr(tc_levelvs, ",") + ")";
			}
			String tc_status = HandleDatabase.get_string(dtmv1, 0, "tc_status");
			if (tc_status.length() > 0) {
				String[] tc_statusvs = tc_status.split(",");
				for (int k = 0; k < tc_statusvs.length; k++) {
					tc_statusvs[k] = "'" + tc_statusvs[k] + "'";
				}
				sqlv = sqlv + " and a.last_status in (" + DealString.getArrayStr(tc_statusvs, ",") + ")";
			}
			String tc_tester = HandleDatabase.get_string(dtmv1, 0, "tc_tester");
			if (tc_tester.length() > 0) {
				String[] tc_testervs = tc_tester.split(",");
				for (int k = 0; k < tc_testervs.length; k++) {
					tc_testervs[k] = "'" + tc_testervs[k] + "'";
				}
				sqlv = sqlv + " and a.tester in (" + DealString.getArrayStr(tc_testervs, ",") + ")";
			}
			String tc_plugin = HandleDatabase.get_string(dtmv1, 0, "tc_plugin");
			if (tc_plugin.length() > 0) {
				String[] tc_pluginvs = tc_plugin.split(",");
				for (int k = 0; k < tc_pluginvs.length; k++) {
					tc_pluginvs[k] = "'" + tc_pluginvs[k] + "'";
				}
				sqlv = sqlv + " and a.run_plugin in (" + DealString.getArrayStr(tc_pluginvs, ",") + ")";
			}
			sqlv = sqlv + " order by a.fun_code,a.tc_code";
			DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
			for (int j = 0; j < dtmv.getRowCount(); j++) {
				String fun_codev = HandleDatabase.get_string(dtmv, j, "fun_code");
				String tc_codev = HandleDatabase.get_string(dtmv, j, "tc_code");
				String last_statusv = HandleDatabase.get_string(dtmv, j, "last_status");
				String configv = fun_codev + "." + tc_codev + ",1,1";
				if (last_statusv.equals("auto")) {
					tc_auto = DealString.addline(tc_auto, configv);
				} else if (last_statusv.equals("develop") || last_statusv.equals("manual")) {
					tc_manual = DealString.addline(tc_manual, configv);
				}
			}
			ProjectParamDetail.set_param("localconfig_task.auto", tc_auto);
			ProjectParamDetail.set_param("localconfig_task.manual", tc_manual);
		}
		writer.println("数据生成完毕...");
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
