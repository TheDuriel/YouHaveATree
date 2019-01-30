extends GraphNode


func get_save_data():
	return "no save func set"


func _on_TreeNode_close_request():
	delete_self()


func _input(event):
	if event is InputEventKey and event.scancode == KEY_DELETE and event.pressed:
		if selected and not $"M".get_child(0).has_focus():
			get_parent().selected_node = false
			delete_self()
			accept_event()


func delete_self():
	Global.unsaved_changes = true
	get_parent().remove_node_connections(self.name)
	queue_free()