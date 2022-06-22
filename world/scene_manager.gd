extends Spatial

export(String) var start_scene = "test_room2"
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
	for i in Network.net_objects:
		if is_instance_valid(Network.net_objects[i]):
			Network.net_objects[i].queue_free()
	Network.command_history.clear()
	Network.net_objects.clear()
	if "town" in scene:
		print("clearing player inventory data")
		Data.clear_char_equipped()
		Data.clear_char_inventory()
		Data.full_save()
	yield(get_tree(), "idle_frame")
	var nscene = load("res://world/scenes/"+scene+"/"+scene+".tscn").instance()
	mount.add_child(nscene)
	current_scene = nscene
	get_tree().paused = false
	Events.emit_signal("console_print", "Scene has changed to " + scene)
	Network.transition(scene)
	print(Data.get_char_data().equipped)


func on_scene_change_request(scene: String) -> void:
	change_scene(scene)
