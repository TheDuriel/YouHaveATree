extends PanelContainer

onready var project_label = $"H/Project"
onready var file_label = $"H/File"


func _init():
	Global.connect("project_dir_changed", self, "_on_project_dir_changed")
	Global.connect("current_tree_dir_changed", self, "_on_current_tree_dir_changed")


func _on_project_dir_changed():
	project_label.text = "Project: " + Global.project_dir


func _on_current_tree_dir_changed(new_dir):
	file_label.text = "File: " + new_dir