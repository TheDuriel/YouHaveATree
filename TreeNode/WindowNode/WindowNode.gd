extends "res://TreeNode/TreeNode.gd"

var tree_path


func _on_Button_pressed():
	if not tree_path:
		var pop = Global.open_folder_dialogue(Global.project_dir, FileDialog.MODE_SAVE_FILE)
		tree_path = yield(pop, "file_selected")
		tree_path = tree_path.right(Global.project_dir.length() + 1)
		$"M/Button".text = tree_path.replace(".tree", "") 
		Global.emit_signal("directories_edited")
	
	Global.open_tree(tree_path)


func get_save_data():
	return [self.name, 1, offset, tree_path]


func set_data(data):
	if data:
		tree_path = data
		$"M/Button".text = data.replace(".tree", "") 