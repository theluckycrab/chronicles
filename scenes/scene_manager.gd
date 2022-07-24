extends Spatial

export(String) var start_scene = "login_menu"
var current_scene = null
onready var mount = $SceneMount

func _ready():
	change_scene(start_scene)
	$Terminal.connect("text_entered", self, "on_terminal_entry")
	
func change_scene(scene) -> void:
	unload_current()
	var nscene = load("res://scenes/"+scene+"/"+scene+".tscn").instance()
	mount.add_child(nscene)
	current_scene = nscene
	
func unload_current() -> void:
	for i in mount.get_children():
		i.queue_free()
		
func spawn_new_player(who, where):
	current_scene.spawn_new_player(who, where)
	
func despawn_player(who):
	current_scene.despawn_player(who)

func update_world_state(world_state):
	current_scene.update_world_state(world_state)

func on_terminal_entry(history, current_line):
	var text = current_line.split(" ")
	var command = text[0]
	text.remove(0)
	match command:
		"quit":
			get_tree().quit()
		"print":
			print(text)
