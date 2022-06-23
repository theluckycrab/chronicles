extends ActionState

var dir = "Forward"
var done = false
var timer = Timer.new()

func _ready():
	timer.autostart = false
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "on_timer")


func _init() -> void:
	index = "Defend"
	animation = "Guard_Forward"
	priority = 1
	host = null

	
func enter() -> void:
	host.npc("parry", {direction="Forward"})
	done = false
	timer.start(0.6)
	pass
	
	
func exit() -> void:
	host.npc("guard_reset", {})
	done = false
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation and done
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	pass

func on_timer():
	done = true
