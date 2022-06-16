class_name Spawner
extends Position3D

export(String) var index
export(PackedScene) onready var pattern = preload("res://world/objects/generic/spawners/patterns/point.tscn").instance()
onready var host = get_parent().get_parent()


#spawn projectiles scenes
# at our location
# network that spawn call
func retrieve_data(_i):
	pass


func spawn(i:String=index):
	var object = retrieve_data(i)
	object.source = host
	get_viewport().add_child(object)
	object.global_transform.origin = global_transform.origin
	object.rotation = get_parent().rotation
	print("host is ", host)
