extends Effect


func _init() -> void:
	effect_name = "Treasure Sense"
	index = "treasure_sense_effect"


func enter(host: Object) -> void:
	host.get_viewport().get_camera().fov = 15
	host.armature.visible = false
	pass
	
	
func exit(host: Object) -> void:
	host.get_viewport().get_camera().fov = 90
	host.armature.visible = true
	pass


func execute(_host: Object) -> void:
	pass
