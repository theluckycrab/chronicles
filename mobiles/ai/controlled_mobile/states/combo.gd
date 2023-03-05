extends State

var combo_list = ["Combo_1", "Combo_2", "Combo_3"]
var combo_counter = -1
var will_combo = false

func _init():
	priority = 2
	index = "Attack"

func can_enter() -> bool:
	return host.is_on_floor()
	
func can_exit() -> bool:
	if will_combo:
		enter()
		return false
	return ! host.armature.is_using_root_motion()

func enter() -> void:
	will_combo = false
	if combo_counter >= combo_list.size() or ! host.is_on_floor():
		return
	tracking()
	host.play(combo_list[combo_counter], true)
	
func exit() -> void:
	combo_counter = -1
	pass
	
func execute() -> void:
	if Input.is_action_just_released("combo") and combo_counter < combo_list.size():
		combo_counter += 1
		will_combo = true
	pass

func tracking():
	if is_instance_valid(host.lock_target):
		var dir = host.direction_to(host.lock_target)
		var angle = atan2(dir.x, dir.z)
		host.armature.rotation.y = angle
	elif host.ai.get_wasd_cam() != Vector3.ZERO:
			var dir = host.ai.get_wasd_cam()
			var angle = atan2(dir.x, dir.z)
			host.armature.rotation.y = angle
