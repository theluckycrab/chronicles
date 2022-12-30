extends State

var facing

func _init():
	priority = 2
	index = "Climb"

func can_enter():
	return true
	
func can_exit():
	return ! host.armature.anim.is_using_root_motion()

func enter():
	host.play("UpLedge", true)
	facing = host.armature.rotation.y
	pass
	
func exit():
	host.using_gravity = true
	pass
	
func execute():
	pass
