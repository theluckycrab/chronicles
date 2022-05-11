extends Node

var effect_name : String = "Treasure Sense"
var source


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
