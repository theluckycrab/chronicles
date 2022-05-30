extends PlayerMoveState


func _init() -> void:
	index = "Dodge"
	animation = "Jump"
	priority = 1
	host = null

var duration: float = 0.4#0.25
var height: float = 1 / duration
var distance: float = 1.75 / duration
var done: bool = false
var direction = Vector3.ZERO

onready var dodge_timer = Timer.new()


func _ready() -> void:
	add_child(dodge_timer)
	dodge_timer.autostart = false
	dodge_timer.one_shot = true
	dodge_timer.connect("timeout", self, "on_dodge_timer")
	
	
func enter() -> void:
	direction = get_dir()
	dodge_timer.start(duration)
	host.gravity.active = false
	pass
	
	
func exit() -> void:
	host.gravity.active = true
	done = false
	pass
	
	
func can_exit() -> bool:
	return done
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	host.anim.play(animation)
	host.add_force(direction.rotated(Vector3.UP, host.get_node("Armature").rotation.y) * distance)
	
	
func on_dodge_timer() -> void:
	done = true
	
func get_dir():
	match host.velocity.controlled.abs().max_axis():
		Vector3.AXIS_X:
			if host.velocity.controlled.x < 0:
				animation = "Dodge_Left"
				return Vector3(1,0,0) * 1
			elif host.velocity.controlled.x > 0:
				animation = "Dodge_Right"
				return Vector3(1,0,0) * -1
		Vector3.AXIS_Z:
			if host.velocity.controlled.z < 0:
				animation = "Dash"
				return Vector3(0,0,1) * 1.25
			if host.velocity.controlled.z > 0:
				animation = "Fall"
				return Vector3(0,0,1) * -0.75
	return Vector3.ZERO
