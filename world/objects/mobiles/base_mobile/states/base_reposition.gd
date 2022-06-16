extends ActionState

var mypos
var tpos
var speed = 3

func _init() -> void:
	index = "Reposition"
	animation = "Walk"
	priority = 1
	host = null
	
	
func enter() -> void:
	mypos = host.global_transform.origin
	choose_next_patrol_point()
	#print("repo : ", tpos, mypos.distance_to(tpos))
	pass
	
	
func exit() -> void:
	pass
	
	
func can_exit() -> bool:
	tpos = Vector3(tpos.x, mypos.y, tpos.z)
	return mypos.distance_to(tpos) < 1
	
	
func can_enter() -> bool:
	return true

	
func execute() -> void:
	host.play({animation="Walk", motion=false})
	mypos = host.global_transform.origin
	pursue_next_patrol_point()
		

func choose_next_patrol_point():
	var rand3 = Vector3(randi() % 5, mypos.y, randi() % 5)
	var invert = randi() % 2
	
	if invert == 0:
		rand3 *= -1
	
	tpos = mypos + rand3


func pursue_next_patrol_point():
	host.add_force(mypos.direction_to(tpos) * Vector3(1,0,1) * speed)
	host.armature.face(mypos.direction_to(tpos))
