extends Spatial
class_name PlayerStateWalk

var animation = "Walk"
var priority = 0
var host = null
var slot = "Walk"

var sprinting = false

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
#	sprinting = Input.is_action_pressed("sprint")
#	if sprinting:
#		host.velocity.controlled *= 2
#		host.Animate("Idle")
	pass
