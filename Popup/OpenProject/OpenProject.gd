extends "res://Popup/Popup.gd"

signal directory_selected
signal file_selected


func _ready():
	$"FileDialog".visible = true


func set_path(path):
	$"FileDialog".current_dir = path
	# Yielding to let file list load.
	yield(self, "tree_entered")
	yield(get_tree(), "idle_frame")
	$"FileDialog".invalidate()

func set_allow_cancel(value):
	if not value:
		$"FileDialog".get_close_button().visible = false
		$"FileDialog".get_cancel().visible = false


func set_mode(mode):
	$"FileDialog".mode = mode
	if mode == FileDialog.MODE_SAVE_FILE:
		$"FileDialog".add_filter("*tree")
		$"FileDialog".get_ok().text = "New/Open"


func _on_FileDialog_dir_selected(dir):
	emit_signal("directory_selected", dir)
	queue_free()


func _on_FileDialog_visibility_changed():
	if $"FileDialog".visible == false:
		queue_free()


func _on_FileDialog_file_selected(path):
	emit_signal("file_selected", path)
	queue_free()