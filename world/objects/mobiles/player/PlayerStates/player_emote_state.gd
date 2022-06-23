extends State

var position = Vector3.ZERO

func _init() -> void:
	index = "Emote"
	animation = "Sit_Floor"
	priority = 1
	host = null
	

func enter():
	#position = host.global_transform.origin
	pass
	
func exit():
	host.armature.global_transform.origin = host.global_transform.origin
	pass
	
func can_enter():
	return true
	
func can_exit():
	return false
	
	
func execute():
	#if host.get_animation() != animation:
		#host.play({"animation":animation, "motion":true})
	for i in ["w", "a", "s", "d"]:
		if Input.is_action_just_pressed(i):
			if get_node("/root/SceneManager/Console").visible == false:
				get_parent().quit_state()
	#host.global_transform.origin = position
