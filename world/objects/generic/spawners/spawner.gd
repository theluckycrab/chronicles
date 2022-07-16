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
	if Network.map_masters.has(Network.map) and Network.map_masters[Network.map] == Network.get_nid():
		net_stats.call_deferred("register")
	
		
func on_register():
	spawn()

func retrieve_data(_i):
	Data.get_reference_instance(index)


func spawn(_args={}):
	if Network.map_masters[Network.map] == Network.get_nid() \
			and !has_spawned and net_stats.is_master:
		has_spawned = true
		net_stats.npc("set_has_spawned", {})
		#print("spawning")
		var object = Data.get_reference_instance(index)
		get_viewport().add_child(object)
		object.global_transform.origin = global_transform.origin
		object.rotation = rotation
		net_stats.unregister()

func set_viewers(v):
	viewers = v
	net_stats.npc("spawn", {}, true)
	
func set_has_spawned(_args):
	has_spawned = true
