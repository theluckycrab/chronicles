extends State

var base_speed = 15
var move_speed = base_speed
var sprint_speed = base_speed * 3.5
var sprint_acceleration = base_speed
var turn_speed = 5
var turn_angle_limit = 45
var exit_delay = 0
var strafe_speed = base_speed# * 0.75

func _init():
	priority = 0
	index = "Walk"

func can_enter():
	return host.is_on_floor() and host.get_wasd() != Vector3.ZERO
	
func can_exit():
	return ! host.is_on_floor() or (host.get_wasd() == Vector3.ZERO and exit_delay > 3)

func enter():
	exit_delay = 0
	pass
	
func exit():
	pass
	
func execute():
	move_speed = base_speed
	handle_sprint()
	check_turning(host)
	host.play("Walk")
	if move_speed == sprint_speed:
		host.armature.get_node("AnimationPlayer").play("Walk", 0, 2.5) #this won't network
	if host.has_lock_target():
		move_speed = strafe_speed
	host.set_velocity(host.get_wasd_cam() * move_speed)
	if host.get_wasd() == Vector3.ZERO:
		exit_delay += 1
	else:
		exit_delay = 0

func handle_sprint():
	if Input.is_action_just_pressed("sprint"):
		sprint_acceleration = base_speed * 1.15
	if Input.is_action_pressed("sprint"):
		sprint_acceleration += base_speed * 0.03
		if sprint_acceleration > sprint_speed:
			sprint_acceleration = sprint_speed
		move_speed = sprint_acceleration
	else:
		sprint_acceleration = base_speed

func check_turning(host):
	if move_speed < sprint_speed:
		return
	var arm_rot = int(rad2deg(host.armature.rotation.y)) % 360
	var wasd = host.get_wasd_cam()
	var angle = rad2deg(atan2(wasd.x, wasd.z))
	if abs(arm_rot - angle) > turn_angle_limit and abs(arm_rot - angle) < 360 - turn_angle_limit:
		move_speed = turn_speed
		sprint_acceleration *= 0.66
	pass
