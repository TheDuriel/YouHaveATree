extends "res://TreeNode/TreeNode.gd"


func _on_TextEdit_text_changed():
	Global.unsaved_changes = true


func get_save_data():
	return [self.name, 0, offset, $"M/TextEdit".text]

func set_data(data):
	$"M/TextEdit".text = data