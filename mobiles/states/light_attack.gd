extends State

var facing
var animation = "Swipe"
#var attack = Data.get_ability("light_attack")

func _init():
	priority = 2
	index = "Light_Attack"

func can_enter():
	return true
	
func can_exit():
	return ! host.armature.anim.is_using_root_motion()

func enter():
	host.play(animation, true)
	facing = host.armature.rotation.y
	pass
	
func exit():
	#attack.execute(host)
	host.using_gravity = true
	pass
	
func execute():
	pass
