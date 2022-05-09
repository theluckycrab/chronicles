extends Spatial
class_name PlayerStateIdle

var animation: String = "Idle"
var priority: int = 0
var host = null
var slot: String = "Idle"


func controls() -> void:
	pass
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return true
	
	
func can_enter() -> bool:
	return host.is_on_floor() and host.velocity.controlled == Vector3.ZERO
	
	
func execute() -> void:
	pass
