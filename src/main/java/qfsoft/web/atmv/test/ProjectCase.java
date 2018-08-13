package qfsoft.web.atmv.test;

import javax.swing.table.DefaultTableModel;

import org.json.JSONException;
import org.json.JSONObject;

import qfsoft.library.common.method.DealString;
import qfsoft.library.common.method.DealTable;
import qfsoft.library.common.util.CommonMethod;
import qfsoft.library.web.method.HandleDatabase;
import qfsoft.web.atmv.method.ProjectDatabase;

public class ProjectCase {

	public final static DefaultTableModel get_tc(String tc_id) {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		String sql = "SELECT * FROM t_funtest_tc WHERE 1=1 AND tc_id='" + tc_id + "'";
		DefaultTableModel dtm = ProjectDatabase.query_data(sql);
		return dtm;
	}

	public final static DefaultTableModel get_fun(String fun_code) {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		String sql = "SELECT * FROM t_funtest_fun WHERE 1=1 AND fun_code='" + fun_code + "'";
		DefaultTableModel dtm = ProjectDatabase.query_data(sql);
		return dtm;
	}

	public final static DefaultTableModel get_api(String api_name) {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		String sql = "SELECT * FROM t_funtest_api WHERE 1=1 AND api_name='" + api_name + "'";
		DefaultTableModel dtm = ProjectDatabase.query_data(sql);
		return dtm;
	}

	public final static DefaultTableModel get_object(String object_name) {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		String sql = "SELECT * FROM t_funtest_object WHERE 1=1 AND object_name='" + object_name + "'";
		DefaultTableModel dtm = ProjectDatabase.query_data(sql);
		return dtm;
	}

	public final static String get_object_value(String object_name) {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		DefaultTableModel dtm = get_object(object_name);
		String value = null;
		if (dtm.getRowCount() == 1) {
			value = DealTable.getString(dtm, 0, "object_value");
		}
		return value;
	}

	public final static DefaultTableModel get_action(String action_type) {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		String sql = "SELECT * FROM t_funtest_action WHERE 1=1 AND last_status='enabled' AND action_type='" + action_type + "' ORDER BY action_name";
		DefaultTableModel dtm = ProjectDatabase.query_data(sql);
		return dtm;
	}

	public final static DefaultTableModel get_action(String action_type, String action_code) {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		String sql = "SELECT * FROM t_funtest_action WHERE 1=1 AND last_status='enabled' AND action_type='" + action_type + "' AND action_code='" + action_code + "'";
		DefaultTableModel dtm = ProjectDatabase.query_data(sql);
		return dtm;
	}

	public final static String get_action_key(String action_type, String action_code) {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		DefaultTableModel dtm = get_action(action_type, action_code);
		String value = null;
		if (dtm.getRowCount() == 1) {
			value = DealTable.getString(dtm, 0, "action_key");
		}
		return value;
	}

	public final static String gen_scripts(String tc_id) {
		String script = "";
		String sql = "select a.* from t_funtest_tc_step a where 1=1 and a.tc_id='" + tc_id + "' order by a.seq";
		DefaultTableModel dtm = ProjectDatabase.query_data(sql);
		for (int i = 0; i < dtm.getRowCount(); i++) {
			String stepv = HandleDatabase.get_string(dtm, i, "seq");
			String action_typev = HandleDatabase.get_string(dtm, i, "action_type");
			String action_codev = HandleDatabase.get_string(dtm, i, "action_code");
			String action_keyv = HandleDatabase.get_string(dtm, i, "action_key");
			String action_valuev = HandleDatabase.get_string(dtm, i, "action_value");
			String scriptv = gen_step(stepv, action_typev, action_codev, action_keyv, action_valuev);
			script = DealString.addline(script, scriptv);
		}
		return script;
	}

	public final static String gen_step(String stepv, String action_typev, String action_codev, String action_keyv, String action_valuev) {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		String script = "";
		JSONObject jsonv = new JSONObject(action_valuev);
		if (action_typev.equals("base")) {
			if (action_codev.equals("testdata")) {
				String codev = jsonv.getString("code");
				String paramv = jsonv.getString("param");
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", (new TestCase_" + codev + "(ted, 0, new JSONObject(" + paramv + "))).test_exec());";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("testfun")) {
				String codev = jsonv.getString("code");
				String paramv = jsonv.getString("param");
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", (new TestCase_" + codev + "(ted, 0, new JSONObject(" + paramv + "))).test_exec());";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("set_param")) {
				String keyv = decode(jsonv.getString("key"));
				String valuev = decode(jsonv.getString("value"));
				String scriptv = "ted.params.put(\"" + keyv + "\", \"" + valuev + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("query_server")) {
				String db_namev = decode(jsonv.getString("db_name"));
				String sqlv = decode(jsonv.getString("sql"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", CommonMethod.query_server(" + db_namev + ", \"" + sqlv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("edit_server")) {
				String db_namev = decode(jsonv.getString("db_name"));
				String sqlv = decode(jsonv.getString("sql"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", CommonMethod.edit_server(" + db_namev + ", \"" + sqlv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("run_shell")) {
				String ipv = decode(jsonv.getString("ip"));
				int portv = Integer.parseInt(decode(jsonv.getString("port")));
				String userv = decode(jsonv.getString("user"));
				String pwdv = decode(jsonv.getString("pwd"));
				String cmdv = decode(jsonv.getString("cmd"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", DealSSH.run_cmd(\"" + ipv + "\", " + portv + ", \"" + userv + "\", DealSecret.deBASE64(\"" + pwdv
						+ "\", \"UTF-8\"), \"" + cmdv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("check_equals")) {
				String namev = decode(jsonv.getString("name"));
				String expectv = decode(jsonv.getString("expect"));
				String realv = decode(jsonv.getString("real"));
				String scriptv = "CommonMethod.check_equals(\"" + namev + "\", \"" + expectv + "\", \"" + realv + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("check_match")) {
				String namev = decode(jsonv.getString("name"));
				String expectv = decode(jsonv.getString("expect"));
				String realv = decode(jsonv.getString("real"));
				String scriptv = "CommonMethod.check_match(\"" + namev + "\", \"" + expectv + "\", \"" + realv + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("waitfor")) {
				int millisecondv = Integer.parseInt(decode(jsonv.getString("millisecond")));
				String scriptv = "FrameworkMethod.waitfor(" + millisecondv + ");";
				script = DealString.concat(script, scriptv);
			}
		}
		if (action_typev.equals("selenium")) {
			if (action_codev.equals("visit")) {
				String urlv = decode(jsonv.getString("url"));
				String scriptv = "SeleniumMethod.visit(ted, \"" + urlv + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("visit_exist")) {
				String urlv = decode(jsonv.getString("url"));
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "SeleniumMethod.visitForExist(ted, \"" + urlv + "\", FrameworkMethod.get_object_value(\"" + objectv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("click")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "SeleniumMethod.click(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("set_text")) {
				String objectv = decode(jsonv.getString("object"));
				String valuev = decode(jsonv.getString("value"));
				String scriptv = "SeleniumMethod.setText(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"), \"" + valuev + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("get_text")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", SeleniumMethod.getText(ted, FrameworkMethod.get_object_value(\"" + objectv + "\")));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("get_text2")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", SeleniumMethod.getText(ted, \"FrameworkMethod.get_object_value(\"" + objectv
						+ "\")\").replace(\"\\r\", \"\").replace(\"\\n\", \"\").replace(\" \", \"\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("select")) {
				String objectv = decode(jsonv.getString("object"));
				String valuev = decode(jsonv.getString("value"));
				String scriptv = "SeleniumMethod.select(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"), \"" + valuev + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("set")) {
				String objectv = decode(jsonv.getString("object"));
				String valuev = decode(jsonv.getString("value"));
				String scriptv = "SeleniumMethod.set(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"), \"" + valuev + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("upload")) {
				String objectv = decode(jsonv.getString("object"));
				String filepathv = decode(jsonv.getString("filepath"));
				String scriptv = "SeleniumMethod.upload(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"), \"" + filepathv + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("set_prompt")) {
				String valuev = decode(jsonv.getString("value"));
				String scriptv = "SeleniumMethod.setPrompt(ted, \"" + valuev + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("refresh")) {
				String scriptv = "SeleniumMethod.refresh(ted);";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("event")) {
				String objectv = decode(jsonv.getString("object"));
				String eventv = decode(jsonv.getString("event"));
				String scriptv = "SeleniumMethod.event(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"), \"" + eventv + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("eventjs")) {
				String jscriptv = decode(jsonv.getString("jscript"));
				String scriptv = "SeleniumMethod.eventjs(ted, \"" + jscriptv + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("view")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "SeleniumMethod.view(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("go_mainframe")) {
				String scriptv = "SeleniumMethod.goMainframe(ted);";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("go_window")) {
				String urlv = decode(jsonv.getString("url"));
				String scriptv = "SeleniumMethod.goWindow(ted, \"" + urlv + "\");";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("close_window")) {
				String scriptv = "SeleniumMethod.closeWindow(ted);";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("waitfor_exist")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "SeleniumMethod.waitforExist(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("waitfor_exist_short")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "SeleniumMethod.waitforExistShort(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("waitfor_not_exist")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "SeleniumMethod.waitforNotExist(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("waitfor_not_exist_short")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "SeleniumMethod.waitforNotExistShort(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("is_waitfor_exist")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", SeleniumMethod.isWaitforExist(ted, FrameworkMethod.get_object_value(\"" + objectv + "\")));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("is_waitfor_exist_short")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", SeleniumMethod.isWaitforExistShort(ted, FrameworkMethod.get_object_value(\"" + objectv + "\")));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("is_waitfor_enable")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", SeleniumMethod.isWaitforEnable(ted, FrameworkMethod.get_object_value(\"" + objectv + "\")));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("get_attri")) {
				String objectv = decode(jsonv.getString("object"));
				String attriv = decode(jsonv.getString("attri"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", SeleniumMethod.getAttri(ted, FrameworkMethod.get_object_value(\"" + objectv + "\"), \"" + attriv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("get_units")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", SeleniumMethod.getUnits(ted, FrameworkMethod.get_object_value(\"" + objectv + "\")));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("get_table")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", SeleniumMethod.getTable(ted, FrameworkMethod.get_object_value(\"" + objectv + "\")));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("input_text")) {
				String valuev = decode(jsonv.getString("value"));
				String scriptv = "SeleniumMethod.inputText(ted, \"" + valuev + "\");";
				script = DealString.concat(script, scriptv);
			}
		}
		if (action_typev.equals("http")) {
			if (action_codev.equals("send_get")) {
				String urlv = decode(jsonv.getString("url"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", HttpMethod.send_get(ted, \"" + urlv + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("send_post")) {
				String url = decode(jsonv.getString("url"));
				String param = decode(jsonv.getString("param"));
				script = DealString.concat(script, "ArrayList<NameValuePair> input = new ArrayList<NameValuePair>();");
				String[] params = param.split("\r\n");
				for (int i = 0; i < params.length; i++) {
					if (params[i].trim().length() == 0) {
						continue;
					}
					int split = params[i].indexOf("=");
					String key = params[i].substring(0, split).trim();
					String value = decode(params[i].substring(split + 1, params[i].length()).trim());
					script = DealString.concat(script, "input.add(new HttpParam(\"" + key + "\", \"" + value + "\"));");
				}
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", HttpMethod.send_post(ted, \"" + url + "\", input));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("invoke_dubbo")) {
				String ip = decode(jsonv.getString("ip"));
				int port = Integer.parseInt(decode(jsonv.getString("port")));
				String cmd = decode(jsonv.getString("cmd"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", HttpMethod.invoke_dubbo(\"" + ip + "\", " + port + ", \"" + cmd + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("is_exist")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", HttpMethod.isExist(ted, FrameworkMethod.get_object_value(\"" + objectv + "\")));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("get_text")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", HttpMethod.getText(ted, FrameworkMethod.get_object_value(\"" + objectv + "\")));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("get_text2")) {
				String objectv = decode(jsonv.getString("object"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", HttpMethod.getText(ted, \"FrameworkMethod.get_object_value(\"" + objectv
						+ "\")\").replace(\"\\r\", \"\").replace(\"\\n\", \"\").replace(\" \", \"\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("get_params")) {
				String left = decode(jsonv.getString("left"));
				String right = decode(jsonv.getString("right"));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", HttpMethod.getParams(ted, \"" + left + "\", \"" + right + "\"));";
				script = DealString.concat(script, scriptv);
			}
			if (action_codev.equals("get_param")) {
				String left = decode(jsonv.getString("left"));
				String right = decode(jsonv.getString("right"));
				int pos = Integer.parseInt(decode(jsonv.getString("pos")));
				String scriptv = "FrameworkCache.params.put(\"STEP" + stepv + "\", HttpMethod.getParam(ted, \"" + left + "\", \"" + right + "\", " + pos + "));";
				script = DealString.concat(script, scriptv);
			}
		}
		return script;
	}

	public final static String decode(String value) throws JSONException {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		String[] params = DealString.getParams(value, "${", "}");
		for (int i = 0; i < params.length; i++) {
			if (params[i].startsWith("param(")) {
				String keyv = DealString.getParam(params[i], "(", ")", 0);
				String valuev = "FrameworkCache.params.get(\"" + keyv.trim() + "\")";
				value = value.replace("${" + params[i] + "}", valuev);
			}
			if (params[i].startsWith("paramv(")) {
				String keyv = DealString.getParam(params[i], "(", ")", 0);
				String valuev = "ted.params.get(\"" + keyv.trim() + "\")";
				value = value.replace("${" + params[i] + "}", valuev);
			}
			if (params[i].startsWith("nowdate(")) {
				String valuev = "\"+DealDate.getNowDateStr()+\"";
				value = value.replace("${" + params[i] + "}", valuev);
			}
			if (params[i].startsWith("nowtime(")) {
				String valuev = "\"+DealDate.getNowTimeStr()+\"";
				value = value.replace("${" + params[i] + "}", valuev);
			}
		}
		return value;
	}

}