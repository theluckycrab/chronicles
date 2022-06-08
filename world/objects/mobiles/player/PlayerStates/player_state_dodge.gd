extends PlayerMoveState


func _init() -> void:
	index = "Dodge"
	animation = "Dodge_Left"
	priority = 1
	host = null

var duration: float = 0.15#0.25
var height: float = 0.05 / duration
var distance: float = 3#0.75 / duration#1.75 / duration
var done: bool = false
var direction = Vector3.ZERO

onready var dodge_timer = Timer.new()


func _ready() -> void:
	add_child(dodge_timer)
	dodge_timer.autostart = false
	dodge_timer.one_shot = true
	dodge_timer.connect("timeout", self, "on_dodge_timer")
	
	
func enter() -> void:
	#direction = get_dir()
	direction = host.get_wasd()
	dodge_timer.start(duration)
	pass
	
	
func exit() -> void:
	dodge_timer.stop()
	done = false
	pass
	
	
func can_exit() -> bool:
	return done
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	host.play("Combat_Idle")
	var dir = -direction.rotated(Vector3.UP, host.armature.rotation.y)
	host.add_force(dir * distance * 3)#.rotated(Vector3.UP, host.get_node("Armature").rotation.y) * distance)
	if Input.is_action_just_pressed("light_attack"):
		host.set_state("dodge_attack")
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
				return Vector3(1,-height,0) * -2
		Vector3.AXIS_Z:
			if dir.z < 0:
				animation = "Dash"
				return Vector3(0,0,1) * 3.25
			if dir.z > 0:
				animation = "Fall"
				return Vector3(0,0,1) * -1.75
	return Vector3.ZERO
