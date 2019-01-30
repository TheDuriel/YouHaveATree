extends GraphEdit


const TextNode = preload("res://TreeNode/TextNode/TextNode.tscn")
const WindowNode = preload("res://TreeNode/WindowNode/WindowNode.tscn")

onready var my_group = str(get_instance_id()) + "_node"

var selected_node = false

func _ready():
	add_valid_connection_type(0, 0)
	add_valid_right_disconnect_type(0)


func _on_Tree_connection_request(from, from_slot, to, to_slot):
	if from != to:
		connect_node(from, from_slot, to, to_slot)
		Global.unsaved_changes = true


func _on_Tree_disconnection_request(from, from_slot, to, to_slot):
	if from != to:
		disconnect_node(from, from_slot, to, to_slot)
		Global.unsaved_changes = true


func spawn_node(type, position, from = false):
	if not from:
		if selected_node and selected_node.selected:
			from = selected_node.name
	
	var n
	if type == 0:
		n = TextNode.instance()
	elif type == 1:
		n = WindowNode.instance()
	
	if n:
		add_child(n)
		n.add_to_group(my_group)
		n.offset = position
		
		if from:
			connect_node(from, 0, n.name, 0)
	
	Global.unsaved_changes = true
	return n


func _on_Tree_node_selected(node):
	selected_node = node


func remove_node_connections(node_name):
	for i in get_connection_list():
		if i.from == node_name or i.to == node_name:
			disconnect_node(i.from, 0, i.to, 0)


func save_tree():
	var connections = []
	for i in get_connection_list():
		connections.append([i.from.replace("@", ""), i.to.replace("@", "")])
	
	var nodes = []
	for i in get_tree().get_nodes_in_group(my_group):
		var save_data = i.get_save_data()
		save_data[0] = save_data[0].replace("@", "")
		nodes.append(i.get_save_data())
	
	return {"connections" : connections, "nodes" : nodes}


func open_tree(data):
	var nodes = data.nodes
	
	for i in nodes:
		var n = spawn_node(i[1], i[2])
		n.name = i[0]
		n.set_data(i[3])
	
	var connections = data.connections
	for i in connections:
		connect_node(i[0], 0, i[1], 0)


func close_tree():
	for i in get_connection_list():
		disconnect_node(i.from, 0, i.to, 0)
	
	for i in get_tree().get_nodes_in_group(my_group):
		i.queue_free()
	
	selected_node = false