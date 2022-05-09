extends Spatial
class_name PlayerStateRun

var animation: String = "Idle"
var priority: int = 0
var host = null
var slot: String = "Walk"


func controls() -> void:
	pass
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return true
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	host.velocity.controlled *= 2
	pass

