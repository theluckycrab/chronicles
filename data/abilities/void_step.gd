extends Ability


func _init() -> void:
	index = "Void Step"
	animation = "Walk"
	priority = 2
	host = null

var duration: float = 0.35#0.25
var height: float = 3 / duration
var distance: int = 5 #1 / duration
var speed = 3
var dir = Vector3.ZERO
var rot = 0

onready var jump_timer = null


func enter() -> void:
	host.npc("set_visible", {"visible":false})
	dir = Vector3(randi() % distance, -distance + randi() % distance, randi() % distance) * Vector3(1,-1,1)
	rot = randi() % 360
	dir = dir.rotated(Vector3.UP, rot)
	jump_timer = Timer.new()
	add_child(jump_timer)
	jump_timer.autostart = false
	jump_timer.one_shot = true
	jump_timer.connect("timeout", self, "on_jump_timer")
	jump_timer.start(duration)
	pass
	
	
func exit() -> void:
	host.npc("set_visible", {"visible":true})
	jump_timer.queue_free()
	done = false
	combat_check()
	pass
	
	
func can_exit() -> bool:
	return done
	
	
func can_enter() -> bool:
	return host.is_on_floor()
	
	
func execute() -> void:
	host.add_force(dir * speed)
	
	
func on_jump_timer() -> void:
	done = true
