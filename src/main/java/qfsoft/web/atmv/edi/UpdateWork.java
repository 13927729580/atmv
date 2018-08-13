package qfsoft.web.atmv.edi;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import qfsoft.library.web.method.HandleRequest;
import qfsoft.web.atmv.method.ProjectLog;
import qfsoft.web.atmv.test.ProjectResult;

@WebServlet("/edi/update_work")
public class UpdateWork extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter writer = response.getWriter();
		ProjectLog.add_log();
		String log_id = HandleRequest.get_string("log_id");
		ProjectResult.update_statics(log_id);
		writer.println("数据生成完毕...");

	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
