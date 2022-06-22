extends Spatial

func _ready() -> void:
	var _discard = Events.connect("spawn", self, "on_spawn")
	var object = Data.get_reference_instance("player")
	call_deferred("add_child", object)
	print("test_room ready")
	
func on_spawn(object, position = Vector3(0, 5, 0)) -> void:
	add_child(object)
	object.global_transform.origin = position
	if object.has_method("on_register"):
		object.on_register()
