function get_path() {
	var path_url = window.document.location.href;
	var path_name = window.document.location.pathname;
	var pos = path_url.indexOf(path_name);
	var path_host = path_url.substring(0, pos);
	var project_path = path_name.substring(0, path_name.substr(1).indexOf('/') + 1);
	return project_path;
}
function go_url(url) {
	window.location.href = url;
	return false;
}
function go_url(url) {
	window.location.href = url;
	return false;
}
function go_main(url) {
	window.top.location.href = url;
	return false;
}
function go_rightup(url) {
	window.top.document.getElementById("content").rows = "100%,0%";
	window.top.frame_rightup.location.href = url;
	return false;
}
function go_rightdown(url) {
	window.top.document.getElementById("content").rows = "60%,40%";
	window.top.frame_rightdown.location.href = url;
	return false;
}
function frame_max() {
	window.top.document.getElementById("content").rows = "100%,0%";
	return false;
}
function frame_min() {
	window.top.document.getElementById("content").rows = "60%,40%";
	return false;
}
function go_list(url) {
	window.top.frame_rightup.location.href = url;
	return false;
}
function open_url(url) {
	window.open(url);
	return false;
}
function post_submit(name, action, target) {
	var targetForm = document.forms[name];
	targetForm.action = action;
	targetForm.target = target;
	if (target == 'frame_rightup') {
		window.top.document.getElementById("content").rows = "100%,0%";
	}
	if (target == 'frame_rightdown') {
		window.top.document.getElementById("content").rows = "60%,40%";
	}
	targetForm.submit();
	return false;
}
function post_submit_array(name, action, target, input_array) {
	var targetForm = document.forms[name];
	targetForm.action = "javascript:;";
	var $form = $('<form action="' + action + '" target="' + target + '" method="POST"></form>');
	var html = "";
	for (var i = 0; i < input_array.length; i++) {
		html += '<input type="hidden" name="' + input_array[i].name + '" value="' + input_array[i].value + '">'
	}
	$form.append(html);
	$form.appendTo('body');
	$form.submit();
	return false;
}
function select_all(id, names) {
	var checked = document.getElementById(id).checked;
	var selvs = document.getElementsByName(names);
	for (var i = 0; i < selvs.length; i++) {
		selvs[i].checked = checked;
	}
	return false;
}
function go_back() {
	history.go(-1);
	return false;
}
function get_lastfix(filepath) {
	var pos1 = filepath.lastIndexOf(".");
	var pos2 = filepath.length;
	var lastfix = filepath.substring(pos1, pos2);
	return lastfix;
}