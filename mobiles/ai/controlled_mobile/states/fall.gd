extends State

var lateral_speed := 25
var base_gravity := -19
var gravity := base_gravity
var gravity_acceleration := 1
var delay := 0

func _init():
	priority = 0
	index = "Fall"

func can_enter() -> bool:
	return ! host.is_on_floor()
	
func can_exit() -> bool:
	return host.is_on_floor()

func enter() -> void:
	gravity = base_gravity
	delay = 0
	
func exit() -> void:
	pass
	
func execute() -> void:
	var wasd: Vector3 = host.ai.get_wasd_cam()
	host.set_velocity(wasd * lateral_speed)
	host.add_force(Vector3.DOWN * gravity)
	gravity += gravity_acceleration
	if delay > 3:
		host.play("Fall")
	delay += 1
