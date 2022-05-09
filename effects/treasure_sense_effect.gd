extends Node

var effect_name = "Treasure Sense"
var source

func enter(host):
	host.get_viewport().get_camera().fov = 15
	host.armature.visible = false
	pass
	
func exit(host):
	host.get_viewport().get_camera().fov = 90
	host.armature.visible = true
	pass

func execute(host):
	pass
