package qfsoft.web.atmv.test;

import java.util.HashMap;

import javax.swing.table.DefaultTableModel;

import qfsoft.library.web.method.HandleDatabase;
import qfsoft.web.atmv.method.ProjectParamDetail;

public class ProjectServer {

	public final static DefaultTableModel get_server(String server_id) {
		String sql = "select a.* from t_env_server a where 1=1 and a.server_id='" + server_id + "'";
		DefaultTableModel dtm = HandleDatabase.query_data(sql);
		return dtm;
	}
	
	public final static DefaultTableModel get_server_detail(String server_id, String server_detail_type) {
		String sql = "select a.* from t_env_server_detail a where 1=1 and a.server_id='" + server_id + "' and detail_type='" + server_detail_type + "'";
		DefaultTableModel dtm = HandleDatabase.query_data(sql);
		if (dtm.getRowCount() == 1) {
			return dtm;
		}
		if (server_detail_type.length() == 0) {
			String sqlv = "select a.* from t_env_server_detail a where 1=1 and a.server_id='" + server_id + "'";
			DefaultTableModel dtmv = HandleDatabase.query_data(sqlv);
			return dtmv;
		}
		return null;
	}

	public final static String get_server_attri(String server_id, String server_detail_type, String key) {
		DefaultTableModel dtm = get_server_detail(server_id, server_detail_type);
		if (dtm.getRowCount() == 1) {
			String value = HandleDatabase.get_string(dtm, 0, key);
			return value;
		}
		return null;
	}

	public final static String get_server_setting(String name) {
		String localconfig_server = ProjectParamDetail.get_param("localconfig_server");
		String[] settings = localconfig_server.split("\n");
		HashMap hm = new HashMap();
		for (int i = 0; i < settings.length; i++) {
			if (settings[i].trim().length() == 0) {
				continue;
			}
			int split = settings[i].indexOf("=");
			String key = settings[i].substring(0, split).trim();
			String value = settings[i].substring(split + 1, settings[i].length()).trim();
			hm.put(key, value);
		}
		String value = String.valueOf(hm.get(name));
		return value;
	}

}
