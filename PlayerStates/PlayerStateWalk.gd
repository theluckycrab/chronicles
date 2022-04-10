extends Spatial
class_name PlayerStateWalk

var animation = "Walk"
var priority = 0
var host = null
var slot = "Walk"

func Controls():
	pass
	
func Enter():
	pass
	
func Exit():
	pass
	
func canExit():
	return true
	
func canEnter():
	return host.is_on_floor() and !host.velocity.controlled == Vector3.ZERO
	
func Execute():
	pass
