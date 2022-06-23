extends PlayerActionState


func _init() -> void:
	index = "Dodge"
	animation = "Combat_Idle"
	priority = 1
	host = null

var duration: float = 0.35#0.25
var height: float = 0#.015 / duration
var distance: float = 4#0.75 / duration#1.75 / duration
var done: bool = false
var direction = Vector3.ZERO

onready var dodge_timer = Timer.new()


func _ready() -> void:
	add_child(dodge_timer)
	dodge_timer.autostart = false
	dodge_timer.one_shot = true
	dodge_timer.connect("timeout", self, "on_dodge_timer")
	
	
func enter() -> void:
	animation = "Combat_Idle"
	direction = host.get_wasd().normalized()
	dodge_timer.start(duration)
	pass
	
	
func exit() -> void:
	dodge_timer.stop()
	done = false
	pass
	
	
func can_exit() -> bool:
	return done
	
	
func can_enter() -> bool:
	return host.is_on_floor() and host.in_combat
	
	
func execute() -> void:
	var dir = -direction.rotated(Vector3.UP, host.armature.rotation.y)
	if dodge_timer.time_left > 0.02 and dodge_timer.time_left < duration - 0.02:
		host.add_force(dir * distance * 3)
		host.add_force(Vector3.BACK.rotated(Vector3.UP, host.armature.rotation.y) * 0.03)
	if Input.is_action_just_pressed("guard"):
		if host.get_wasd().z < 0:
			host.set_state("dash")
	host.lock_on()
	
	
func on_dodge_timer() -> void:
	done = true
	
	
func get_dir():
	var dir = host.get_wasd()
	match dir.abs().max_axis():
		Vector3.AXIS_X:
			if dir.x < 0:
				animation = "Dodge_Left"
				return Vector3(1,0,0) * 2
			elif dir.x > 0:
				animation = "Dodge_Right"
				return Vector3(1,0,0) * -2
		Vector3.AXIS_Z:
			if dir.z < 0:
				animation = "Dash"
				return Vector3(0,0,1) * 3.25
			if dir.z > 0:
				animation = "Fall"
				return Vector3(0,0,1) * -1.75
	return Vector3.ZERO
