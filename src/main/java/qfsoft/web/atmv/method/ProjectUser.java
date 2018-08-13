package qfsoft.web.atmv.method;

import java.util.ArrayList;

import qfsoft.library.web.method.HandleUser;

public class ProjectUser {

	public final static ArrayList<String> get_user_menus(String user_id) {
		ArrayList<String> list = HandleUser.get_user_menus(ProjectParam.PROJECT_CODE, user_id);
		return list;
	}

	public final static ArrayList<String> get_user_links(String user_id) {
		ArrayList<String> list = HandleUser.get_user_links(ProjectParam.PROJECT_CODE, user_id);
		return list;
	}

}