extends Node
class_name State

var host
var index: String = ""
var priority: int = 0

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	return true

func enter() -> void:
	pass
	
func execute() -> void:
	pass
	
func exit() -> void:
	pass
	
