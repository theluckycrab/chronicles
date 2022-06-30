class_name Spawner
extends Position3D

export(String) var index = "target_dummy"
export(PackedScene) onready var pattern = preload("res://world/objects/generic/spawners/patterns/point.tscn").instance()
onready var host = get_parent()

func _ready():
	yield(get_tree().create_timer(3), "timeout")
	spawn()
#spawn projectiles scenes
# at our location
# network that spawn call
func retrieve_data(_i):
	Data.get_reference_instance(index)
	pass


func spawn():
	if Network.map_masters[Network.map] == Network.get_nid():
		#print("spawning from spawner")
		var object = Data.get_reference_instance(index)
		add_child(object)
		object.global_transform.origin = global_transform.origin
		object.rotation = rotation

