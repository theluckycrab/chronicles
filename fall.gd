extends State

var lateral_speed = 50
var base_gravity = 7
var gravity = base_gravity
var gravity_acceleration = 0.33


func _init():
	priority = 0
	index = "Fall"

func can_enter():
	return ! host.is_on_floor()
	
func can_exit():
	return host.is_on_floor()

func enter():
	gravity = base_gravity
	pass
	
func exit():
	pass
	
func execute():
	var wasd = host.get_wasd_cam()
	host.set_velocity(wasd * lateral_speed)
	host.add_force(Vector3.DOWN * gravity)
	gravity += gravity_acceleration
	host.play("Idle")
