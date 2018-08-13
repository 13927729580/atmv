package qfsoft.web.atmv.method;

import java.util.ArrayList;

import javax.swing.table.DefaultTableModel;

import qfsoft.library.web.method.HandleDatabase;
import qfsoft.library.web.method.HandleMenu;
import qfsoft.library.web.method.HandleSession;

public class ProjectMenu {

	public final static DefaultTableModel get_self(String menu_code) {
		DefaultTableModel dtm = HandleMenu.get_self(ProjectParam.PROJECT_CODE, menu_code);
		return dtm;
	}

	public final static DefaultTableModel get_childs(String menu_code) {
		DefaultTableModel dtm = HandleMenu.get_childs(ProjectParam.PROJECT_CODE, menu_code);
		return dtm;
	}

	public final static DefaultTableModel get_default() {
		DefaultTableModel dtm_01 = get_childs("1");
		for (int i = 0; i < dtm_01.getRowCount(); i++) {
			String menu_codev = HandleDatabase.get_string(dtm_01, i, "menu_code");
			if (i == 0) {
				DefaultTableModel menuv = get_self(menu_codev);
				return menuv;
			}
		}
		return null;
	}

	public final static boolean check_menu(String menu_code) {
		DefaultTableModel loginuser_roles = HandleSession.get_dtm("loginuser_roles");
		for (int i = 0; i < loginuser_roles.getRowCount(); i++) {
			String role_typev = HandleDatabase.get_string(loginuser_roles, i, "role_type");
			if (role_typev.equals("super")) {
				return true;
			}
		}
		ArrayList loginuser_menus = HandleSession.get_list("loginuser_menus");
		for (int i = 0; i < loginuser_menus.size(); i++) {
			String loginuser_menuv = String.valueOf(loginuser_menus.get(i));
			if (loginuser_menuv.startsWith(menu_code)) {
				return true;
			}
		}
		return false;
	}

}