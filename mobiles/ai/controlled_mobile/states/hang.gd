extends State

var facing
var has_hung = false

func _init():
	priority = 1
	index = "Hang"
	
func _physics_process(_delta):
	if host.is_on_floor():
		has_hung = false

func can_enter():
	return ! host.is_on_floor() and ! has_hung
	
func can_exit():
	return host.is_on_floor() or host.get_ledge() == Vector3.ZERO

func enter():
	var c = host.get_ledge()
	facing = c
	host.ai.get_state("Jump").jumped = false
	host.play("HangLedge")
	has_hung = true
	pass
	
func exit():
	pass
	
func execute():
	host.add_force(Vector3.UP)
	host.play("HangLedge")
	var wasd = host.ai.get_wasd()
	host.armature.face_dir(-facing, 0.09)
	host.add_force(Vector3.RIGHT.rotated(Vector3.UP, host.armature.rotation.y) * wasd.x * 5)
	if Input.is_action_just_pressed("hang_climb"):
		host.set_state("Climb")
		return
	if Input.is_action_just_released("hang_drop"):
		host.add_force(Vector3(0, -1, 1).rotated(Vector3.UP, host.armature.rotation.y) * 20)
		return
	pass
