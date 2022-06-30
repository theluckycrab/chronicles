extends ActionState

var timer = Timer.new()

func _init() -> void:
	index = "Patrol"
	animation = "Walk"
	priority = 1
	host = null
	
func _ready():
	timer.autostart = false
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "on_timer")
	
	
func enter() -> void:
	choose_next_patrol_point()
	pass
	
	
func exit() -> void:
	timer.stop()
	pass
	
	
func can_exit() -> bool:
	return host.lock_target
	
	
func can_enter() -> bool:
	return true
	

var mypos = Vector3.ZERO
var tpos = Vector3.ZERO
	
func execute() -> void:
	if host.lock_target != null:
		return
		
	host.play({animation="Walk", motion=false})
		
	var dist = host.distance_to(tpos)
	
	if tpos == Vector3.ZERO or dist < 1:
		choose_next_patrol_point()
	else:
		pursue_next_patrol_point()
	
	host.acquire_lock_target()


func choose_next_patrol_point():
	mypos = host.global_transform.origin
	var rand3 = Vector3(randi() % 5, 0, randi() % 5)
	var invert = randi() % 2
	
	if invert == 0:
		rand3 *= -1
	
	tpos = mypos + rand3
	print(tpos)
	timer.start(randi() % 10 + 5)


func pursue_next_patrol_point():
	host.add_force(host.direction_to(tpos) * Vector3(1,0,1))
	host.armature.face(host.direction_to(tpos))

func on_timer():
	choose_next_patrol_point()
