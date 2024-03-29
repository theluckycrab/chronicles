extends Node

var current_scene = null

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

func spawn(object, location=Vector3.ZERO, rotation=0):
	var args = {"uuid":get_map_name(), 
			"function":"spawn", 
			"object":object.as_dict(), 
			"position":location,
			"rotation":rotation}
	if object.name.is_valid_integer():
		args["unit_uuid"] = object.name
	Server.npc(args)
	
func despawn(object):
	var args = {"uuid":get_map_name(),
	"function":"despawn",
	"unit":object.name}
	Server.npc(args)
