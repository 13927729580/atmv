package qfsoft.web.atmv.edi;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.table.DefaultTableModel;

import qfsoft.library.common.method.DealDatabase;
import qfsoft.library.web.method.HandleDatabase;
import qfsoft.library.web.method.HandleRequest;
import qfsoft.web.atmv.method.ProjectDatabase;
import qfsoft.web.atmv.method.ProjectLog;

@WebServlet("/edi/submit_log_detail")
public class SubmitLogDetail extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter writer = response.getWriter();
		ProjectLog.add_log();
		String operate_ip = HandleRequest.get_server_ip();
		String log_id = HandleRequest.get_string("log_id");
		String[] ids = HandleRequest.get_strings("id");
		if (ids != null) {
			for (int i = 0; i < ids.length; i++) {
				String fun_codev = ids[i].split("\\.")[0];
				String tc_codev = ids[i].split("\\.")[1];
				String sqlv = "select t.* from t_funtest_log_detail t where 1=1 and t.tc_type='case' and t.operate_ip='" + operate_ip + "' and t.fun_code='" + fun_codev + "' and t.tc_code='"
						+ tc_codev + "' order by t.firetime_start desc limit 1";
				DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
				for (int j = 0; j < dtmv.getRowCount(); j++) {
					HashMap hm = new HashMap();
					for (int k = 0; k < dtmv.getColumnCount(); k++) {
						String key = dtmv.getColumnName(k);
						String value = HandleDatabase.get_string(dtmv, j, k);
						if (value != null && value.length() != 0) {
							hm.put(key, "'" + DealDatabase.cvtString(value) + "'");
						}
					}
					hm.put("log_id", "'" + log_id + "'");
					String sqlvv = DealDatabase.getAddSql("t_funtest_log_history", hm);
					ProjectDatabase.edit_data(sqlvv);
				}
			}
		} else {
			String sqlv = "select t.* from t_funtest_log_detail t where 1=1 and t.tc_type='case' and t.operate_ip='" + operate_ip + "' order by t.firetime_start desc limit 1";
			DefaultTableModel dtmv = ProjectDatabase.query_data(sqlv);
			for (int j = 0; j < dtmv.getRowCount(); j++) {
				HashMap hm = new HashMap();
				for (int k = 0; k < dtmv.getColumnCount(); k++) {
					String key = dtmv.getColumnName(k);
					String value = HandleDatabase.get_string(dtmv, j, k);
					if (value != null && value.length() != 0) {
						hm.put(key, "'" + DealDatabase.cvtString(value) + "'");
					}
				}
				hm.put("log_id", "'" + log_id + "'");
				String sqlvv = DealDatabase.getAddSql("t_funtest_log_history", hm);
				ProjectDatabase.edit_data(sqlvv);
			}
		}
		writer.println("数据生成完毕...");

	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
