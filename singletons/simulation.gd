extends Node

var current_scene = null


func _ready():
	var _discard = Events.connect("scene_change_request", self, "switch_scene")

func switch_scene(scene:String ) -> void:
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	current_scene = load("res://scenes/"+scene.to_lower()+".tscn")
	if is_instance_valid(current_scene):
		current_scene = current_scene.instance()
		add_child(current_scene)
	else:
		print("[SceneManager] tried to switch to a scene that does not exist.")
		
func get_map():
	return current_scene
	
func get_map_name():
	return current_scene.name

func parse_npc(args):
	current_scene.parse_npc(args)

func spawn(object, location):
	var args = {"uuid":get_map_name(), 
			"function":"spawn", 
			"object":object.as_dict(), 
			"position":location}
	if object.name.is_valid_integer():
		args["unit_uuid"] = object.name
	Server.npc(args)
