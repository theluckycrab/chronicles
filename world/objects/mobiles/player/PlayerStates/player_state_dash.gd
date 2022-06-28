extends PlayerActionState


func _init() -> void:
	index = "Dash"
	animation = "Dash"
	priority = 2
	host = null

var duration: float = 0.25#0.25
var height: float = 0.05 / duration
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
	get_anim_dir()
	if animation != "Dash":
		host.npc("guard", {"direction":"Forward"})
	direction = host.get_wasd()
	#direction = -direction.rotated(Vector3.UP, host.armature.rotation.y)
	dodge_timer.start(duration)
	pass
	
	
func exit() -> void:
	host.npc("guard_reset", {})
	dodge_timer.stop()
	done = false
	pass
	
	
func can_exit() -> bool:
	return done
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	if Input.is_action_just_pressed("light_attack") and animation == "Dash":
		host.set_state("dodge_attack")
	if dodge_timer.time_left > 0.02 and dodge_timer.time_left < duration - 0.02:
		var dir = -direction.rotated(Vector3.UP, host.armature.rotation.y)
		host.add_force(dir * distance * 3)
		host.add_force(Vector3.BACK.rotated(Vector3.UP, host.armature.rotation.y) * 0.03)
	host.lock_on()
	
	
func on_dodge_timer() -> void:
	done = true
	
	
func get_anim_dir():
	var dir = host.get_wasd()
	if dir.z < 0:
		animation = "Dash"
		return
	if dir.z > 0:
		animation = "Guard_Forward"
		return
	if dir.x < 0:
		animation = "Guard_Forward"
		return
	if dir.x > 0:
		animation = "Guard_Forward"
		return
	animation = "Dash"
