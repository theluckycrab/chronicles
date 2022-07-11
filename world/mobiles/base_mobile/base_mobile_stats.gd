extends Node

onready var host: KinematicBody = get_parent()
var faction = "System"


func set_faction(f:String) -> void:
	faction = f


func get_faction():
	return faction
