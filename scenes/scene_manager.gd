extends Spatial

export(String) var start_scene = "login_menu"
var current_scene = null
onready var mount = $SceneMount

func _ready():
	change_scene(start_scene)
	
func change_scene(scene) -> void:
	unload_current()
	var nscene = load("res://scenes/"+scene+"/"+scene+".tscn").instance()
	mount.add_child(nscene)
	current_scene = nscene
	
func unload_current() -> void:
	for i in mount.get_children():
		i.queue_free()
