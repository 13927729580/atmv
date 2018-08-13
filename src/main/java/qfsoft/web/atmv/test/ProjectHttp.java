package qfsoft.web.atmv.test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;

import qfsoft.library.common.defclass.auto.HttpAction;
import qfsoft.library.common.defclass.datatype.HttpParam;
import qfsoft.library.common.defclass.datatype.IntString;
import qfsoft.library.common.defclass.web.HttpResult;
import qfsoft.library.common.method.DealString;
import qfsoft.library.common.util.CommonMethod;

public class ProjectHttp {

	public final static IntString send_get(String url, HashMap<String, String> header) throws Exception {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		HttpAction ha = new HttpAction();
		HttpGet httpreq = ha.getGet(url);
		HttpResult httpresult = ha.sendGet(httpreq, header, null, null, null);
		String response = DealString.getString(httpresult.httpresp.getEntity().getContent());
		ha.closeResponse(httpresult.httpresp);
		ha.end();
		IntString result = new IntString(httpresult.code, response);
		return result;
	}

	public final static IntString send_get(String url, String[] param_keys, String[] param_values) throws Exception {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		for (int i = 0; i < param_keys.length; i++) {
			if (!url.contains("?") && i == 0) {
				url = url + "?" + param_keys[i] + "=" + param_values[i];
			} else {
				url = url + "&" + param_keys[i] + "=" + param_values[i];
			}
		}
		IntString result = ProjectHttp.send_get(url, null);
		return result;
	}

	public final static IntString send_post(String url, HashMap<String, String> header, List<NameValuePair> inputs) throws Exception {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		HttpAction ha = new HttpAction();
		HttpPost httpreq = ha.getPost(url);
		HttpResult httpresult = ha.sendPost(httpreq, header, inputs, null, null, null);
		String response = DealString.getString(httpresult.httpresp.getEntity().getContent());
		ha.closeResponse(httpresult.httpresp);
		ha.end();
		IntString result = new IntString(httpresult.code, response);
		return result;
	}

	public final static IntString send_post(String url, String[] param_keys, String[] param_values) throws Exception {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		ArrayList<NameValuePair> inputs = new ArrayList<NameValuePair>();
		for (int i = 0; i < param_keys.length; i++) {
			inputs.add(new HttpParam(param_keys[i], param_values[i]));
		}
		IntString result = ProjectHttp.send_post(url, null, inputs);
		return result;
	}

	public final static IntString send_json(String url, HashMap<String, String> header, String param) throws Exception {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		HttpAction ha = new HttpAction();
		HttpPost httpreq = ha.getPost(url);
		HttpResult httpresult = ha.sendApi(httpreq, header, param, null, null, null);
		String response = DealString.getString(httpresult.httpresp.getEntity().getContent());
		ha.closeResponse(httpresult.httpresp);
		ha.end();
		IntString result = new IntString(httpresult.code, response);
		return result;
	}

	public final static IntString send_json(String url, String[] param_keys, String[] param_values) throws Exception {
		boolean is_ok = CommonMethod.verify();
		if (!is_ok) {
			return null;
		}
		String param = null;
		for (int i = 0; i < param_keys.length; i++) {
			if (param_keys[i].equals("data")) {
				param = param_values[i];
			}
		}
		HashMap<String, String> header = new HashMap<String, String>();
		header.put("Content-Type", "application/json");
		IntString result = ProjectHttp.send_json(url, header, param);
		return result;
	}

}
