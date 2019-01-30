extends Node

onready var tree = get_parent()

var dragging = false


func _on_Tree_gui_input(event):
	if event is InputEventMouseButton:
		
		# TODO: find hotkey not in use by graphedit
#		if event.button_index == BUTTON_WHEEL_UP and Input.is_key_pressed(KEY_SHIFT):
#			tree.zoom = clamp(tree.zoom + 0.1, 0.6, 1.7)
#			get_tree().set_input_as_handled()
#		elif event.button_index == BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_SHIFT):
#			tree.zoom = clamp(tree.zoom - 0.1, 0.6, 1.7)
#			get_tree().set_input_as_handled()
		
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				dragging = true
			else:
				dragging = false
			get_tree().set_input_as_handled()
		
		if event.button_index == BUTTON_LEFT:
			if Input.is_key_pressed(KEY_SHIFT) and event.pressed:
				tree.spawn_node(0, tree.scroll_offset + tree.get_local_mouse_position())
			
			elif Input.is_key_pressed(KEY_CONTROL) and event.pressed:
				tree.spawn_node(1, tree.scroll_offset + tree.get_local_mouse_position())
	
	if event is InputEventMouseMotion:
		if dragging:
			tree.scroll_offset += -event.relative
			get_tree().set_input_as_handled()