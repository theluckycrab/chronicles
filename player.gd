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
	
func _physics_process(delta):
	stored_delta = delta
	state_machine.cycle()
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.remove_override("Walk")
	#move(delta)

func get_wasd():
	var wasd = Vector3.ZERO
	wasd.x = Input.get_action_strength("a") - Input.get_action_strength("d")
	wasd.z = Input.get_action_strength("w") - Input.get_action_strength("s")
	return wasd
	
func get_wasd_cam():
	return get_wasd().normalized().rotated(Vector3.UP, $CameraPivot.rotation.y)
	
func move(delta):
	var wasd = get_wasd().normalized()
	move_speed = base_speed
	if wasd != Vector3.ZERO:
		armature.face_dir(wasd.rotated(Vector3.UP, $CameraPivot.rotation.y), delta)
	sprint(delta)
	wasd = wasd.rotated(Vector3.UP, $CameraPivot.rotation.y)
	wasd.y = -1
	if wasd.z != 0:
		$Armature/AnimationPlayer.play("Walk")
	else:
		$Armature/AnimationPlayer.play("Idle")
	if move_speed == sprint_speed:
		$Armature/AnimationPlayer.play("Walk", 0, 2.5)
	move_and_slide(wasd * move_speed)

func sprint(delta):
	if Input.is_action_just_pressed("sprint"):
			sprint_acceleration = base_speed * 2
	if Input.is_action_pressed("sprint"):
		sprint_acceleration += base_speed * 1.33 * delta
		if sprint_acceleration > sprint_speed:
			sprint_acceleration = sprint_speed
		move_speed = sprint_acceleration
	else:
		sprint_acceleration = base_speed
		
