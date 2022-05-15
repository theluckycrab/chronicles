extends Spatial

func _ready() -> void:
	Events.connect("spawn", self, "on_spawn")
	print("Scene ready")
	
func on_spawn(object, position = Vector3(0, 2, 0)):
	add_child(object)
	object.global_transform.origin = position




