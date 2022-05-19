class_name State
extends Node

var index: String = "index not set"
var animation: String = "Idle"
var priority: int = 0
var host = null


func _controls() -> void:
	pass
	
	
func _enter() -> void:
	pass
	
	
func _exit() -> void:
	pass
	
	
func _can_exit() -> bool:
	return true
	
	
func _can_enter() -> bool:
	return true
	
	
func _execute() -> void:
	pass
