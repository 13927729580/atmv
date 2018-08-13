package qfsoft.web.atmv.method;

import qfsoft.library.web.method.HandleLog;

public class ProjectLog {

	public final static void log(String txt) {
		HandleLog.log(ProjectParam.PROJECT_CODE, txt);
	}

	public final static void add_log() {
		HandleLog.add_log(ProjectParam.PROJECT_CODE);
	}

}