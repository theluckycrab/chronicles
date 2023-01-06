extends State

var enter_wasd
var wasd
var enter_pos
var distance = 10
var duration = 0.33
var delta = 0
var speed =0
var frame_distance = distance / duration

func _init():
	priority = 1
	index = "Quickstep"

func can_enter():
	return host.is_on_floor()
	
func can_exit():
	return host.get_animation() == ""

func enter():
	delta = duration
	enter_pos = host.global_transform.origin
	distance = enter_pos.distance_to(host.lock_target.global_transform.origin) * distance * duration
	enter_wasd = host.get_wasd().normalized()
	pass
	
func exit():
	pass
	
func execute():
	delta -= 0.016
	if delta > 0:
		wasd = enter_wasd.rotated(Vector3.UP, host.armature.rotation.y)
		host.set_velocity(wasd * frame_distance)
		#host.add_force(wasd * delta * 4)
		if enter_wasd.abs().max_axis() == Vector3.AXIS_Z:
			if enter_wasd.z > 0:
				host.play("Quickstep_Forward")
			else:
				host.play("Quickstep_Back")
		elif enter_wasd.x > 0:
			host.play("Quickstep_Left")
		else:
			host.play("Quickstep_Right")
		speed -= delta
