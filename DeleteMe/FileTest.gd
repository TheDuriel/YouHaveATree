extends Node

var F = File.new()

var dummy_data = {
		"meta" : {
				"camera_position" : Vector2(128, 0),
				},
		"connections" : [
					["node_a", "node_b"],
				],
		"nodes" : [
					{
						"name" : "node_a", 
						"type" : 0, 
						"position" : Vector2(0, 0), 
						"data" : """some 
text"""
					},
					{
						"name" : "node_b", 
						"type" : 0, 
						"position" : Vector2(256, 0), 
						"data" : "some text"
					},
				]
		}


var file_path = "res://DeleteMe/testtree.tree"


func _ready():
	#write_file(dummy_data)
	read_file(file_path)


func write_file(tree_data):
	var error = F.open(file_path, File.WRITE)
	if error != OK:
		print(error)
		return
	
	var header = "YouHaveATree .tree file."
	store_line(header)
	
	new_line()
	var meta_header = "###META###"
	store_line(meta_header)
	
	var camera_position = str([tree_data.meta.camera_position.x, tree_data.meta.camera_position.y])
	var camera_string = "camera_position = " + camera_position
	store_line(camera_string)
	
	new_line()
	var connections_header = "###CONNECTIONS###"
	store_line(connections_header)
	
	for connection in tree_data.connections:
		var connection_string = str(connection)
		store_line(connection_string)
	
	new_line()
	var nodes_header = "###NODES###"
	store_line(nodes_header)
	
	for node in tree_data.nodes:
		var node_name = "node_name = " + str(node.name)
		store_line(node_name)
		var node_type = "node_type = " + str(node.type)
		store_line(node_type)
		var node_pos = "node_position = " + str(node.position.floor())
		store_line(node_pos)
		var node_data = str(node.data)
		store_line(node_data.strip_edges())
		new_line()
	
	F.close()


func new_line():
	F.store_line("")
	F.seek_end()

func store_line(text):
	F.store_line(text)
	F.seek_end()


func read_file(file_path):
	var error = F.open(file_path, File.READ)
	if error != OK:
		print(error)
		return
	
	var data = {"meta" : {}, "connections" : [], "nodes" : []}
	
	var current_section = 0
	
	while not F.eof_reached():
		var line = F.get_line()
		
		# Header
		if current_section == 0:
			if line == "###META###":
				current_section = 1
			continue
		
		# Meta
		elif current_section == 1:
			if line == "###CONNECTIONS###":
				current_section = 2
				continue
			
			if line.begins_with("camera_position = "):
				var camera_pos_array = str2var(line.right(18)) # "camera_position = "
				data.meta.camera_position = Vector2(camera_pos_array[0], camera_pos_array[1])
			continue
		
		# Connections
		elif current_section == 2:
			if line == "###NODES###":
				current_section = 3
				continue
			
			if line != "":
				var connection = line.split(", ")
				connection[0] = connection[0].right(1)
				connection[1] = connection[1].left(connection[1].length() - 1)
				data.connections.append(connection)
			continue
		
		# Nodes
		elif current_section == 3:
			if line.begins_with("node_name = "):
				var node = {"name" : null, "type" : null, "position" : null, "data" : null}
				
				node.name = line.right(12) # "node_name = "
				
				node.type = str2var(F.get_line().right(12)) # "node_type = "
				
				var array_pos = F.get_line().right(16) # "node_position = "
				node.position = Vector2(array_pos[0], array_pos[1])
				
				#Node Paragraph
				var previous_position_in_file = F.get_position()
				var paragraph = []
				var next_line = F.get_line()
				
				while not next_line.begins_with("node_name = ") and not F.eof_reached():
					paragraph.append(next_line)
					previous_position_in_file = F.get_position()
					next_line = F.get_line()
				
				F.seek(previous_position_in_file)
				
				node.data = ""
				for i in paragraph:
					node.data += i
				
				data.nodes.append(node)
				continue
	
	print(data.nodes)
	F.close()