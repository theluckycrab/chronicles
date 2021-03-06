extends PlayerMoveState


func _init() -> void:
	index = "Jump"
	animation = "Jump"
	priority = 1
	host = null

var duration: float = 0.25#0.25
var height: float = 2 / duration
var distance: float = 1.5 / duration
var done: bool = false
var dir = Vector3.ZERO
var player_vel = Vector3.ZERO

onready var jump_timer = Timer.new()


func _ready() -> void:
	add_child(jump_timer)
	jump_timer.autostart = false
	jump_timer.one_shot = true
	jump_timer.connect("timeout", self, "on_jump_timer")
	
	
func enter() -> void:
	done = false
	jump_timer.start(duration)
	dir = host.get_wasd_cam()
	player_vel = host.move.last_velocity
	pass
	
	
func exit() -> void:
	done = false
	pass
	
	
func can_exit() -> bool:
	return done
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	host.add_force(Vector3.UP * host.move.gravity)
	host.add_force(Vector3.UP * height)
	host.add_force(player_vel)
	
	
func on_jump_timer() -> void:
	done = true
