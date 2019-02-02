extends Node

signal changes_saved
signal changes_unsaved
signal directories_edited
signal project_dir_changed
signal current_tree_dir_changed

const default_project_folder = "default_project/"

onready var tree = get_tree_editor()

var default_project_dir = get_default_project_dir()
var project_dir
var current_tree_dir
var tree_history = []

var unsaved_changes = false setget set_unsaved_changes
var popup


func _ready():
	var pop = open_folder_dialogue(default_project_dir, FileDialog.MODE_OPEN_DIR, false)
	project_dir = yield(pop, "directory_selected")
	emit_signal("project_dir_changed")
	open_tree("root.tree")


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_project()
		get_tree().quit()


func get_tree_editor():
	var group_nodes = get_tree().get_nodes_in_group("trees")
	if not group_nodes.empty():
		return group_nodes[0]


func get_default_project_dir():
	if OS.is_debug_build():
		return "res://" + default_project_folder
	else:
		return OS.get_executable_path().get_base_dir().plus_file(default_project_folder)


func set_unsaved_changes(new_value):
	unsaved_changes = new_value
	if unsaved_changes:
		emit_signal("changes_unsaved")
	else:
		emit_signal("changes_saved")


func save_project():
	# {connections : [[from, to]], nodes : [[name, offset, data]}
	var save_data = tree.save_tree()
	
	# TODO: backup file if last change over one minute ago.
	
	var file = File.new()
	var error = file.open(current_tree_dir, File.WRITE)
	
	if not error == OK:
		printt("ERROR: Could not save file.", error)
	else:
		file.store_var(save_data)
		file.close()


func open_folder_dialogue(path, mode, allow_cancel = true):
	var p = preload("res://Popup/OpenProject/OpenProject.tscn").instance()
	
	p.set_as_toplevel(true)
	p.set_path(path)
	p.set_mode(mode)
	p.set_allow_cancel(allow_cancel)
	if $"/root/Main":
		$"/root/Main".add_child(p)
	return p


func open_tree(relative_path):
	if unsaved_changes:
		save_project()
	
	var path = project_dir.plus_file(relative_path)
	
	if path == current_tree_dir:
		return
	
	tree.close_tree()
	
	var f = File.new()
	
	if not f.file_exists(path):
		f.open(path, File.WRITE)
		f.store_var({"nodes" : [], "connections" : []})
		f.close()
	
	var error = f.open(path, File.READ)
	
	if not error == OK:
		print(error)
		return
	
	current_tree_dir = path
	
	var data = f.get_var()
	tree.open_tree(data)
	
	tree_history.push_front(relative_path)
	emit_signal("current_tree_dir_changed", relative_path)


func go_to_previous_tree():
	if not tree_history.empty():
		var prev_tree = tree_history[-1]
		tree_history.pop_back()
		open_tree(prev_tree)