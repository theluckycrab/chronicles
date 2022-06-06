extends Spatial

func _ready() -> void:
	var _discard = Events.connect("spawn", self, "on_spawn")
	print("Scene ready")
	Network.call_deferred("rpc_id", 1, "request_history")
	
	
func on_spawn(object, position = Vector3(0, 2, 0)) -> void:
	add_child(object)
	object.global_transform.origin = position




