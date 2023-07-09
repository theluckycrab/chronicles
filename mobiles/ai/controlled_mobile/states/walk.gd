extends State

var base_speed: float = 6#10
var move_speed: float= base_speed
var sprint_speed: float = base_speed * 3.75
var sprint_acceleration: float = base_speed
var turn_speed: float = 4#8
var turn_angle_limit: float = 35
var exit_delay: float = 0
var strafe_speed: float = base_speed * 1.5

func _init():
	priority = 0
	index = "Walk"

func can_enter() -> bool:
	return host.is_on_floor() and host.ai.get_wasd() != Vector3.ZERO
	
func can_exit() -> bool:
	return (! host.is_on_floor() or host.ai.get_wasd() == Vector3.ZERO) and exit_delay > 3

func enter() -> void:
	exit_delay = 0
	
func exit() -> void:
	pass
	
func execute() -> void:
	move_speed = base_speed
	handle_sprint()
	check_turning(host)
	if move_speed >= sprint_speed:
		host.play("Run")
	else:
		host.play("Walk")
	host.set_velocity(host.ai.get_wasd_cam() * move_speed)
	if host.get_ground_point() != Vector3.ZERO and ! host.is_on_floor():
		host.add_force(Vector3.DOWN * 9 * (host.global_transform.origin.distance_to(host.get_ground_point())))
		print("grav")
	if host.ai.get_wasd() == Vector3.ZERO or ! host.get_grounded():
		exit_delay += 1
	else:
		exit_delay = 0

func handle_sprint() -> void:
	if Input.is_action_just_pressed("sprint"):
		sprint_acceleration = base_speed * 1.15
	if Input.is_action_pressed("sprint"):
		sprint_acceleration += base_speed * 0.03
		if sprint_acceleration > sprint_speed:
			sprint_acceleration = sprint_speed
		move_speed = sprint_acceleration
	else:
		sprint_acceleration = base_speed

func check_turning(host) -> void:
	if move_speed < sprint_speed:
		return
	var arm_rot = int(rad2deg(host.armature.rotation.y)) % 360
	var wasd = host.ai.get_wasd_cam()
	var angle = rad2deg(atan2(wasd.x, wasd.z))
	if abs(arm_rot - angle) > turn_angle_limit and abs(arm_rot - angle) < 360 - turn_angle_limit:
		move_speed = turn_speed
		sprint_acceleration *= 0.66
