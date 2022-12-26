extends KinematicBody

var velocity = Vector3.ZERO
var force = Vector3.ZERO
var using_gravity = true
var stored_delta = 0

onready var state_machine = $StateMachine
onready var armature = $Armature

onready var jump_state = $StateMachine/Jump
	
func _ready():
	state_machine.connect("state_changed", $StateLabel, "set_text")
	yield(get_tree().create_timer(1), "timeout")
	if is_dummy():
		$CameraPivot/Vertical/Camera.current = false
	else:
		$CameraPivot/Vertical/Camera.current = true
	
func _physics_process(delta):
	if !is_dummy():
		stored_delta = delta
		state_machine.cycle()
		if Input.is_action_just_pressed("jump"):
			state_machine.call_deferred("set_state", jump_state)
		move(delta)

func get_wasd():
	var wasd = Vector3.ZERO
	wasd.x = Input.get_action_strength("a") - Input.get_action_strength("d")
	wasd.z = Input.get_action_strength("w") - Input.get_action_strength("s")
	return wasd
	
func get_wasd_cam():
	return get_wasd().normalized().rotated(Vector3.UP, $CameraPivot.rotation.y)
	
func move(delta):
	if using_gravity:
		add_force(Vector3.DOWN * 20)
	if velocity != Vector3.ZERO:
		armature.face_dir(velocity, delta)
	var _d = move_and_slide(velocity + force, Vector3.UP)
	velocity = Vector3.ZERO
	force = Vector3.ZERO
	Server.npc({"function":"sync_move", "update":"", "position":global_transform.origin, "rotation":armature.rotation.y,\
			"animation":armature.get_node("AnimationPlayer").current_animation, "uuid":int(name)})
		
func set_velocity(v):
	velocity = v
	
func add_force(f):
	force += f

func play(anim:String, root_motion:=false):
	armature.play(anim, root_motion)

func sync_move(args):
	if is_dummy():
		print(name + " getting updates")
		global_transform.origin = args.position
		armature.rotation.y = args.rotation
		play(args.animation)

func is_dummy():
	return name != str(Client.nid)
