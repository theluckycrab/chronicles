extends Position3D

export(String) var item = "debug_item"

onready var args = {
					parent = 0, 
					index = item,
					position = global_transform.origin,
					modifications = {}
	}
	
	
func _physics_process(delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Network.call_deferred("relay_signal", "spawn", args)
