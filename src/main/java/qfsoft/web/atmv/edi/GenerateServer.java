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
import qfsoft.web.atmv.method.ProjectLog;
import qfsoft.web.atmv.method.ProjectParamDetail;
import qfsoft.web.atmv.test.ProjectServer;

@WebServlet("/edi/generate_server")
public class GenerateServer extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter writer = response.getWriter();
		ProjectLog.add_log();

		String server_id = HandleRequest.get_string("server_id");
		String detail_ip = HandleRequest.get_string("detail_ip");
		String sqlv = "SELECT t1.detail_ip,t2.* FROM t_env_server_detail t1 INNER JOIN t_env_server t2 ON (t2.server_id=t1.server_id AND t1.detail_type='shell.data') WHERE 1=1";
		if (server_id.length() > 0) {
			sqlv = sqlv + " and t2.server_id='" + server_id + "'";
		}
		if (detail_ip.length() > 0) {
			sqlv = sqlv + " and t1.detail_ip='" + detail_ip + "'";
		}
		DefaultTableModel dtmv = HandleDatabase.query_data(sqlv);
		if (dtmv.getRowCount() > 0) {
			String auto_host = "";
			auto_host = DealString.addline(auto_host, "server_id = " + server_id);
			auto_host = DealString.addline(auto_host, "db_instance = 1");
			auto_host = DealString.addline(auto_host, "db_ip_0 = " + ProjectServer.get_server_attri(server_id, "data.mysql", "detail_ip"));
			auto_host = DealString.addline(auto_host, "db_port_0 = " + ProjectServer.get_server_attri(server_id, "data.mysql", "detail_port"));
			auto_host = DealString.addline(auto_host, "db_user_0 = " + ProjectServer.get_server_attri(server_id, "data.mysql", "detail_user"));
			auto_host = DealString.addline(auto_host, "db_pwd_0 = " + ProjectServer.get_server_attri(server_id, "data.mysql", "detail_pwd"));
			auto_host = DealString.addline(auto_host, "db_names_0 = " + ProjectServer.get_server_attri(server_id, "data.mysql", "detail_other"));
			auto_host = DealString.addline(auto_host, "db_sys_ip_0 = " + ProjectServer.get_server_attri(server_id, "shell.data", "detail_ip"));
			auto_host = DealString.addline(auto_host, "db_sys_user_0 = " + ProjectServer.get_server_attri(server_id, "shell.data", "detail_user"));
			auto_host = DealString.addline(auto_host, "db_sys_pwd_0 = " + ProjectServer.get_server_attri(server_id, "shell.data", "detail_pwd"));
			ProjectParamDetail.set_param("localconfig_server", auto_host);
		}
		writer.println("数据生成完毕...");

	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
