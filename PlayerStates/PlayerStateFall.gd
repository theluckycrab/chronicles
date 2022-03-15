extends Spatial
class_name PlayerStateFall

var animation = null
var priority = 0
var host = null
var slot = "Fall"

func Controls():
	pass
	
func Enter():
	pass
	
func Exit():
	pass
	
func canExit():
	return host.is_on_floor()
	
func canEnter():
	return !host.is_on_floor()
	
func Execute():
	pass
