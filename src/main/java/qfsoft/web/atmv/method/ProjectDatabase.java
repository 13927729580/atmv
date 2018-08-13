package qfsoft.web.atmv.method;

import javax.swing.table.DefaultTableModel;

import qfsoft.library.common.defclass.data.QueryPage;
import qfsoft.library.web.method.HandleDatabase;
import qfsoft.library.web.util.CacheList;

public class ProjectDatabase {

	public final static String PROJECT_DB = CacheList.config.getProperty("project_db");

	public final static QueryPage get_querypage(String select, String from, String where, String groupby, String having, String orderby, int page_num) {
		QueryPage page = HandleDatabase.get_querypage(PROJECT_DB, select, from, where, groupby, having, orderby, page_num);
		return page;
	}

	public final static DefaultTableModel query_data(String sql) {
		DefaultTableModel dtm = HandleDatabase.query_data(PROJECT_DB, sql);
		return dtm;
	}

	public final static int edit_data(String sql) {
		int result = HandleDatabase.edit_data(PROJECT_DB, sql);
		return result;
	}

	public final static int bat_edit_data(String[] sqls) {
		int result = HandleDatabase.bat_edit_data(PROJECT_DB, sqls);
		return result;
	}

}