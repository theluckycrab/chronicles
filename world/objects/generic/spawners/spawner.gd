class_name Spawner
extends KinematicBody

var net_stats = NetStats.new("spawner")
export(String) var index = "target_dummy"
export(PackedScene) onready var pattern = preload("res://world/objects/generic/spawners/patterns/point.tscn").instance()
onready var host = get_parent()
var viewers = 0 setget set_viewers
var has_spawned = false

func _ready():
	net_stats.original_instance_id = get_instance_id()
	net_stats.register()
	
		
func on_register():
	if net_stats.is_dummy:
		queue_free()
	else:
		spawn()

func retrieve_data(_i):
	Data.get_reference_instance(index)
	pass


func spawn():
	if Network.map_masters[Network.map] == Network.get_nid() \
			and !has_spawned:
		has_spawned = true
		#print("spawning")
		var object = Data.get_reference_instance(index)
		get_viewport().add_child(object)
		object.global_transform.origin = global_transform.origin
		object.rotation = rotation
		net_stats.unregister()

func set_viewers(v):
	viewers = v
	spawn()
	pass
