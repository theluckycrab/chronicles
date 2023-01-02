extends State

var lateral_speed = 50
var base_gravity = 7
var gravity = base_gravity
var gravity_acceleration = 0.25
var max_gravity = 20

var facing


func _init():
	priority = 1
	index = "Hang"

func can_enter():
	return ! host.is_on_floor()
	
func can_exit():
	return host.is_on_floor() or !host.get_ledge()
	
func _physics_process(_delta):
	if !host.get_node("Armature/Sensors/LedgeClimb/Wall").enabled:
		host.get_node("Armature/Sensors/LedgeClimb").toggle()

func enter():
	var c = host.get_node("Armature/Sensors/LedgeClimb/Wall").get_collision_normal()
	host.get_node("Armature/Sensors/LedgeClimb").toggle()
	facing = c
	host.using_gravity = false
	host.state_machine.get_state("Jump").jumped = false
	host.play("HangLedge")
	pass
	
func exit():
	host.using_gravity = true
	pass
	
func execute():
	var wasd = host.get_wasd().rotated(Vector3.UP, host.armature.rotation.y)
	host.set_velocity(-facing)
	host.add_force(Vector3(wasd.x, 0, 0) * 2)
	if Input.is_action_just_pressed("w"):
		host.set_state("Climb")
		return
	if Input.is_action_just_pressed("s"):
		host.add_force(Vector3(0, -1, 1).rotated(Vector3.UP, host.armature.rotation.y) * 20)
		return
	pass
