extends KinematicBody

var base_speed = 15
var move_speed = base_speed
var sprint_speed = base_speed * 4
var sprint_acceleration = base_speed
var turn_speed = 5
var turn_angle_limit = 30
var rotation_speed = 15#0.4
var velocity = Vector3.ZERO
var force = Vector3.ZERO
var using_gravity = true
var stored_delta = 0

var move_stats = MoveStats.new()

onready var state_machine = $StateMachine
onready var armature = $Armature
	
func _ready():
	state_machine.add_override("Walk", preload("res://fly.gd").new())
	state_machine.set_state("Walk")
	
func _physics_process(delta):
	stored_delta = delta
	state_machine.cycle()
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.call_deferred("remove_override", "Walk")
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
	move_and_slide(velocity + force)
	velocity = Vector3.ZERO
	force = Vector3.ZERO
		
func set_velocity(v):
	velocity = v
	
func add_force(f):
	force += f

func play(anim:String, root_motion:=false):
	armature.play(anim, root_motion)
