extends Spatial
class_name PlayerStateIdle

var animation = null
var priority = 0
var host = null
var slot = "Idle"

func Controls():
	pass
	
func Enter():
	pass
	
func Exit():
	pass
	
func canExit():
	return true
	
func canEnter():
	return host.is_on_floor()
	
func Execute():
	pass
