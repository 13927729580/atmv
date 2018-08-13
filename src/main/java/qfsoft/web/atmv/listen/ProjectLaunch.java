package qfsoft.web.atmv.listen;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import qfsoft.library.common.method.DealMachine;
import qfsoft.library.web.method.HandleLog;
import qfsoft.web.atmv.method.ProjectParamDetail;

public class ProjectLaunch implements ServletContextListener {

	public void contextInitialized(ServletContextEvent arg0) {
		HandleLog.log("执行项目初始化过程");
		String operate_ip = DealMachine.getHostIP();
		ProjectParamDetail.init_param(operate_ip);
	}

	public void contextDestroyed(ServletContextEvent arg0) {
		HandleLog.log("执行项目结束过程");
	}

}