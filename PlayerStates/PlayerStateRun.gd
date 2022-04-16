extends Spatial
class_name PlayerStateRun

var animation = "Idle"
var priority = 0
var host = null
var slot = "Walk"

func Controls():
	pass
	
func Enter():
	print("running")
	pass
	
func Exit():
	print("stop runnin")
	pass
	
func canExit():
	return true
	
func canEnter():
	return host.is_on_floor()
	
func Execute():
	host.velocity.controlled *= 2
	pass
