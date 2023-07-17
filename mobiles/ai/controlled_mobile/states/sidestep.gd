extends State

var wasd = Vector3.ZERO
var start_pos = Vector3.ZERO
var max_distance = 3
var duration = 0.15
var speed = max_distance / duration
var stop = false

func _init():
	priority = 1
	index = "Sidestep"

func can_enter() -> bool:
	return host.is_on_floor()
	
func can_exit() -> bool:
	return host.is_on_wall() or host.armature.get_current_animation() == ""

func enter() -> void:
	stop = false
	start_pos = host.global_transform.origin
	wasd = host.ai.get_wasd()
	if wasd == Vector3.ZERO or wasd.z != 0:
		host.play("Jump")
		wasd = Vector3.UP * 0.5
	else:
		host.play("Sidestep")
	yield(get_tree().create_timer(duration), "timeout")
	stop = true
	
func exit() -> void:
	stop = false
	pass
	
func execute() -> void:
	var was = wasd.rotated(Vector3.UP, get_viewport().get_camera().rotation.y)
	if stop:
		wasd *= .9
	host.set_velocity(was * speed)
		
	pass


func distance_traveled():
	return host.distance_to(start_pos)
