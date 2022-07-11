extends Node

var faction = "Player"
onready var host: KinematicBody = get_parent()


func get_faction():
	return faction
	
	
func set_faction(f):
	faction = f
