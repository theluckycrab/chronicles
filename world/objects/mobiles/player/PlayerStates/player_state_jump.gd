extends PlayerActionState


func _init() -> void:
	index = "Jump"
	animation = "Jump"
	priority = 1
	host = null

var duration: float = 0.4#0.25
var height: float = 3 / duration
var distance: float = 1.5 / duration
var done: bool = false

onready var jump_timer = Timer.new()


func _ready() -> void:
	add_child(jump_timer)
	jump_timer.autostart = false
	jump_timer.one_shot = true
	jump_timer.connect("timeout", self, "on_jump_timer")
	
	
func enter() -> void:
	jump_timer.start(duration)
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
	if host.anim.current_animation == "":
		host.add_force((Vector3.UP * height) + (host.get_node("Armature").global_transform.basis.z * distance))
	
	
func on_jump_timer() -> void:
	done = true
