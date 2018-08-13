package qfsoft.web.atmv.edi;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import qfsoft.library.common.method.DealDatabase;
import qfsoft.library.common.method.DealDate;
import qfsoft.library.web.method.HandleRequest;
import qfsoft.library.web.method.HandleResponse;
import qfsoft.web.atmv.method.ProjectDatabase;
import qfsoft.web.atmv.method.ProjectLog;

@WebServlet("/edi/submit_manual")
public class SubmitManual extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		ProjectLog.add_log();
		String log_detail_id = HandleRequest.get_string("log_detail_id");
		String record_result = HandleRequest.get_string("record_result", "utf-8");
		String record_memo = HandleRequest.get_string("record_memo", "utf-8");
		HashMap hmv = new HashMap();
		hmv.put("firetime_start", "'" + DealDate.getNowTimeStr2() + "'");
		hmv.put("firetime_end", "'" + DealDate.getNowTimeStr2() + "'");
		hmv.put("log_time", "'0'");
		hmv.put("log_result", "'" + record_result + "'");
		hmv.put("memo", "'" + record_memo + "'");
		String sqlv = DealDatabase.getModifySql("t_funtest_log_detail", hmv, "log_detail_id='" + log_detail_id + "'");
		ProjectDatabase.edit_data(sqlv);
		HandleResponse.redirect(HandleRequest.get_path() + "/jsp/module/atmv/test/execute/task_detail/log_detail_manual.jsp");
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
