extends ProgressBar

signal autosaving

onready var T = $"Timer"

var time_elapsed = 0
var wait_time = 1

func _ready():
	Global.connect("changes_unsaved", self, "_on_changes_unsaved")
	set_process(false)


func _process(delta):
	time_elapsed += delta
	
	value = time_elapsed
	
	if time_elapsed <= 0.5:
		modulate.g += delta * 2
	elif time_elapsed >= 0.5:
		modulate.r -= delta * 2
	
	if time_elapsed >= wait_time:
		Global.save_project()
		
		set_process(false)


func _on_changes_unsaved():
	set_process(true)
	time_elapsed = 0
	modulate.r = 1
	modulate.g = 0