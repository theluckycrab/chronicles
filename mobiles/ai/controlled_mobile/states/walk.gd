extends State

var base_speed: float = 6#10
var sprint_speed: float = base_speed * 3.75
var strafe_speed: float = base_speed * 1.5

var current_speed: float= base_speed
var sprint_acceleration: float = base_speed

var exit_delay: float = 0
var lock_target = null

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
	lock()
	pass
	
func execute() -> void:
	current_speed = base_speed
	
	if is_instance_valid(host.lock_target):
		strafe()
	
	if Input.is_action_just_pressed("sprint"):
		sprint_acceleration = base_speed * 1.15
		unlock()
	elif Input.is_action_just_released("sprint"):
		lock()
		sprint_acceleration = base_speed
	if Input.is_action_pressed("sprint"):
		accelerate()
		
	select_animation()
	host.set_velocity(host.ai.get_wasd_cam() * current_speed)
	handle_exit_delay()
	
		
func unlock():
	lock_target = host.lock_target
	host.lock_target = null
	get_parent().camera.set_lock_target(null)
	
func lock():
	if is_instance_valid(lock_target):
		host.lock_target = lock_target
		get_parent().camera.set_lock_target(lock_target)
		
func accelerate():
	sprint_acceleration += base_speed * 0.03
	if sprint_acceleration > sprint_speed:
		sprint_acceleration = sprint_speed
	current_speed = sprint_acceleration

func strafe():
	current_speed = strafe_speed
	host.play("Walk")
	
func select_animation():
	if current_speed >= sprint_speed:
		host.play("Run")
	else:
		host.play("Walk")
		
func handle_exit_delay():
	if host.get_ground_point() != Vector3.ZERO and ! host.is_on_floor():
		host.add_force(Vector3.DOWN * 9 * (host.global_transform.origin.distance_to(host.get_ground_point())))
	if host.ai.get_wasd() == Vector3.ZERO or ! host.get_grounded():
		exit_delay += 1
	else:
		exit_delay = 0
