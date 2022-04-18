extends Spatial
class_name PlayerStateFall

var animation: String = "Fall"
var priority: int = 0
var host = null
var slot: String = "Fall"


func controls() -> void:
	pass
	
	
func enter() -> void:
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	return host.is_on_floor()
	
	
func can_enter() -> bool:
	return !host.is_on_floor()
	
	
func execute() -> void:
	pass
