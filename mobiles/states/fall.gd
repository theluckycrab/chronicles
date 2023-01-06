extends State

var lateral_speed = 25
var base_gravity = -19
var gravity = base_gravity
var gravity_acceleration = 1
var max_gravity = 20
var delay = 0


func _init():
	priority = 0
	index = "Fall"

func can_enter():
	return ! host.is_on_floor() and host.using_gravity
	
func can_exit():
	return host.is_on_floor()

func enter():
	gravity = base_gravity
	delay = 0
	pass
	
func exit():
	pass
	
func execute():
	if host.get_ledge():
		host.set_state("Hang")
		return
	var wasd = host.get_wasd_cam()
	host.set_velocity(wasd * lateral_speed)
	host.add_force(Vector3.DOWN * gravity)
	gravity += gravity_acceleration
	#gravity = clamp(gravity, 0, max_gravity)
	if delay > 3:
		host.play("Fall")
	delay += 1
