extends ActionState

var idle_timer := Timer.new()
var idle_duration: int = 5
var done: bool = false


func _ready() -> void:
	idle_timer.one_shot = true
	idle_timer.autostart = false
	add_child(idle_timer)
	var _discard = idle_timer.connect("timeout", self, "on_idle_timer")


func _init() -> void:
	index = "Delay"
	animation = "Combat_Idle"
	priority = -1
	host = null

	
func enter() -> void:
	idle_timer.start(idle_duration)
	pass
	
	
func exit() -> void:
	idle_timer.stop()
	done = false
	pass
	
	
func can_exit() -> bool:
	return done
	
	
func can_enter() -> bool:
	return host.is_on_floor() and host.get_wasd() == Vector3.ZERO
	
	
func execute() -> void:
	host.lock_on()
	pass

func on_idle_timer() -> void:
	done = true
