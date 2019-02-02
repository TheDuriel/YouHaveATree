extends Tree

var items = {}


func _init():
	Global.connect("project_dir_changed", self, "refresh")
	Global.connect("directories_edited", self, "refresh")
	set_column_expand(0, true)
	


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		refresh()


func refresh():
	clear()
	
	var dir = Directory.new()
	var project_dir = Global.project_dir
	
	var error = dir.open(project_dir)
	if error:
		print("Error: FileBrowser: Opening project_dir at: ", project_dir)
		return
	
	var todo = [project_dir]
	
	while not todo.empty():
		dir.change_dir(todo[0])
		dir.list_dir_begin(true, true)
	
		var file_name = dir.get_next()
		var root = make_item(todo[0])
		
		while file_name != "":
			
			if dir.current_is_dir():
				todo.append(file_name)
			
			else:
				var new_item = make_item(file_name.replace(".tree", ""), root)
				
				# This is ridiculous.
				var item_path = dir.get_current_dir().replace(project_dir, "")
				item_path = item_path.plus_file(file_name)
				
				items[new_item] = item_path
			
			file_name = dir.get_next()
		
		todo.pop_front()


func make_item(item_name, parent_item = null):
	var item = create_item(parent_item)
	item.set_text(0, item_name)
	return item


func _on_FileBrowser_item_activated():
	var selected = get_selected()
	
	if items.keys().has(selected):
		var path = items[get_selected()]
		
		if path.ends_with(".tree"):
			Global.open_tree(path)