extends Node

var effect_name = "Treasure Sense"

func enter(host):
	host.get_viewport().get_camera().fov = 10
	host.armature.visible = false
	pass
	
func exit(host):
	host.get_viewport().get_camera().fov = 90
	host.armature.visible = true
	pass

func execute(host):
	pass
