package qfsoft.web.atmv.edi;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import qfsoft.library.common.method.DealDatabase;
import qfsoft.library.common.method.DealFile;
import qfsoft.library.web.method.HandleRequest;
import qfsoft.web.atmv.method.ProjectDatabase;
import qfsoft.web.atmv.method.ProjectLog;
import qfsoft.web.atmv.method.ProjectParamDetail;

@WebServlet("/edi/delete_log_detail")
public class DeleteLogDetail extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter writer = response.getWriter();
		ProjectLog.add_log();

		String operate_ip = HandleRequest.get_server_ip();
		String sqlv = DealDatabase.getDeleteSql("t_funtest_log_detail", "operate_ip='" + operate_ip + "'");
		ProjectDatabase.edit_data(sqlv);

		String path = ProjectParamDetail.get_param("localconfig_attachpath") + DealFile.getSplit() + "funtest" + DealFile.getSplit() + "temp";
		File dir = DealFile.getFileByPath(path);
		File[] ds = dir.listFiles();
		if (ds != null) {
			for (int i = 0; i < ds.length; i++) {
				if (!ds[i].getName().equals("readme.txt")) {
					DealFile.delFolder(ds[i]);
				}
			}
		}
		writer.println("数据生成完毕...");

	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
