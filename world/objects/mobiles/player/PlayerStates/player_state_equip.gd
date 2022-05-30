extends PlayerMoveState

var dir = "Front"

func _init() -> void:
	index = "Guard"
	animation = "Guard_Forward"
	priority = 1
	host = null


func controls() -> String:
	dir = get_dir()
	print(dir)
	animation = "Guard_"+dir
	return "guard"
	
	
	
func enter() -> void:
	controls()
	host.speed_mult = 1
	host.guard(get_dir())
	pass
	
	
func exit() -> void:
	host.set_war()
	host.guard_reset()
	pass
	
	
func can_exit() -> bool:
	return host.anim.current_animation != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	if Input.is_action_just_released("guard"):
		get_parent().quit_state()
	pass

func get_dir():
	var vel = Vector3.ZERO
	vel.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	vel.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	print(vel)
	match vel.abs().max_axis():
		Vector3.AXIS_Y:
			if vel.y > 0:
				return "Above"
		Vector3.AXIS_X:
			if vel.x > 0:
				return "Right"
			if vel.x < 0:
				return "Left"
	return "Forward"
