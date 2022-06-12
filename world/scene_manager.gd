extends Spatial

export(String) var start_scene = "test_room"
var current_scene = null
onready var mount = $SceneMount


func _ready() -> void:
	var _datscard = Data.connect("data_ready", self, "on_data_ready")
	var _discard = Events.connect("scene_change_request", self, "on_scene_change_request")
	print("Scene Manager ready")
	
	
func on_data_ready() -> void:
	Events.emit_signal("scene_change_request", start_scene)


func change_scene(scene: String) -> void:
	get_tree().paused = true
	for i in mount.get_children():
		i.queue_free()
	yield(get_tree(), "idle_frame")
	Network.command_history.clear()
	Network.net_objects.clear()
	yield(get_tree(), "idle_frame")
	var nscene = load("res://world/scenes/"+scene+"/"+scene+".tscn").instance()
	mount.add_child(nscene)
	current_scene = nscene
	get_tree().paused = false
	Events.emit_signal("console_print", "Scene has changed to " + scene)
	Network.transition(scene)


func on_scene_change_request(scene: String) -> void:
	change_scene(scene)
