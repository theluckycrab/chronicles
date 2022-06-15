class_name Spawner
extends Position3D

export(String) var index

#spawn projectiles scenes
# at our location
# network that spawn call
func retrieve_data(_i):
	pass


func spawn(i:String=index):
	var object = retrieve_data(i)
	get_viewport().add_child(object)
	object.global_transform.origin = global_transform.origin
	object.rotation = get_parent().rotation
