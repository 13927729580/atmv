package qfsoft.web.atmv.test;

import java.util.HashMap;

import javax.swing.table.DefaultTableModel;

import qfsoft.library.common.defclass.date.TimeNumber;
import qfsoft.library.common.method.DealDatabase;
import qfsoft.library.common.method.DealDate;
import qfsoft.library.common.method.DealString;
import qfsoft.library.web.method.HandleDatabase;
import qfsoft.library.web.method.HandleSession;
import qfsoft.library.web.method.HandleUdc;
import qfsoft.web.atmv.method.ProjectDatabase;
import qfsoft.web.atmv.method.ProjectParam;
import qfsoft.web.atmv.method.ProjectUdc;

public class ProjectResult {

	public final static String gen_report(String log_id) {
		String project_code = ProjectParam.get_param("web_code");
		String project_name = HandleUdc.get_udc_value("project_code", project_code);

		String context = "";
		context = DealString.addline(context, "<p>Hi All~</p>");
		context = DealString.addline(context, "<p>以下是本次的版本迭代上线回归自动化测试执行报告，大家请查收。如有疑问请与本次自动化测试执行负责人(<span style='font-weight:bold;'>" + HandleSession.get_string("loginuser_name") + "</span>)联系~</p>");
		String sql_01 = "SELECT a.* FROM t_funtest_log_history a WHERE 1=1";
		if (log_id.length() > 0) {
			sql_01 = sql_01 + " AND a.log_id='" + log_id + "'";
		}
		sql_01 = sql_01 + " ORDER BY a.fun_code ASC,a.tc_code ASC,a.firetime_start ASC,a.log_detail_id ASC";
		DefaultTableModel dtm_01 = ProjectDatabase.query_data(sql_01);
		int pos = 0;
		int idle = 0;
		int running = 0;
		int pass = 0;
		int fail = 0;
		String test_start = null;
		String test_end = null;
		double maxtime = 0;
		double runtime = 0;
		pos = 1;
		int rownum = dtm_01.getRowCount();
		if (rownum > 0) {
			test_start = HandleDatabase.get_string(dtm_01, 0, "firetime_start");
			test_end = HandleDatabase.get_string(dtm_01, rownum - 1, "firetime_end");
		}
		for (int i = 0; i < rownum; i++) {
			String log_resultv = HandleDatabase.get_string(dtm_01, i, "log_result");
			if (log_resultv.equals("idle")) {
				idle++;
			} else if (log_resultv.equals("running")) {
				running++;
			} else if (log_resultv.equals("pass")) {
				pass++;
			} else if (log_resultv.equals("fail")) {
				fail++;
			}
			double runtimev = HandleDatabase.get_double(dtm_01, i, "log_time");
			runtime = runtime + runtimev;
			if (maxtime < runtimev) {
				maxtime = runtimev;
			}
		}
		int total = idle + running + pass + fail;
		TimeNumber tn = new TimeNumber(runtime);
		String sql_02 = "SELECT b.* FROM (" + sql_01 + ") b GROUP BY b.fun_code,b.tc_code ";
		DefaultTableModel dtm_02 = ProjectDatabase.query_data(sql_02);
		String test_result = "Pass";
		for (int i = 0; i < dtm_02.getRowCount(); i++) {
			String log_resultv = HandleDatabase.get_string(dtm_02, i, "log_result");
			if (log_resultv.equals("fail")) {
				test_result = "Fail";
				break;
			}
		}
		context = DealString.addline(context, "<p style='height:50px; font-size:32px; font-weight:bold;'>" + project_name + "需求上线自动化测试报告</p>");
		context = DealString.addline(context,
				"<p style='height:20px; font-size:14px; font-weight:bold;'>——由" + ProjectParam.get_param("title") + "创建于" + DealDate.getNowTimeStr() + " " + DealDate.getNowWeekDayStr() + "</p>");
		context = DealString.addline(context, "<p style='height:20px; font-size:14px; font-weight:bold;'>1. 测试报告摘要</p>");
		context = DealString.addline(context, "<table width='90%' cellspacing='0' style='border:solid 1px #999999; table-layout:fixed;'>");
		context = DealString.addline(context, "<tr style='height:25px;'>");
		context = DealString.addline(context, "<td width='4%' style='border:solid 1px #999999; text-align:center; font-weight:bold;'>序号</td>");
		context = DealString.addline(context, "<td width='18%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>执行时间</td>");
		context = DealString.addline(context, "<td width='12%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>总耗时</td>");
		context = DealString.addline(context, "<td width='8%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>执行总数</td>");
		context = DealString.addline(context, "<td width='8%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>通过</td>");
		context = DealString.addline(context, "<td width='8%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>失败</td>");
		context = DealString.addline(context, "<td width='8%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>正在执行</td>");
		context = DealString.addline(context, "<td width='8%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>尚未执行</td>");
		context = DealString.addline(context, "<td width='8%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>最终结果</td>");
		context = DealString.addline(context, "</tr>");
		context = DealString.addline(context, "<tr style='height:38px; font-weight:bold;'>");
		context = DealString.addline(context, "<td style='border:solid 1px #999999; text-align:center;'>" + DealString.intFormat(pos, 3) + "</td>");
		context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'>");
		context = DealString.addline(context, "<p>" + test_start + "</p>");
		context = DealString.addline(context, "<p>" + test_end + "</p>");
		context = DealString.addline(context, "</td>");
		context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'>" + tn + "</td>");
		context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'>" + total + "</td>");
		context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'>");
		context = DealString.addline(context, "<span style='color:#009900;'>" + pass + "</span>");
		context = DealString.addline(context, "</td>");
		context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'>");
		context = DealString.addline(context, "<span style='color:#ff0000;'>" + fail + "</span>");
		context = DealString.addline(context, "</td>");
		context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'>");
		context = DealString.addline(context, "<span style='color:#aaaaaa;'>" + running + "</span>");
		context = DealString.addline(context, "</td>");
		context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'>");
		context = DealString.addline(context, "<span style='color:#aaaaaa;'>" + idle + "</span>");
		context = DealString.addline(context, "</td>");
		context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'>");
		String color = "#009900";
		if (test_result.equals("Fail")) {
			color = "#ff0000";
		}
		context = DealString.addline(context, "<span style='color:" + color + ";'>" + test_result + "</span>");
		context = DealString.addline(context, "</td>");
		context = DealString.addline(context, "</tr>");
		context = DealString.addline(context, "</table>");

		context = DealString.addline(context, "<p style='height:20px; font-size:14px; font-weight:bold;'>2. 测试执行错误信息</p>");
		context = DealString.addline(context, "<table width='90%' cellspacing='0' style='border:solid 1px #999999; table-layout:fixed;'>");
		context = DealString.addline(context, "<tr style='height:25px;'>");
		context = DealString.addline(context, "<td width='4%' style='border:solid 1px #999999; text-align:center; font-weight:bold;'>序号</td>");
		context = DealString.addline(context, "<td width='8%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>功能模块</td>");
		context = DealString.addline(context, "<td width='30%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold; word-wrap:break-word;'>测试用例描述</td>");
		context = DealString.addline(context, "<td width='30%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>执行结果</td>");
		context = DealString.addline(context, "<td width='10%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>错误分析</td>");
		context = DealString.addline(context, "</tr>");
		pos = 1;
		for (int j = 0; j < dtm_02.getRowCount(); j++) {
			String fun_codev = HandleDatabase.get_string(dtm_02, j, "fun_code");
			String tc_codev = HandleDatabase.get_string(dtm_02, j, "tc_code");
			String sql_01v = "select a.* from t_funtest_log_history a where 1=1 and a.log_id='" + log_id + "' and a.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev
					+ "' order by a.firetime_start desc";
			DefaultTableModel dtm_01v = ProjectDatabase.query_data(sql_01v);
			String log_resultv = HandleDatabase.get_string(dtm_01v, 0, "log_result");
			if (log_resultv.equals("pass")) {
				continue;
			}

			String sql_02v = "select b.fun_name,a.* from t_funtest_tc a inner join t_funtest_fun b on b.fun_code=a.fun_code where 1=1 and b.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev
					+ "'";
			DefaultTableModel dtm_02v = ProjectDatabase.query_data(sql_02v);
			String fun_namev = fun_codev;
			String tc_namev = "<p><b>(" + fun_codev + "." + tc_codev + ")</b>";
			if (dtm_02v.getRowCount() > 0) {
				fun_namev = HandleDatabase.get_string(dtm_02v, 0, "fun_name");
				tc_namev = tc_namev + " <b>【用例描述】</b>" + HandleDatabase.get_string(dtm_02v, 0, "tc_path") + ": " + HandleDatabase.get_string(dtm_02v, 0, "tc_summary") + ". <b>【预期结果】</b>"
						+ HandleDatabase.get_string(dtm_02v, 0, "expect_result") + "</p>";
			} else {
				tc_namev = tc_namev + "</p>";
			}
			String log_history_resultv = "<b>【测试结果】</b>" + ProjectUdc.get_udc_value("log_status", log_resultv) + ". " + HandleDatabase.get_string(dtm_02, j, "memo") + "";
			context = DealString.addline(context, "<tr style='height:40px;'>");
			context = DealString.addline(context, "<td style='border:solid 1px #999999; text-align:center;'><span style='color:" + color + ";'>" + DealString.intFormat(pos, 3) + "</span></td>");
			context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'><span style='color:" + color + ";'>" + fun_namev + "</span></td>");
			context = DealString.addline(context,
					"<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px; word-wrap:break-word; word-break:break-all; white-space:pre-wrap;'><span style='color:" + color + ";'>"
							+ tc_namev + "</span></td>");
			context = DealString.addline(context,
					"<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px; word-wrap:break-word; word-break:break-all; white-space:pre-wrap;'><span style='color:" + color + ";'>"
							+ log_history_resultv + "</span></td>");
			context = DealString.addline(context,
					"<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px; word-wrap:break-word; word-break:break-all; white-space:pre-wrap;'>&nbsp;</td>");
			context = DealString.addline(context, "</tr>");
			pos++;
		}
		if (pos == 1) {
			context = DealString.addline(context, "<tr style='height:40px;'>");
			context = DealString.addline(context, "<td colspan='5' style='padding-left:25px; padding-right:5px;'>没有任何符合条件的数据</td>");
			context = DealString.addline(context, "</tr>");
		}
		context = DealString.addline(context, "</table>");

		context = DealString.addline(context, "<p style='height:20px; font-size:14px; font-weight:bold;'>4. 测试执行详细信息</p>");
		context = DealString.addline(context, "<table width='90%' cellspacing='0' style='border:solid 1px #999999; table-layout:fixed;'>");
		context = DealString.addline(context, "<tr style='height:25px;'>");
		context = DealString.addline(context, "<td width='4%' style='border:solid 1px #999999; text-align:center; font-weight:bold;'>序号</td>");
		context = DealString.addline(context, "<td width='8%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>功能模块</td>");
		context = DealString.addline(context, "<td width='30%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold; word-wrap:break-word;'>测试用例描述</td>");
		context = DealString.addline(context, "<td width='30%' style='border:solid 1px #999999; padding-left:5px; padding-right:5px; font-weight:bold;'>执行结果</td>");
		context = DealString.addline(context, "<td width='10%' style='border:solid 1px #999999; text-align:right; padding-left:5px; padding-right:5px; font-weight:bold;'>耗时</td>");
		context = DealString.addline(context, "</tr>");
		pos = 1;
		for (int j = 0; j < dtm_02.getRowCount(); j++) {
			String fun_codev = HandleDatabase.get_string(dtm_02, j, "fun_code");
			String tc_codev = HandleDatabase.get_string(dtm_02, j, "tc_code");
			String sql_01v = "select a.* from t_funtest_log_history a where 1=1 and a.log_id='" + log_id + "' and a.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev
					+ "' order by a.firetime_start desc";
			DefaultTableModel dtm_01v = ProjectDatabase.query_data(sql_01v);
			String log_resultv = HandleDatabase.get_string(dtm_01v, 0, "log_result");

			String sql_02v = "select b.fun_name,a.* from t_funtest_tc a inner join t_funtest_fun b on b.fun_code=a.fun_code where 1=1 and b.fun_code='" + fun_codev + "' and a.tc_code='" + tc_codev
					+ "'";
			DefaultTableModel dtm_02v = ProjectDatabase.query_data(sql_02v);
			String fun_namev = fun_codev;
			String tc_namev = "<p><b>(" + fun_codev + "." + tc_codev + ")";
			if (dtm_02v.getRowCount() > 0) {
				fun_namev = HandleDatabase.get_string(dtm_02v, 0, "fun_name");
				tc_namev = tc_namev + " <b>【用例描述】</b>" + HandleDatabase.get_string(dtm_02v, 0, "tc_path") + ": " + HandleDatabase.get_string(dtm_02v, 0, "tc_summary") + ". <b>【预期结果】</b>"
						+ HandleDatabase.get_string(dtm_02v, 0, "expect_result") + "</p>";
			} else {
				tc_namev = tc_namev + "</p>";
			}
			String log_history_resultv = "<b>测试结果</b>：测试" + HandleUdc.get_udc_value("log_status", log_resultv) + ". " + HandleDatabase.get_string(dtm_02, j, "memo") + "";
			double log_timev = HandleDatabase.get_double(dtm_02, j, "log_time");
			String colorv = "#999999";
			if (log_resultv.equals("running")) {
				colorv = "#333333";
			} else if (log_resultv.equals("pass")) {
				colorv = "#009900";
			} else if (log_resultv.equals("fail")) {
				colorv = "#ff0000";
			}
			context = DealString.addline(context, "<tr style='height:40px;'>");
			context = DealString.addline(context, "<td style='border:solid 1px #999999; text-align:center;'><span style='color:" + colorv + ";'>" + DealString.intFormat(pos, 3) + "</span></td>");
			context = DealString.addline(context, "<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px;'><span style='color:" + colorv + ";'>" + fun_namev + "</span></td>");
			context = DealString.addline(context,
					"<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px; word-wrap:break-word; word-break:break-all; white-space:pre-wrap;'><span style='color:" + colorv + ";'>"
							+ tc_namev + "</span></td>");
			context = DealString.addline(context,
					"<td style='border:solid 1px #999999; padding-left:5px; padding-right:5px; word-wrap:break-word; word-break:break-all; white-space:pre-wrap;'><span style='color:" + colorv + ";'>"
							+ log_history_resultv + "</span></td>");
			context = DealString.addline(context,
					"<td style='border:solid 1px #999999; text-align:right; padding-left:5px; padding-right:5px;'><span style='color:" + colorv + ";'>" + log_timev + "</span></td>");
			context = DealString.addline(context, "</tr>");
			pos++;
		}
		context = DealString.addline(context, "</table>");
		context = DealString.addline(context, "<p style='height:20px; font-size:14px;'>");
		context = DealString.addline(context, "如您需要查看更多信息，请访问<a href='" + ProjectParam.get_param("atmv_url") + "'>自动化测试管理平台</a>。");
		context = DealString.addline(context, "</p>");
		return context;
	}

	public final static void update_statics(String log_id) {
		String sql_01 = "SELECT a.* FROM t_funtest_log_history a WHERE 1=1 AND a.log_result='pass'";
		if (log_id.length() > 0) {
			sql_01 = sql_01 + " AND a.log_id='" + log_id + "'";
		}
		sql_01 = sql_01 + " ORDER BY a.fun_code ASC,a.tc_code ASC,a.firetime_start ASC,a.log_detail_id ASC";
		DefaultTableModel dtm_01 = ProjectDatabase.query_data(sql_01);

		HashMap hm = new HashMap();
		hm.put("run_flag", '0');
		String sql_02 = DealDatabase.getModifySql("t_funtest_tc", hm, "1=1");
		ProjectDatabase.edit_data(sql_02);

		int total_num = dtm_01.getRowCount();
		String[] sqlvs = new String[total_num];
		for (int i = 0; i < total_num; i++) {
			String fun_codev = HandleDatabase.get_string(dtm_01, i, "fun_code");
			String tc_codev = HandleDatabase.get_string(dtm_01, i, "tc_code");
			HashMap hmv = new HashMap();
			hmv.put("run_flag", '1');
			sqlvs[i] = DealDatabase.getModifySql("t_funtest_tc", hmv, "fun_code='" + fun_codev + "' AND tc_code='" + tc_codev + "'");
		}
		ProjectDatabase.bat_edit_data(sqlvs);
	}

}