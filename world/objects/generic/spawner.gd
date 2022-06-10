extends Position3D

export(String) var item = "target_dummy"

onready var args = {
					type = "item",
					index = item,
					position = global_transform.origin,
					modifications = {},
					netID = Network.nid_gen()
	}
	
func _physics_process(delta):
	if Network.get_nid() != 1:
		return
	if Input.is_action_just_pressed("debug"):
		var obj = Data.get_reference_instance("target_dummy")
		add_child(obj)
	
#func _physics_process(_delta) -> void:
	#if Input.is_action_just_pressed("ui_cancel"):
		#args.netID = Network.nid_gen()
		#Network.call_deferred("relay_signal", "spawn", args)
