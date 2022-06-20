extends Ability


func _init() -> void:
	index = "High Jump"
	animation = "Jump"
	priority = 2
	host = null

var duration: float = 0.25#0.25
var height: float = 4 / duration
var distance: float = 1.5 / duration
var dir = Vector3.ZERO

onready var jump_timer = null


func enter() -> void:
	jump_timer = Timer.new()
	add_child(jump_timer)
	jump_timer.autostart = false
	jump_timer.one_shot = true
	jump_timer.connect("timeout", self, "on_jump_timer")
	jump_timer.start(duration)
	dir = host.get_wasd_cam()
	pass
	
	
func exit() -> void:
	jump_timer.queue_free()
	done = false
	completed()
	pass
	
	
func can_exit() -> bool:
	return done
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	host.add_force(Vector3.UP * host.move.gravity)
	host.add_force((Vector3.UP + dir) * height)
	
	
func on_jump_timer() -> void:
	done = true
