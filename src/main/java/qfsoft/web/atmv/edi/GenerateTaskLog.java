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

@WebServlet("/edi/generate_task_log")
public class GenerateTaskLog extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter writer = response.getWriter();
		ProjectLog.add_log();
		String[] ids = HandleRequest.get_strings("id");
		if (ids != null) {
			String tc_auto = "";
			String tc_manual = "";
			for (int i = 0; i < ids.length; i++) {
				String fun_codev = ids[i].split("\\.")[0];
				String tc_codev = ids[i].split("\\.")[1];
				String sqlv = "SELECT t.* FROM t_funtest_log_detail t WHERE t.tc_type='case' and t.fun_code='" + fun_codev + "' AND t.tc_code='" + tc_codev + "'";
				DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
				if (dtmv.getRowCount() > 0) {
					String run_pluginv = HandleDatabase.get_string(dtmv, 0, "run_plugin");
					String last_statusv = HandleDatabase.get_string(dtmv, 0, "last_status");
					String configv = fun_codev + "." + tc_codev + ",1,1";
					if (last_statusv.equals("auto")) {
						tc_auto = DealString.addline(tc_auto, configv);
					} else if (last_statusv.equals("develop") || last_statusv.equals("manual")) {
						tc_manual = DealString.addline(tc_manual, configv);
					}
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
