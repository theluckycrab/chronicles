extends PlayerMoveState

var dir = "Forward"

func _init() -> void:
	index = "Guard"
	animation = "Guard_Forward"
	priority = 1
	host = null


func controls():
	animation = "Guard_"+dir
	
	
func enter() -> void:
	controls()
	host.guard(dir)
	pass
	
	
func exit() -> void:
	dir = "Forward"
	host.guard_reset()
	pass
	
	
func can_exit() -> bool:
	return Input.is_action_just_released("guard")#host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	if Input.is_action_just_released("guard"):
		get_parent().quit_state()
		return
	for i in ["w", "a", "d"]:
		if Input.is_action_just_pressed(i):
			animation = "Guard_"+get_dir()
			host.play({animation="Guard_"+get_dir(), motion = false})
			host.guard_reset()
			host.parry(get_dir())
			yield(get_tree().create_timer(0.35), "timeout")
			exit()
			get_parent().quit_state()
			return
#	var dir = host.get_wasd_cam()
#	host.add_force(dir * 3)
	host.lock_on()
	pass

func get_dir() -> String:
	var vel = Vector3.ZERO
	vel.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	vel.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	match vel.abs().max_axis():
		Vector3.AXIS_Y:
			if vel.y < 0:
				return "Above"
		Vector3.AXIS_X:
			if vel.x > 0:
				return "Right"
			if vel.x < 0:
				return "Left"
	return "Above"
