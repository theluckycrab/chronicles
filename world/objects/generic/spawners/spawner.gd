class_name Spawner
extends Position3D

export(String) var index = "target_dummy"
export(PackedScene) onready var pattern = preload("res://world/objects/generic/spawners/patterns/point.tscn").instance()
onready var host = get_parent()

func _ready():
	if Network.get_map_master(Network.map, Network.get_nid()) == Network.get_nid():
		spawn()
#spawn projectiles scenes
# at our location
# network that spawn call
func retrieve_data(_i):
	Data.get_reference_instance(index)
	pass


func spawn(i:String=index):
	var object = Data.get_reference_instance(index)
	add_child(object)
	object.global_transform.origin = global_transform.origin
	object.rotation = rotation
