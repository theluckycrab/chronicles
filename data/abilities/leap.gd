extends Ability


func _init() -> void:
	index = "Leap"
	animation = "Taunt"
	priority = 2
	host = null

var duration: float = 0.25#0.25
var height: float = 3 / duration
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
	pass
	
	
func exit() -> void:
	jump_timer.queue_free()
	done = false
	combat_check()
	completed()
	pass
	
	
func can_exit() -> bool:
	return done
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	host.add_force(Vector3.UP * host.move.gravity)
	host.add_force((Vector3.UP * 0.5 + Vector3.BACK).rotated(Vector3.UP, host.armature.rotation.y) * height)
	if Input.is_action_just_pressed("light_attack"):
		host.at_war = true
		show_weapon()
		host.set_state("dodge_attack")
	
	
func on_jump_timer() -> void:
	done = true
