extends Spatial

export(String) var start_scene = "main_menu"
var current_scene = null
onready var mount = $SceneMount


func _ready() -> void:
	var _discard = Events.connect("scene_change_request", self, "on_scene_change_request")
	change_scene({}, {}, start_scene)


func on_scene_change_request(scene: String) -> void:
	print("Scene Request: ", scene)
	unload_current(scene)
	get_history(scene)


func unload_current(next_scene) -> void:
	for i in mount.get_children():
		i.queue_free()
		
	for i in Network.net_objects:
		if is_instance_valid(Network.net_objects[i]):
			Network.net_objects[i].queue_free()
			
	Network.net_objects.clear()
	Network.command_history.clear()
	
	if "town" in next_scene:
		print("clearing inventories")
		Data.clear_char_equipped()
		Data.clear_char_inventory()
	Data.full_save()
	
	
func get_history(scene: String) -> void:
	var _discard = Network.connect("history_received", self, "on_history_received",[], CONNECT_ONESHOT)
	Network.rpc_id(1, "request_history", scene)


func on_history_received(history, commands, masters, tmap) -> void:
	Network.map_masters = masters.duplicate(true)
	Network.map = tmap
	if "town" in tmap:
		Data.save_char_value("map", tmap)
	Data.full_save()
	change_scene(history, commands, tmap)


func change_scene(history, commands, tmap) -> void:
	var nscene = load("res://world/scenes/"+tmap+"/"+tmap+".tscn").instance()
	mount.add_child(nscene)
	current_scene = nscene
	play_history(history, commands)
	Events.emit_signal("console_print", "Scene has changed to " + tmap)
	

func play_history(history, commands):
	for i in history:
		Network.on_register(history[i])
	for i in commands:
		if Network.net_objects.has(commands[i].sender):
			if is_instance_valid(Network.net_objects[commands[i].sender]):
				Network.net_objects[commands[i].sender].call_deferred(commands[i].command, commands[i])

