extends KinematicBody

var velocity = Vector3.ZERO
var force = Vector3.ZERO
var using_gravity = true
var stored_delta = 0

var move_stats = MoveStats.new()

onready var state_machine = $StateMachine
onready var armature = $Armature

onready var jump_state = $StateMachine/Jump
	
func _ready():
	state_machine.connect("state_changed", $StateLabel, "set_text")
	
func _physics_process(delta):
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
		
func set_velocity(v):
	velocity = v
	
func add_force(f):
	force += f

func play(anim:String, root_motion:=false):
	armature.play(anim, root_motion)
